library ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity log_controller is
    generic (
        MAX_PACKET_LEN    : integer := 16384;
        DATA_WIDTH        : integer := 64;
        DATA_OUT_WIDTH    : integer := 32;
        AMPS_WIDTH        : integer := 3;
        FILTERS_WIDTH     : integer := 2;
        ATTENUATOR_WIDTH  : integer := 6
    );
    port (
        clk   : in std_logic;
        reset_n : in std_logic;

        sink_signal     : in std_logic_vector(DATA_WIDTH-1 downto 0);
        sink_valid      : in std_logic;
        sink_sop        : in std_logic;
        sink_eop        : in std_logic;
        sink_amps       : in std_logic_vector(AMPS_WIDTH-1 downto 0);
        sink_filters    : in std_logic_vector(FILTERS_WIDTH-1 downto 0);
        sink_attenuator : in std_logic_vector(ATTENUATOR_WIDTH-1 downto 0);
        sink_protection : in std_logic;
        sink_error      : in std_logic;

        fifo_source_data       : out std_logic_vector(DATA_WIDTH-1 downto 0);
        fifo_source_valid      : out std_logic;
        fifo_source_ready      : in std_logic;

        fifo_sink_data         : in std_logic_vector(DATA_WIDTH-1 downto 0);
        fifo_sink_valid        : in std_logic;
        fifo_sink_ready        : out std_logic;

        rffe_fifo_source_amps       : out std_logic_vector(AMPS_WIDTH-1 downto 0);
        rffe_fifo_source_filters    : out std_logic_vector(FILTERS_WIDTH-1 downto 0);
        rffe_fifo_source_attenuator : out std_logic_vector(ATTENUATOR_WIDTH-1 downto 0);
        rffe_fifo_source_protection : out std_logic;
        rffe_fifo_source_error      : out std_logic;
        rffe_fifo_source_valid      : out std_logic;
        rffe_fifo_source_ready      : in std_logic;

        rffe_fifo_sink_amps       : in std_logic_vector(AMPS_WIDTH-1 downto 0);
        rffe_fifo_sink_filters    : in std_logic_vector(FILTERS_WIDTH-1 downto 0);
        rffe_fifo_sink_attenuator : in std_logic_vector(ATTENUATOR_WIDTH-1 downto 0);
        rffe_fifo_sink_protection : in std_logic;
        rffe_fifo_sink_error      : in std_logic;
        rffe_fifo_sink_valid      : in std_logic;
        rffe_fifo_sink_ready      : out std_logic;

        source_signal     : out std_logic_vector(DATA_OUT_WIDTH-1 downto 0);
        source_valid      : out std_logic;
        source_sop        : out std_logic;
        source_eop        : out std_logic;
        source_amps       : out std_logic_vector(AMPS_WIDTH-1 downto 0);
        source_filters    : out std_logic_vector(FILTERS_WIDTH-1 downto 0);
        source_attenuator : out std_logic_vector(ATTENUATOR_WIDTH-1 downto 0);
        source_protection : out std_logic;
        source_error      : out std_logic
    );
end entity log_controller;

architecture rtl of log_controller is
    type st_fifo_write is (s_idle, s_valid, s_wait);
    signal sr_fifo_write : st_fifo_write;

    type st_send_result is (s_sop, s_valid, s_eop);
    signal sr_send_result : st_send_result;

    signal r_in_samples_count : integer range 0 to MAX_PACKET_LEN;
    signal r_out_samples_count : integer range 0 to MAX_PACKET_LEN;

    component log10 is
        generic (
            DATA_WIDTH : integer := 64
        );
        port (
            clk : in std_logic;
            reset_n : in std_logic;
            
            asi_sink_ready : out std_logic;
            asi_sink_valid : in std_logic;
            asi_sink_data : in std_logic_vector(DATA_WIDTH-1 downto 0); --sfix32_En0
    
            aso_source_data   : out std_logic_vector(31 downto 0); --sfix32_En10
            aso_source_valid  : out std_logic 
    
        );
    end component log10;

    signal log_sink_ready : std_logic;
    signal log_sink_valid : std_logic;
    signal log_sink_data : std_logic_vector(DATA_WIDTH-1 downto 0);

    signal log_source_valid : std_logic;
    signal log_source_data : std_logic_vector(DATA_OUT_WIDTH-1 downto 0);
    
begin
    u0: log10
        generic map (
            DATA_WIDTH => DATA_WIDTH
        )
        port map (
            clk   => clk,
            reset_n => reset_n,
            
            asi_sink_ready => log_sink_ready,
            asi_sink_valid => log_sink_valid,
            asi_sink_data  => log_sink_data,

            aso_source_data => log_source_data,
            aso_source_valid => log_source_valid
        );

    process (clk, reset_n)
    begin
        if rising_edge(clk) then
            if reset_n = '0' then
                fifo_source_data <= (others => '0');
                fifo_source_valid <= '0';
                sr_fifo_write <= s_idle;
                r_in_samples_count <= 0;
    
                log_sink_valid <= '0';
                log_sink_data <= (others => '0'); 
                fifo_sink_ready <= '0';
    
                sr_send_result <= s_sop;
                source_signal <= (others => '0'); 
                source_valid <= '0';
                source_sop <= '0';
                source_eop <= '0';
                r_out_samples_count <= 0;
    
                rffe_fifo_source_amps       <= (others => '0'); 
                rffe_fifo_source_filters    <= (others => '0'); 
                rffe_fifo_source_attenuator <= (others => '0'); 
                rffe_fifo_source_protection <= '0'; 
                rffe_fifo_source_error      <= '0'; 
                rffe_fifo_source_valid      <= '0'; 
    
                rffe_fifo_sink_ready <= '0';
    
                source_amps       <= (others => '0');
                source_filters    <= (others => '0');
                source_attenuator <= (others => '0');
                source_protection <= '0';
                source_error      <= '0';
            else
                ---- send signal to data fifo ----
                ---- fifo should never be full because of packet decimation ----
                rffe_fifo_source_valid <= '0';

                case sr_fifo_write is
                    when s_idle =>
                        if sink_valid = '1' and sink_sop = '1' then
                            fifo_source_data <= sink_signal;
                            fifo_source_valid <= sink_valid;
                            sr_fifo_write <= s_valid;
                            -- r_in_samples_count <= r_in_samples_count + 1;

                            rffe_fifo_source_amps       <= sink_amps;
                            rffe_fifo_source_filters    <= sink_filters;
                            rffe_fifo_source_attenuator <= sink_attenuator;
                            rffe_fifo_source_protection <= sink_protection; 
                            rffe_fifo_source_error      <= sink_error; 
                            rffe_fifo_source_valid      <= '1'; 
                        end if;

                    when s_valid =>
                        fifo_source_valid <= sink_valid;
                        
                        if sink_valid = '1' then
                            fifo_source_data <= sink_signal;
                            r_in_samples_count <= r_in_samples_count + 1;
                            if sink_eop = '1' then
                                sr_fifo_write <= s_wait;
                            end if;
                        end if;
                    
                    when s_wait => 
                        fifo_source_valid <= '0';
                        if sr_send_result = s_eop then
                            sr_fifo_write <= s_idle;
                            r_in_samples_count <= 0;
                        end if;

                    when others =>
                        null;
                end case;
                
                ---- Ready latency adapter: from fifo's 0 latency to log10's 1 latency ----
                if fifo_sink_valid = '1' and log_sink_ready = '1' and log_sink_valid = '0' then
                    log_sink_data <= fifo_sink_data;
                    log_sink_valid <= '1';
                    fifo_sink_ready <= '1';
                else
                    log_sink_valid <= '0';
                    fifo_sink_ready <= '0';
                end if;

                ---- send result of log calculation & rebuild packet info ----
                rffe_fifo_sink_ready <= '0';
                case sr_send_result is
                    when s_sop =>
                        if log_source_valid = '1' and rffe_fifo_sink_valid = '1' then
                            source_signal <= log_source_data;
                            source_valid <= '1';
                            source_sop <= '1';
                            r_out_samples_count <= r_out_samples_count + 1;
                            
                            rffe_fifo_sink_ready <= '1';
                            sr_send_result <= s_valid;

                            source_amps       <= rffe_fifo_sink_amps;
                            source_filters    <= rffe_fifo_sink_filters;
                            source_attenuator <= rffe_fifo_sink_attenuator;
                            source_protection <= rffe_fifo_sink_protection;
                            source_error      <= rffe_fifo_sink_error;
                        end if;

                    when s_valid =>
                        source_sop <= '0';

                        if log_source_valid = '1' then
                            source_signal <= log_source_data;
                            source_valid <= '1';
                            if r_out_samples_count < r_in_samples_count - 1 then
                                r_out_samples_count <= r_out_samples_count + 1;
                            else
                                sr_send_result <= s_eop;
                                source_eop <= '1';
                                r_out_samples_count <= 0;
                            end if;
                        else
                            source_valid <= '0';
                        end if;
                            
                    when s_eop =>
                        sr_send_result <= s_sop;
                        source_eop <= '0';
                        source_valid <= '0';
                
                    when others =>
                        null;
                end case;
            end if;
        end if;
    end process;
end architecture;