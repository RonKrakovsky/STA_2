library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity packet_decimator is
    generic (
        CLK_FREQ        : integer := 50000000;
        PACKET_RATE     : integer := 60;
        MAX_PACKET_LEN  : integer := 8192;
        DATA_WIDTH      : integer := 8
    );
    port (
        clk     : in std_logic;
        reset_n : in std_logic;
        
        sink_signal     : in std_logic_vector(DATA_WIDTH-1 downto 0);
        sink_valid      : in std_logic;
        sink_sop        : in std_logic;
        sink_eop        : in std_logic;
        sink_amps       : in std_logic_vector(2 downto 0);
        sink_filters    : in std_logic_vector(1 downto 0);
        sink_attenuator : in std_logic_vector(5 downto 0);
        sink_protection : in std_logic;
        sink_error      : in std_logic;

        source_signal     : out std_logic_vector(DATA_WIDTH-1 downto 0);
        source_valid      : out std_logic;
        source_sop        : out std_logic;
        source_eop        : out std_logic;
        source_amps       : out std_logic_vector(2 downto 0);
        source_filters    : out std_logic_vector(1 downto 0);
        source_attenuator : out std_logic_vector(5 downto 0);
        source_protection : out std_logic;
        source_error      : out std_logic
    );
end entity packet_decimator;

architecture rtl of packet_decimator is

    constant c_packetwidth    : integer := integer(ceil(log2(real(MAX_PACKET_LEN))));
  
    type stream_states_t is (idle_s, send_s, delay_s);
  
    signal r_stream_states : stream_states_t;

    constant c_decimation_factor      : integer := CLK_FREQ / PACKET_RATE;
    signal   r_decimation_counter     : integer range 0 to c_decimation_factor - 1;
begin

    
    write_to_buff : process (clk, reset_n) is
    begin
  
      
      if (rising_edge(clk)) then
		if (reset_n = '0') then
			r_stream_states      <= idle_s;
			r_decimation_counter <= 0;

			source_signal <= (others => '0');
			source_valid <= '0';
			source_sop <= '0';
			source_eop <= '0';
			
			source_amps <= (others => '0');
			source_filters <= (others => '0');
			source_attenuator <= (others => '0');
			source_protection <= '0';
			source_error <= '0';
		else
			case r_stream_states is
	  
			  when idle_s =>
	  
				if (sink_sop = '1' and sink_valid = '1') then
				  source_signal <= sink_signal;
				  source_valid <= '1';
				  source_sop <= '1';

				  source_amps <= sink_amps;
				  source_filters <= sink_filters;
				  source_attenuator <= sink_attenuator;
				  source_protection <= sink_protection;
				  source_error <= sink_error;

				  r_decimation_counter                         <= r_decimation_counter + 1;
				  r_stream_states                              <= send_s;
				end if;
	  
			  when send_s =>
	  
				r_decimation_counter <= r_decimation_counter + 1;

				source_sop <= '0';

				if (sink_valid = '1') then
					source_signal <= sink_signal;
					source_valid <= '1';
					if (sink_eop = '1') then
						source_eop <= '1';
						r_stream_states  <= delay_s;
					end if;
				else
					source_valid <= '0';
				end if;
	  
			  when delay_s =>
				source_eop <= '0';
				source_valid <= '0';

				if (r_decimation_counter < c_decimation_factor - 1) then
				  r_decimation_counter <= r_decimation_counter + 1;
				else
				  r_decimation_counter <= 0;
				  r_stream_states      <= idle_s;
				end if;
	  
			  when others =>
	  
			end case;
		end if;
  
      end if;
  
    end process write_to_buff;
end architecture;