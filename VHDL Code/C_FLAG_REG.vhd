library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
        
entity C_FLAG_REG is
    Port ( C : in STD_LOGIC;
           FLG_C_SET : in STD_LOGIC;
           FLG_C_LD : in STD_LOGIC;
           FLG_C_CLR : in STD_LOGIC;
           CLK : in STD_LOGIC;
           C_FLAG : out STD_LOGIC);
end C_FLAG_REG;

architecture Behavioral of C_FLAG_REG is

begin

process(CLK)
begin
    if (rising_edge(CLK)) then
        if (FLG_C_CLR = '1') then
            C_FLAG <= '0';
        elsif (FLG_C_SET = '1') then
            C_FLAG <= '1';
        elsif (FLG_C_LD = '1') then
            C_FLAG <= C;        
        end if;
    end if;
end process;

end Behavioral;
