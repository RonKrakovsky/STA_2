library ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity log_cdc is
    generic (
        MAX_PACKET_LEN    : integer := 16384;
        DATA_WIDTH        : integer := 32;
        AMPS_WIDTH        : integer := 3;
        FILTERS_WIDTH     : integer := 2;
        ATTENUATOR_WIDTH  : integer := 6
    );
    port (
        in_clk   : in std_logic;
        out_clk  : in std_logic;
        reset_n  : in std_logic;

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

        source_signal     : out std_logic_vector(DATA_WIDTH-1 downto 0);
        source_valid      : out std_logic;
        source_sop        : out std_logic;
        source_eop        : out std_logic;
        source_amps       : out std_logic_vector(AMPS_WIDTH-1 downto 0);
        source_filters    : out std_logic_vector(FILTERS_WIDTH-1 downto 0);
        source_attenuator : out std_logic_vector(ATTENUATOR_WIDTH-1 downto 0);
        source_protection : out std_logic;
        source_error      : out std_logic
    );
end entity log_cdc;

architecture rtl of log_cdc is
    type st_fifo_write is (s_idle, s_valid, s_wait);
    signal sr_fifo_write : st_fifo_write;

    type st_send_result is (s_idle, s_sop, s_valid, s_eop);
    signal sr_send_result : st_send_result;

    signal r_in_samples_count : integer range 0 to MAX_PACKET_LEN;
    signal r_out_samples_count : integer range 0 to MAX_PACKET_LEN;
    signal r_in_samples : integer range 0 to MAX_PACKET_LEN;
    signal r_last_samples_req : std_logic;
    signal r_out_samples : integer range 0 to MAX_PACKET_LEN;
    signal r_last_samples_ack : std_logic;

    signal log_source_valid : std_logic;
    signal log_source_data : std_logic_vector(31 downto 0);

    signal r_fifo_sink_ready : std_logic;
    
begin
    process (in_clk, reset_n)
    begin
        if rising_edge(in_clk) then
            if reset_n = '0' then
                fifo_source_data <= (others => '0');
                fifo_source_valid <= '0';
                sr_fifo_write <= s_idle;
                r_in_samples_count <= 0;
    
                rffe_fifo_source_amps       <= (others => '0'); 
                rffe_fifo_source_filters    <= (others => '0'); 
                rffe_fifo_source_attenuator <= (others => '0'); 
                rffe_fifo_source_protection <= '0'; 
                rffe_fifo_source_error      <= '0'; 
                rffe_fifo_source_valid      <= '0'; 
                r_in_samples <= 0;
                r_last_samples_req <= '0';
            else
                ---- send signal to data fifo ----
                ---- fifo should never be full because of packet decimation ----
                rffe_fifo_source_valid <= '0';

                if r_last_samples_ack = '1' then
                    r_last_samples_req <= '0';
                end if;

                case sr_fifo_write is
                    when s_idle =>
                        fifo_source_valid <= '0';
                        if sink_valid = '1' and sink_sop = '1' then
                            fifo_source_data <= sink_signal;
                            fifo_source_valid <= sink_valid;
                            sr_fifo_write <= s_valid;
                            r_in_samples_count <= r_in_samples_count + 1;

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
                            
                            if sink_eop = '1' then
                                sr_fifo_write <= s_idle;
                                r_in_samples <= r_in_samples_count;
                                r_last_samples_req <= '1';
                                r_in_samples_count <= 0;
                            else
                                r_in_samples_count <= r_in_samples_count + 1;
                            end if;
                        end if;

                    when others =>
                        null;
                end case;
            end if;
        end if;
    end process;

    process (out_clk, reset_n)
    begin
        if rising_edge(out_clk) then
            if reset_n = '0' then
                sr_send_result <= s_idle;
                source_signal <= (others => '0'); 
                source_valid <= '0';
                source_sop <= '0';
                source_eop <= '0';
                r_out_samples_count <= 0;
    
                r_fifo_sink_ready <= '0';
    
                rffe_fifo_sink_ready <= '0';
    
                source_amps       <= (others => '0');
                source_filters    <= (others => '0');
                source_attenuator <= (others => '0');
                source_protection <= '0';
                source_error      <= '0';
    
                r_out_samples <= 0;
                r_last_samples_ack <= '0';
            else
                ---- send result of log calculation & rebuild packet info ----

                if r_last_samples_req = '1' then
                    r_out_samples <= r_in_samples;
                    r_last_samples_ack <= '1';
                else
                    r_last_samples_ack <= '0';
                end if;

                rffe_fifo_sink_ready <= '0';
                r_fifo_sink_ready <= '0';
                source_valid <= '0';
                case sr_send_result is
                    
                    when s_idle =>
                        if fifo_sink_valid = '1' and rffe_fifo_sink_valid = '1' then
                            r_fifo_sink_ready <= '1';
                            
                            -- r_out_samples_count <= r_out_samples_count + 1;
                            
                            rffe_fifo_sink_ready <= '1';
                            sr_send_result <= s_sop;

                            source_amps       <= rffe_fifo_sink_amps;
                            source_filters    <= rffe_fifo_sink_filters;
                            source_attenuator <= rffe_fifo_sink_attenuator;
                            source_protection <= rffe_fifo_sink_protection;
                            source_error      <= rffe_fifo_sink_error;
                        end if;
                    
                    when s_sop =>
                        if fifo_sink_valid = '1' then
                            if r_fifo_sink_ready = '1' then
                                source_signal <= fifo_sink_data;
                                source_valid <= '1';
                                source_sop <= '1';
                                -- r_out_samples_count <= r_out_samples_count + 1;
                                if r_out_samples_count < r_out_samples - 1 then
                                    r_out_samples_count <= r_out_samples_count + 1;
                                end if;
                                sr_send_result <= s_valid;
                            else
                                r_fifo_sink_ready <= '1';
                            end if;
                        end if;

                    when s_valid =>
                        source_sop <= '0';

                        if fifo_sink_valid = '1' then
                            if r_fifo_sink_ready = '1' then
                                source_signal <= fifo_sink_data;
                                source_valid <= '1';
                                if r_out_samples_count < r_out_samples then
                                    r_out_samples_count <= r_out_samples_count + 1;
                                else
                                    sr_send_result <= s_eop;
                                    source_eop <= '1';
                                    r_out_samples_count <= 0;
                                end if;
                            else
                                r_fifo_sink_ready <= '1';
                            end if;
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
    fifo_sink_ready <= r_fifo_sink_ready;
end architecture;