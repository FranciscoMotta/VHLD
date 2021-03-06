LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY DIVISOR_50 IS 
PORT 
( 
SALIDA: BUFFER STD_LOGIC;
SALIDA_CUENTA : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
salida_bits : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
CLK_IN: IN STD_LOGIC
);
END DIVISOR_50;


ARCHITECTURE DIVISOR_DE_FREQ OF DIVISOR_50 IS
CONSTANT TOP: STD_LOGIC_VECTOR (27 DOWNTO 0) := x"2FAF07F"; 
SIGNAL CONTADOR : STD_LOGIC_VECTOR (27 DOWNTO 0);
SIGNAL CLK_OUT: STD_LOGIC;
SIGNAL CONTA : STD_LOGIC_VECTOR (3 DOWNTO 0) := "0000";
BEGIN 
PROCESS (CLK_IN)
BEGIN
IF(CLK_IN'EVENT AND CLK_IN ='1') THEN

--DISEÑO DEL CONTADOR 
  IF (CONTADOR = TOP) THEN 
  CONTADOR <= x"0000000";
  ELSE 
   CONTADOR <= CONTADOR + x"0000001";
  END IF;
--DISEÑO DEL COMPARADOR

   IF (CONTADOR = TOP) THEN 
		CLK_OUT <= '1';
	ELSE 
		CLK_OUT <= '0';
   END IF;	
END IF;
END PROCESS;
--DISEÑO DEL FF TIPO "T"
PROCESS (CLK_OUT)
BEGIN 
IF (CLK_OUT'EVENT AND CLK_OUT = '1') THEN 
	SALIDA <= NOT SALIDA;
END IF;
END PROCESS;
END DIVISOR_DE_FREQ;