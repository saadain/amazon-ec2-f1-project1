
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity ShiftLeft is
   port (
      nextaddress: in std_logic_vector( 31 downto 0);
      JumpAddress: in std_logic_vector(25 downto 0);
      shiftleftaddress: out std_logic_vector( 31 downto 0)
   );
end ShiftLeft;

architecture behave of ShiftLeft is
begin
   process(JumpAddress)
   begin
      shiftleftaddress <= (JumpAddress & "00") + nextaddress;
   end process;   
end behave;
