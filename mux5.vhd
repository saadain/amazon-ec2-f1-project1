
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity mux5 is
   port (
     JumpInstrComplete: out std_logic;
      mux4out: in std_logic_vector( 31 downto 0);
      shiftleftaddress: in std_logic_vector(31 downto 0);
      readdata1: in std_logic_vector(31 downto 0);
      finaladdress: out std_logic_vector(31 downto 0);
      Jump: in std_logic_vector(1 downto 0)
   );
end mux5;

architecture behave of mux5 is
begin
    
   process (Jump,shiftleftaddress,mux4out,readdata1)
   begin
     case Jump is
      when "00" => --If jump condition false go to next PC
        finaladdress <= mux4out;
      when "01" => --If j condition true go to jump address
        finaladdress <= shiftleftaddress;
      when "10" => --If jr condition true go to jr address
        finaladdress <= readdata1;
      when others => --In all other cases go to next PC
        finaladdress <= mux4out;
      end case;
   end process;
   
   process(Jump) --Jump instruction Complete flag
     begin
       if(Jump = "01" or Jump = "10") then
      JumpInstrComplete <= '1','0' after 21 ns;
    end if;
  end process;
end behave;




