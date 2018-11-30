library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
 
entity Peripheral_1 is
   Port ( CLK : in STD_LOGIC;
          SW : in STD_LOGIC_VECTOR (7 downto 0);
          freq : out STD_LOGIC);
end Peripheral_1;
 
architecture Behavioral of Peripheral_1 is
   signal output : std_logic := '1';
   signal counter : integer := 0;
 
begin
  
process (CLK) begin
    if rising_edge(CLK) then --Basys 3 Board internal clock runs at 100MHz
       
    case (SW) is
        when "00000001" => --When Switches flipped equal 1 in binart
            counter <= counter + 1; --counter will increment
            if counter >= 47778 then --if the counter reaches 47778 clock pulses (.00047 s)
               output <= not output; --output signal will flip high to low or low to high
               counter <= 0; --counter will reset
            end if;
           
        when "00000010" => --Same as above except signal will equal new frequency
            counter <= counter + 1;
            if counter >= 45097 then
               output <= not output;
               counter <= 0;
            end if;
               
 
        when "00000011" =>    
            counter <= counter + 1;
            if counter >= 42566 then
               output <= not output;
               counter <= 0;
            end if;
               
        when "00000100" =>
            counter <= counter + 1;
            if counter >= 40177 then
               output <= not output;
               counter <= 0;
            end if;            
       
        when "00000101" =>     
            counter <= counter + 1;
            if counter >= 37922 then
               output <= not output;
               counter <= 0;
            end if;
       
        when "00000110" =>   
            counter <= counter + 1;
            if counter >= 35793 then
               output <= not output;
               counter <= 0;
            end if;
       
        when "00000111" =>     
            counter <= counter + 1;
            if counter >= 33784 then
               output <= not output;
               counter <= 0;
            end if;
 
        when "00001000" =>                 
            counter <= counter + 1;
            if counter >= 31888 then
               output <= not output;
               counter <= 0;
            end if;
       
        when "00001001" =>  
            counter <= counter + 1;
            if counter >= 30098 then
               output <= not output;
               counter <= 0;
            end if;
 
        when "00001010" =>                 
            counter <= counter + 1;
            if counter >= 28409 then
               output <= not output;
               counter <= 0;
            end if;
       
        when "00001011" =>   
            counter <= counter + 1;
            if counter >= 26815 then
               output <= not output;
               counter <= 0;
            end if;
 
        when "00001100" =>                  
            counter <= counter + 1;
            if counter >= 25310 then
               output <= not output;
               counter <= 0;
            end if;
       
        when "00001101" =>  
            counter <= counter + 1;
            if counter >= 23889 then
               output <= not output;
               counter <= 0;
            end if;

        when "00001110" =>               
            counter <= counter + 1;
            if counter >= 22548 then
               output <= not output;
               counter <= 0;
            end if;
       
        when "00001111" =>    
            counter <= counter + 1;
            if counter >= 21283 then
               output <= not output;
               counter <= 0;
            end if;
 
        when "00010000" =>
            counter <= counter + 1;
            if counter >= 20088 then
               output <= not output;
               counter <= 0;
            end if;
            
        when "00010001" =>
            counter <= counter + 1;
            if counter >= 18961 then
               output <= not output;
               counter <= 0;
            end if;

        when "00010010" =>
            counter <= counter + 1;
            if counter >= 17897 then
               output <= not output;
               counter <= 0;
            end if;

        when "00010011" =>
            counter <= counter + 1;
            if counter >= 16892 then
               output <= not output;
               counter <= 0;
            end if;

        when "00010100" =>
            counter <= counter + 1;
            if counter >= 15944 then
               output <= not output;
               counter <= 0;
            end if;
            
        when "00010101" =>
            counter <= counter + 1;
            if counter >= 15049 then
               output <= not output;
               counter <= 0;
            end if;
                
        when "00010110" =>
            counter <= counter + 1;
            if counter >= 14205 then
               output <= not output;
               counter <= 0;
            end if;
         
        when "00010111" =>
            counter <= counter + 1;
            if counter >= 13407 then
               output <= not output;
               counter <= 0;
            end if;

        when "00011000" =>
            counter <= counter + 1;
            if counter >= 12655 then
               output <= not output;
               counter <= 0;
            end if;

        when "00011001" =>
            counter <= counter + 1;
            if counter >= 11945 then
               output <= not output;
               counter <= 0;
            end if;
        when "00011010" =>
            counter <= counter + 1;
            if counter >= 11274 then
               output <= not output;
               counter <= 0;
            end if;
            
        when "00011011" =>
            counter <= counter + 1;
            if counter >= 10641 then
               output <= not output;
               counter <= 0;
            end if;
            
        when "00011100" =>
            counter <= counter + 1;
            if counter >= 10044 then
               output <= not output;
               counter <= 0;
            end if;
            
        when "00011101" =>
            counter <= counter + 1;
            if counter >= 9480 then
               output <= not output;
               counter <= 0;
            end if;
            
        when "00011110" =>
            counter <= counter + 1;
            if counter >= 8948 then
               output <= not output;
               counter <= 0;
            end if;
            
        when "00011111" =>
            counter <= counter + 1;
            if counter >= 8446 then
               output <= not output;
               counter <= 0;
            end if;
            
        when "00100000" =>
            counter <= counter + 1;
            if counter >= 7972 then
               output <= not output;
               counter <= 0;
            end if;
            
        when "00100001" =>
            counter <= counter + 1;
            if counter >= 7525 then
               output <= not output;
               counter <= 0;
            end if;
        
        when "00100010" =>
            counter <= counter + 1;
            if counter >= 7102 then
               output <= not output;
               counter <= 0;
            end if;
                            
        when "00100011" =>
            counter <= counter + 1;
            if counter >= 6704 then
               output <= not output;
               counter <= 0;
            end if;

        when "00100100" =>
            counter <= counter + 1;
            if counter >= 6327 then
               output <= not output;
               counter <= 0;
            end if;

        when others => 
            output <= '0';
 
    end case;
    end if; --for rising edge clock
 
freq <= output; --freq is set to the output signal used above
end process; --ends process
   
end Behavioral;
