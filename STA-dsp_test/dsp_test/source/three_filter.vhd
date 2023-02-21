library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity three_filter is
    generic (
		FFT_Transform_Width          : integer   := 14;
        Magnitude_Width              : integer   := 32;
		CLK_FREQ					 : integer   := 150000000;
        First_Stage_Frequency        : integer   := 30000000;   -- 30MHz
        Second_Stage_Frequency       : integer   := 43000000;   -- 43MHz
        Third_Stage_Frequency        : integer   := 58000000;   -- 58MHz
        End_Frequency                : integer   := 66000000 	-- 66MHz
	);  

    port (
		clk 	: in std_logic;
		reset_n : in std_logic;
		
        sink_signal	                : in std_logic_vector((Magnitude_Width - 1) downto 0);
        sink_index				    : in std_logic_vector((FFT_Transform_Width - 1) downto 0);
		sink_valid  				: in std_logic;
		sink_sop  					: in std_logic;
		sink_eop 					: in std_logic;
        sink_filter_info            : in std_logic_vector(1 downto 0);
		
		source_signal	            : out std_logic_vector((Magnitude_Width - 1) downto 0);
		source_valid  				: out std_logic;
		source_sop  				: out std_logic;
		source_eop 					: out std_logic;
		
		in_amps : in std_logic_vector(2 downto 0);
		in_filters : in std_logic_vector(1 downto 0);
		in_attenuator : in std_logic_vector(5 downto 0);
		in_protection : in std_logic;
		in_error : in std_logic;

		out_amps : out std_logic_vector(2 downto 0);
--		out_filters : out std_logic_vector(1 downto 0);
		out_attenuator : out std_logic_vector(5 downto 0);
		out_protection : out std_logic;
		out_error : out std_logic
	);
end entity three_filter;

architecture rtl of three_filter is
	constant c_first_stage_index : integer := ((2**FFT_Transform_Width)*First_Stage_Frequency)/CLK_FREQ;
	constant c_second_stage_index : integer := ((2**FFT_Transform_Width)*Second_Stage_Frequency)/CLK_FREQ;
	constant c_third_stage_index : integer := ((2**FFT_Transform_Width)*Third_Stage_Frequency)/CLK_FREQ;
	constant c_end_freq_index : integer := ((2**FFT_Transform_Width)*End_Frequency)/CLK_FREQ;
	constant c_ram_size : integer := c_end_freq_index-c_first_stage_index;
	
	type t_mem is array (c_ram_size-1 downto 0) of std_logic_vector((Magnitude_Width - 1) downto 0);
	signal mem0, mem1 : t_mem;
	
	type st_packet_stage is (s_sop, s_valid);
	type st_out is (s_idle, s_read);
	signal sr_in_packet : st_packet_stage;
	signal sr_out_packet : st_out;
	
	type st_input is (s_filter0, s_filter1, s_filter2);
	signal sr_input : st_input;
	
	signal r_filter_info : std_logic_vector(1 downto 0);
	signal r_sink_data : std_logic_vector((Magnitude_Width - 1) downto 0);
	signal r_sink_index : integer range 0 to 2**FFT_Transform_Width-1;
	signal r_write_valid : std_logic;
	signal r_write_mem_sel : std_logic;
	
	signal r_we0, r_we1 : std_logic;
	signal r_write_address : integer range 0 to c_ram_size-1;
	signal r_write_data : std_logic_vector((Magnitude_Width - 1) downto 0);
	
	signal r_re0, r_re1 : std_logic;
	signal r_read_address : integer range 0 to c_ram_size-1;
	signal r_read_data0 : std_logic_vector((Magnitude_Width - 1) downto 0);
	signal r_read_data1 : std_logic_vector((Magnitude_Width - 1) downto 0);
	
	signal r_write_done : std_logic;
	signal r_read_ack : std_logic;
	signal r_read_mem_sel : std_logic;
	signal r_read_mem_sel_reg : std_logic;
	
	signal r_read_req : std_logic;
	signal r_read_valid : std_logic;
	signal r_read_index : integer range 0 to c_ram_size-1;
	
begin
	process(clk)
	begin
	if(rising_edge(clk)) then 
		if(r_we0 = '1') then
			mem0(r_write_address) <= r_write_data;
		end if;
		
		if(r_we1 = '1') then
			mem1(r_write_address) <= r_write_data;
		end if;
 
		r_read_data0 <= mem0(r_read_address);
		r_read_data1 <= mem1(r_read_address);
	end if;
	end process;
	
	process(clk, reset_n)
	begin
		if (rising_edge(clk)) then
			if (reset_n = '0') then
				r_we0 <= '0';
				r_we1 <= '0';
				r_write_address <= 0;
				r_write_data <= (others => '0');
			else
				r_we0 <= '0';
				r_we1 <= '0';
				r_write_address <= r_sink_index-c_first_stage_index;
				r_write_data <= r_sink_data;
				
				if (r_write_valid = '1') then
					case to_integer(unsigned(r_filter_info)) is
						when 0 =>
							if (r_sink_index >= c_first_stage_index and r_sink_index < c_second_stage_index) then
								r_we0 <= not r_write_mem_sel;
								r_we1 <= r_write_mem_sel;
							end if;
							
						when 1 =>
							if (r_sink_index >= c_second_stage_index and r_sink_index < c_third_stage_index) then
								r_we0 <= not r_write_mem_sel;
								r_we1 <= r_write_mem_sel;
							end if;
							
						when 2 =>
							if (r_sink_index >= c_third_stage_index and r_sink_index < c_end_freq_index) then
								r_we0 <= not r_write_mem_sel;
								r_we1 <= r_write_mem_sel;
							end if;
						when others =>
							r_we0 <= '0';
							r_we1 <= '0';
					end case;
				end if;
			end if;
		end if;
	end process;
	
	process(clk, reset_n)
	begin
		if (rising_edge(clk)) then
			if (reset_n = '0') then
				sr_in_packet <= s_sop;
				r_sink_data <= (others => '0');
				r_sink_index <= 0;
				r_write_valid <= '0';
				r_filter_info <= (others => '0');
				r_write_mem_sel <= '0';
				r_read_mem_sel <= '0';
				r_write_done <= '0';
			else
				r_sink_data <= sink_signal;
				r_sink_index <= to_integer(unsigned(sink_index));
				r_write_valid <= '0';
				
				if (r_read_ack = '1') then
					r_write_done <= '0';
				end if;
				
				case sr_in_packet is
					when s_sop =>
						if (sink_sop = '1' and sink_valid = '1') then
							sr_in_packet <= s_valid;
							r_write_mem_sel <= not r_write_mem_sel;
							r_filter_info <= sink_filter_info;
							r_write_valid <= '1';
						end if;
						
					when s_valid =>
						if (sink_valid = '1') then
							r_write_valid <= '1';
							
							if (sink_eop = '1') then
								sr_in_packet <= s_sop;
								r_write_done <= '1';
								r_read_mem_sel <= r_write_mem_sel;
							end if;
						end if;
					when others =>
				end case;
			end if;
		end if;
	end process;
	
	
	process(clk, reset_n)
	begin
		if (rising_edge(clk)) then
			if (reset_n = '0') then
				sr_out_packet <= s_idle;
				r_read_mem_sel_reg <= '0';
				r_read_ack <= '0';
				r_read_address <= 0;
				r_read_req <= '0';
			else
				r_read_req <= '0';
				r_read_ack <= '0';
				
				case sr_out_packet is
					when s_idle =>
						if (r_write_done = '1') then
							sr_out_packet <= s_read;
							r_read_mem_sel_reg <= r_read_mem_sel;
							r_read_ack <= '1';
							r_read_address <= 0;
							r_read_req <= '1';
						end if;
						
					when s_read =>
						if (r_read_address < c_ram_size-1) then
							r_read_address <= r_read_address + 1;
							r_read_req <= '1';
						else
							r_read_address <= 0;
							sr_out_packet <= s_idle;
						end if;
				end case;
			end if;
		end if;
	end process;
						
	process(clk, reset_n)
	begin
		if (rising_edge(clk)) then
			if (reset_n = '0') then
				r_read_valid <= '0';
				r_read_index <= 0;
				source_valid <= '0';
				source_sop <= '0';
				source_eop <= '0';
				source_signal <=(others => '0');
			else
				r_read_valid <= r_read_req;
				r_read_index <= r_read_address;
				source_valid <= '0';
				source_sop <= '0';
				source_eop <= '0';
				
				if (r_read_valid = '1') then
					source_valid <= '1';
					
					if (r_read_index = 0) then
						source_sop <= '1';
					end if;
					
					if (r_read_index = c_ram_size-1) then
						source_eop <= '1';
					end if;
					
					if (r_read_mem_sel_reg = '0') then
						source_signal <= r_read_data0;
					else
						source_signal <= r_read_data1;
					end if;
				end if;
			end if;
		end if;
	end process;
end architecture;
			
			