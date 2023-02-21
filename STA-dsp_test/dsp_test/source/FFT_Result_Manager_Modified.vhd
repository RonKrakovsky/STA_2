--
--
--This Entity is the FFT Results Manager, that manages the output of the FFT QIP.
--The data transmition will be under the Avalon-ST interface.
--
--Generics:
--
--- FFT_In_Data_Width		 	 : The FFT real and imaginery input width (16).		  
--- FFT_Transform_Width	 	 : The fft transform size (9).
--- FFT_Transform_Width	 : The fft maximum transform width, Log2(MaxTransformSize).
--
--Inputs:
--
--- csi_sink_clk          	 : System clock (96 MHz).
--- rsi_sink_reset_n      	 : Active-low asynchronous.
--- asi_sink_FFT_sop      	 : Asserted when the FFT data packet starts.
--- asi_sink_FFT_eop      	 : Asserted when the FFT data packet ends.
--- asi_sink_FFT_valid         : Asserted when the FFT data is valid.
--- asi_sink_FFT_data 	     : The FFT source data, contain real data, imag data and fftpts_out. 
--							   The data is received in Bit-Reveresed.
--										
--Outputs:
--
--- aso_source_ready       	 : Asserted.
--- aso_source_bit_reversed   : Bit reversed counter.
--- aso_source_FFT_real_data  : The FFT source real data.
--- aso_source_FFT_imag_data  : The FFT source imag data.
--
--FFT Calculation:
--
--- System Clock * NCO Input / NCO Size = Desired FFT Result.
--- System Clock / FFT Size = FFT Resolution.
--- FFT Bit-Reversed Result * FFT Resolution = Actual FFT Result.



Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Entity FFT_Result_Manager_Modified is

	Generic(FFT_In_Data_Width       : integer   := 16;
			FFT_Transform_Width     : integer   := 14);	
	Port(csi_sink_clk     				  : in std_logic;
		  rsi_sink_reset_n 				  : in std_logic;
		  asi_sink_FFT_sop    		      : in std_logic;
		  asi_sink_FFT_eop     		  	  : in std_logic;
		  asi_sink_FFT_valid      		  : in std_logic;
		  asi_sink_FFT_data		  		  : in std_logic_vector((FFT_In_Data_Width * 2) + FFT_Transform_Width downto 0);

		  in_amps : in std_logic_vector(2 downto 0);
		  in_filters : in std_logic_vector(1 downto 0);
		  in_attenuator : in std_logic_vector(5 downto 0);
		  in_protection : in std_logic;
		  in_error : in std_logic;
		  
		  aso_source_ready      		  : out std_logic;
		  aso_source_FFT_real_data        : out std_logic_vector((FFT_In_Data_Width - 1) downto 0);
		  aso_source_FFT_imag_data        : out std_logic_vector((FFT_In_Data_Width - 1) downto 0);
		  aso_source_bit_reversed         : out std_logic_vector((FFT_Transform_Width - 1) downto 0);

		  Packet_Manager_valid,Packet_Manager_sop,Packet_Manager_eop    : out std_Logic;

		  out_amps : out std_logic_vector(2 downto 0);
		  out_filters : out std_logic_vector(1 downto 0);
		  out_attenuator : out std_logic_vector(5 downto 0);
		  out_protection : out std_logic;
		  out_error : out std_logic

		  );
		  
End Entity;

Architecture Arch_FFT_Result_Manager_Modified of FFT_Result_Manager_Modified is

Type t_state is (st_idle,st_sop,st_data,st_eop);

Signal s_state : t_state;
Signal s_counter : integer range 0 to 2**FFT_Transform_Width;
Signal s_between_packets: std_Logic;
Signal s_Bit_Reversed_counter, s_std_counter : std_logic_vector ((FFT_Transform_Width - 1) downto 0);

Begin

	aso_source_ready <= '1'; -- Ready Asserted.
	
	s_std_counter <= std_logic_vector(to_unsigned(s_counter, FFT_Transform_Width)); -- convert integer to std_logic_vector.
	
	Bit_Reverse_Operation : for i in 0 to (FFT_Transform_Width - 1) generate -- Bit Reveresed Operation.
					
		s_Bit_Reversed_counter(i) <= s_std_counter((FFT_Transform_Width - 1) - i);
			
	end generate Bit_Reverse_Operation;
	
	aso_source_bit_reversed <= s_bit_Reversed_counter; -- output the reversed bit.
--	aso_source_bit_reversed <= s_std_counter;
	
	-- aso_source_FFT_real_data <= asi_sink_FFT_data(((FFT_In_Data_Width * 2) + FFT_Transform_Width) downto (FFT_In_Data_Width + FFT_Transform_Width + 1)) when s_between_packets = '1' else (others => '0');
	-- aso_source_FFT_imag_data <= asi_sink_FFT_data(((FFT_In_Data_Width) + FFT_Transform_Width) downto (FFT_Transform_Width + 1)) when s_between_packets = '1' else (others => '0');

	Process(rsi_sink_reset_n, csi_sink_clk)
	Begin
		
		if (rising_edge(csi_sink_clk)) then
			if (rsi_sink_reset_n = '0') then
			
				s_counter <= 0;
				s_between_packets <= '0';
				aso_source_FFT_real_data <= (others => '0');
				aso_source_FFT_imag_data <= (others => '0');
			else
				Packet_Manager_sop <= asi_sink_FFT_sop;
				Packet_Manager_eop <= asi_sink_FFT_eop;
				Packet_Manager_valid <= asi_sink_FFT_valid;

				aso_source_FFT_real_data <= asi_sink_FFT_data(((FFT_In_Data_Width * 2) + FFT_Transform_Width) downto (FFT_In_Data_Width + FFT_Transform_Width + 1));
				aso_source_FFT_imag_data <= asi_sink_FFT_data(((FFT_In_Data_Width) + FFT_Transform_Width) downto (FFT_Transform_Width + 1));

				if (asi_sink_FFT_sop = '1' and asi_sink_FFT_valid = '1') then -- FFT Start of Packet 
					
					s_state <= st_sop;
					s_between_packets <= '1';	
					
				elsif (asi_sink_FFT_eop = '1' and asi_sink_FFT_valid = '1') then -- FFT End of Packet
				
					s_state <= st_eop;
					s_between_packets <= '0';
				
				end if;

				if (asi_sink_FFT_sop = '1') then -- Data That Passes Through All System Components
					out_amps <= in_amps;
					out_attenuator <= in_attenuator;
					out_filters <= in_filters; 
				end if;
			
				case s_state is
					
					when st_sop => 
						if asi_sink_FFT_valid = '1' then
							s_counter <= s_counter + 1;
						end if;
					
					when st_eop => s_counter <= 0;
					
					when others =>
					
				end case;	

			end if;
		end if;
	End Process;

End Arch_FFT_Result_Manager_Modified;

	