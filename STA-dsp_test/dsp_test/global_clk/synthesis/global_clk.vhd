-- global_clk.vhd

-- Generated using ACDS version 20.1 711

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity global_clk is
	port (
		inclk  : in  std_logic := '0'; --  altclkctrl_input.inclk
		outclk : out std_logic         -- altclkctrl_output.outclk
	);
end entity global_clk;

architecture rtl of global_clk is
	component global_clk_altclkctrl_0 is
		port (
			inclk  : in  std_logic := 'X'; -- inclk
			outclk : out std_logic         -- outclk
		);
	end component global_clk_altclkctrl_0;

begin

	altclkctrl_0 : component global_clk_altclkctrl_0
		port map (
			inclk  => inclk,  --  altclkctrl_input.inclk
			outclk => outclk  -- altclkctrl_output.outclk
		);

end architecture rtl; -- of global_clk
