library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity Peripheral_2 is
    Port ( CLK : in STD_LOGIC;
           SW : in STD_LOGIC_VECTOR (7 downto 0);
           OUTPUT : out STD_LOGIC);
end Peripheral_2;

architecture Behavioral of Peripheral_2 is

begin

process(CLK)

    variable count_up : unsigned (7 downto 0); -- 8 bit count
      
begin

if rising_edge(CLK) then
    count_up := count_up + 1;
    if count_up = "11111111" then
        OUTPUT <= '1';
    elsif STD_LOGIC_VECTOR(count_up) = SW then
        OUTPUT <= '0';
    end if;
end if;

end process;
end Behavioral;
