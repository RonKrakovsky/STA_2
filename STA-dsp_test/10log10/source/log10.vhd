-- Name : Ron Krakovsky 
-- Component : Calculate 10LOG(in) with 2 components from ip core, 
-- ALTFP_CONVERT & ALTFP_LOG (this components work in FLOATING POINT).
-- The component take 33 clocks for result : 12 for convert & 21 for log.
-- the input is integer 32 bit and output sfix32_En10  

LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library altera_mf;
use altera_mf.altera_mf_components.all; 

entity log10 is
    generic (
        DATA_WIDTH : integer := 64
    );
    port (
        clk : in std_logic;
        reset_n : in std_logic;
        
        -- AVALON STRIMING SINK
        asi_sink_ready : out std_logic;
        asi_sink_valid : in std_logic;
        asi_sink_data : in std_logic_vector(DATA_WIDTH-1 downto 0); --sfix32_En0

        -- AVALON STRIMING SOURCE
        aso_source_data   : out std_logic_vector(31 downto 0); --sfix32_En10
        aso_source_valid  : out std_logic 

    );
end entity log10;

architecture rtl of log10 is
    
    component log_v2
        port
        (
            aclr		: in std_logic ;
            clock		: in std_logic ;
            data		: in std_logic_vector (31 downto 0);
            result		: out std_logic_vector (31 downto 0)
        );
    end component;
    
	component fix_to_float is
		port (
			clk    : in  std_logic                     := 'X';             -- clk
			areset : in  std_logic                     := 'X';             -- reset
			a      : in  std_logic_vector(77 downto 0) := (others => 'X'); -- a
			q      : out std_logic_vector(31 downto 0)                     -- q
		);
	end component fix_to_float;

    signal r_counter : integer range 0 to 63;
    signal r_aclr, r_ready : std_logic;

    signal r_data : std_logic_vector(DATA_WIDTH-1 downto 0);
	signal w_float_data : std_logic_vector(31 downto 0);
	signal w_float_log_data : std_logic_vector(31 downto 0);
	signal w_fixed_log_data : std_logic_vector(26 downto 0);
    signal w_10log : std_logic_vector(53 downto 0);

    type states_T is (idle, cal);
    signal state : states_T;

begin

    main : process(clk)
    begin
        if rising_edge(clk) then
            if reset_n = '0' then 
                state <= idle;
                r_ready <= '0';
                aso_source_valid <= '0';
                r_data <= (others => '0');
            else
                case state is
                    when idle =>

                        if asi_sink_valid = '1' and r_ready = '1' then 
                            state <= cal;
                            r_data <= asi_sink_data;
                            r_aclr <= '0';
                            r_counter <= 1;
                            r_ready <= '0';
                        else
                            r_aclr <= '1';
                            r_counter <= 0;
                            r_ready <= '1';
                        end if;
                        
                        aso_source_valid <= '0';
                        
                        
                    when cal =>
                        
                        if r_counter = 60 then 
                            aso_source_valid <= '1';
                            r_counter <= 0;
                            state <= idle;
                        else
                            r_counter <= r_counter + 1;
                        end if;
                        
                end case;
            end if;
        end if;
    end process main;

    -- u1 : i2f port map (clock => clk ,dataa => sig_cal_argu , result => sig_result);
    u1 : ALTFP_CONVERT
	generic map (
		intended_device_family => "Cyclone V",
		lpm_hint => "UNUSED",
		lpm_type => "altfp_convert",
		operation => "INT2FLOAT",
		rounding => "TO_NEAREST",
		width_data => DATA_WIDTH,
		width_exp_input => 8,
		width_exp_output => 8,
		width_int => DATA_WIDTH,
		width_man_input => 23,
		width_man_output => 23,
		width_result => 32
	)
	port map (
		clock => clk,
		dataa => r_data,
		result => w_float_data
	);
    -- u1 : fix_to_float
	-- port map (
	-- 	clk => clk,
	-- 	areset => not reset_n,
	-- 	a => r_data,
	-- 	q => w_float_data
	-- );
    
    u2 : log_v2 port map (aclr => r_aclr ,clock => clk ,data => w_float_data , result => w_float_log_data);
    
    u3 : ALTFP_CONVERT
	generic map (
		intended_device_family => "Cyclone V",
		lpm_hint => "UNUSED",
		lpm_type => "altfp_convert",
		operation => "FLOAT2FIXED",
		rounding => "TO_NEAREST",
		width_data => 32,
		width_exp_input => 8,
		width_exp_output => 8,
		width_int => 7,			-- largest number is ln(2^63) = 44.. | 1 bit for sign | 6 bits for 0-63 | other for fraction to complete for 27 bits
		width_man_input => 23,
		width_man_output => 23,
		width_result => 27
	)
	port map (
		clock => clk,
		dataa => w_float_log_data,
		result => w_fixed_log_data
	);

    -- uses 1 dsp block for 26x26 unsigned multiplication (27x27 signed multiplication)
	-- 10/ln(10) = 4.347..
	-- 4.347 represented as 72862523 in ufix27_en24 | 3 bits to represent 4 | other for fraction to complete for 27 bits
	w_10log <= std_logic_vector(unsigned(w_fixed_log_data) * to_unsigned(72862523, 27));
    aso_source_data(31 downto 0) <= w_10log(53 downto 22);

    asi_sink_ready <= r_ready;
end architecture rtl;
