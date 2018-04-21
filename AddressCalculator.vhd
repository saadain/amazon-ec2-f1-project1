

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity AddressCalculator is
   port (
      nextaddress: in std_logic_vector( 31 downto 0);
      JumpImmediate: in std_logic_vector(31 downto 0);
      Outaddress: out std_logic_vector(31 downto 0)
   );
end AddressCalculator;

architecture behave of AddressCalculator is
begin
   process (nextaddress,JumpImmediate) --Calculating new PC value for branch instruction
     begin
     OutAddress<=  (JumpImmediate(29 downto 0) & "00")+ nextaddress;
   end process;
end behave;



