LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;	
--use ieee.std_logic_arith.all;
USE ieee.math_real.all;

package Common is 
	type reg_type is array (15 downto 0) of std_logic_vector(31 downto 0);
end package;

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;	
--use ieee.std_logic_arith.all;
USE ieee.math_real.all;

LIBRARY work;
use work.Common.all;

ENTITY DECIDER IS
	
	GENERIC(
		ADDR: integer range 0 to 255:=1;
		preREG0:	integer:=0;
		preREG1:	integer:=0;
		preREG2:	integer:=0;
		preREG3:	integer:=0;
		preREG4:	integer:=0;
		preREG5:	integer:=0;	
		preREG6:	integer:=0;
		preREG7:	integer:=0;
		preREG8:	integer:=0
	);
   PORT(
		clk100: 		IN  std_logic;
		clk1: 			IN  std_logic;
				
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
		
		NewCommand: 	IN   std_logic;		
		Send:			OUT  std_logic;
		Busy:			IN   std_logic;
		
		REG_set:		OUT  reg_type:=(
		0=>std_logic_vector(to_unsigned(preREG0,32)),
		1=>std_logic_vector(to_unsigned(preREG1,32)),
		2=>std_logic_vector(to_unsigned(preREG2,32)),
		3=>std_logic_vector(to_unsigned(preREG3,32)),
		4=>std_logic_vector(to_unsigned(preREG4,32)),
		5=>std_logic_vector(to_unsigned(preREG5,32)),
		6=>std_logic_vector(to_unsigned(preREG6,32)),
		7=>std_logic_vector(to_unsigned(preREG7,32)),
		8=>std_logic_vector(to_unsigned(preREG8,32)),
		others=>(others=>'0'));
		REG_get:		IN   reg_type
   );
END DECIDER;

ARCHITECTURE arch OF DECIDER IS
--signal REG_mem: reg_type;
BEGIN
-------------------------------------------------
-------------------------------------------------
-------------------------------------------------
	newcomm_proc:
	PROCESS (NewCommand,Busy)
	BEGIN
	if(Busy='1')then
		Send<='0';
	elsif(clk100'event AND clk100='1')then
		if(ADDR_DST_in=std_logic_vector(to_unsigned(ADDR,8)) and NewCommand='1')then
			if(COMMAND_in="01")then--write
				ADDR_DST_out<=ADDR_SRC_in;
				ADDR_SRC_out<=ADDR_DST_in;
				COMMAND_out	<="11";--OK
				REG_set(to_integer(unsigned(REG_in)))<=DATA_in;
				DATA_out<=DATA_in;
				REG_out<=REG_in;
				Send<='1';
			elsif(COMMAND_in="10")then--Read
				ADDR_DST_out<=ADDR_SRC_in;
				ADDR_SRC_out<=ADDR_DST_in;
				COMMAND_out	<="11";--OK
				DATA_out<=REG_get(to_integer(unsigned(REG_in)));
				REG_out<=REG_in;
				Send<='1';
			end if;
		end if;
	end if;
	end process newcomm_proc;
-------------------------------------------------
-------------------------------------------------
-------------------------------------------------
END arch;