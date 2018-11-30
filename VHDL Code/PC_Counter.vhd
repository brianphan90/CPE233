library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity PC_Counter is
    Port ( FROM_IMMED : in STD_LOGIC_VECTOR (9 downto 0);
           FROM_STACK : in STD_LOGIC_VECTOR (9 downto 0);
           PC_MUX_SEL : in STD_LOGIC_VECTOR (1 downto 0);
           PC_LD : in STD_LOGIC;
           PC_INC : in STD_LOGIC;
           RST : in STD_LOGIC;
           CLK : in STD_LOGIC;
           PC_COUNT : out STD_LOGIC_VECTOR (9 downto 0));
end PC_Counter;

architecture Behavioral of PC_Counter is

component Mux_3x1
    Port ( FROM_IMMED : in STD_LOGIC_VECTOR (9 downto 0);
           FROM_STACK : in STD_LOGIC_VECTOR (9 downto 0);
           PC_MUX_SEL : in STD_LOGIC_VECTOR (1 downto 0);
           D_IN : out STD_LOGIC_VECTOR (9 downto 0));
end component;

component program_counter
    Port ( D_IN : in STD_LOGIC_VECTOR (9 downto 0);
           PC_LD : in STD_LOGIC;
           PC_INC : in STD_LOGIC;
           RST : in STD_LOGIC;
           CLK : in STD_LOGIC;
           PC_COUNT : out STD_LOGIC_VECTOR (9 downto 0));
end component;

signal s_D_IN : std_logic_vector(9 downto 0);

begin

mux: Mux_3x1 port map (FROM_IMMED, FROM_STACK, PC_MUX_SEL, s_D_IN);

counter: program_counter port map (s_D_IN, PC_LD, PC_INC, RST, CLK, PC_COUNT);


end Behavioral;
