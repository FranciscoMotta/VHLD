LIBRARY ieee;
USE ieee.std_logic_1164.all;
--
ENTITY CONVERSOR IS
	PORT
	(
	
	a:IN STD_LOGIC_VECTOR(3 DOWNTO 0);
	sal: OUT STD_LOGIC_VECTOR(0 TO 6)
	
	);
END CONVERSOR;

ARCHITECTURE DISPLAY OF CONVERSOR IS
BEGIN
	WITH a SELECT
		sal <= "1000000" WHEN "0000",
				 "1111001" WHEN "0001",
				 "0100100" WHEN "0010",
				 "0110000" WHEN "0011",
				 "0011001" WHEN "0100",
				 "0010010" when "0101",
				 "0000010" when "0110",
				 "1111000" when "0111",
				 "0000000" when "1000",
				 "0010000" when "1001",
				 "0001000" when "1010",
				 "0000011" when "1011",
				 "1000110" when "1100",
				 "0100001" when "1101",
				 "0000110" when "1110",
				 "0001110" when OTHERS; 
END DISPLAY;