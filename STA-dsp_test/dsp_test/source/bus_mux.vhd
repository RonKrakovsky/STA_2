library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bus_mux is
    generic (
        DATA_WIDTH : integer := 14
    );
    port (
        clk   : in std_logic;
        
        i_sel : in std_logic;
        i_signal_a : in std_logic_vector(DATA_WIDTH-1 downto 0);
        i_signal_b : in std_logic_vector(DATA_WIDTH-1 downto 0);

        o_signal : out std_logic_vector(DATA_WIDTH-1 downto 0)
        
    );
end entity bus_mux;

architecture rtl of bus_mux is
begin
    process (clk)
    begin
        if (rising_edge(clk)) then
            if i_sel = '0' then
                o_signal <= i_signal_a;
            else
                o_signal <= i_signal_b;
            end if;
        end if;
    end process;
end architecture;
