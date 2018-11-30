library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RAT_MCU is
    Port ( IN_PORT : in STD_LOGIC_VECTOR (7 downto 0);
           RESET : in STD_LOGIC;
           INT : in STD_LOGIC;
           CLK : in STD_LOGIC;
           OUT_PORT : out STD_LOGIC_VECTOR (7 downto 0);
           PORT_ID : out STD_LOGIC_VECTOR (7 downto 0);
           IO_STRB : out STD_LOGIC);
end RAT_MCU;

architecture Behavioral of RAT_MCU is

-- Start Components

component PC_Counter
    Port ( FROM_IMMED : in STD_LOGIC_VECTOR (9 downto 0);
           FROM_STACK : in STD_LOGIC_VECTOR (9 downto 0);
           PC_MUX_SEL : in STD_LOGIC_VECTOR (1 downto 0);
           PC_LD : in STD_LOGIC;
           PC_INC : in STD_LOGIC;
           RST : in STD_LOGIC;
           CLK : in STD_LOGIC;
           PC_COUNT : out STD_LOGIC_VECTOR (9 downto 0));
end component;

component Control_Unit
    Port ( OPCODE : in STD_LOGIC_VECTOR (6 downto 0);
           INT : in STD_LOGIC;
           C_FLAG : in STD_LOGIC;
           Z_FLAG : in STD_LOGIC;
           RESET : in STD_LOGIC;
           CLK : in STD_LOGIC;
           
           I_SET : out STD_LOGIC;
           I_CLR : out STD_LOGIC;
           
           PC_LD : out STD_LOGIC;
           PC_INC : out STD_LOGIC;
           PC_MUX_SEL : out STD_LOGIC_VECTOR (1 downto 0);
           
           ALU_OPY_SEL : out STD_LOGIC;
           ALU_SEL : out STD_LOGIC_VECTOR (3 downto 0);
           
           RF_WR : out STD_LOGIC;
           RF_WR_SEL : out STD_LOGIC_VECTOR(1 downto 0);
           
           SP_LD : out STD_LOGIC;
           SP_INCR : out STD_LOGIC;
           SP_DECR : out STD_LOGIC;
                      
           SCR_WE : out STD_LOGIC;
           SCR_ADDR_SEL : out STD_LOGIC_VECTOR (1 downto 0);
           SCR_DATA_SEL : out STD_LOGIC;
           
           FLG_C_SET : out STD_LOGIC;
           FLG_C_CLR : out STD_LOGIC;
           FLG_C_LD : out STD_LOGIC;
           FLG_Z_LD : out STD_LOGIC;
           FLG_LD_SEL : out STD_LOGIC;
           FLG_SHAD_LD : out STD_LOGIC;
           
           RST : out STD_LOGIC;
     
           IO_STRB : out STD_LOGIC);
end component;

component prog_rom 
   port (     ADDRESS : in std_logic_vector(9 downto 0); 
          INSTRUCTION : out std_logic_vector(17 downto 0); 
                  CLK : in std_logic);  
end component;

component REG_FILE
    Port ( RF_WR_DATA : in STD_LOGIC_VECTOR (7 downto 0);
           ADRX : in STD_LOGIC_VECTOR (4 downto 0);
           ADRY : in STD_LOGIC_VECTOR (4 downto 0);
           RF_WR : in STD_LOGIC;
           CLK : in STD_LOGIC;
           DX_OUT : out STD_LOGIC_VECTOR (7 downto 0);
           DY_OUT : out STD_LOGIC_VECTOR (7 downto 0));
end component;

component ALU
    Port ( A : in STD_LOGIC_VECTOR (7 downto 0);
           B : in STD_LOGIC_VECTOR (7 downto 0);
           C_IN : in STD_LOGIC;
           SEL : in STD_LOGIC_VECTOR (3 downto 0);
           SUM : out STD_LOGIC_VECTOR (7 downto 0);
           C_FLAG : out STD_LOGIC;
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

component Z_FLAG_REG
    Port ( Z : in STD_LOGIC;
           FLG_Z_LD : in STD_LOGIC;
           CLK : in STD_LOGIC;
           Z_FLAG : out STD_LOGIC);
end component;

component Mux_4x1
    Port ( IN_PORT : in STD_LOGIC_VECTOR (7 downto 0);
           SP_OUT : in STD_LOGIC_VECTOR (7 downto 0);
           SCR_OUT : in STD_LOGIC_VECTOR (7 downto 0);
           ALU_RESULT : in STD_LOGIC_VECTOR (7 downto 0);
           RF_WR_SEL : in STD_LOGIC_VECTOR (1 downto 0);
           OUTPUT : out STD_LOGIC_VECTOR (7 downto 0));
end component;

component Mux_2x1
    Port ( DY_OUT : in STD_LOGIC_VECTOR (7 downto 0);
           IR : in STD_LOGIC_VECTOR (7 downto 0);
           ALU_OPY_SEL : in STD_LOGIC;
           OUTPUT : out STD_LOGIC_VECTOR (7 downto 0));
end component;

-- End Components

-- Begin Signals

signal s_C : std_logic; -- These 2 are ALU Outputs
signal s_Z : std_logic;

signal s_C_Flag : std_logic; -- These 2 are from Z/C Flag Register Outputs
signal s_Z_Flag : std_logic;

signal s_FLG_Z_LD : std_logic; -- Z Flag Register Load

signal s_FLG_C_SET : std_logic; --  These 3 are C Flag Reg Set/Load/Clear
signal s_FLG_C_LD : std_logic;
signal s_FLG_C_CLR : std_logic; 

signal s_FLG_LD_SEL :  STD_LOGIC; -- Unknown Flag signals
signal s_FLG_SHAD_LD :  STD_LOGIC;

signal s_OPCODE :  STD_LOGIC_VECTOR (6 downto 0); -- Control Unit Inputs
signal s_INT :  STD_LOGIC;

signal s_I_SET :  STD_LOGIC; -- Unknown Flag Signals
signal s_I_CLR :  STD_LOGIC;

signal s_PC_LD :  STD_LOGIC; -- Program Counter Inputs
signal s_PC_INC :  STD_LOGIC;
signal s_PC_MUX_SEL :  STD_LOGIC_VECTOR (1 downto 0);

signal s_PC_COUNT :  STD_LOGIC_VECTOR (9 downto 0); -- Program Counter Output

signal s_IR : STD_LOGIC_VECTOR (17 downto 0); -- Prog Rom Output

signal s_ALU_OPY_SEL :  STD_LOGIC; -- ALU Mux Select
signal s_ALU_SEL :  STD_LOGIC_VECTOR (3 downto 0); -- ALU Input
signal s_ALU_Mux_O : STD_LOGIC_VECTOR (7 downto 0); -- ALU Mux Output
signal s_ALU_Result : STD_LOGIC_VECTOR (7 downto 0); -- ALU Output


signal s_RF_WR :  STD_LOGIC; -- Reg File Write Signal
signal s_RF_WR_SEL :  STD_LOGIC_VECTOR(1 downto 0); -- Reg File Mux Select
signal s_RF_Mux_O : STD_LOGIC_VECTOR (7 downto 0); -- Reg File Mux Output
signal s_RF_DX_OUT : STD_LOGIC_VECTOR (7 downto 0); -- Reg File Data X Output
signal s_RF_DY_OUT : STD_LOGIC_VECTOR (7 downto 0); -- Reg File Data Y Output


signal s_SP_LD :  STD_LOGIC; -- Unknown Flag Signals
signal s_SP_INCR :  STD_LOGIC;
signal s_SP_DECR :  STD_LOGIC;

signal s_SCR_WE :  STD_LOGIC; -- Scratch RAM 
signal s_SCR_ADDR_SEL :  STD_LOGIC_VECTOR (1 downto 0); -- Scratch Ram Addr Select signa;
signal s_SCR_DATA_SEL :  STD_LOGIC; --Scratch Ram Data Select

signal s_SCR_Data_Out : STD_LOGIC_VECTOR (9 downto 0); -- Scratch RAM Output

signal s_RST :  STD_LOGIC; -- Reset Signal

-- End Signals

begin

s_OPCODE <= std_logic_vector(s_IR(17 downto 13)) & std_logic_vector(s_IR(1 downto 0));

Control_U: Control_Unit port map (s_OPCODE, INT, s_C_FLAG, s_Z_FLAG, RESET, CLK, s_I_SET, s_I_CLR, s_PC_LD, s_PC_INC, 
                                    s_PC_MUX_SEL, s_ALU_OPY_SEL, s_ALU_SEL, s_RF_WR, s_RF_WR_SEL, 
                                    s_SP_LD, s_SP_INCR, s_SP_DECR, s_SCR_WE, s_SCR_ADDR_SEL, s_SCR_DATA_SEL, s_FLG_C_SET, 
                                    s_FLG_C_CLR, s_FLG_C_LD, s_FLG_Z_LD, s_FLG_LD_SEL, s_FLG_SHAD_LD, s_RST, IO_STRB); --Good

PC: PC_Counter port map (std_logic_vector(s_IR(12 downto 3)), s_SCR_Data_Out, s_PC_MUX_SEL, s_PC_LD, s_PC_INC, s_RST, CLK, s_PC_COUNT);  --Good

prog_r : prog_rom port map (s_PC_COUNT, s_IR, CLK); --Good

mux_RF: Mux_4x1 port map (IN_PORT, "00000000", "00000000", s_ALU_Result, s_RF_WR_SEL, s_RF_Mux_O); --Good

R_File : REG_FILE port map (s_RF_Mux_O, std_logic_vector(s_IR(12 downto 8)), std_logic_vector(s_IR(7 downto 3)), s_RF_WR, 
                                    CLK, s_RF_DX_OUT, s_RF_DY_OUT); --Good

mux_ALU: Mux_2x1 port map (s_RF_DY_OUT, std_logic_vector(s_IR(7 downto 0)), s_ALU_OPY_SEL, s_ALU_MUX_O);

Arith_LU : ALU port map (s_RF_DX_OUT, s_ALU_Mux_O, s_C_FLAG, s_ALU_SEL, s_ALU_Result, s_C, s_Z); --Good

Z_FLAG: Z_FLAG_REG port map (s_Z, s_FLG_Z_LD, CLK, s_Z_Flag); --Good

C_FLAG: C_FLAG_REG port map (s_C, s_FLG_C_SET, s_FLG_Z_LD, s_FLG_C_CLR, CLK, s_C_Flag); --Good

OUT_PORT <= s_RF_DX_OUT;
PORT_ID <= std_logic_vector(s_IR(7 downto 0));

end Behavioral;
