library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- both inputs are signed
-- output is unsigned

entity fft_magnitude is
    generic (
        IN_WIDTH          : integer := 29;
        OUT_WIDTH         : integer := 58;
        AMPS_WIDTH        : integer := 3;
        FILTERS_WIDTH     : integer := 2;
        ATTENUATOR_WIDTH  : integer := 6;
        FFT_SAMPLES_WIDTH : integer := 14
    );
    port (
        clk : in std_logic;
        reset_n : in std_logic;

        sink_real     : in std_logic_vector(IN_WIDTH-1 downto 0);
        sink_imag     : in std_logic_vector(IN_WIDTH-1 downto 0);
		sink_index      : in std_logic_vector(FFT_SAMPLES_WIDTH-1 downto 0);
        sink_valid      : in std_logic;
        sink_sop        : in std_logic;
        sink_eop        : in std_logic;
        sink_amps       : in std_logic_vector(AMPS_WIDTH-1 downto 0);
        sink_filters    : in std_logic_vector(FILTERS_WIDTH-1 downto 0);
        sink_attenuator : in std_logic_vector(ATTENUATOR_WIDTH-1 downto 0);
        sink_protection : in std_logic;
        sink_error      : in std_logic;
        

        source_magnitude  : out std_logic_vector(OUT_WIDTH-1 downto 0);
        source_index      : out std_logic_vector(FFT_SAMPLES_WIDTH-1 downto 0);
		source_valid      : out std_logic;
        source_sop        : out std_logic;
        source_eop        : out std_logic;
        source_amps       : out std_logic_vector(AMPS_WIDTH-1 downto 0);
        source_filters    : out std_logic_vector(FILTERS_WIDTH-1 downto 0);
        source_attenuator : out std_logic_vector(ATTENUATOR_WIDTH-1 downto 0);
        source_protection : out std_logic;
        source_error      : out std_logic
        
    );
end entity fft_magnitude;

architecture rtl of fft_magnitude is
    constant c_throughput_latency : integer := 3;
    constant c_flags_width : integer := 3 + AMPS_WIDTH + FILTERS_WIDTH + ATTENUATOR_WIDTH + 1 + 1 + FFT_SAMPLES_WIDTH;
    signal r_real, r_imag : signed(IN_WIDTH-1 downto 0);
	signal r_real_squared, r_imag_squared : signed((2*IN_WIDTH)-1 downto 0);
	signal r_magnitude : signed((2*IN_WIDTH) downto 0);

    subtype t_flags is std_logic_vector(c_flags_width-1 downto 0);
	type t_flags_pipe is array(c_throughput_latency-1 downto 0) of t_flags;
    signal r_flags_pipe : t_flags_pipe;
    
begin
	process (clk, reset_n)
	begin
        if (rising_edge(clk)) then
			if (reset_n = '0') then
				r_real <= (others => '0');
				r_imag <= (others => '0');
				r_real_squared <= (others => '0');
				r_imag_squared <= (others => '0');
				r_flags_pipe <= (others => (others => '0'));
			else
				r_flags_pipe(c_throughput_latency-1 downto 1) <= r_flags_pipe(c_throughput_latency-2 downto 0);
				r_flags_pipe(0) <= sink_valid & sink_sop & sink_eop & sink_amps & sink_filters & sink_attenuator & sink_protection & sink_error & sink_index;

				r_real <= signed(sink_real);
				r_imag <= signed(sink_imag);
				r_real_squared <= r_real * r_real;
				r_imag_squared <= r_imag * r_imag;
				r_magnitude <= resize(r_real_squared, 2*IN_WIDTH+1) + resize(r_imag_squared, 2*IN_WIDTH+1);
			end if;
		end if;
	end process;

    source_valid      <= r_flags_pipe(c_throughput_latency-1)(c_flags_width-1);
    source_sop        <= r_flags_pipe(c_throughput_latency-1)(c_flags_width-2);
    source_eop        <= r_flags_pipe(c_throughput_latency-1)(c_flags_width-3);
    source_amps       <= r_flags_pipe(c_throughput_latency-1)(c_flags_width-4 downto c_flags_width-3-AMPS_WIDTH);
    source_filters    <= r_flags_pipe(c_throughput_latency-1)(c_flags_width-4-AMPS_WIDTH downto c_flags_width-3-AMPS_WIDTH-FILTERS_WIDTH);
    source_attenuator <= r_flags_pipe(c_throughput_latency-1)(c_flags_width-4-AMPS_WIDTH-FILTERS_WIDTH downto c_flags_width-3-AMPS_WIDTH-FILTERS_WIDTH-ATTENUATOR_WIDTH);
    source_protection <= r_flags_pipe(c_throughput_latency-1)(c_flags_width-4-AMPS_WIDTH-FILTERS_WIDTH-ATTENUATOR_WIDTH);
    source_error      <= r_flags_pipe(c_throughput_latency-1)(c_flags_width-4-AMPS_WIDTH-FILTERS_WIDTH-ATTENUATOR_WIDTH-1);
    source_index      <= r_flags_pipe(c_throughput_latency-1)(c_flags_width-4-AMPS_WIDTH-FILTERS_WIDTH-ATTENUATOR_WIDTH-2 downto c_flags_width-4-AMPS_WIDTH-FILTERS_WIDTH-ATTENUATOR_WIDTH-1-FFT_SAMPLES_WIDTH);
    
    source_magnitude <= std_logic_vector(r_magnitude(2*IN_WIDTH-1 downto 2*IN_WIDTH-OUT_WIDTH));
    
end architecture rtl;