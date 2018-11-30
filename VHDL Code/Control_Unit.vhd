library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Control_Unit is
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
end Control_Unit;

architecture Behavioral of Control_Unit is

type state_type is (INIT, FETCH, EXEC);

signal PS, NS : state_type;

begin

states : process(RESET, CLK)
begin
    if RESET = '1' then
        PS <= INIT;
    else
        if rising_edge(CLK) then
            PS <= NS;
        end if;
    end if;
end process;

NS_state : process(OPCODE, PS)
begin
    I_SET <= '0';
    I_CLR <= '0';
    
    PC_LD <= '0';
    PC_INC <= '0';
    PC_MUX_SEL <= "00";
    
    ALU_OPY_SEL <= '0';
    ALU_SEL <= "0000";
    
    RF_WR <= '0';
    RF_WR_SEL<= "00";
    
    SP_LD<= '0';
    SP_INCR <= '0';
    SP_DECR <= '0';
    
    SCR_WE <= '0';
    SCR_ADDR_SEL<= "00";
    SCR_DATA_SEL<= '0';
    
    FLG_C_SET <= '0';
    FLG_C_CLR <= '0';
    FLG_C_LD<= '0';
    FLG_Z_LD <= '0';
    FLG_LD_SEL <= '0';
    FLG_SHAD_LD<= '0';     
    
    RST <= '0';
    
    IO_STRB<= '0';

    case PS is
        when INIT =>
            NS <= FETCH;
            RST <= '1';
        
        when FETCH =>
            NS <= EXEC;
            PC_INC <= '1';
            
        when EXEC =>
            NS <= FETCH;
    
    case STD_LOGIC_VECTOR(OPCODE(6 downto 2)) is
        when "00100" => --BRN
            if STD_LOGIC_VECTOR(OPCODE(1 downto 0)) = "00" then
                PC_LD <= '1';
            end if;
        
        when "00000" => --EXOR (Rd ? Rd exor Rs)
            if STD_LOGIC_VECTOR(OPCODE(1 downto 0)) = "10" then
                RF_WR <= '1';
                ALU_SEL <= "0111";
                ALU_OPY_SEL <= '1';
            end if;
            
        when "10010" => --EXOR (Rd ? Rd exor immed)
            RF_WR <= '1';
            ALU_SEL <= "0111";
                
        when "11001" => --IN
            RF_WR <= '1';
            RF_WR_SEL <= "11";
            
        when "00010" => --MOV(Rd ? Rs)
            if STD_LOGIC_VECTOR(OPCODE(1 downto 0)) = "01" then
                ALU_SEL <= "1110";
                ALU_OPY_SEL <= '1';
            end if;
            
        when "11011" => --MOV(Rd ? immed)
            RF_WR <= '1';
            ALU_SEL <= "1110";
        
        when "11010" => --OUT
            IO_STRB <= '1';
            
        when others => --anything else
            RF_WR <= '0';

    end case;
    end case;
end process;

end Behavioral;
