LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;

ENTITY CONTADOR IS 
PORT
(
RELOJ_INTERNO : IN STD_LOGIC;
SALIDA_DIS, SALIDA_DIS2, SALIDA_DIS3, SALIDA_DIS4, SALIDA_DIS5, SALIDA_DIS6 : OUT STD_LOGIC_VECTOR(0 TO 6)
);
END CONTADOR;

ARCHITECTURE RELOJ OF CONTADOR IS

--------------------DIVISOR DE FREQ-------------------
COMPONENT DIVISOR IS 
PORT 
( 
SALIDA: BUFFER STD_LOGIC;
CLK_IN: IN STD_LOGIC
);
END COMPONENT;

--------------------CONVERSOR------------------------

COMPONENT CONVERSOR IS
	PORT
	(
	
	a:IN STD_LOGIC_VECTOR(3 DOWNTO 0);
	sal: OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
	
	);
END COMPONENT;
 
--------------------CONTADOR TRUNCADO 10 ----------------------------


COMPONENT TRUNCADO10 IS 
PORT 
(
clock_in_contador, enable, reset : in std_logic;
CARRY : BUFFER STD_LOGIC;
SALIDA: buffer std_logic_vector(3 downto 0)
);
END COMPONENT;

--------------------CONTADOR TRUNCADO 6---------------------------

COMPONENT TRUNCADO6 IS 
PORT 
(
clock_in_contador, enable, reset : in std_logic;
CARRY : BUFFER STD_LOGIC;
SALIDA: buffer std_logic_vector(3 downto 0)
);
END COMPONENT;
 
------------------- CONTADOR TRUNCADO 1------------------------------

COMPONENT TRUNCADO1 IS 
PORT 
(
clock_in_contador, enable, reset : in std_logic;
CARRY : BUFFER STD_LOGIC;
SALIDA: buffer std_logic_vector(3 downto 0)
);
END COMPONENT;



 SIGNAL MUL : STD_LOGIC;
 SIGNAL MUL2 : STD_LOGIC;
 SIGNAL MUL3 : STD_LOGIC;
 SIGNAL MUL4 : STD_LOGIC;
 SIGNAL SENRELOJ : STD_LOGIC;
 SIGNAL CARRY_TOP : STD_LOGIC;
 SIGNAL CARRY_TOP1 : STD_LOGIC;
 SIGNAL CARRY_TOP2 : STD_LOGIC;
 SIGNAL CARRY_TOP21 : STD_LOGIC;
 SIGNAL CARRY_TOP121 : STD_LOGIC;
 SIGNAL CARRY_TOP221 : STD_LOGIC;
 SIGNAL CARRY_TOP222 : STD_LOGIC;
 
 SIGNAL RESETEO : STD_LOGIC;
 
 SIGNAL NEGADO : STD_LOGIC; 
 
 SIGNAL DATA : STD_LOGIC;
 
 SIGNAL SALIDA_1, SALIDA_2, SALIDA_3, SALIDA_4, SALIDA_5, SALIDA_6: STD_LOGIC_VECTOR( 3 DOWNTO 0 );
 -------- 1001 ---- 0101     1001      0101      0001      0001 
 -------------------------------------------------------------------------------------------------
 SIGNAL SALI1, SALI2, SALI3, SALI4, SALI5, SALI6: STD_LOGIC_VECTOR( 3 DOWNTO 0 );
 
 
BEGIN

 
----------------------DIVISOR DE FREQ DE 50MILLONES A 1 HERZ------------------------

DIVISOR50: DIVISOR PORT MAP ( SALIDA => SENRELOJ, CLK_IN => RELOJ_INTERNO);

--SENRELOJ <= RELOJ_INTERNO ;
--------------------------------------------------------------------------------------

-----------------------------------SEGUNDOS-------------------------------------------

---------------------- CONTADOR TRUNCADOR DE 0 A 10 ----------------------------------

CONTADOR_10: TRUNCADO10 PORT MAP (clock_in_contador => SENRELOJ, SALIDA => SALIDA_1, CARRY => CARRY_TOP1, ENABLE => '1', reset => RESETEO);

--------------------------------------------------------------------------------------

---------------------- CONTADOR TRUNCADOR DE 0 A 6 -----------------------------------

CONTADOR_6: TRUNCADO6 PORT MAP (clock_in_contador => SENRELOJ , SALIDA => SALIDA_2, CARRY => CARRY_TOP2, ENABLE => CARRY_TOP1, reset => RESETEO );

-------------------------------------------------------------------------------------


--------------------------------------MINUTOS-----------------------------------------

MUL <= CARRY_TOP1 AND CARRY_TOP2;
MUL2 <= MUL AND CARRY_TOP21;

CONTADOR_11: TRUNCADO10 PORT MAP (clock_in_contador => SENRELOJ, SALIDA => SALIDA_3, CARRY => CARRY_TOP21, ENABLE => MUL, reset => RESETEO);

CONTADOR_61: TRUNCADO6 PORT MAP (clock_in_contador => SENRELOJ , SALIDA => SALIDA_4, CARRY => CARRY_TOP121, ENABLE => MUL2, reset => RESETEO );


---------------------------------------------------------------------------------------

-------------------------------------------HORAS-----------------------------------------
MUL3 <= MUL2 AND CARRY_TOP121;

CONTADOR_12: TRUNCADO10 PORT MAP (clock_in_contador => SENRELOJ, SALIDA => SALIDA_5, CARRY => CARRY_TOP221, ENABLE => MUL3, reset => RESETEO);

CONTADOR_63: TRUNCADO1 PORT MAP (clock_in_contador => SENRELOJ , SALIDA => SALIDA_6, CARRY => CARRY_TOP222, ENABLE => MUL4, reset => RESETEO);

--------------------------------------------------------------------------------------

---------------------- CONVERSOR DE BINARIO A DECIMAL -----------------------------

MUL4 <= CARRY_TOP221 AND MUL3;

CONVERSOR_1: CONVERSOR PORT MAP (a => SALIDA_1, sal => SALIDA_DIS);
CONVERSOR_2: CONVERSOR PORT MAP (a => SALIDA_2, sal => SALIDA_DIS2);
CONVERSOR_3: CONVERSOR PORT MAP (a => SALIDA_3, sal => SALIDA_DIS3);
CONVERSOR_4: CONVERSOR PORT MAP (a => SALIDA_4, sal => SALIDA_DIS4);
CONVERSOR_5: CONVERSOR PORT MAP (a => SALIDA_5, sal => SALIDA_DIS5);
CONVERSOR_6: CONVERSOR PORT MAP (a => SALIDA_6, sal => SALIDA_DIS6);

 -------- 0001 ---- 0001 --- 1001 ---- 0101 ---- 1001 ---- 0101 -----



RESETEO <= '0' WHEN DATA = '0' ELSE 
           '1' WHEN DATA = '1';
			  
DATA <= (SALIDA_6(0) AND SALIDA_5(0) AND (SALIDA_4(0) AND SALIDA_4(2)) AND (SALIDA_2(0) AND SALIDA_2(2)) AND (SALIDA_1(0) AND SALIDA_1(3)) AND (SALIDA_3(0) AND SALIDA_3(3)));



END RELOJ;