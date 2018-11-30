library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FLAGS is
    Port (  C : in STD_LOGIC;
            FLG_C_SET : in STD_LOGIC;
            FLG_C_LD : in STD_LOGIC;
            FLG_C_CLR : in STD_LOGIC;
            
            Z : in STD_LOGIC;
            FLG_Z_LD : in STD_LOGIC;
            
            CLK : in STD_LOGIC;
            
            C_FLAG : out STD_LOGIC;
            Z_FLAG : out STD_LOGIC);
end FLAGS;

architecture Behavioral of FLAGS is

component Z_FLAG_REG 
    Port ( Z : in STD_LOGIC;
           FLG_Z_LD : in STD_LOGIC;
           CLK : in STD_LOGIC;
           Z_FLAG : out STD_LOGIC);
end component;

component C_FLAG_REG 
    Port ( C : in STD_LOGIC;
           FLG_C_SET : in STD_LOGIC;
           FLG_C_LD : in STD_LOGIC;
           FLG_C_CLR : in STD_LOGIC;
           CLK : in STD_LOGIC;
           C_FLAG : out STD_LOGIC);
end component;

begin




end Behavioral;
