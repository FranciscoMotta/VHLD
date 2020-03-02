LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY STEPPER IS 
PORT 
( 
reset, w: IN STD_LOGIC;
CLK_IN: IN STD_LOGIC;
SALIDA_MOTOR : OUT STD_LOGIC_VECTOR(3 TO 0)
--SALIDA_GPIO : OUT STD_LOGIC;
--SALIDA_PWM : OUT STD_LOGIC
);
END STEPPER;


ARCHITECTURE DIVISOR_DE_FREQ OF STEPPER IS
CONSTANT TOP: STD_LOGIC_VECTOR (27 DOWNTO 0) := x"04C4B40";
SIGNAL CONTADOR : STD_LOGIC_VECTOR (27 DOWNTO 0);
SIGNAL CLK_OUT: STD_LOGIC;
SIGNAL CONTADOR_PWM :STD_LOGIC_VECTOR(15 DOWNTO 0); 
SIGNAL PWM : STD_LOGIC;
---------------------------------------------------------------------

TYPE state IS (A, B, C, D, E, F, G, H);
SIGNAL pr_state, nx_state: state;

--------------------------------------------------------------------
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

PROCESS (CLK_OUT)
BEGIN
IF (CLK_OUT'EVENT AND CLK_OUT = '1') THEN 
    IF (CONTADOR_PWM = x"0031") THEN 
	    CONTADOR_PWM <= x"0000";
    ELSE 
	 CONTADOR_PWM <= CONTADOR_PWM + x"01";
	 
	 --DISEÑO DEL COMPARADOR 
        
	 END IF;
END IF;
END PROCESS; 

----------------- Seccion inferior: ------------------------

	PROCESS (reset, CLK_OUT)
	BEGIN
		IF (reset='1') THEN
			pr_state <= A;
		ELSIF (CLK_OUT'EVENT AND CLK_OUT='1') THEN
			pr_state <= nx_state;
		END IF;
	END PROCESS;
	
----------------- Seccion superior: -----------------------
	
	PROCESS (w, pr_state)
	BEGIN
		CASE pr_state IS
			WHEN A => SALIDA_MOTOR <= "0101";
				IF (w = '1') THEN
					nx_state <= B;
				ELSE
					nx_state <= H;
				END IF;
				
			WHEN B => SALIDA_MOTOR <= "0001";
				IF (w = '1') THEN
					nx_state <= C;
				ELSE
					nx_state <= A;
				END IF;
				
			WHEN C => SALIDA_MOTOR <= "1001";
   			IF (w = '1') THEN
					nx_state <= D;
				ELSE
					nx_state <= B;
				END IF;
				
		   WHEN D => SALIDA_MOTOR <= "1000";
				IF (w = '1') THEN
					nx_state <= E;
				ELSE
					nx_state <= C;
				END IF;
				
		   WHEN E => SALIDA_MOTOR <= "1010";
				IF (w = '1') THEN
					nx_state <= F;
				ELSE
					nx_state <= D;
				END IF;
				
		   WHEN F => SALIDA_MOTOR <= "0010";
				IF (w = '1') THEN
					nx_state <= G;
				ELSE
					nx_state <= E;
				END IF;	
				
			WHEN G => SALIDA_MOTOR <= "0110";
				IF (w = '1') THEN
					nx_state <= H;
				ELSE
					nx_state <= F;
				END IF;	
				
			WHEN H => SALIDA_MOTOR <= "0100";
				IF (w = '1') THEN
					nx_state <= A;
				ELSE
					nx_state <= G;
				END IF;
		END CASE;
	END PROCESS;

END DIVISOR_DE_FREQ;