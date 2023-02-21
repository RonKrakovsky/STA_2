library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity packet_writer is
    generic (
        MAX_PACKET_LEN      : integer := 1024;
        DATA_WIDTH          : integer := 32;
        ADDRESS_WIDTH       : integer := 13;
        AMPS_WIDTH          : integer := 3;
        FILTERS_WIDTH       : integer := 2;
        ATTENUATOR_WIDTH    : integer := 6
    );
    port (
        clk     : in    std_logic;
        reset_n : in    std_logic;

        sink_data     : in std_logic_vector(DATA_WIDTH-1 downto 0);
        sink_valid      : in std_logic;
        sink_sop        : in std_logic;
        sink_eop        : in std_logic;
        sink_amps       : in std_logic_vector(AMPS_WIDTH-1 downto 0);
        sink_filters    : in std_logic_vector(FILTERS_WIDTH-1 downto 0);
        sink_attenuator : in std_logic_vector(ATTENUATOR_WIDTH-1 downto 0);
        sink_protection : in std_logic;
        sink_error      : in std_logic;

        mem_address     : out   std_logic_vector(ADDRESS_WIDTH-1 downto 0);
        mem_waitrequest : in    std_logic;
        mem_writedata   : out   std_logic_vector(DATA_WIDTH-1 downto 0);
        mem_write       : out   std_logic;

        ins_csr_interrupt : out   std_logic;
        avs_csr_address   : in    std_logic_vector(3 downto 0);
        avs_csr_writedata : in    std_logic_vector(31 downto 0);
        avs_csr_write     : in    std_logic;
        avs_csr_readdata  : out   std_logic_vector(31 downto 0);
        avs_csr_read      : in    std_logic
    );
end entity packet_writer;

architecture rtl of packet_writer is
    constant c_bytes : integer := DATA_WIDTH / 8;

    signal r_base_address : std_logic_vector(ADDRESS_WIDTH - 1 downto 0);
    signal r_en           : std_logic;

    type mm_t is (idle_s, write_s, done_s);

    signal r_mm_state : mm_t;

    signal r_address       : std_logic_vector(ADDRESS_WIDTH - 1 downto 0);
    signal r_read_buff_idx : integer range 0 to MAX_PACKET_LEN;
    signal r_mm_we         : std_logic;

    signal r_clear : std_logic;
    signal r_done  : std_logic;
    signal r_last_word : std_logic;
begin

    csr_config : process (clk, reset_n) is
    begin
        if (clk'event and clk = '1') then
            if (reset_n = '0') then
                r_base_address      <= (others => '0');
                r_en                <= '0';
                avs_csr_readdata    <= (others => '0');
                r_clear             <= '0';
            else
            
                if (avs_csr_write = '1') then
                    case to_integer(unsigned(avs_csr_address)) is
                        when 0 =>
                            r_en    <= avs_csr_writedata(0);
                            r_clear <= avs_csr_writedata(1);

                        when 1 =>
                            r_base_address <= avs_csr_writedata(ADDRESS_WIDTH - 1 downto 0);
                        when others =>

                    end case;

                elsif (avs_csr_read = '1') then
                    case to_integer(unsigned(avs_csr_address)) is
                        when 0 =>
                            avs_csr_readdata(0) <= r_en;
                            avs_csr_readdata(1) <= r_done;

                        when 1 =>
                            avs_csr_readdata                             <= (others => '0');
                            avs_csr_readdata(ADDRESS_WIDTH - 1 downto 0) <= r_base_address;

                        when 2 =>
                            avs_csr_readdata <= (others => '0');
                        when 3 =>
                            avs_csr_readdata <= std_logic_vector(to_unsigned(r_read_buff_idx, 32));

                        when others =>
                            avs_csr_readdata <= (others => '0');
                    end case;
                end if;
            end if;
        end if;
    end process csr_config;
    
    write_to_mem : process (clk, reset_n) is
    begin
        if (clk'event and clk = '1') then
            if (reset_n = '0') then
                r_mm_state        <= idle_s;
                r_read_buff_idx   <= 0;
                r_address         <= (others => '0');
                r_mm_we           <= '0';
                mem_writedata     <= (others => '0');
                mem_address       <= (others => '0');
                r_done            <= '0';
                ins_csr_interrupt <= '0';
    
                r_last_word <= '0';
            else
                if (r_mm_we = '1' and mem_waitrequest = '0') then
                    r_mm_we <= '0';
                end if;

                case r_mm_state is
            
                    when idle_s =>
                
                        if (sink_sop = '1' and sink_valid = '1' and r_en = '1') then
                            r_mm_state        <= write_s;
                            mem_writedata     <= sink_data;
                            mem_address       <= r_base_address;
                            r_mm_we           <= '1';

                            r_read_buff_idx   <= r_read_buff_idx + 1;
                            r_address         <= r_address + c_bytes;
                        end if;
            
                    when write_s =>
                        
                        if (r_mm_we = '0' or mem_waitrequest = '0') then
                            if r_last_word = '1' then

                                r_mm_state      <= done_s;
                                r_read_buff_idx <= 0;
                                r_address       <= (others => '0');
                                r_last_word     <= '0';

                            elsif (sink_valid = '1') then
                                if (r_read_buff_idx < MAX_PACKET_LEN) then
                                    r_mm_we           <= '1';
                                    r_read_buff_idx   <= r_read_buff_idx + 1;
                                    r_address         <= r_address + c_bytes;
                                    mem_writedata     <= sink_data;
                                    mem_address       <= r_address + r_base_address;
                                end if;

                                if (sink_eop = '1') then
                                    r_last_word <= '1';
                                end if;

                            end if;
                        end if;
                
                    when done_s =>
                        r_done            <= '1';
                        ins_csr_interrupt <= '1';
                        
                        if (r_clear = '1') then
                            r_mm_state        <= idle_s;
                            r_done            <= '0';
                            ins_csr_interrupt <= '0';
                        end if;
            
                    when others =>
            
                end case;
            end if;
        end if;
    
    end process write_to_mem;
    
    mem_write <= r_mm_we;
    
end architecture rtl;
