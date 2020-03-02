LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY TRUNCADO10 IS 
PORT 
(
clock_in_contador, enable, reset : in std_logic;
CARRY : BUFFER STD_LOGIC;
SALIDA: buffer std_logic_vector(3 downto 0)
);
END TRUNCADO10;

architecture arqui of TRUNCADO10 is 
begin
PROCESS (clock_in_contador, enable, reset)
BEGIN

	IF (clock_in_contador'event and clock_in_contador = '1') then
		IF (ENABLE = '0') THEN
			SALIDA <= UNAFFECTED;
		ELSE
			IF (SALIDA = "1001" or reset = '1') THEN
		    SALIDA <= "0000";
			ELSE 
		SALIDA <= SALIDA + "0001";
		END IF;			
		END IF;
	END IF;
	
	
END PROCESS;


	CARRY <= '1' WHEN (SALIDA = "1001" or reset = '1') ELSE 
	         '0';
end arqui;