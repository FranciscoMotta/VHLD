LIBRARY ieee;
USE ieee.std_logic_1164.all;

------------------------------------------------------------

ENTITY MAQUINA IS
	PORT (w, reset, clock: IN STD_LOGIC;
			z: OUT STD_LOGIC);
END MAQUINA;
			
------------------------------------------------------------

ARCHITECTURE arquitectura OF MAQUINA IS

	TYPE state IS (A, B, C);
	SIGNAL pr_state, nx_state: state;

BEGIN
	
----------------- Seccion inferior: ------------------------

	PROCESS (reset, clock)
	BEGIN
		IF (reset='1') THEN
			pr_state <= A;
		ELSIF (clock'EVENT AND clock='1') THEN
			pr_state <= nx_state;
		END IF;
	END PROCESS;
	
----------------- Seccion superior: -----------------------
	
	PROCESS (w, pr_state)
	BEGIN
		CASE pr_state IS
			WHEN A => z <= '0';
				IF (w = '1') THEN
					nx_state <= B;
				ELSE
					nx_state <= A;
				END IF;
			WHEN B => z <= '0';
				IF (w = '1') THEN
					nx_state <= C;
				ELSE
					nx_state <= A;
				END IF;
			WHEN C => z <= '1';
				IF (w = '1') THEN
					nx_state <= C;
				ELSE
					nx_state <= A;
				END IF;
		END CASE;
	END PROCESS;
END arquitectura;