library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; --defines signed/unsigned vectors

entity program_counter is
    Port ( D_IN : in STD_LOGIC_VECTOR (9 downto 0);
           PC_LD : in STD_LOGIC;
           PC_INC : in STD_LOGIC;
           RST : in STD_LOGIC;
           CLK : in STD_LOGIC;
           PC_COUNT : out STD_LOGIC_VECTOR (9 downto 0));
end program_counter;

architecture Behavioral of program_counter is

signal PC_sig : unsigned (9 downto 0);

begin

process(CLK)
begin
    if (rising_edge(CLK)) then
        if (RST = '1') then
            PC_COUNT <= (others => '0');
        elsif (PC_LD = '1') then
            PC_COUNT <= D_IN;
        elsif (PC_INC = '1') then
            PC_sig <= unsigned(D_IN) + 1;
        end if;    
    end if;  
end process;

PC_COUNT <= std_logic_vector(PC_sig);

end Behavioral;
