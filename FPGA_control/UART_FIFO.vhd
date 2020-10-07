LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;	
--use ieee.std_logic_arith.all;
USE ieee.math_real.all;

LIBRARY Mylib;
use Mylib.PCK_CRC16_D8.all;

ENTITY UART_FIFO IS
   GENERIC(
		COUNT_BYTE:		integer range 0 to 4096:=50;
		COUNT_MAX:		integer range 0 to 32767:=511
   );
   PORT(
		clk100: 		IN  std_logic;
		clk1: 			IN  std_logic;
		
		rx: 			IN  std_logic;
		tx: 			OUT  std_logic:='1';
		
		ADDR_SRC_in:	IN  std_logic_vector(7 downto 0);
		ADDR_DST_in:	IN  std_logic_vector(7 downto 0);
		COMMAND_in:		IN  std_logic_vector(1 downto 0);
		REG_in:			IN  std_logic_vector(13 downto 0);
		DATA_in:		IN  std_logic_vector(31 downto 0);
		
		ADDR_SRC_out:	OUT  std_logic_vector(7 downto 0);
		ADDR_DST_out:	OUT  std_logic_vector(7 downto 0);
		COMMAND_out:	OUT  std_logic_vector(1 downto 0);
		REG_out:		OUT  std_logic_vector(13 downto 0);
		DATA_out:		OUT  std_logic_vector(31 downto 0);
		
		NewCommand: 	OUT  std_logic;		
		Send:			IN   std_logic;
		Busy:			OUT  std_logic;
		CRC_error:		OUT  std_logic:='1';--верхний зелёный
		Wait_error:		OUT  std_logic:='1';
		StartByte_error:OUT  std_logic:='0'--нижний зелёный
   );
END UART_FIFO;

ARCHITECTURE arch OF UART_FIFO IS
signal txSTATE:		integer range 0 to 15:=0;
signal rxSTATE:		integer range 0 to 15:=0;
signal count_m:		integer range 0 to 32767:=0;
signal N_IN:		integer range 0 to 15:=0;
signal N_OUT:		integer range 0 to 15:=11;

signal rx_last:		std_logic:='1';
signal start_bit:	std_logic:='0';
signal SendClr:		std_logic:='0';
signal to_Send:		std_logic:='0';
signal newcomm:		std_logic:='0';

type byte_type is array (10 downto 0) of std_logic_vector(7 downto 0);
signal BytesIN:		byte_type;
signal BytesOUT:	byte_type;

signal CRC_IN : STD_LOGIC_VECTOR (15 downto 0) := x"FFFF";
signal CRC_OUT: STD_LOGIC_VECTOR (15 downto 0) := x"FFFF";
signal ByteOUT:	std_logic_vector(7 downto 0);

BEGIN
-------------------------------------------------
-------------------------------------------------
-------------------------------------------------
	rx_proc:
	PROCESS (clk100)
	BEGIN
	IF (clk100'event AND clk100 = '1') THEN
		count_m<=count_m+1;
		if(rx='0' and start_bit='0')then
			start_bit<='1';
			count_m<=COUNT_BYTE/2;
			rxSTATE<=0;
		end if;		
		if(start_bit='1')then
			if(count_m=COUNT_BYTE)then
				count_m<=0;
				rxSTATE<=rxSTATE+1;
				case rxSTATE is
					when 0=>null;--start bit
					when 1 to 8=>
						BytesIN(N_IN)(6 downto 0)<=BytesIN(N_IN)(7 downto 1);
						BytesIN(N_IN)(7)<=rx;
					when others=>--stop bit
						rxSTATE<=0;
						start_bit<='0';
						count_m<=COUNT_BYTE/2;
						if(N_IN=0 and BytesIN(0)/=x"55")then
							StartByte_error<='0';
						else							
							StartByte_error<='1';
							N_IN<=N_IN+1;
						end if;
						
						if(N_IN>0 and N_IN<9)then
							CRC_IN <= nextCRC16_D8(BytesIN(N_IN),CRC_IN);
						end if;
				end case;
			end if;
		end if;
		
		if(count_m=COUNT_MAX)then--Timeout
			if(N_IN/=0)then
				Wait_error<='0';
				rxSTATE		<=0;
				start_bit	<='0';			
				N_IN		<=0;
				CRC_IN 		<=x"FFFF";
			end if;
		else
			Wait_error<='1';
		end if;
		
		if(N_IN=11)then
			CRC_error<='1';
			N_IN		<=0;
			rxSTATE		<=0;
			CRC_IN 		<= x"FFFF";
			if(CRC_IN(15 downto 8)=BytesIN(9) and CRC_IN(7 downto 0)=BytesIN(10) and BytesIN(0)=x"55")then
				ADDR_SRC_out			<=BytesIN(1);
				ADDR_DST_out			<=BytesIN(2);
				COMMAND_out				<=BytesIN(3)(7 downto 6);
				REG_out(13 downto 8)	<=BytesIN(3)(5 downto 0);
				REG_out(7 downto 0)		<=BytesIN(4);
				DATA_out(31 downto 24)	<=BytesIN(5);
				DATA_out(23 downto 16)	<=BytesIN(6);
				DATA_out(15 downto 8)	<=BytesIN(7);
				DATA_out(7 downto 0)	<=BytesIN(8);
				newcomm					<='1';
			else
				CRC_error<='0';
			end if;
		end if;
		
		NewCommand		<='0';
		if(to_Send='0' and newcomm='1')then
			newcomm<='0';
			NewCommand	<='1';
		end if;
	end if;
	end process rx_proc;
-------------------------------------------------
-------------------------------------------------
-------------------------------------------------
	send_proc:
	PROCESS (clk100,Send,SendClr)
	BEGIN
	if(SendClr='1')then
		to_Send<='0';
		Busy<='0';
	elsif(clk100'event AND clk100='1')then
		if(to_Send='0' and Send='1')then
			to_Send<='1';
			Busy<='1';
			
			BytesOUT(0)				<=x"55";
			BytesOUT(1)				<=ADDR_SRC_in;
			BytesOUT(2)				<=ADDR_DST_in;
			BytesOUT(3)(7 downto 6)	<=COMMAND_in;	
			BytesOUT(3)(5 downto 0)	<=REG_in(13 downto 8);
			BytesOUT(4)				<=REG_in(7 downto 0);
			BytesOUT(5)				<=DATA_in(31 downto 24);	
			BytesOUT(6)				<=DATA_in(23 downto 16);	
			BytesOUT(7)				<=DATA_in(15 downto 8);
			BytesOUT(8)				<=DATA_in(7 downto 0);
		end if;
	end if;
	end process send_proc;
-------------------------------------------------	
	tx_proc:
	PROCESS (clk1)
	BEGIN
	IF (clk1'event AND clk1 = '1') THEN
		tx<='1';
		SendClr			<='0';		
		if(N_OUT=11 and to_Send='1')then			
			N_OUT			<=0;
			txSTATE			<=0;
			CRC_OUT 		<= x"FFFF";
		end if;
		if(N_OUT/=11)then
			txSTATE<=txSTATE+1;
			case txSTATE is
				when 0=>--start bit
					ByteOUT<=BytesOUT(N_OUT);
					if(N_OUT=9)then
						ByteOUT<=CRC_OUT(15 downto 8);
					end if;	
					if(N_OUT=10)then
						ByteOUT<=CRC_OUT(7 downto 0);						
					end if;
					if(N_OUT>0 and N_OUT<9)then
						CRC_OUT <= nextCRC16_D8(BytesOUT(N_OUT),CRC_OUT);
					end if;
					tx<='0';
				when 1 to 8=>
					ByteOUT(6 downto 0)<=ByteOUT(7 downto 1);
					tx<=ByteOUT(0);
				when others=>--stop bit
					txSTATE<=0;	
					N_OUT<=N_OUT+1;					
					tx<='1';
					if(N_OUT=10)then
						SendClr		<='1';
					end if;
			end case;
		end if;
	end if;
	end process tx_proc;
-------------------------------------------------
-------------------------------------------------
-------------------------------------------------
END arch;