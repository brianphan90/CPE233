library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;


entity ALU is
    Port ( A : in STD_LOGIC_VECTOR (7 downto 0);
           B : in STD_LOGIC_VECTOR (7 downto 0);
           C_IN : in STD_LOGIC;
           SEL : in STD_LOGIC_VECTOR (3 downto 0);
           SUM : out STD_LOGIC_VECTOR (7 downto 0);
           C_FLAG : out STD_LOGIC;
           Z_FLAG : out STD_LOGIC);
end ALU;

architecture Behavioral of ALU is

    signal uA, uB : unsigned (8 downto 0); -- 9 bits wide for the ADDC and SUBC instructions

begin

    uA <= '0' & unsigned(A);
    uB <= '0' & unsigned(B);

process (SEL, uA, uB)

    variable uSUM : unsigned (8 downto 0); -- 9 bits for C_in for ADDC, SUBC instructions

begin
    case (SEL) is
        when "0000" => --ADD
            uSUM := (uA + uB);
            SUM <= std_logic_vector(uSUM(7 downto 0));
            C_FLAG <= std_logic(uSUM(8));
            if std_logic_vector(uSUM(7 downto 0)) = "00000000" then
                Z_FLAG <= '1';
            else 
                Z_FLAG <= '0';
            end if;
        
        when "0001" => --ADDC
            if C_IN = '1' then
                uSUM := (uA + uB + 1);
            else
                uSUM := (uA +uB);
            end if;
            SUM <= std_logic_vector(uSUM(7 downto 0));
            C_FLAG <= std_logic(uSUM(8));
            if std_logic_vector(uSUM(7 downto 0)) = "00000000" then
                Z_FLAG <= '1';
            else 
                Z_FLAG <= '0';
            end if;
            
        when "0010" => --SUB
            uSUM := (uA - uB);
            SUM <= std_logic_vector(uSUM(7 downto 0));
            C_FLAG <= std_logic(uSUM(8));
            if std_logic_vector(uSUM(7 downto 0)) = "00000000" then
                Z_FLAG <= '1';
            else 
                Z_FLAG <= '0';
            end if;
            
        when "0011" => --SUBC
            if C_IN = '1' then  
                uSUM := (uA - uB - 1);
            else
                uSUM := (uA - uB);
            end if;
            SUM <= std_logic_vector(uSUM(7 downto 0));
            C_FLAG <= std_logic(uSUM(8));
            if std_logic_vector(uSUM(7 downto 0)) = "00000000" then
                Z_FLAG <= '1';
            else 
                Z_FLAG <= '0';
            end if;
            
        when "0100" => --CMP
            uSUM := (uA - uB);
            C_FLAG <= std_logic(uSUM(8));
            if std_logic_vector(uSUM(7 downto 0)) = "00000000" then
                Z_FLAG <= '1';
            else 
                Z_FLAG <= '0';
            end if;

        when "0101" => --AND
            C_FLAG <= '0';
            SUM <= A and B;
            if (A and B) = "00000000" then
                Z_FLAG <= '1';
            else 
                Z_FLAG <= '0';
            end if;
            
        when "0110" => --OR
            C_FLAG <= '0';
            SUM <= A or B;
            if (A or B) = "00000000" then
                Z_FLAG <= '1';
            else 
                Z_FLAG <= '0';
            end if;
            
        when "0111" => --EXOR
            C_FLAG <= '0';
            SUM <= A xor B;
            if (A xor B) = "00000000" then
                Z_FLAG <= '1';
            else 
                Z_FLAG <= '0';
            end if;
        
        when "1000" => --TEST
            C_FLAG <= '0';
            if (A and B) = "00000000" then
                Z_FLAG <= '1';
            else 
                Z_FLAG <= '0';
            end if;
        
        when "1001" => --LSL
            C_FLAG <= A(7);
            SUM <= A(6 downto 0) & C_IN;
            if (A(6 downto 0) & C_IN) = "00000000" then
                Z_FLAG <= '1';
            else 
                Z_FLAG <= '0';
            end if;

        when "1010" => --LSR
            C_FLAG <= A(0);
            SUM <= C_IN & A(7 downto 1);
            if (C_IN & A(7 downto 1)) = "00000000" then
                Z_FLAG <= '1';
            else 
                Z_FLAG <= '0';
            end if;
        
        when "1011" => --ROL
            C_FLAG <= A(7);
            SUM <= A(6 downto 0) & A(7); 
            if (A(6 downto 0) & A(7)) = "00000000" then
                Z_FLAG <= '1';
            else 
                Z_FLAG <= '0';
            end if;    

        when "1100" => --ROR
            C_FLAG <= A(0);
            SUM <= A(0) & A(7 downto 1);
            if (A(0) & A(7 downto 1)) = "00000000" then
                Z_FLAG <= '1';
            else 
                Z_FLAG <= '0';
            end if; 
        
        when "1101" => --ASR
            C_FLAG <= A(0);
            SUM <= A(7) & A(7 downto 1);
            if (A(7) & A(7 downto 1)) = "00000000" then
                Z_FLAG <= '1';
            else 
                Z_FLAG <= '0';
            end if;
                
        when "1110" => --MOV
            SUM <= A;
        
        when others => --unused
            SUM <= (others => '0');
            
    end case;
end process;
end Behavioral;
