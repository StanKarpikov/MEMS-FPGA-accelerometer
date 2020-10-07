LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;	
--use ieee.std_logic_arith.all;
USE ieee.math_real.all;

ENTITY NONLINEAR IS
   PORT(
		clk100: 		IN  std_logic;		
				
		T_WAIT_A:	 	IN  integer;
		T_OFF_A:		IN  integer;
		T_WAIT_B:	 	IN  integer;
		T_OFF_B:		IN  integer;		
		SIGN_INP:		IN  std_logic;
		ToZERO:			IN  std_logic;
		
		inp:			IN  std_logic;
		outA:			OUT std_logic;
		outB:			OUT std_logic;
		
		T1:				OUT integer:=0;
		T2:				OUT integer:=0;
		
		rise:			OUT std_logic;
		fade:			OUT std_logic;
		test:			OUT std_logic;
		
		F_START:	 	IN  integer;
		MIN_T:		 	IN  integer;
		external_in:	IN  std_logic		
   );
END NONLINEAR;

ARCHITECTURE arch OF NONLINEAR IS
signal inp_reg:  std_logic:='0';
signal inp_last: std_logic:='0';
signal inp_reg_reg: std_logic:='0';

signal inp_rise:   std_logic:='0';
signal inp_fade:   std_logic:='0';
signal inp_t: 	   std_logic_vector(2 downto 0):=(others=>'0');

signal outA_slow:   std_logic:='0';
signal outB_slow:   std_logic:='0';

signal A_start_with_front:   std_logic:='1';
signal B_start_with_front:   std_logic:='1';

signal A_stop_with_fade:   	 std_logic:='1';
signal B_stop_with_fade:  	 std_logic:='1';

signal inp_good:		  	 std_logic:='0';
signal inp_good_last:	  	 std_logic:='0';
signal count_in:		  	 integer:=0;
signal inp_generate:		 std_logic:='0';

signal Tf_reg:		  		 integer:=0;

BEGIN
-------------------------------------------------
-------------------------------------------------
-------------------------------------------------
	PROCESS (clk100,inp)
	BEGIN
	if(count_in>=MIN_T)then
		if(inp_good_last='0')then
			inp_good<=inp_good or inp;
		else
			inp_good<=inp_good and inp;
		end if;
	else
		inp_good<=inp_good_last;
	end if;	
	if(clk100'event AND clk100='1')then
		if(count_in<MIN_T)then
			count_in<=count_in+1;
		end if;
		if(inp/=inp_good_last and count_in>=MIN_T)then
			inp_good_last<=inp;			
			count_in<=0;
		end if;
	end if;
	END PROCESS;
-------------------------------------------------
	PROCESS (clk100,inp_reg)
	BEGIN	
	rise<=inp_rise;
	fade<=inp_fade;
	
	inp_rise	<=	(not inp_t(2)) and inp_reg;
	inp_fade	<=	inp_t(2) and (not inp_reg);
	
	if(clk100'event AND clk100='1')then
		inp_t(0)<=inp_reg;
		inp_t(2 downto 1)<=inp_t(1 downto 0);
	end if;
	END PROCESS;
-------------------------------------------------
	PROCESS (clk100)
	variable outA_need: std_logic:='0';
	variable outB_need: std_logic:='0';
	variable T1_reg: 	integer:=MIN_T*2;
	variable T2_reg: 	integer:=MIN_T*2;
	BEGIN
	
	if(external_in='0')then
		if(SIGN_INP='1')then
			inp_reg<=inp_good;
		else
			inp_reg<=not inp_good;
		end if;
	else
		if(SIGN_INP='1')then
			inp_reg<=inp_generate;
		else
			inp_reg<=not inp_generate;
		end if;
	end if;
-------------
	if(T_WAIT_A=0)then
		A_start_with_front<='1';
	else
		A_start_with_front<='0';
	end if;
	
	if(T_WAIT_B=0)then
		B_start_with_front<='1';
	else
		B_start_with_front<='0';
	end if;
-------------	
	if((T1_reg<=T_OFF_A and ToZERO='0') or (ToZERO='1' and T_WAIT_B=0))then
		A_stop_with_fade<='1';
	else
		A_stop_with_fade<='0';
	end if;
	
	if((T2_reg<=T_OFF_B and ToZERO='0') or (ToZERO='1' and T_WAIT_A=0))then
		B_stop_with_fade<='1';
	else
		B_stop_with_fade<='0';
	end if;
-------------
	outA<=(outA_slow or (inp_rise and A_start_with_front)) and ((not inp_fade) or (not A_stop_with_fade));
	outB<=(outB_slow or (inp_fade and B_start_with_front)) and ((not inp_rise) or (not B_stop_with_fade));
	test<=inp_reg;
-------------
	if(clk100'event AND clk100='1')then
		--------------------------------------------
		Tf_reg<=Tf_reg+1;
		if(Tf_reg>F_START)then
			inp_generate<=not inp_generate;
			Tf_reg<=0;
		end if;
		--------------------------------------------
		if(inp_last='1')then
			T1_reg:=T1_reg+1;
		else
			T2_reg:=T2_reg+1;
		end if;		
		--------------------------------------------
		inp_reg_reg<=inp_reg;
		inp_last<=inp_reg_reg;		
		if(inp_last='0' and inp_reg_reg='1')then
			T1<=T1_reg;
			T1_reg:=0;
						
			outA_need:='1';
			outB_need:='0';
		end if;		
		if(inp_last='1' and inp_reg_reg='0')then
			T2<=T2_reg;
			T2_reg:=0;
			
			outA_need:='0';
			outB_need:='1';
		end if;
		--------------------------------------------
		if(ToZERO='0')then
			if(T1_reg<=T_OFF_A and T1_reg>=T_WAIT_A)then
				outA_slow<=outA_need;
			else	
				outA_slow<='0';
			end if;
			if(T2_reg<=T_OFF_B and T2_reg>=T_WAIT_B)then
				outB_slow<=outB_need;
			else
				outB_slow<='0';
			end if;
		else
			if(T1_reg=T_WAIT_A or T2_reg=T_WAIT_B)then
				outA_slow<=outA_need;
				outB_slow<=outB_need;
			end if;
			if(T1_reg=T_OFF_A or T2_reg=T_OFF_B)then
				outA_slow<=not outA_need;
				outB_slow<=not outB_need;
			end if;			
		end if;	
		--------------------------------------------
	end if;
	end process;
-------------------------------------------------
-------------------------------------------------
-------------------------------------------------
END arch;