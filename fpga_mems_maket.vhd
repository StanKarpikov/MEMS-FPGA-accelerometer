-- Copyright (C) 1991-2009 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.

-- PROGRAM		"Quartus II"
-- VERSION		"Version 9.1 Build 222 10/21/2009 SJ Full Version"
-- CREATED		"Mon Feb 20 09:59:42 2017"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY fpga_mems_maket IS 
	PORT
	(
		clk100 :  IN  STD_LOGIC;
		RX :  IN  STD_LOGIC;
		inp :  IN  STD_LOGIC;
		adc :  IN  STD_LOGIC;
		TX :  OUT  STD_LOGIC;
		outA :  OUT  STD_LOGIC;
		outB :  OUT  STD_LOGIC;
		LED1 :  OUT  STD_LOGIC;
		LED2 :  OUT  STD_LOGIC;
		LED3 :  OUT  STD_LOGIC;
		test1 :  OUT  STD_LOGIC;
		test2 :  OUT  STD_LOGIC;
		test3 :  OUT  STD_LOGIC;
		adc_fb :  OUT  STD_LOGIC;
		adc_signal_out :  OUT  STD_LOGIC
	);
END fpga_mems_maket;

ARCHITECTURE bdf_type OF fpga_mems_maket IS 

COMPONENT uart_fifo
GENERIC (COUNT_BYTE : INTEGER;
			COUNT_MAX : INTEGER
			);
	PORT(clk100 : IN STD_LOGIC;
		 clk1 : IN STD_LOGIC;
		 rx : IN STD_LOGIC;
		 Send : IN STD_LOGIC;
		 ADDR_DST_in : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 ADDR_SRC_in : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 COMMAND_in : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		 DATA_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 REG_in : IN STD_LOGIC_VECTOR(13 DOWNTO 0);
		 tx : OUT STD_LOGIC;
		 NewCommand : OUT STD_LOGIC;
		 Busy : OUT STD_LOGIC;
		 CRC_error : OUT STD_LOGIC;
		 Wait_error : OUT STD_LOGIC;
		 StartByte_error : OUT STD_LOGIC;
		 ADDR_DST_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		 ADDR_SRC_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		 COMMAND_out : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		 DATA_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		 REG_out : OUT STD_LOGIC_VECTOR(13 DOWNTO 0)
	);
END COMPONENT;

COMPONENT nonlinear
GENERIC (MIN_T : INTEGER
			);
	PORT(clk100 : IN STD_LOGIC;
		 SIGN_INP : IN STD_LOGIC;
		 ToZERO : IN STD_LOGIC;
		 inp : IN STD_LOGIC;
		 external_in : IN STD_LOGIC;
		 F_START : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 MIN_T : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 T_OFF_A : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 T_OFF_B : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 T_WAIT_A : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 T_WAIT_B : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 outA : OUT STD_LOGIC;
		 outB : OUT STD_LOGIC;
		 rise : OUT STD_LOGIC;
		 fade : OUT STD_LOGIC;
		 test : OUT STD_LOGIC;
		 T1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		 T2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

COMPONENT decider
GENERIC (ADDR : INTEGER;
			preREG0 : INTEGER;
			preREG1 : INTEGER;
			preREG2 : INTEGER;
			preREG3 : INTEGER;
			preREG4 : INTEGER;
			preREG5 : INTEGER;
			preREG6 : INTEGER;
			preREG7 : INTEGER;
			preREG8 : STD_LOGIC_VECTOR(2 DOWNTO 0)
			);
	PORT(clk100 : IN STD_LOGIC;
		 clk1 : IN STD_LOGIC;
		 NewCommand : IN STD_LOGIC;
		 Busy : IN STD_LOGIC;
		 ADDR_DST_in : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 ADDR_SRC_in : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 COMMAND_in : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		 DATA_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 REG_get : IN STD_LOGIC_VECTOR(15 DOWNTO 0 , 31 DOWNTO 0);
		 REG_in : IN STD_LOGIC_VECTOR(13 DOWNTO 0);
		 Send : OUT STD_LOGIC;
		 ADDR_DST_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		 ADDR_SRC_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		 COMMAND_out : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		 DATA_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		 REG_out : OUT STD_LOGIC_VECTOR(13 DOWNTO 0);
		 REG_set : OUT STD_LOGIC_VECTOR(15 DOWNTO 0 , 31 DOWNTO 0)
	);
END COMPONENT;

COMPONENT pll
	PORT(inclk0 : IN STD_LOGIC;
		 c0 : OUT STD_LOGIC
	);
END COMPONENT;

SIGNAL	ADDR_DST :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	ADDR_SRC :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	clk1 :  STD_LOGIC;
SIGNAL	COMMAND :  STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL	DATA :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	REG :  STD_LOGIC_VECTOR(13 DOWNTO 0);
SIGNAL	REG_get :  STD_LOGIC_VECTOR(15 DOWNTO 0 , 31 DOWNTO 0);
SIGNAL	REG_set :  STD_LOGIC_VECTOR(15 DOWNTO 0 , 31 DOWNTO 0);
SIGNAL	Send :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_9 :  STD_LOGIC;
SIGNAL	DFF_inst12 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_2 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_3 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_4 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_5 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_6 :  STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_7 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_8 :  STD_LOGIC_VECTOR(13 DOWNTO 0);


BEGIN 
adc_signal_out <= DFF_inst12;
SYNTHESIZED_WIRE_9 <= '1';



b2v_inst : uart_fifo
GENERIC MAP(COUNT_BYTE => 109,
			COUNT_MAX => 25000
			)
PORT MAP(clk100 => clk100,
		 clk1 => clk1,
		 rx => RX,
		 Send => Send,
		 ADDR_DST_in => ADDR_DST,
		 ADDR_SRC_in => ADDR_SRC,
		 COMMAND_in => COMMAND,
		 DATA_in => DATA,
		 REG_in => REG,
		 tx => TX,
		 NewCommand => SYNTHESIZED_WIRE_2,
		 Busy => SYNTHESIZED_WIRE_3,
		 CRC_error => LED1,
		 Wait_error => LED2,
		 StartByte_error => LED3,
		 ADDR_DST_out => SYNTHESIZED_WIRE_4,
		 ADDR_SRC_out => SYNTHESIZED_WIRE_5,
		 COMMAND_out => SYNTHESIZED_WIRE_6,
		 DATA_out => SYNTHESIZED_WIRE_7,
		 REG_out => SYNTHESIZED_WIRE_8);


b2v_inst1 : nonlinear
GENERIC MAP(MIN_T => 5
			)
PORT MAP(clk100 => clk100,
		 SIGN_INP => REG_set(8 , 0) ,
		 ToZERO => REG_set(8 , 1) ,
		 inp => inp,
		 external_in => REG_set(8 , 2) ,
		 F_START => REG_set(4 , 31 DOWNTO 0) ,
		 MIN_T => REG_set(5 , 31 DOWNTO 0) ,
		 T_OFF_A => REG_set(1 , 31 DOWNTO 0) ,
		 T_OFF_B => REG_set(3 , 31 DOWNTO 0) ,
		 T_WAIT_A => REG_set(0 , 31 DOWNTO 0) ,
		 T_WAIT_B => REG_set(2 , 31 DOWNTO 0) ,
		 outA => outA,
		 outB => outB,
		 rise => test1,
		 fade => test2,
		 test => test3,
		 T1 => REG_get(6 , 31 DOWNTO 0) ,
		 T2 => REG_get(7 , 31 DOWNTO 0) );

REG_get(8 , 31 DOWNTO 0)  <= REG_set(8 , 31 DOWNTO 0) ;




PROCESS(clk100,SYNTHESIZED_WIRE_9,SYNTHESIZED_WIRE_9)
BEGIN
IF (SYNTHESIZED_WIRE_9 = '0') THEN
	DFF_inst12 <= '0';
ELSIF (SYNTHESIZED_WIRE_9 = '0') THEN
	DFF_inst12 <= '1';
ELSIF (RISING_EDGE(clk100)) THEN
	DFF_inst12 <= adc;
END IF;
END PROCESS;


adc_fb <= NOT(DFF_inst12);



REG_get(0 , 31 DOWNTO 0)  <= REG_set(0 , 31 DOWNTO 0) ;


REG_get(1 , 31 DOWNTO 0)  <= REG_set(1 , 31 DOWNTO 0) ;


REG_get(2 , 31 DOWNTO 0)  <= REG_set(2 , 31 DOWNTO 0) ;


REG_get(3 , 31 DOWNTO 0)  <= REG_set(3 , 31 DOWNTO 0) ;


REG_get(4 , 31 DOWNTO 0)  <= REG_set(4 , 31 DOWNTO 0) ;


REG_get(5 , 31 DOWNTO 0)  <= REG_set(5 , 31 DOWNTO 0) ;



b2v_inst8 : decider
GENERIC MAP(ADDR => 1,
			preREG0 => 0,
			preREG1 => 200000,
			preREG2 => 0,
			preREG3 => 200000,
			preREG4 => 1500000,
			preREG5 => 1000,
			preREG6 => 0,
			preREG7 => 0,
			preREG8 => "100"
			)
PORT MAP(clk100 => clk100,
		 clk1 => clk1,
		 NewCommand => SYNTHESIZED_WIRE_2,
		 Busy => SYNTHESIZED_WIRE_3,
		 ADDR_DST_in => SYNTHESIZED_WIRE_4,
		 ADDR_SRC_in => SYNTHESIZED_WIRE_5,
		 COMMAND_in => SYNTHESIZED_WIRE_6,
		 DATA_in => SYNTHESIZED_WIRE_7,
		 REG_get => REG_get,
		 REG_in => SYNTHESIZED_WIRE_8,
		 Send => Send,
		 ADDR_DST_out => ADDR_DST,
		 ADDR_SRC_out => ADDR_SRC,
		 COMMAND_out => COMMAND,
		 DATA_out => DATA,
		 REG_out => REG,
		 REG_set => REG_set);


b2v_inst9 : pll
PORT MAP(inclk0 => clk100,
		 c0 => clk1);


REG_get(15 DOWNTO 9 , 31 DOWNTO 0)  <= "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
END bdf_type;