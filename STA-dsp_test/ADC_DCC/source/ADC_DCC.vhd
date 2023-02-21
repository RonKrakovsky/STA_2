-- Name : Ron Krakovsky 
-- Component : DCC ALTERA with HSMC Conector. 
-- the adresses for DE10-Standart HSMC.
-- importent : the clock for DCC need to be phase shift to 180 deg. 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ADC_DCC is
	generic (
		FFT_DATA_WIDTH 	: integer := 16;
		ADC_WIDTH		: integer := 14
	);
	port 
	(
		i_clk : in std_logic;
		
		FPGA_CLK_A_P : out std_logic;
		FPGA_CLK_A_N : out std_logic;
		FPGA_CLK_B_P : out std_logic;
		FPGA_CLK_B_N : out std_logic;
		
		AD_SCLK		 : out std_logic; -- (DFS)Data Format Select
		AD_SDIO		 : out std_logic; -- (DCS)Duty Cycle Stabilizer Select
		ADA_OE		 : out std_logic; -- enable ADA output
		ADB_OE		 : out std_logic; -- enable ADB output
		ADA_SPI_CS	 : out std_logic; -- disable ADA_SPI_CS (CSB)
		ADB_SPI_CS	 : out std_logic; -- disable ADB_SPI_CS (CSB)
		
		ADA_D		 : in std_logic_vector(ADC_WIDTH-1 downto 0); -- data from chanel A
		ADB_D		 : in std_logic_vector(ADC_WIDTH-1 downto 0); -- data from chanel B
		o_data_A	 : out std_logic_vector(FFT_DATA_WIDTH-1 downto 0);
		o_data_B	 : out std_logic_vector(FFT_DATA_WIDTH-1 downto 0)
		
	);

end entity;


architecture rtl of ADC_DCC is
	signal r_data_a, r_data_b : std_logic_vector(ADC_WIDTH-1 downto 0);
	
begin
	-- positive gets inverted clock to create 180 degree phase shift
	FPGA_CLK_B_N <= i_clk; 
	FPGA_CLK_B_P <= not i_clk;
	FPGA_CLK_A_N <= i_clk;
	FPGA_CLK_A_P <= not i_clk;

	ADA_OE <= '0';	
	ADB_OE <= '0';	
	ADA_SPI_CS <= '1'; 
	ADB_SPI_CS <= '1';
	AD_SCLK <= '1';
	AD_SDIO <= '0';

	process(i_clk)
	begin
		if rising_edge(i_clk) then
			r_data_a <= ADA_D;
			r_data_b <= ADB_D;
			
--			o_data_A(FFT_DATA_WIDTH-1 downto FFT_DATA_WIDTH-ADC_WIDTH) <= r_data_a;
			o_data_A <= r_data_a;
				
			o_data_B(FFT_DATA_WIDTH-1 downto FFT_DATA_WIDTH-ADC_WIDTH) <= r_data_b;
		end if;
	end process;
end rtl;
