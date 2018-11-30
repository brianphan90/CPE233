library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Mux_4x1 is
    Port ( IN_PORT : in STD_LOGIC_VECTOR (7 downto 0);
           SP_OUT : in STD_LOGIC_VECTOR (7 downto 0);
           SCR_OUT : in STD_LOGIC_VECTOR (7 downto 0);
           ALU_RESULT : in STD_LOGIC_VECTOR (7 downto 0);
           RF_WR_SEL : in STD_LOGIC_VECTOR (1 downto 0);
           OUTPUT : out STD_LOGIC_VECTOR (7 downto 0));
end Mux_4x1;

architecture Behavioral of Mux_4x1 is

begin
 
with RF_WR_SEL select
OUTPUT <=   IN_PORT when "11",
            SP_OUT when "10",
            SCR_OUT when "01",
            ALU_RESULT when "00",
            "00000000" when others; 
end Behavioral;
