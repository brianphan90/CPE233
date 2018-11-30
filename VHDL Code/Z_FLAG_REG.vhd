library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Z_FLAG_REG is
    Port ( Z : in STD_LOGIC;
           FLG_Z_LD : in STD_LOGIC;
           CLK : in STD_LOGIC;
           Z_FLAG : out STD_LOGIC);
end Z_FLAG_REG;

architecture Behavioral of Z_FLAG_REG is

begin

process(CLK)
begin
    if (rising_edge(CLK)) then
        if (FLG_Z_LD = '1') then
            Z_FLAG <= Z;
        end if;
    end if;
end process;

end Behavioral;
