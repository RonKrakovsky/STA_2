library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity window_function is
    generic (
        WINDOW_LENGTH : integer := 16384;
        SINK_DATA_WIDTH  : integer := 14;
        MEMORY_WIDTH : integer := 10;
        SOURCE_DATA_WIDTH  : integer := 24;
        AMPS_WIDTH        : integer := 3;
        FILTERS_WIDTH     : integer := 2;
        ATTENUATOR_WIDTH  : integer := 6
    );
    port (
        clk : in std_logic;
        reset_n : in std_logic;

        sink_data : in std_logic_vector(SINK_DATA_WIDTH-1 downto 0);
        sink_valid : in std_logic;
        sink_sop : in std_logic;
        sink_eop : in std_logic;

        source_data : out std_logic_vector(SOURCE_DATA_WIDTH-1 downto 0);
        source_valid : out std_logic;
        source_sop : out std_logic;
        source_eop : out std_logic;

        sink_amps : in std_logic_vector(2 downto 0);
		sink_filters : in std_logic_vector(1 downto 0);
		sink_attenuator : in std_logic_vector(5 downto 0);
		sink_protection : in std_logic;
		sink_error : in std_logic;

		source_amps : out std_logic_vector(2 downto 0);
		source_filters : out std_logic_vector(1 downto 0);
		source_attenuator : out std_logic_vector(5 downto 0);
		source_protection : out std_logic;
		source_error : out std_logic

    );
end entity;

architecture rtl of window_function is
    type mem_t is array(0 to WINDOW_LENGTH-1) of std_logic_vector(MEMORY_WIDTH-1 downto 0);

    signal mem : mem_t;
    attribute ram_init_file : string;
    attribute ram_init_file of mem :
    signal is "source/mif_hann14.mif";

    signal r_window_sample : std_logic_vector(MEMORY_WIDTH-1 downto 0);
    signal r_window_idx : integer range 0 to WINDOW_LENGTH-1;

    signal r_sink_valid, r_sink_sop, r_sink_eop : std_logic;
    signal r_sink_data : std_logic_vector(SINK_DATA_WIDTH-1 downto 0);
    signal r_source_data : signed(SINK_DATA_WIDTH+MEMORY_WIDTH downto 0);

    type t_state is (s_sop, s_valid, s_eop);
    signal r_state : t_state;

    signal r_filters : std_logic_vector(FILTERS_WIDTH-1 downto 0);

begin

    process(clk)
	begin
	if(rising_edge(clk)) then 
		r_window_sample <= mem(r_window_idx);
	end if;
	end process;
    
    source_data <= std_logic_vector(r_source_data(SINK_DATA_WIDTH+MEMORY_WIDTH-1 downto SINK_DATA_WIDTH+MEMORY_WIDTH-SOURCE_DATA_WIDTH));

    process (clk, reset_n)
	begin
        if (rising_edge(clk)) then
			if (reset_n = '0') then
                r_sink_data <= (others => '0');
                r_source_data <= (others => '0');
                r_window_idx <= 0;
                r_sink_valid <= '0';
                r_sink_sop <= '0';
                r_sink_eop <= '0';
                r_state <= s_sop;
                r_filters <= (others => '0');
			else
                r_sink_data <= sink_data;
                r_sink_valid <= sink_valid;
                r_sink_sop <= sink_sop;
                r_sink_eop <= sink_eop;

                r_filters <= sink_filters;
                source_filters <= r_filters;

                source_valid <= r_sink_valid;
                source_sop <= r_sink_sop;
                source_eop <= r_sink_eop;

                r_source_data <= signed(r_sink_data) * signed('0' & r_window_sample);

                case r_state is
                    when s_sop =>
                        if (r_sink_valid = '1' and r_sink_sop = '1') then
                            r_state <= s_valid;
                            r_window_idx <= r_window_idx + 1;
                        end if;
                    
                    when s_valid =>
                        if (r_sink_valid = '1') then
                            if (r_window_idx < WINDOW_LENGTH-2) then
                                r_window_idx <= r_window_idx + 1;
                            else
                                r_state <= s_eop;
                            end if;
                        end if;

                    when s_eop =>
                        if (r_sink_valid = '1') then
                            r_window_idx <= 0;
                            -- if (r_sink_eop = '0') then
                            --     source_error <= '1';
                            -- end if;
                            r_state <= s_sop;
                        end if;
                end case;
			end if;
		end if;
	end process;
    
    
    
end architecture rtl;