-- ------------------------------------------------------------------------- 
-- High Level Design Compiler for Intel(R) FPGAs Version 17.0 (Release Build #595)
-- Quartus Prime development tool and MATLAB/Simulink Interface
-- 
-- Legal Notice: Copyright 2017 Intel Corporation.  All rights reserved.
-- Your use of  Intel Corporation's design tools,  logic functions and other
-- software and  tools, and its AMPP partner logic functions, and any output
-- files any  of the foregoing (including  device programming  or simulation
-- files), and  any associated  documentation  or information  are expressly
-- subject  to the terms and  conditions of the  Intel FPGA Software License
-- Agreement, Intel MegaCore Function License Agreement, or other applicable
-- license agreement,  including,  without limitation,  that your use is for
-- the  sole  purpose of  programming  logic devices  manufactured by  Intel
-- and  sold by Intel  or its authorized  distributors. Please refer  to the
-- applicable agreement for further details.
-- ---------------------------------------------------------------------------

-- VHDL created from fix_to_float_0002
-- VHDL created on Mon Nov 14 09:01:39 2022


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;
use IEEE.MATH_REAL.all;
use std.TextIO.all;
use work.dspba_library_package.all;

LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;
LIBRARY altera_lnsim;
USE altera_lnsim.altera_lnsim_components.altera_syncram;
LIBRARY lpm;
USE lpm.lpm_components.all;

entity fix_to_float_0002 is
    port (
        a : in std_logic_vector(77 downto 0);  -- sfix78_en14
        q : out std_logic_vector(31 downto 0);  -- float32_m23
        clk : in std_logic;
        areset : in std_logic
    );
end fix_to_float_0002;

architecture normal of fix_to_float_0002 is

    attribute altera_attribute : string;
    attribute altera_attribute of normal : architecture is "-name AUTO_SHIFT_REGISTER_RECOGNITION OFF; -name PHYSICAL_SYNTHESIS_REGISTER_DUPLICATION ON; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 10037; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 15400; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 12020; -name MESSAGE_DISABLE 12030; -name MESSAGE_DISABLE 12010; -name MESSAGE_DISABLE 12110; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 13410; -name MESSAGE_DISABLE 113007";
    
    signal GND_q : STD_LOGIC_VECTOR (0 downto 0);
    signal VCC_q : STD_LOGIC_VECTOR (0 downto 0);
    signal signX_uid6_fxpToFPTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal xXorSign_uid7_fxpToFPTest_b : STD_LOGIC_VECTOR (77 downto 0);
    signal xXorSign_uid7_fxpToFPTest_qi : STD_LOGIC_VECTOR (77 downto 0);
    signal xXorSign_uid7_fxpToFPTest_q : STD_LOGIC_VECTOR (77 downto 0);
    signal y_uid9_fxpToFPTest_in : STD_LOGIC_VECTOR (77 downto 0);
    signal y_uid9_fxpToFPTest_b : STD_LOGIC_VECTOR (77 downto 0);
    signal maxCount_uid11_fxpToFPTest_q : STD_LOGIC_VECTOR (6 downto 0);
    signal inIsZero_uid12_fxpToFPTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal inIsZero_uid12_fxpToFPTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal msbIn_uid13_fxpToFPTest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal expPreRnd_uid14_fxpToFPTest_a : STD_LOGIC_VECTOR (8 downto 0);
    signal expPreRnd_uid14_fxpToFPTest_b : STD_LOGIC_VECTOR (8 downto 0);
    signal expPreRnd_uid14_fxpToFPTest_o : STD_LOGIC_VECTOR (8 downto 0);
    signal expPreRnd_uid14_fxpToFPTest_q : STD_LOGIC_VECTOR (8 downto 0);
    signal expFracRnd_uid16_fxpToFPTest_q : STD_LOGIC_VECTOR (32 downto 0);
    signal sticky_uid20_fxpToFPTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal sticky_uid20_fxpToFPTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal nr_uid21_fxpToFPTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal rnd_uid22_fxpToFPTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal rnd_uid22_fxpToFPTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal expFracR_uid24_fxpToFPTest_a : STD_LOGIC_VECTOR (34 downto 0);
    signal expFracR_uid24_fxpToFPTest_b : STD_LOGIC_VECTOR (34 downto 0);
    signal expFracR_uid24_fxpToFPTest_o : STD_LOGIC_VECTOR (34 downto 0);
    signal expFracR_uid24_fxpToFPTest_q : STD_LOGIC_VECTOR (33 downto 0);
    signal fracR_uid25_fxpToFPTest_in : STD_LOGIC_VECTOR (23 downto 0);
    signal fracR_uid25_fxpToFPTest_b : STD_LOGIC_VECTOR (22 downto 0);
    signal expR_uid26_fxpToFPTest_b : STD_LOGIC_VECTOR (9 downto 0);
    signal udf_uid27_fxpToFPTest_a : STD_LOGIC_VECTOR (11 downto 0);
    signal udf_uid27_fxpToFPTest_b : STD_LOGIC_VECTOR (11 downto 0);
    signal udf_uid27_fxpToFPTest_o : STD_LOGIC_VECTOR (11 downto 0);
    signal udf_uid27_fxpToFPTest_n : STD_LOGIC_VECTOR (0 downto 0);
    signal expInf_uid28_fxpToFPTest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal ovf_uid29_fxpToFPTest_a : STD_LOGIC_VECTOR (11 downto 0);
    signal ovf_uid29_fxpToFPTest_b : STD_LOGIC_VECTOR (11 downto 0);
    signal ovf_uid29_fxpToFPTest_o : STD_LOGIC_VECTOR (11 downto 0);
    signal ovf_uid29_fxpToFPTest_n : STD_LOGIC_VECTOR (0 downto 0);
    signal excSelector_uid30_fxpToFPTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal excSelector_uid30_fxpToFPTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracZ_uid31_fxpToFPTest_q : STD_LOGIC_VECTOR (22 downto 0);
    signal fracRPostExc_uid32_fxpToFPTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal fracRPostExc_uid32_fxpToFPTest_q : STD_LOGIC_VECTOR (22 downto 0);
    signal udfOrInZero_uid33_fxpToFPTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excSelector_uid34_fxpToFPTest_q : STD_LOGIC_VECTOR (1 downto 0);
    signal expZ_uid37_fxpToFPTest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal expR_uid38_fxpToFPTest_in : STD_LOGIC_VECTOR (7 downto 0);
    signal expR_uid38_fxpToFPTest_b : STD_LOGIC_VECTOR (7 downto 0);
    signal expRPostExc_uid39_fxpToFPTest_s : STD_LOGIC_VECTOR (1 downto 0);
    signal expRPostExc_uid39_fxpToFPTest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal outRes_uid40_fxpToFPTest_q : STD_LOGIC_VECTOR (31 downto 0);
    signal zs_uid42_lzcShifterZ1_uid10_fxpToFPTest_q : STD_LOGIC_VECTOR (63 downto 0);
    signal vCount_uid44_lzcShifterZ1_uid10_fxpToFPTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal vCount_uid44_lzcShifterZ1_uid10_fxpToFPTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal cStage_uid47_lzcShifterZ1_uid10_fxpToFPTest_q : STD_LOGIC_VECTOR (77 downto 0);
    signal vStagei_uid48_lzcShifterZ1_uid10_fxpToFPTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal vStagei_uid48_lzcShifterZ1_uid10_fxpToFPTest_q : STD_LOGIC_VECTOR (77 downto 0);
    signal zs_uid49_lzcShifterZ1_uid10_fxpToFPTest_q : STD_LOGIC_VECTOR (31 downto 0);
    signal vCount_uid51_lzcShifterZ1_uid10_fxpToFPTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal cStage_uid54_lzcShifterZ1_uid10_fxpToFPTest_q : STD_LOGIC_VECTOR (77 downto 0);
    signal vStagei_uid55_lzcShifterZ1_uid10_fxpToFPTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal vStagei_uid55_lzcShifterZ1_uid10_fxpToFPTest_q : STD_LOGIC_VECTOR (77 downto 0);
    signal zs_uid56_lzcShifterZ1_uid10_fxpToFPTest_q : STD_LOGIC_VECTOR (15 downto 0);
    signal vCount_uid58_lzcShifterZ1_uid10_fxpToFPTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal cStage_uid61_lzcShifterZ1_uid10_fxpToFPTest_q : STD_LOGIC_VECTOR (77 downto 0);
    signal vStagei_uid62_lzcShifterZ1_uid10_fxpToFPTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal vStagei_uid62_lzcShifterZ1_uid10_fxpToFPTest_q : STD_LOGIC_VECTOR (77 downto 0);
    signal vCount_uid65_lzcShifterZ1_uid10_fxpToFPTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal cStage_uid68_lzcShifterZ1_uid10_fxpToFPTest_q : STD_LOGIC_VECTOR (77 downto 0);
    signal vStagei_uid69_lzcShifterZ1_uid10_fxpToFPTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal vStagei_uid69_lzcShifterZ1_uid10_fxpToFPTest_q : STD_LOGIC_VECTOR (77 downto 0);
    signal zs_uid70_lzcShifterZ1_uid10_fxpToFPTest_q : STD_LOGIC_VECTOR (3 downto 0);
    signal vCount_uid72_lzcShifterZ1_uid10_fxpToFPTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal cStage_uid75_lzcShifterZ1_uid10_fxpToFPTest_q : STD_LOGIC_VECTOR (77 downto 0);
    signal vStagei_uid76_lzcShifterZ1_uid10_fxpToFPTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal vStagei_uid76_lzcShifterZ1_uid10_fxpToFPTest_q : STD_LOGIC_VECTOR (77 downto 0);
    signal zs_uid77_lzcShifterZ1_uid10_fxpToFPTest_q : STD_LOGIC_VECTOR (1 downto 0);
    signal vCount_uid79_lzcShifterZ1_uid10_fxpToFPTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal cStage_uid82_lzcShifterZ1_uid10_fxpToFPTest_q : STD_LOGIC_VECTOR (77 downto 0);
    signal vStagei_uid83_lzcShifterZ1_uid10_fxpToFPTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal vStagei_uid83_lzcShifterZ1_uid10_fxpToFPTest_q : STD_LOGIC_VECTOR (77 downto 0);
    signal vCount_uid86_lzcShifterZ1_uid10_fxpToFPTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal cStage_uid89_lzcShifterZ1_uid10_fxpToFPTest_q : STD_LOGIC_VECTOR (77 downto 0);
    signal vStagei_uid90_lzcShifterZ1_uid10_fxpToFPTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal vStagei_uid90_lzcShifterZ1_uid10_fxpToFPTest_q : STD_LOGIC_VECTOR (77 downto 0);
    signal vCount_uid91_lzcShifterZ1_uid10_fxpToFPTest_q : STD_LOGIC_VECTOR (6 downto 0);
    signal vCountBig_uid93_lzcShifterZ1_uid10_fxpToFPTest_a : STD_LOGIC_VECTOR (8 downto 0);
    signal vCountBig_uid93_lzcShifterZ1_uid10_fxpToFPTest_b : STD_LOGIC_VECTOR (8 downto 0);
    signal vCountBig_uid93_lzcShifterZ1_uid10_fxpToFPTest_o : STD_LOGIC_VECTOR (8 downto 0);
    signal vCountBig_uid93_lzcShifterZ1_uid10_fxpToFPTest_c : STD_LOGIC_VECTOR (0 downto 0);
    signal vCountFinal_uid95_lzcShifterZ1_uid10_fxpToFPTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal vCountFinal_uid95_lzcShifterZ1_uid10_fxpToFPTest_q : STD_LOGIC_VECTOR (6 downto 0);
    signal yE_uid8_fxpToFPTest_UpperBits_for_b_q : STD_LOGIC_VECTOR (77 downto 0);
    signal yE_uid8_fxpToFPTest_p1_of_2_a : STD_LOGIC_VECTOR (73 downto 0);
    signal yE_uid8_fxpToFPTest_p1_of_2_b : STD_LOGIC_VECTOR (73 downto 0);
    signal yE_uid8_fxpToFPTest_p1_of_2_o : STD_LOGIC_VECTOR (73 downto 0);
    signal yE_uid8_fxpToFPTest_p1_of_2_c : STD_LOGIC_VECTOR (0 downto 0);
    signal yE_uid8_fxpToFPTest_p1_of_2_q : STD_LOGIC_VECTOR (72 downto 0);
    signal yE_uid8_fxpToFPTest_p2_of_2_a : STD_LOGIC_VECTOR (7 downto 0);
    signal yE_uid8_fxpToFPTest_p2_of_2_b : STD_LOGIC_VECTOR (7 downto 0);
    signal yE_uid8_fxpToFPTest_p2_of_2_o : STD_LOGIC_VECTOR (7 downto 0);
    signal yE_uid8_fxpToFPTest_p2_of_2_cin : STD_LOGIC_VECTOR (0 downto 0);
    signal yE_uid8_fxpToFPTest_p2_of_2_q : STD_LOGIC_VECTOR (5 downto 0);
    signal yE_uid8_fxpToFPTest_BitJoin_for_q_q : STD_LOGIC_VECTOR (78 downto 0);
    signal yE_uid8_fxpToFPTest_BitSelect_for_a_BitJoin_for_c_q : STD_LOGIC_VECTOR (5 downto 0);
    signal yE_uid8_fxpToFPTest_BitSelect_for_b_BitJoin_for_b_q : STD_LOGIC_VECTOR (72 downto 0);
    signal yE_uid8_fxpToFPTest_BitSelect_for_a_tessel0_0_merged_bit_select_b : STD_LOGIC_VECTOR (72 downto 0);
    signal yE_uid8_fxpToFPTest_BitSelect_for_a_tessel0_0_merged_bit_select_c : STD_LOGIC_VECTOR (4 downto 0);
    signal rVStage_uid43_lzcShifterZ1_uid10_fxpToFPTest_merged_bit_select_b : STD_LOGIC_VECTOR (63 downto 0);
    signal rVStage_uid43_lzcShifterZ1_uid10_fxpToFPTest_merged_bit_select_c : STD_LOGIC_VECTOR (13 downto 0);
    signal l_uid17_fxpToFPTest_merged_bit_select_in : STD_LOGIC_VECTOR (1 downto 0);
    signal l_uid17_fxpToFPTest_merged_bit_select_b : STD_LOGIC_VECTOR (0 downto 0);
    signal l_uid17_fxpToFPTest_merged_bit_select_c : STD_LOGIC_VECTOR (0 downto 0);
    signal rVStage_uid50_lzcShifterZ1_uid10_fxpToFPTest_merged_bit_select_b : STD_LOGIC_VECTOR (31 downto 0);
    signal rVStage_uid50_lzcShifterZ1_uid10_fxpToFPTest_merged_bit_select_c : STD_LOGIC_VECTOR (45 downto 0);
    signal rVStage_uid57_lzcShifterZ1_uid10_fxpToFPTest_merged_bit_select_b : STD_LOGIC_VECTOR (15 downto 0);
    signal rVStage_uid57_lzcShifterZ1_uid10_fxpToFPTest_merged_bit_select_c : STD_LOGIC_VECTOR (61 downto 0);
    signal rVStage_uid64_lzcShifterZ1_uid10_fxpToFPTest_merged_bit_select_b : STD_LOGIC_VECTOR (7 downto 0);
    signal rVStage_uid64_lzcShifterZ1_uid10_fxpToFPTest_merged_bit_select_c : STD_LOGIC_VECTOR (69 downto 0);
    signal rVStage_uid71_lzcShifterZ1_uid10_fxpToFPTest_merged_bit_select_b : STD_LOGIC_VECTOR (3 downto 0);
    signal rVStage_uid71_lzcShifterZ1_uid10_fxpToFPTest_merged_bit_select_c : STD_LOGIC_VECTOR (73 downto 0);
    signal rVStage_uid78_lzcShifterZ1_uid10_fxpToFPTest_merged_bit_select_b : STD_LOGIC_VECTOR (1 downto 0);
    signal rVStage_uid78_lzcShifterZ1_uid10_fxpToFPTest_merged_bit_select_c : STD_LOGIC_VECTOR (75 downto 0);
    signal rVStage_uid85_lzcShifterZ1_uid10_fxpToFPTest_merged_bit_select_b : STD_LOGIC_VECTOR (0 downto 0);
    signal rVStage_uid85_lzcShifterZ1_uid10_fxpToFPTest_merged_bit_select_c : STD_LOGIC_VECTOR (76 downto 0);
    signal fracRnd_uid15_fxpToFPTest_merged_bit_select_in : STD_LOGIC_VECTOR (76 downto 0);
    signal fracRnd_uid15_fxpToFPTest_merged_bit_select_b : STD_LOGIC_VECTOR (23 downto 0);
    signal fracRnd_uid15_fxpToFPTest_merged_bit_select_c : STD_LOGIC_VECTOR (52 downto 0);
    signal yE_uid8_fxpToFPTest_BitSelect_for_b_tessel0_1_merged_bit_select_b : STD_LOGIC_VECTOR (71 downto 0);
    signal yE_uid8_fxpToFPTest_BitSelect_for_b_tessel0_1_merged_bit_select_c : STD_LOGIC_VECTOR (5 downto 0);
    signal redist0_fracRnd_uid15_fxpToFPTest_merged_bit_select_b_2_q : STD_LOGIC_VECTOR (23 downto 0);
    signal redist1_fracRnd_uid15_fxpToFPTest_merged_bit_select_c_1_q : STD_LOGIC_VECTOR (52 downto 0);
    signal redist2_rVStage_uid43_lzcShifterZ1_uid10_fxpToFPTest_merged_bit_select_c_1_q : STD_LOGIC_VECTOR (13 downto 0);
    signal redist3_yE_uid8_fxpToFPTest_BitSelect_for_a_tessel0_0_merged_bit_select_c_1_q : STD_LOGIC_VECTOR (4 downto 0);
    signal redist4_yE_uid8_fxpToFPTest_BitSelect_for_b_tessel0_0_b_1_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist5_yE_uid8_fxpToFPTest_p1_of_2_q_1_q : STD_LOGIC_VECTOR (72 downto 0);
    signal redist6_vCount_uid91_lzcShifterZ1_uid10_fxpToFPTest_q_1_q : STD_LOGIC_VECTOR (6 downto 0);
    signal redist7_vCount_uid72_lzcShifterZ1_uid10_fxpToFPTest_q_1_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist8_vCount_uid65_lzcShifterZ1_uid10_fxpToFPTest_q_2_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist9_vCount_uid58_lzcShifterZ1_uid10_fxpToFPTest_q_3_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist10_vCount_uid51_lzcShifterZ1_uid10_fxpToFPTest_q_4_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist11_vCount_uid44_lzcShifterZ1_uid10_fxpToFPTest_q_6_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist12_expR_uid38_fxpToFPTest_b_1_q : STD_LOGIC_VECTOR (7 downto 0);
    signal redist13_excSelector_uid34_fxpToFPTest_q_1_q : STD_LOGIC_VECTOR (1 downto 0);
    signal redist14_expR_uid26_fxpToFPTest_b_1_q : STD_LOGIC_VECTOR (9 downto 0);
    signal redist15_fracR_uid25_fxpToFPTest_b_2_q : STD_LOGIC_VECTOR (22 downto 0);
    signal redist16_expFracRnd_uid16_fxpToFPTest_q_1_q : STD_LOGIC_VECTOR (32 downto 0);
    signal redist17_inIsZero_uid12_fxpToFPTest_q_2_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist18_y_uid9_fxpToFPTest_b_1_q : STD_LOGIC_VECTOR (77 downto 0);
    signal redist19_signX_uid6_fxpToFPTest_b_14_q : STD_LOGIC_VECTOR (0 downto 0);

begin


    -- VCC(CONSTANT,1)
    VCC_q <= "1";

    -- signX_uid6_fxpToFPTest(BITSELECT,5)@0
    signX_uid6_fxpToFPTest_b <= STD_LOGIC_VECTOR(a(77 downto 77));

    -- redist19_signX_uid6_fxpToFPTest_b_14(DELAY,146)
    redist19_signX_uid6_fxpToFPTest_b_14 : dspba_delay
    GENERIC MAP ( width => 1, depth => 14, reset_kind => "ASYNC" )
    PORT MAP ( xin => signX_uid6_fxpToFPTest_b, xout => redist19_signX_uid6_fxpToFPTest_b_14_q, clk => clk, aclr => areset );

    -- expInf_uid28_fxpToFPTest(CONSTANT,27)
    expInf_uid28_fxpToFPTest_q <= "11111111";

    -- expZ_uid37_fxpToFPTest(CONSTANT,36)
    expZ_uid37_fxpToFPTest_q <= "00000000";

    -- rVStage_uid85_lzcShifterZ1_uid10_fxpToFPTest_merged_bit_select(BITSELECT,124)@9
    rVStage_uid85_lzcShifterZ1_uid10_fxpToFPTest_merged_bit_select_b <= vStagei_uid83_lzcShifterZ1_uid10_fxpToFPTest_q(77 downto 77);
    rVStage_uid85_lzcShifterZ1_uid10_fxpToFPTest_merged_bit_select_c <= vStagei_uid83_lzcShifterZ1_uid10_fxpToFPTest_q(76 downto 0);

    -- GND(CONSTANT,0)
    GND_q <= "0";

    -- cStage_uid89_lzcShifterZ1_uid10_fxpToFPTest(BITJOIN,88)@9
    cStage_uid89_lzcShifterZ1_uid10_fxpToFPTest_q <= rVStage_uid85_lzcShifterZ1_uid10_fxpToFPTest_merged_bit_select_c & GND_q;

    -- rVStage_uid78_lzcShifterZ1_uid10_fxpToFPTest_merged_bit_select(BITSELECT,123)@9
    rVStage_uid78_lzcShifterZ1_uid10_fxpToFPTest_merged_bit_select_b <= vStagei_uid76_lzcShifterZ1_uid10_fxpToFPTest_q(77 downto 76);
    rVStage_uid78_lzcShifterZ1_uid10_fxpToFPTest_merged_bit_select_c <= vStagei_uid76_lzcShifterZ1_uid10_fxpToFPTest_q(75 downto 0);

    -- zs_uid77_lzcShifterZ1_uid10_fxpToFPTest(CONSTANT,76)
    zs_uid77_lzcShifterZ1_uid10_fxpToFPTest_q <= "00";

    -- cStage_uid82_lzcShifterZ1_uid10_fxpToFPTest(BITJOIN,81)@9
    cStage_uid82_lzcShifterZ1_uid10_fxpToFPTest_q <= rVStage_uid78_lzcShifterZ1_uid10_fxpToFPTest_merged_bit_select_c & zs_uid77_lzcShifterZ1_uid10_fxpToFPTest_q;

    -- rVStage_uid71_lzcShifterZ1_uid10_fxpToFPTest_merged_bit_select(BITSELECT,122)@8
    rVStage_uid71_lzcShifterZ1_uid10_fxpToFPTest_merged_bit_select_b <= vStagei_uid69_lzcShifterZ1_uid10_fxpToFPTest_q(77 downto 74);
    rVStage_uid71_lzcShifterZ1_uid10_fxpToFPTest_merged_bit_select_c <= vStagei_uid69_lzcShifterZ1_uid10_fxpToFPTest_q(73 downto 0);

    -- zs_uid70_lzcShifterZ1_uid10_fxpToFPTest(CONSTANT,69)
    zs_uid70_lzcShifterZ1_uid10_fxpToFPTest_q <= "0000";

    -- cStage_uid75_lzcShifterZ1_uid10_fxpToFPTest(BITJOIN,74)@8
    cStage_uid75_lzcShifterZ1_uid10_fxpToFPTest_q <= rVStage_uid71_lzcShifterZ1_uid10_fxpToFPTest_merged_bit_select_c & zs_uid70_lzcShifterZ1_uid10_fxpToFPTest_q;

    -- rVStage_uid64_lzcShifterZ1_uid10_fxpToFPTest_merged_bit_select(BITSELECT,121)@7
    rVStage_uid64_lzcShifterZ1_uid10_fxpToFPTest_merged_bit_select_b <= vStagei_uid62_lzcShifterZ1_uid10_fxpToFPTest_q(77 downto 70);
    rVStage_uid64_lzcShifterZ1_uid10_fxpToFPTest_merged_bit_select_c <= vStagei_uid62_lzcShifterZ1_uid10_fxpToFPTest_q(69 downto 0);

    -- cStage_uid68_lzcShifterZ1_uid10_fxpToFPTest(BITJOIN,67)@7
    cStage_uid68_lzcShifterZ1_uid10_fxpToFPTest_q <= rVStage_uid64_lzcShifterZ1_uid10_fxpToFPTest_merged_bit_select_c & expZ_uid37_fxpToFPTest_q;

    -- rVStage_uid57_lzcShifterZ1_uid10_fxpToFPTest_merged_bit_select(BITSELECT,120)@6
    rVStage_uid57_lzcShifterZ1_uid10_fxpToFPTest_merged_bit_select_b <= vStagei_uid55_lzcShifterZ1_uid10_fxpToFPTest_q(77 downto 62);
    rVStage_uid57_lzcShifterZ1_uid10_fxpToFPTest_merged_bit_select_c <= vStagei_uid55_lzcShifterZ1_uid10_fxpToFPTest_q(61 downto 0);

    -- zs_uid56_lzcShifterZ1_uid10_fxpToFPTest(CONSTANT,55)
    zs_uid56_lzcShifterZ1_uid10_fxpToFPTest_q <= "0000000000000000";

    -- cStage_uid61_lzcShifterZ1_uid10_fxpToFPTest(BITJOIN,60)@6
    cStage_uid61_lzcShifterZ1_uid10_fxpToFPTest_q <= rVStage_uid57_lzcShifterZ1_uid10_fxpToFPTest_merged_bit_select_c & zs_uid56_lzcShifterZ1_uid10_fxpToFPTest_q;

    -- rVStage_uid50_lzcShifterZ1_uid10_fxpToFPTest_merged_bit_select(BITSELECT,119)@5
    rVStage_uid50_lzcShifterZ1_uid10_fxpToFPTest_merged_bit_select_b <= vStagei_uid48_lzcShifterZ1_uid10_fxpToFPTest_q(77 downto 46);
    rVStage_uid50_lzcShifterZ1_uid10_fxpToFPTest_merged_bit_select_c <= vStagei_uid48_lzcShifterZ1_uid10_fxpToFPTest_q(45 downto 0);

    -- zs_uid49_lzcShifterZ1_uid10_fxpToFPTest(CONSTANT,48)
    zs_uid49_lzcShifterZ1_uid10_fxpToFPTest_q <= "00000000000000000000000000000000";

    -- cStage_uid54_lzcShifterZ1_uid10_fxpToFPTest(BITJOIN,53)@5
    cStage_uid54_lzcShifterZ1_uid10_fxpToFPTest_q <= rVStage_uid50_lzcShifterZ1_uid10_fxpToFPTest_merged_bit_select_c & zs_uid49_lzcShifterZ1_uid10_fxpToFPTest_q;

    -- redist4_yE_uid8_fxpToFPTest_BitSelect_for_b_tessel0_0_b_1(DELAY,131)
    redist4_yE_uid8_fxpToFPTest_BitSelect_for_b_tessel0_0_b_1 : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => signX_uid6_fxpToFPTest_b, xout => redist4_yE_uid8_fxpToFPTest_BitSelect_for_b_tessel0_0_b_1_q, clk => clk, aclr => areset );

    -- yE_uid8_fxpToFPTest_BitSelect_for_b_BitJoin_for_b(BITJOIN,113)@1
    yE_uid8_fxpToFPTest_BitSelect_for_b_BitJoin_for_b_q <= yE_uid8_fxpToFPTest_BitSelect_for_b_tessel0_1_merged_bit_select_b & redist4_yE_uid8_fxpToFPTest_BitSelect_for_b_tessel0_0_b_1_q;

    -- xXorSign_uid7_fxpToFPTest(LOGICAL,6)@0 + 1
    xXorSign_uid7_fxpToFPTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((77 downto 1 => signX_uid6_fxpToFPTest_b(0)) & signX_uid6_fxpToFPTest_b));
    xXorSign_uid7_fxpToFPTest_qi <= a xor xXorSign_uid7_fxpToFPTest_b;
    xXorSign_uid7_fxpToFPTest_delay : dspba_delay
    GENERIC MAP ( width => 78, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => xXorSign_uid7_fxpToFPTest_qi, xout => xXorSign_uid7_fxpToFPTest_q, clk => clk, aclr => areset );

    -- yE_uid8_fxpToFPTest_BitSelect_for_a_tessel0_0_merged_bit_select(BITSELECT,116)@1
    yE_uid8_fxpToFPTest_BitSelect_for_a_tessel0_0_merged_bit_select_b <= STD_LOGIC_VECTOR(xXorSign_uid7_fxpToFPTest_q(72 downto 0));
    yE_uid8_fxpToFPTest_BitSelect_for_a_tessel0_0_merged_bit_select_c <= STD_LOGIC_VECTOR(xXorSign_uid7_fxpToFPTest_q(77 downto 73));

    -- yE_uid8_fxpToFPTest_p1_of_2(ADD,103)@1 + 1
    yE_uid8_fxpToFPTest_p1_of_2_a <= STD_LOGIC_VECTOR("0" & yE_uid8_fxpToFPTest_BitSelect_for_a_tessel0_0_merged_bit_select_b);
    yE_uid8_fxpToFPTest_p1_of_2_b <= STD_LOGIC_VECTOR("0" & yE_uid8_fxpToFPTest_BitSelect_for_b_BitJoin_for_b_q);
    yE_uid8_fxpToFPTest_p1_of_2_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            yE_uid8_fxpToFPTest_p1_of_2_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            yE_uid8_fxpToFPTest_p1_of_2_o <= STD_LOGIC_VECTOR(UNSIGNED(yE_uid8_fxpToFPTest_p1_of_2_a) + UNSIGNED(yE_uid8_fxpToFPTest_p1_of_2_b));
        END IF;
    END PROCESS;
    yE_uid8_fxpToFPTest_p1_of_2_c(0) <= yE_uid8_fxpToFPTest_p1_of_2_o(73);
    yE_uid8_fxpToFPTest_p1_of_2_q <= yE_uid8_fxpToFPTest_p1_of_2_o(72 downto 0);

    -- yE_uid8_fxpToFPTest_UpperBits_for_b(CONSTANT,100)
    yE_uid8_fxpToFPTest_UpperBits_for_b_q <= "000000000000000000000000000000000000000000000000000000000000000000000000000000";

    -- yE_uid8_fxpToFPTest_BitSelect_for_b_tessel0_1_merged_bit_select(BITSELECT,126)
    yE_uid8_fxpToFPTest_BitSelect_for_b_tessel0_1_merged_bit_select_b <= STD_LOGIC_VECTOR(yE_uid8_fxpToFPTest_UpperBits_for_b_q(71 downto 0));
    yE_uid8_fxpToFPTest_BitSelect_for_b_tessel0_1_merged_bit_select_c <= STD_LOGIC_VECTOR(yE_uid8_fxpToFPTest_UpperBits_for_b_q(77 downto 72));

    -- redist3_yE_uid8_fxpToFPTest_BitSelect_for_a_tessel0_0_merged_bit_select_c_1(DELAY,130)
    redist3_yE_uid8_fxpToFPTest_BitSelect_for_a_tessel0_0_merged_bit_select_c_1 : dspba_delay
    GENERIC MAP ( width => 5, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => yE_uid8_fxpToFPTest_BitSelect_for_a_tessel0_0_merged_bit_select_c, xout => redist3_yE_uid8_fxpToFPTest_BitSelect_for_a_tessel0_0_merged_bit_select_c_1_q, clk => clk, aclr => areset );

    -- yE_uid8_fxpToFPTest_BitSelect_for_a_BitJoin_for_c(BITJOIN,110)@2
    yE_uid8_fxpToFPTest_BitSelect_for_a_BitJoin_for_c_q <= GND_q & redist3_yE_uid8_fxpToFPTest_BitSelect_for_a_tessel0_0_merged_bit_select_c_1_q;

    -- yE_uid8_fxpToFPTest_p2_of_2(ADD,104)@2 + 1
    yE_uid8_fxpToFPTest_p2_of_2_cin <= yE_uid8_fxpToFPTest_p1_of_2_c;
    yE_uid8_fxpToFPTest_p2_of_2_a <= STD_LOGIC_VECTOR("0" & yE_uid8_fxpToFPTest_BitSelect_for_a_BitJoin_for_c_q) & '1';
    yE_uid8_fxpToFPTest_p2_of_2_b <= STD_LOGIC_VECTOR("0" & yE_uid8_fxpToFPTest_BitSelect_for_b_tessel0_1_merged_bit_select_c) & yE_uid8_fxpToFPTest_p2_of_2_cin(0);
    yE_uid8_fxpToFPTest_p2_of_2_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            yE_uid8_fxpToFPTest_p2_of_2_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            yE_uid8_fxpToFPTest_p2_of_2_o <= STD_LOGIC_VECTOR(UNSIGNED(yE_uid8_fxpToFPTest_p2_of_2_a) + UNSIGNED(yE_uid8_fxpToFPTest_p2_of_2_b));
        END IF;
    END PROCESS;
    yE_uid8_fxpToFPTest_p2_of_2_q <= yE_uid8_fxpToFPTest_p2_of_2_o(6 downto 1);

    -- redist5_yE_uid8_fxpToFPTest_p1_of_2_q_1(DELAY,132)
    redist5_yE_uid8_fxpToFPTest_p1_of_2_q_1 : dspba_delay
    GENERIC MAP ( width => 73, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => yE_uid8_fxpToFPTest_p1_of_2_q, xout => redist5_yE_uid8_fxpToFPTest_p1_of_2_q_1_q, clk => clk, aclr => areset );

    -- yE_uid8_fxpToFPTest_BitJoin_for_q(BITJOIN,105)@3
    yE_uid8_fxpToFPTest_BitJoin_for_q_q <= yE_uid8_fxpToFPTest_p2_of_2_q & redist5_yE_uid8_fxpToFPTest_p1_of_2_q_1_q;

    -- y_uid9_fxpToFPTest(BITSELECT,8)@3
    y_uid9_fxpToFPTest_in <= STD_LOGIC_VECTOR(yE_uid8_fxpToFPTest_BitJoin_for_q_q(77 downto 0));
    y_uid9_fxpToFPTest_b <= STD_LOGIC_VECTOR(y_uid9_fxpToFPTest_in(77 downto 0));

    -- rVStage_uid43_lzcShifterZ1_uid10_fxpToFPTest_merged_bit_select(BITSELECT,117)@3
    rVStage_uid43_lzcShifterZ1_uid10_fxpToFPTest_merged_bit_select_b <= y_uid9_fxpToFPTest_b(77 downto 14);
    rVStage_uid43_lzcShifterZ1_uid10_fxpToFPTest_merged_bit_select_c <= y_uid9_fxpToFPTest_b(13 downto 0);

    -- redist2_rVStage_uid43_lzcShifterZ1_uid10_fxpToFPTest_merged_bit_select_c_1(DELAY,129)
    redist2_rVStage_uid43_lzcShifterZ1_uid10_fxpToFPTest_merged_bit_select_c_1 : dspba_delay
    GENERIC MAP ( width => 14, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => rVStage_uid43_lzcShifterZ1_uid10_fxpToFPTest_merged_bit_select_c, xout => redist2_rVStage_uid43_lzcShifterZ1_uid10_fxpToFPTest_merged_bit_select_c_1_q, clk => clk, aclr => areset );

    -- zs_uid42_lzcShifterZ1_uid10_fxpToFPTest(CONSTANT,41)
    zs_uid42_lzcShifterZ1_uid10_fxpToFPTest_q <= "0000000000000000000000000000000000000000000000000000000000000000";

    -- cStage_uid47_lzcShifterZ1_uid10_fxpToFPTest(BITJOIN,46)@4
    cStage_uid47_lzcShifterZ1_uid10_fxpToFPTest_q <= redist2_rVStage_uid43_lzcShifterZ1_uid10_fxpToFPTest_merged_bit_select_c_1_q & zs_uid42_lzcShifterZ1_uid10_fxpToFPTest_q;

    -- redist18_y_uid9_fxpToFPTest_b_1(DELAY,145)
    redist18_y_uid9_fxpToFPTest_b_1 : dspba_delay
    GENERIC MAP ( width => 78, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => y_uid9_fxpToFPTest_b, xout => redist18_y_uid9_fxpToFPTest_b_1_q, clk => clk, aclr => areset );

    -- vCount_uid44_lzcShifterZ1_uid10_fxpToFPTest(LOGICAL,43)@3 + 1
    vCount_uid44_lzcShifterZ1_uid10_fxpToFPTest_qi <= "1" WHEN rVStage_uid43_lzcShifterZ1_uid10_fxpToFPTest_merged_bit_select_b = zs_uid42_lzcShifterZ1_uid10_fxpToFPTest_q ELSE "0";
    vCount_uid44_lzcShifterZ1_uid10_fxpToFPTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => vCount_uid44_lzcShifterZ1_uid10_fxpToFPTest_qi, xout => vCount_uid44_lzcShifterZ1_uid10_fxpToFPTest_q, clk => clk, aclr => areset );

    -- vStagei_uid48_lzcShifterZ1_uid10_fxpToFPTest(MUX,47)@4 + 1
    vStagei_uid48_lzcShifterZ1_uid10_fxpToFPTest_s <= vCount_uid44_lzcShifterZ1_uid10_fxpToFPTest_q;
    vStagei_uid48_lzcShifterZ1_uid10_fxpToFPTest_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            vStagei_uid48_lzcShifterZ1_uid10_fxpToFPTest_q <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            CASE (vStagei_uid48_lzcShifterZ1_uid10_fxpToFPTest_s) IS
                WHEN "0" => vStagei_uid48_lzcShifterZ1_uid10_fxpToFPTest_q <= redist18_y_uid9_fxpToFPTest_b_1_q;
                WHEN "1" => vStagei_uid48_lzcShifterZ1_uid10_fxpToFPTest_q <= cStage_uid47_lzcShifterZ1_uid10_fxpToFPTest_q;
                WHEN OTHERS => vStagei_uid48_lzcShifterZ1_uid10_fxpToFPTest_q <= (others => '0');
            END CASE;
        END IF;
    END PROCESS;

    -- vCount_uid51_lzcShifterZ1_uid10_fxpToFPTest(LOGICAL,50)@5
    vCount_uid51_lzcShifterZ1_uid10_fxpToFPTest_q <= "1" WHEN rVStage_uid50_lzcShifterZ1_uid10_fxpToFPTest_merged_bit_select_b = zs_uid49_lzcShifterZ1_uid10_fxpToFPTest_q ELSE "0";

    -- vStagei_uid55_lzcShifterZ1_uid10_fxpToFPTest(MUX,54)@5 + 1
    vStagei_uid55_lzcShifterZ1_uid10_fxpToFPTest_s <= vCount_uid51_lzcShifterZ1_uid10_fxpToFPTest_q;
    vStagei_uid55_lzcShifterZ1_uid10_fxpToFPTest_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            vStagei_uid55_lzcShifterZ1_uid10_fxpToFPTest_q <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            CASE (vStagei_uid55_lzcShifterZ1_uid10_fxpToFPTest_s) IS
                WHEN "0" => vStagei_uid55_lzcShifterZ1_uid10_fxpToFPTest_q <= vStagei_uid48_lzcShifterZ1_uid10_fxpToFPTest_q;
                WHEN "1" => vStagei_uid55_lzcShifterZ1_uid10_fxpToFPTest_q <= cStage_uid54_lzcShifterZ1_uid10_fxpToFPTest_q;
                WHEN OTHERS => vStagei_uid55_lzcShifterZ1_uid10_fxpToFPTest_q <= (others => '0');
            END CASE;
        END IF;
    END PROCESS;

    -- vCount_uid58_lzcShifterZ1_uid10_fxpToFPTest(LOGICAL,57)@6
    vCount_uid58_lzcShifterZ1_uid10_fxpToFPTest_q <= "1" WHEN rVStage_uid57_lzcShifterZ1_uid10_fxpToFPTest_merged_bit_select_b = zs_uid56_lzcShifterZ1_uid10_fxpToFPTest_q ELSE "0";

    -- vStagei_uid62_lzcShifterZ1_uid10_fxpToFPTest(MUX,61)@6 + 1
    vStagei_uid62_lzcShifterZ1_uid10_fxpToFPTest_s <= vCount_uid58_lzcShifterZ1_uid10_fxpToFPTest_q;
    vStagei_uid62_lzcShifterZ1_uid10_fxpToFPTest_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            vStagei_uid62_lzcShifterZ1_uid10_fxpToFPTest_q <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            CASE (vStagei_uid62_lzcShifterZ1_uid10_fxpToFPTest_s) IS
                WHEN "0" => vStagei_uid62_lzcShifterZ1_uid10_fxpToFPTest_q <= vStagei_uid55_lzcShifterZ1_uid10_fxpToFPTest_q;
                WHEN "1" => vStagei_uid62_lzcShifterZ1_uid10_fxpToFPTest_q <= cStage_uid61_lzcShifterZ1_uid10_fxpToFPTest_q;
                WHEN OTHERS => vStagei_uid62_lzcShifterZ1_uid10_fxpToFPTest_q <= (others => '0');
            END CASE;
        END IF;
    END PROCESS;

    -- vCount_uid65_lzcShifterZ1_uid10_fxpToFPTest(LOGICAL,64)@7
    vCount_uid65_lzcShifterZ1_uid10_fxpToFPTest_q <= "1" WHEN rVStage_uid64_lzcShifterZ1_uid10_fxpToFPTest_merged_bit_select_b = expZ_uid37_fxpToFPTest_q ELSE "0";

    -- vStagei_uid69_lzcShifterZ1_uid10_fxpToFPTest(MUX,68)@7 + 1
    vStagei_uid69_lzcShifterZ1_uid10_fxpToFPTest_s <= vCount_uid65_lzcShifterZ1_uid10_fxpToFPTest_q;
    vStagei_uid69_lzcShifterZ1_uid10_fxpToFPTest_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            vStagei_uid69_lzcShifterZ1_uid10_fxpToFPTest_q <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            CASE (vStagei_uid69_lzcShifterZ1_uid10_fxpToFPTest_s) IS
                WHEN "0" => vStagei_uid69_lzcShifterZ1_uid10_fxpToFPTest_q <= vStagei_uid62_lzcShifterZ1_uid10_fxpToFPTest_q;
                WHEN "1" => vStagei_uid69_lzcShifterZ1_uid10_fxpToFPTest_q <= cStage_uid68_lzcShifterZ1_uid10_fxpToFPTest_q;
                WHEN OTHERS => vStagei_uid69_lzcShifterZ1_uid10_fxpToFPTest_q <= (others => '0');
            END CASE;
        END IF;
    END PROCESS;

    -- vCount_uid72_lzcShifterZ1_uid10_fxpToFPTest(LOGICAL,71)@8
    vCount_uid72_lzcShifterZ1_uid10_fxpToFPTest_q <= "1" WHEN rVStage_uid71_lzcShifterZ1_uid10_fxpToFPTest_merged_bit_select_b = zs_uid70_lzcShifterZ1_uid10_fxpToFPTest_q ELSE "0";

    -- vStagei_uid76_lzcShifterZ1_uid10_fxpToFPTest(MUX,75)@8 + 1
    vStagei_uid76_lzcShifterZ1_uid10_fxpToFPTest_s <= vCount_uid72_lzcShifterZ1_uid10_fxpToFPTest_q;
    vStagei_uid76_lzcShifterZ1_uid10_fxpToFPTest_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            vStagei_uid76_lzcShifterZ1_uid10_fxpToFPTest_q <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            CASE (vStagei_uid76_lzcShifterZ1_uid10_fxpToFPTest_s) IS
                WHEN "0" => vStagei_uid76_lzcShifterZ1_uid10_fxpToFPTest_q <= vStagei_uid69_lzcShifterZ1_uid10_fxpToFPTest_q;
                WHEN "1" => vStagei_uid76_lzcShifterZ1_uid10_fxpToFPTest_q <= cStage_uid75_lzcShifterZ1_uid10_fxpToFPTest_q;
                WHEN OTHERS => vStagei_uid76_lzcShifterZ1_uid10_fxpToFPTest_q <= (others => '0');
            END CASE;
        END IF;
    END PROCESS;

    -- vCount_uid79_lzcShifterZ1_uid10_fxpToFPTest(LOGICAL,78)@9
    vCount_uid79_lzcShifterZ1_uid10_fxpToFPTest_q <= "1" WHEN rVStage_uid78_lzcShifterZ1_uid10_fxpToFPTest_merged_bit_select_b = zs_uid77_lzcShifterZ1_uid10_fxpToFPTest_q ELSE "0";

    -- vStagei_uid83_lzcShifterZ1_uid10_fxpToFPTest(MUX,82)@9
    vStagei_uid83_lzcShifterZ1_uid10_fxpToFPTest_s <= vCount_uid79_lzcShifterZ1_uid10_fxpToFPTest_q;
    vStagei_uid83_lzcShifterZ1_uid10_fxpToFPTest_combproc: PROCESS (vStagei_uid83_lzcShifterZ1_uid10_fxpToFPTest_s, vStagei_uid76_lzcShifterZ1_uid10_fxpToFPTest_q, cStage_uid82_lzcShifterZ1_uid10_fxpToFPTest_q)
    BEGIN
        CASE (vStagei_uid83_lzcShifterZ1_uid10_fxpToFPTest_s) IS
            WHEN "0" => vStagei_uid83_lzcShifterZ1_uid10_fxpToFPTest_q <= vStagei_uid76_lzcShifterZ1_uid10_fxpToFPTest_q;
            WHEN "1" => vStagei_uid83_lzcShifterZ1_uid10_fxpToFPTest_q <= cStage_uid82_lzcShifterZ1_uid10_fxpToFPTest_q;
            WHEN OTHERS => vStagei_uid83_lzcShifterZ1_uid10_fxpToFPTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- vCount_uid86_lzcShifterZ1_uid10_fxpToFPTest(LOGICAL,85)@9
    vCount_uid86_lzcShifterZ1_uid10_fxpToFPTest_q <= "1" WHEN rVStage_uid85_lzcShifterZ1_uid10_fxpToFPTest_merged_bit_select_b = GND_q ELSE "0";

    -- vStagei_uid90_lzcShifterZ1_uid10_fxpToFPTest(MUX,89)@9
    vStagei_uid90_lzcShifterZ1_uid10_fxpToFPTest_s <= vCount_uid86_lzcShifterZ1_uid10_fxpToFPTest_q;
    vStagei_uid90_lzcShifterZ1_uid10_fxpToFPTest_combproc: PROCESS (vStagei_uid90_lzcShifterZ1_uid10_fxpToFPTest_s, vStagei_uid83_lzcShifterZ1_uid10_fxpToFPTest_q, cStage_uid89_lzcShifterZ1_uid10_fxpToFPTest_q)
    BEGIN
        CASE (vStagei_uid90_lzcShifterZ1_uid10_fxpToFPTest_s) IS
            WHEN "0" => vStagei_uid90_lzcShifterZ1_uid10_fxpToFPTest_q <= vStagei_uid83_lzcShifterZ1_uid10_fxpToFPTest_q;
            WHEN "1" => vStagei_uid90_lzcShifterZ1_uid10_fxpToFPTest_q <= cStage_uid89_lzcShifterZ1_uid10_fxpToFPTest_q;
            WHEN OTHERS => vStagei_uid90_lzcShifterZ1_uid10_fxpToFPTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- fracRnd_uid15_fxpToFPTest_merged_bit_select(BITSELECT,125)@9
    fracRnd_uid15_fxpToFPTest_merged_bit_select_in <= vStagei_uid90_lzcShifterZ1_uid10_fxpToFPTest_q(76 downto 0);
    fracRnd_uid15_fxpToFPTest_merged_bit_select_b <= fracRnd_uid15_fxpToFPTest_merged_bit_select_in(76 downto 53);
    fracRnd_uid15_fxpToFPTest_merged_bit_select_c <= fracRnd_uid15_fxpToFPTest_merged_bit_select_in(52 downto 0);

    -- redist1_fracRnd_uid15_fxpToFPTest_merged_bit_select_c_1(DELAY,128)
    redist1_fracRnd_uid15_fxpToFPTest_merged_bit_select_c_1 : dspba_delay
    GENERIC MAP ( width => 53, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => fracRnd_uid15_fxpToFPTest_merged_bit_select_c, xout => redist1_fracRnd_uid15_fxpToFPTest_merged_bit_select_c_1_q, clk => clk, aclr => areset );

    -- sticky_uid20_fxpToFPTest(LOGICAL,19)@10 + 1
    sticky_uid20_fxpToFPTest_qi <= "1" WHEN redist1_fracRnd_uid15_fxpToFPTest_merged_bit_select_c_1_q /= "00000000000000000000000000000000000000000000000000000" ELSE "0";
    sticky_uid20_fxpToFPTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => sticky_uid20_fxpToFPTest_qi, xout => sticky_uid20_fxpToFPTest_q, clk => clk, aclr => areset );

    -- nr_uid21_fxpToFPTest(LOGICAL,20)@11
    nr_uid21_fxpToFPTest_q <= not (l_uid17_fxpToFPTest_merged_bit_select_c);

    -- maxCount_uid11_fxpToFPTest(CONSTANT,10)
    maxCount_uid11_fxpToFPTest_q <= "1001110";

    -- redist11_vCount_uid44_lzcShifterZ1_uid10_fxpToFPTest_q_6(DELAY,138)
    redist11_vCount_uid44_lzcShifterZ1_uid10_fxpToFPTest_q_6 : dspba_delay
    GENERIC MAP ( width => 1, depth => 5, reset_kind => "ASYNC" )
    PORT MAP ( xin => vCount_uid44_lzcShifterZ1_uid10_fxpToFPTest_q, xout => redist11_vCount_uid44_lzcShifterZ1_uid10_fxpToFPTest_q_6_q, clk => clk, aclr => areset );

    -- redist10_vCount_uid51_lzcShifterZ1_uid10_fxpToFPTest_q_4(DELAY,137)
    redist10_vCount_uid51_lzcShifterZ1_uid10_fxpToFPTest_q_4 : dspba_delay
    GENERIC MAP ( width => 1, depth => 4, reset_kind => "ASYNC" )
    PORT MAP ( xin => vCount_uid51_lzcShifterZ1_uid10_fxpToFPTest_q, xout => redist10_vCount_uid51_lzcShifterZ1_uid10_fxpToFPTest_q_4_q, clk => clk, aclr => areset );

    -- redist9_vCount_uid58_lzcShifterZ1_uid10_fxpToFPTest_q_3(DELAY,136)
    redist9_vCount_uid58_lzcShifterZ1_uid10_fxpToFPTest_q_3 : dspba_delay
    GENERIC MAP ( width => 1, depth => 3, reset_kind => "ASYNC" )
    PORT MAP ( xin => vCount_uid58_lzcShifterZ1_uid10_fxpToFPTest_q, xout => redist9_vCount_uid58_lzcShifterZ1_uid10_fxpToFPTest_q_3_q, clk => clk, aclr => areset );

    -- redist8_vCount_uid65_lzcShifterZ1_uid10_fxpToFPTest_q_2(DELAY,135)
    redist8_vCount_uid65_lzcShifterZ1_uid10_fxpToFPTest_q_2 : dspba_delay
    GENERIC MAP ( width => 1, depth => 2, reset_kind => "ASYNC" )
    PORT MAP ( xin => vCount_uid65_lzcShifterZ1_uid10_fxpToFPTest_q, xout => redist8_vCount_uid65_lzcShifterZ1_uid10_fxpToFPTest_q_2_q, clk => clk, aclr => areset );

    -- redist7_vCount_uid72_lzcShifterZ1_uid10_fxpToFPTest_q_1(DELAY,134)
    redist7_vCount_uid72_lzcShifterZ1_uid10_fxpToFPTest_q_1 : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => vCount_uid72_lzcShifterZ1_uid10_fxpToFPTest_q, xout => redist7_vCount_uid72_lzcShifterZ1_uid10_fxpToFPTest_q_1_q, clk => clk, aclr => areset );

    -- vCount_uid91_lzcShifterZ1_uid10_fxpToFPTest(BITJOIN,90)@9
    vCount_uid91_lzcShifterZ1_uid10_fxpToFPTest_q <= redist11_vCount_uid44_lzcShifterZ1_uid10_fxpToFPTest_q_6_q & redist10_vCount_uid51_lzcShifterZ1_uid10_fxpToFPTest_q_4_q & redist9_vCount_uid58_lzcShifterZ1_uid10_fxpToFPTest_q_3_q & redist8_vCount_uid65_lzcShifterZ1_uid10_fxpToFPTest_q_2_q & redist7_vCount_uid72_lzcShifterZ1_uid10_fxpToFPTest_q_1_q & vCount_uid79_lzcShifterZ1_uid10_fxpToFPTest_q & vCount_uid86_lzcShifterZ1_uid10_fxpToFPTest_q;

    -- redist6_vCount_uid91_lzcShifterZ1_uid10_fxpToFPTest_q_1(DELAY,133)
    redist6_vCount_uid91_lzcShifterZ1_uid10_fxpToFPTest_q_1 : dspba_delay
    GENERIC MAP ( width => 7, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => vCount_uid91_lzcShifterZ1_uid10_fxpToFPTest_q, xout => redist6_vCount_uid91_lzcShifterZ1_uid10_fxpToFPTest_q_1_q, clk => clk, aclr => areset );

    -- vCountBig_uid93_lzcShifterZ1_uid10_fxpToFPTest(COMPARE,92)@10
    vCountBig_uid93_lzcShifterZ1_uid10_fxpToFPTest_a <= STD_LOGIC_VECTOR("00" & maxCount_uid11_fxpToFPTest_q);
    vCountBig_uid93_lzcShifterZ1_uid10_fxpToFPTest_b <= STD_LOGIC_VECTOR("00" & redist6_vCount_uid91_lzcShifterZ1_uid10_fxpToFPTest_q_1_q);
    vCountBig_uid93_lzcShifterZ1_uid10_fxpToFPTest_o <= STD_LOGIC_VECTOR(UNSIGNED(vCountBig_uid93_lzcShifterZ1_uid10_fxpToFPTest_a) - UNSIGNED(vCountBig_uid93_lzcShifterZ1_uid10_fxpToFPTest_b));
    vCountBig_uid93_lzcShifterZ1_uid10_fxpToFPTest_c(0) <= vCountBig_uid93_lzcShifterZ1_uid10_fxpToFPTest_o(8);

    -- vCountFinal_uid95_lzcShifterZ1_uid10_fxpToFPTest(MUX,94)@10 + 1
    vCountFinal_uid95_lzcShifterZ1_uid10_fxpToFPTest_s <= vCountBig_uid93_lzcShifterZ1_uid10_fxpToFPTest_c;
    vCountFinal_uid95_lzcShifterZ1_uid10_fxpToFPTest_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            vCountFinal_uid95_lzcShifterZ1_uid10_fxpToFPTest_q <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            CASE (vCountFinal_uid95_lzcShifterZ1_uid10_fxpToFPTest_s) IS
                WHEN "0" => vCountFinal_uid95_lzcShifterZ1_uid10_fxpToFPTest_q <= redist6_vCount_uid91_lzcShifterZ1_uid10_fxpToFPTest_q_1_q;
                WHEN "1" => vCountFinal_uid95_lzcShifterZ1_uid10_fxpToFPTest_q <= maxCount_uid11_fxpToFPTest_q;
                WHEN OTHERS => vCountFinal_uid95_lzcShifterZ1_uid10_fxpToFPTest_q <= (others => '0');
            END CASE;
        END IF;
    END PROCESS;

    -- msbIn_uid13_fxpToFPTest(CONSTANT,12)
    msbIn_uid13_fxpToFPTest_q <= "10111110";

    -- expPreRnd_uid14_fxpToFPTest(SUB,13)@11
    expPreRnd_uid14_fxpToFPTest_a <= STD_LOGIC_VECTOR("0" & msbIn_uid13_fxpToFPTest_q);
    expPreRnd_uid14_fxpToFPTest_b <= STD_LOGIC_VECTOR("00" & vCountFinal_uid95_lzcShifterZ1_uid10_fxpToFPTest_q);
    expPreRnd_uid14_fxpToFPTest_o <= STD_LOGIC_VECTOR(UNSIGNED(expPreRnd_uid14_fxpToFPTest_a) - UNSIGNED(expPreRnd_uid14_fxpToFPTest_b));
    expPreRnd_uid14_fxpToFPTest_q <= expPreRnd_uid14_fxpToFPTest_o(8 downto 0);

    -- redist0_fracRnd_uid15_fxpToFPTest_merged_bit_select_b_2(DELAY,127)
    redist0_fracRnd_uid15_fxpToFPTest_merged_bit_select_b_2 : dspba_delay
    GENERIC MAP ( width => 24, depth => 2, reset_kind => "ASYNC" )
    PORT MAP ( xin => fracRnd_uid15_fxpToFPTest_merged_bit_select_b, xout => redist0_fracRnd_uid15_fxpToFPTest_merged_bit_select_b_2_q, clk => clk, aclr => areset );

    -- expFracRnd_uid16_fxpToFPTest(BITJOIN,15)@11
    expFracRnd_uid16_fxpToFPTest_q <= expPreRnd_uid14_fxpToFPTest_q & redist0_fracRnd_uid15_fxpToFPTest_merged_bit_select_b_2_q;

    -- l_uid17_fxpToFPTest_merged_bit_select(BITSELECT,118)@11
    l_uid17_fxpToFPTest_merged_bit_select_in <= STD_LOGIC_VECTOR(expFracRnd_uid16_fxpToFPTest_q(1 downto 0));
    l_uid17_fxpToFPTest_merged_bit_select_b <= STD_LOGIC_VECTOR(l_uid17_fxpToFPTest_merged_bit_select_in(1 downto 1));
    l_uid17_fxpToFPTest_merged_bit_select_c <= STD_LOGIC_VECTOR(l_uid17_fxpToFPTest_merged_bit_select_in(0 downto 0));

    -- rnd_uid22_fxpToFPTest(LOGICAL,21)@11 + 1
    rnd_uid22_fxpToFPTest_qi <= l_uid17_fxpToFPTest_merged_bit_select_b or nr_uid21_fxpToFPTest_q or sticky_uid20_fxpToFPTest_q;
    rnd_uid22_fxpToFPTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => rnd_uid22_fxpToFPTest_qi, xout => rnd_uid22_fxpToFPTest_q, clk => clk, aclr => areset );

    -- redist16_expFracRnd_uid16_fxpToFPTest_q_1(DELAY,143)
    redist16_expFracRnd_uid16_fxpToFPTest_q_1 : dspba_delay
    GENERIC MAP ( width => 33, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => expFracRnd_uid16_fxpToFPTest_q, xout => redist16_expFracRnd_uid16_fxpToFPTest_q_1_q, clk => clk, aclr => areset );

    -- expFracR_uid24_fxpToFPTest(ADD,23)@12
    expFracR_uid24_fxpToFPTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((34 downto 33 => redist16_expFracRnd_uid16_fxpToFPTest_q_1_q(32)) & redist16_expFracRnd_uid16_fxpToFPTest_q_1_q));
    expFracR_uid24_fxpToFPTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("0" & "000000000000000000000000000000000" & rnd_uid22_fxpToFPTest_q));
    expFracR_uid24_fxpToFPTest_o <= STD_LOGIC_VECTOR(SIGNED(expFracR_uid24_fxpToFPTest_a) + SIGNED(expFracR_uid24_fxpToFPTest_b));
    expFracR_uid24_fxpToFPTest_q <= expFracR_uid24_fxpToFPTest_o(33 downto 0);

    -- expR_uid26_fxpToFPTest(BITSELECT,25)@12
    expR_uid26_fxpToFPTest_b <= STD_LOGIC_VECTOR(expFracR_uid24_fxpToFPTest_q(33 downto 24));

    -- redist14_expR_uid26_fxpToFPTest_b_1(DELAY,141)
    redist14_expR_uid26_fxpToFPTest_b_1 : dspba_delay
    GENERIC MAP ( width => 10, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => expR_uid26_fxpToFPTest_b, xout => redist14_expR_uid26_fxpToFPTest_b_1_q, clk => clk, aclr => areset );

    -- expR_uid38_fxpToFPTest(BITSELECT,37)@13
    expR_uid38_fxpToFPTest_in <= redist14_expR_uid26_fxpToFPTest_b_1_q(7 downto 0);
    expR_uid38_fxpToFPTest_b <= expR_uid38_fxpToFPTest_in(7 downto 0);

    -- redist12_expR_uid38_fxpToFPTest_b_1(DELAY,139)
    redist12_expR_uid38_fxpToFPTest_b_1 : dspba_delay
    GENERIC MAP ( width => 8, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => expR_uid38_fxpToFPTest_b, xout => redist12_expR_uid38_fxpToFPTest_b_1_q, clk => clk, aclr => areset );

    -- ovf_uid29_fxpToFPTest(COMPARE,28)@13
    ovf_uid29_fxpToFPTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((11 downto 10 => redist14_expR_uid26_fxpToFPTest_b_1_q(9)) & redist14_expR_uid26_fxpToFPTest_b_1_q));
    ovf_uid29_fxpToFPTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("0" & "000" & expInf_uid28_fxpToFPTest_q));
    ovf_uid29_fxpToFPTest_o <= STD_LOGIC_VECTOR(SIGNED(ovf_uid29_fxpToFPTest_a) - SIGNED(ovf_uid29_fxpToFPTest_b));
    ovf_uid29_fxpToFPTest_n(0) <= not (ovf_uid29_fxpToFPTest_o(11));

    -- inIsZero_uid12_fxpToFPTest(LOGICAL,11)@11 + 1
    inIsZero_uid12_fxpToFPTest_qi <= "1" WHEN vCountFinal_uid95_lzcShifterZ1_uid10_fxpToFPTest_q = maxCount_uid11_fxpToFPTest_q ELSE "0";
    inIsZero_uid12_fxpToFPTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => inIsZero_uid12_fxpToFPTest_qi, xout => inIsZero_uid12_fxpToFPTest_q, clk => clk, aclr => areset );

    -- redist17_inIsZero_uid12_fxpToFPTest_q_2(DELAY,144)
    redist17_inIsZero_uid12_fxpToFPTest_q_2 : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => inIsZero_uid12_fxpToFPTest_q, xout => redist17_inIsZero_uid12_fxpToFPTest_q_2_q, clk => clk, aclr => areset );

    -- udf_uid27_fxpToFPTest(COMPARE,26)@13
    udf_uid27_fxpToFPTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("0" & "0000000000" & GND_q));
    udf_uid27_fxpToFPTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((11 downto 10 => redist14_expR_uid26_fxpToFPTest_b_1_q(9)) & redist14_expR_uid26_fxpToFPTest_b_1_q));
    udf_uid27_fxpToFPTest_o <= STD_LOGIC_VECTOR(SIGNED(udf_uid27_fxpToFPTest_a) - SIGNED(udf_uid27_fxpToFPTest_b));
    udf_uid27_fxpToFPTest_n(0) <= not (udf_uid27_fxpToFPTest_o(11));

    -- udfOrInZero_uid33_fxpToFPTest(LOGICAL,32)@13
    udfOrInZero_uid33_fxpToFPTest_q <= udf_uid27_fxpToFPTest_n or redist17_inIsZero_uid12_fxpToFPTest_q_2_q;

    -- excSelector_uid34_fxpToFPTest(BITJOIN,33)@13
    excSelector_uid34_fxpToFPTest_q <= ovf_uid29_fxpToFPTest_n & udfOrInZero_uid33_fxpToFPTest_q;

    -- redist13_excSelector_uid34_fxpToFPTest_q_1(DELAY,140)
    redist13_excSelector_uid34_fxpToFPTest_q_1 : dspba_delay
    GENERIC MAP ( width => 2, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => excSelector_uid34_fxpToFPTest_q, xout => redist13_excSelector_uid34_fxpToFPTest_q_1_q, clk => clk, aclr => areset );

    -- expRPostExc_uid39_fxpToFPTest(MUX,38)@14
    expRPostExc_uid39_fxpToFPTest_s <= redist13_excSelector_uid34_fxpToFPTest_q_1_q;
    expRPostExc_uid39_fxpToFPTest_combproc: PROCESS (expRPostExc_uid39_fxpToFPTest_s, redist12_expR_uid38_fxpToFPTest_b_1_q, expZ_uid37_fxpToFPTest_q, expInf_uid28_fxpToFPTest_q)
    BEGIN
        CASE (expRPostExc_uid39_fxpToFPTest_s) IS
            WHEN "00" => expRPostExc_uid39_fxpToFPTest_q <= redist12_expR_uid38_fxpToFPTest_b_1_q;
            WHEN "01" => expRPostExc_uid39_fxpToFPTest_q <= expZ_uid37_fxpToFPTest_q;
            WHEN "10" => expRPostExc_uid39_fxpToFPTest_q <= expInf_uid28_fxpToFPTest_q;
            WHEN "11" => expRPostExc_uid39_fxpToFPTest_q <= expInf_uid28_fxpToFPTest_q;
            WHEN OTHERS => expRPostExc_uid39_fxpToFPTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- fracZ_uid31_fxpToFPTest(CONSTANT,30)
    fracZ_uid31_fxpToFPTest_q <= "00000000000000000000000";

    -- fracR_uid25_fxpToFPTest(BITSELECT,24)@12
    fracR_uid25_fxpToFPTest_in <= expFracR_uid24_fxpToFPTest_q(23 downto 0);
    fracR_uid25_fxpToFPTest_b <= fracR_uid25_fxpToFPTest_in(23 downto 1);

    -- redist15_fracR_uid25_fxpToFPTest_b_2(DELAY,142)
    redist15_fracR_uid25_fxpToFPTest_b_2 : dspba_delay
    GENERIC MAP ( width => 23, depth => 2, reset_kind => "ASYNC" )
    PORT MAP ( xin => fracR_uid25_fxpToFPTest_b, xout => redist15_fracR_uid25_fxpToFPTest_b_2_q, clk => clk, aclr => areset );

    -- excSelector_uid30_fxpToFPTest(LOGICAL,29)@13 + 1
    excSelector_uid30_fxpToFPTest_qi <= redist17_inIsZero_uid12_fxpToFPTest_q_2_q or ovf_uid29_fxpToFPTest_n or udf_uid27_fxpToFPTest_n;
    excSelector_uid30_fxpToFPTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => excSelector_uid30_fxpToFPTest_qi, xout => excSelector_uid30_fxpToFPTest_q, clk => clk, aclr => areset );

    -- fracRPostExc_uid32_fxpToFPTest(MUX,31)@14
    fracRPostExc_uid32_fxpToFPTest_s <= excSelector_uid30_fxpToFPTest_q;
    fracRPostExc_uid32_fxpToFPTest_combproc: PROCESS (fracRPostExc_uid32_fxpToFPTest_s, redist15_fracR_uid25_fxpToFPTest_b_2_q, fracZ_uid31_fxpToFPTest_q)
    BEGIN
        CASE (fracRPostExc_uid32_fxpToFPTest_s) IS
            WHEN "0" => fracRPostExc_uid32_fxpToFPTest_q <= redist15_fracR_uid25_fxpToFPTest_b_2_q;
            WHEN "1" => fracRPostExc_uid32_fxpToFPTest_q <= fracZ_uid31_fxpToFPTest_q;
            WHEN OTHERS => fracRPostExc_uid32_fxpToFPTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- outRes_uid40_fxpToFPTest(BITJOIN,39)@14
    outRes_uid40_fxpToFPTest_q <= redist19_signX_uid6_fxpToFPTest_b_14_q & expRPostExc_uid39_fxpToFPTest_q & fracRPostExc_uid32_fxpToFPTest_q;

    -- xOut(GPOUT,4)@14
    q <= outRes_uid40_fxpToFPTest_q;

END normal;
