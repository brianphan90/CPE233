library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity REG_FILE is
    Port ( RF_WR_DATA : in STD_LOGIC_VECTOR (7 downto 0);
           ADRX : in STD_LOGIC_VECTOR (4 downto 0);
           ADRY : in STD_LOGIC_VECTOR (4 downto 0);
           RF_WR : in STD_LOGIC;
           CLK : in STD_LOGIC;
           DX_OUT : out STD_LOGIC_VECTOR (7 downto 0);
           DY_OUT : out STD_LOGIC_VECTOR (7 downto 0));
end REG_FILE;

architecture Behavioral of REG_FILE is

TYPE memory is ARRAY (0 to 31) of STD_LOGIC_VECTOR (7 downto 0);

SIGNAL set : memory := (others => (others => '0')); -- initialize to 0s
-- SIGNAL data : STD_LOGIC_VECTOR (7 downto 0);

begin

-- data <= set(to_integer(unsigned(ADRX)));

process(CLK)
begin
    if (rising_edge(CLK)) then
        if (RF_WR = '1') then
            set(to_integer(unsigned(ADRX))) <= (RF_WR_DATA);
        end if;
    end if;
end process;

DX_OUT <= set(to_integer(unsigned(ADRX)));
DY_OUT <= set(to_integer(unsigned(ADRY)));

end Behavioral;
