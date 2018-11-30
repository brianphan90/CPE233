library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Mux_3x1 is
    Port ( FROM_IMMED : in STD_LOGIC_VECTOR (9 downto 0);
           FROM_STACK : in STD_LOGIC_VECTOR (9 downto 0);
           PC_MUX_SEL : in STD_LOGIC_VECTOR (1 downto 0);
           D_IN : out STD_LOGIC_VECTOR (9 downto 0));
end Mux_3x1;

architecture Behavioral of Mux_3x1 is

begin
 
with PC_MUX_SEL select
D_IN <= -- "0000000000" when "11",
        "1111111111" when "10",
        FROM_STACK when "01",
        FROM_IMMED when "00",
        "0000000000" when others;

end Behavioral;
