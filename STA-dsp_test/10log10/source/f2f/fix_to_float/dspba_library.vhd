-- (C) 2012 Altera Corporation. All rights reserved.
-- Your use of Altera Corporation's design tools, logic functions and other
-- software and tools, and its AMPP partner logic functions, and any output
-- files any of the foregoing (including device programming or simulation
-- files), and any associated documentation or information are expressly subject
-- to the terms and conditions of the Altera Program License Subscription
-- Agreement, Altera MegaCore Function License Agreement, or other applicable
-- license agreement, including, without limitation, that your use is for the
-- sole purpose of programming logic devices manufactured by Altera and sold by
-- Altera or its authorized distributors.  Please refer to the applicable
-- agreement for further details.

library IEEE;
use IEEE.std_logic_1164.all;
use work.dspba_library_package.all;

entity dspba_delay is
    generic (
        width : natural := 8;
        depth : natural := 1;
        reset_high : std_logic := '1';
        reset_kind : string := "ASYNC"
    );
    port (
        clk   : in  std_logic;
        aclr  : in  std_logic;
        ena   : in  std_logic := '1';
        xin   : in  std_logic_vector(width-1 downto 0);
        xout  : out std_logic_vector(width-1 downto 0)
    );
end dspba_delay;

architecture delay of dspba_delay is
    type delay_array is array (depth downto 0) of std_logic_vector(width-1 downto 0);
    signal delay_signals : delay_array;
begin
    delay_signals(depth) <= xin;

    delay_block: if 0 < depth generate
    begin
        delay_loop: for i in depth-1 downto 0 generate
        begin
            async_reset: if reset_kind = "ASYNC" generate
                process(clk, aclr)
                begin
                    if aclr=reset_high then
                        delay_signals(i) <= (others => '0');
                    elsif clk'event and clk='1' then
                        if ena='1' then
                            delay_signals(i) <= delay_signals(i + 1);
                        end if;
                    end if;
                end process;
            end generate;

            sync_reset: if reset_kind = "SYNC" generate
                process(clk)
                begin
                    if clk'event and clk='1' then
                        if aclr=reset_high then
                            delay_signals(i) <= (others => '0');
                        elsif ena='1' then
                            delay_signals(i) <= delay_signals(i + 1);
                        end if;
                    end if;
                end process;
            end generate;

            no_reset: if reset_kind = "NONE" generate
                process(clk)
                begin
                    if clk'event and clk='1' then
                        if ena='1' then
                            delay_signals(i) <= delay_signals(i + 1);
                        end if;
                    end if;
                end process;
            end generate;
        end generate;
    end generate;

    xout <= delay_signals(0);
end delay;


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;
use work.dspba_library_package.all;

entity dspba_sync_reg is
    generic (
        width1 : natural := 8;
        init_value : std_logic_vector;
        width2 : natural := 8;
        depth : natural := 2;
        pulse_multiplier : natural := 1;
        counter_width : natural := 8;
        reset1_high : std_logic := '1';
        reset2_high : std_logic := '1';
        reset_kind : string := "ASYNC"
    );
    port (
        clk1    : in std_logic;
        aclr1   : in std_logic;
        ena     : in std_logic_vector(0 downto 0);
        xin     : in std_logic_vector(width1-1 downto 0);
        xout    : out std_logic_vector(width1-1 downto 0);
        clk2    : in std_logic;
        aclr2   : in std_logic;
        sxout   : out std_logic_vector(width2-1 downto 0)
    );
end entity;

architecture sync_reg of dspba_sync_reg is
    type bit_array is array (depth-1 downto 0) of std_logic;

    signal iclk_enable : std_logic;
    signal iclk_data : std_logic_vector(width1-1 downto 0);
    signal oclk_data : std_logic_vector(width2-1 downto 0); 

    -- For Synthesis this means: preserve this registers and do not merge any other flip-flops with synchronizer flip-flops 
    -- For TimeQuest this means: identify these flip-flops as synchronizer to enable aitomatic MTBF analysis
    signal sync_regs : bit_array;
    attribute altera_attribute : string;
    attribute altera_attribute of sync_regs : signal is "-name SYNCHRONIZER_IDENTIFICATION FORCED_IF_ASYNCHRONOUS; -name DONT_MERGE_REGISTER ON; -name PRESERVE_REGISTER ON";

    signal oclk_enable : std_logic;

    constant init_value_internal : std_logic_vector(width1-1 downto 0) := init_value;
    
    signal counter : UNSIGNED(counter_width-1 downto 0);
    signal ena_internal : std_logic;
begin
    oclk_enable <= sync_regs(depth-1);  

    no_multiplication: if pulse_multiplier=1 generate
        ena_internal <= ena(0);
    end generate;

    async_reset: if reset_kind="ASYNC" generate
        
        multiply_ena: if pulse_multiplier>1 generate
            ena_internal <= '1' when counter>0 else ena(0);
            process (clk1, aclr1)
	        begin	
                if aclr1=reset1_high then
                    counter <= (others => '0');
                elsif clk1'event and clk1='1' then
                    if counter>0 then
                        if counter=pulse_multiplier-1 then
                            counter <= (others => '0');
                        else 
                            counter <= counter + TO_UNSIGNED(1, counter_width);
                        end if;
                    else
                        if ena(0)='1' then
                            counter <= TO_UNSIGNED(1, counter_width);
                        end if;
                    end if;
                end if;
            end process;
        end generate;
        
        process (clk1, aclr1)
        begin
            if aclr1=reset1_high then
                iclk_enable <= '0';
                iclk_data <= init_value_internal;
            elsif clk1'event and clk1='1' then
                iclk_enable <= ena_internal;
                if ena(0)='1' then
                    iclk_data <= xin;
                end if;
            end if;
        end process;
        
        sync_reg_loop: for i in 0 to depth-1 generate
            process (clk2, aclr2) 
            begin
                if aclr2=reset2_high then
                    sync_regs(i) <= '0';
                elsif clk2'event and clk2='1' then
                    if i>0 then
                        sync_regs(i) <= sync_regs(i-1); 
                    else
                        sync_regs(i) <= iclk_enable; 
                    end if;
                end if;
            end process;
        end generate;
    
        process (clk2, aclr2)
        begin
            if aclr2=reset2_high then
                oclk_data <= init_value_internal(width2-1 downto 0);
            elsif clk2'event and clk2='1' then
                if oclk_enable='1' then
                    oclk_data <= iclk_data(width2-1 downto 0);
                end if;
            end if;
        end process;
    end generate;

    sync_reset: if reset_kind="SYNC" generate

        multiply_ena: if pulse_multiplier>1 generate
            ena_internal <= '1' when counter>0 else ena(0);
            process (clk1)
	        begin
                if clk1'event and clk1='1' then
                    if aclr1=reset1_high then
                        counter <= (others => '0');
                    else
                        if counter>0 then
                            if counter=pulse_multiplier-1 then
                                counter <= (others => '0');
                            else 
                                counter <= counter + TO_UNSIGNED(1, counter_width);
                            end if;
                        else
                            if ena(0)='1' then
                                counter <= TO_UNSIGNED(1, counter_width);
                            end if;
                        end if;
                    end if;
                end if;
            end process;
        end generate;

        process (clk1)
        begin
            if clk1'event and clk1='1' then
                if aclr1=reset1_high then
                    iclk_enable <= '0';
                    iclk_data <= init_value_internal;
                else 
                    iclk_enable <= ena_internal;
                    if ena(0)='1' then
                        iclk_data <= xin;
                    end if;
                end if;
            end if;
        end process;
        
        sync_reg_loop: for i in 0 to depth-1 generate
            process (clk2) 
            begin
                if clk2'event and clk2='1' then
                    if aclr2=reset2_high then
                        sync_regs(i) <= '0';
                    else 
                        if i>0 then
                            sync_regs(i) <= sync_regs(i-1); 
                        else
                            sync_regs(i) <= iclk_enable; 
                        end if;
                    end if;
                end if;
            end process;
        end generate;
    
        process (clk2)
        begin
            if clk2'event and clk2='1' then
                if aclr2=reset2_high then
                    oclk_data <= init_value_internal(width2-1 downto 0);
                elsif oclk_enable='1' then
                    oclk_data <= iclk_data(width2-1 downto 0);
                end if;
            end if;
        end process;
    end generate;

    none_reset: if reset_kind="NONE" generate
        
        multiply_ena: if pulse_multiplier>1 generate
            ena_internal <= '1' when counter>0 else ena(0);
            process (clk1, aclr1) 
	        begin
                if clk1'event and clk1='1' then
                    if counter>0 then
                        if counter=pulse_multiplier-1 then
                            counter <= (others => '0');
                        else 
                            counter <= counter + TO_UNSIGNED(1, counter_width);
                        end if;
                    else
                        if ena(0)='1' then
                            counter <= TO_UNSIGNED(1, counter_width);
                        end if;
                    end if;
                end if;
            end process;
        end generate;

        process (clk1)
        begin
            if clk1'event and clk1='1' then
                iclk_enable <= ena_internal;
                if ena(0)='1' then
                    iclk_data <= xin;
                end if;
            end if;
        end process;
        
        sync_reg_loop: for i in 0 to depth-1 generate
            process (clk2) 
            begin
                if clk2'event and clk2='1' then
                    if i>0 then
                        sync_regs(i) <= sync_regs(i-1); 
                    else
                        sync_regs(i) <= iclk_enable; 
                    end if;
                end if;
            end process;
        end generate;
    
        process (clk2)
        begin
            if clk2'event and clk2='1' then
                if oclk_enable='1' then
                    oclk_data <= iclk_data(width2-1 downto 0);
                end if;
            end if;
        end process;
    end generate;

    xout <= iclk_data;
    sxout <= oclk_data;

end sync_reg;
