library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sg_controller is
    generic (
        NCO_PHI_WIDTH : integer := 16;
        NCO_SIGNAL_WIDTH : integer := 14
    );
    port (
        clk   : in std_logic;
        reset_n : in std_logic;
        out_signal : out std_logic_vector(NCO_SIGNAL_WIDTH-1 downto 0);
		en0, en1 : in std_logic
    );
end entity sg_controller;

architecture rtl of sg_controller is
	constant phi_inc_35M : std_logic_vector(NCO_PHI_WIDTH-1 downto 0) := std_logic_vector(to_unsigned(((2**NCO_PHI_WIDTH)*35)/150, NCO_PHI_WIDTH));
	constant phi_inc_45M : std_logic_vector(NCO_PHI_WIDTH-1 downto 0) := std_logic_vector(to_unsigned(((2**NCO_PHI_WIDTH)*45)/150, NCO_PHI_WIDTH));
    component NCO is
        port (
            nco_ii_0_clk_clk     : in  std_logic                     := '0';             -- nco_ii_0_clk.clk
            nco_ii_0_in_valid    : in  std_logic                     := '0';             --  nco_ii_0_in.valid
            nco_ii_0_in_data     : in  std_logic_vector(NCO_PHI_WIDTH-1 downto 0) := (others => '0'); --             .data
            nco_ii_0_out_data    : out signed(NCO_SIGNAL_WIDTH-1 downto 0);                    -- nco_ii_0_out.data
            nco_ii_0_out_valid   : out std_logic;                                        --             .valid
            nco_ii_0_rst_reset_n : in  std_logic                     := '0'              -- nco_ii_0_rst.reset_n
        );
    end component NCO;

    signal nco0_data : signed(NCO_SIGNAL_WIDTH-1 downto 0);
    signal nco1_data : signed(NCO_SIGNAL_WIDTH-1 downto 0);
    signal nco_sum  : signed(NCO_SIGNAL_WIDTH downto 0);
begin
    u0: NCO
        port map (
            nco_ii_0_clk_clk   => clk,
            nco_ii_0_rst_reset_n => reset_n,
            nco_ii_0_in_valid => en0,
            nco_ii_0_in_data => phi_inc_35M,
            nco_ii_0_out_data => nco0_data,
            nco_ii_0_out_valid => open
        );

    u1: NCO
        port map (
            nco_ii_0_clk_clk   => clk,
            nco_ii_0_rst_reset_n => reset_n,
            nco_ii_0_in_valid => en1,
            nco_ii_0_in_data => phi_inc_45M,
            nco_ii_0_out_data => nco1_data,
            nco_ii_0_out_valid => open
        );
    
    nco_sum <= resize(nco0_data, NCO_SIGNAL_WIDTH+1) + resize(nco1_data, NCO_SIGNAL_WIDTH+1);
    out_signal <= std_logic_vector(nco_sum(NCO_SIGNAL_WIDTH downto 1));

end architecture;