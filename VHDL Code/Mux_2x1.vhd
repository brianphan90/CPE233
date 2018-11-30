library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Mux_2x1 is
    Port ( DY_OUT : in STD_LOGIC_VECTOR (7 downto 0);
           IR : in STD_LOGIC_VECTOR (7 downto 0);
           ALU_OPY_SEL : in STD_LOGIC;
           OUTPUT : out STD_LOGIC_VECTOR (7 downto 0));
end Mux_2x1;

architecture Behavioral of Mux_2x1 is

begin
 
with ALU_OPY_SEL select
OUTPUT <=   DY_OUT when '0',
            IR when '1',
            "00000000" when others;
end Behavioral;
