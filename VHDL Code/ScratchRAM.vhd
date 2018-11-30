library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity ScratchRAM is
    Port ( DATA_IN : in STD_LOGIC_VECTOR (9 downto 0);
           SCR_ADDR : in STD_LOGIC_VECTOR (7 downto 0);
           SCR_WE : in STD_LOGIC;
           CLK : in STD_LOGIC;
           DATA_OUT : out STD_LOGIC_VECTOR (9 downto 0));
end ScratchRAM;

architecture Behavioral of ScratchRAM is

TYPE memory is ARRAY (0 to 255) of STD_LOGIC_VECTOR (9 downto 0);

SIGNAL set : memory := (others => (others => '0')); -- initialize to 0s

begin

process(CLK)
begin
    if (rising_edge(CLK)) then
        if (SCR_WE = '1') then
            set(to_integer(unsigned(SCR_ADDR))) <= (DATA_IN);
        end if;
    end if;
end process;    

DATA_OUT <= set(to_integer(unsigned(SCR_ADDR)));

end Behavioral;
