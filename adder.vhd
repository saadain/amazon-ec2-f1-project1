
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity adder is
   port (
     rst: std_logic;
      address: in std_logic_vector(31 downto 0);
      nextaddress: out std_logic_vector(31 downto 0)
   );
end adder;

architecture behave of adder is
begin
    
   process (rst, address)
   begin

      nextaddress <= address + "00000000000000000000000000000100";

   end process;
   
   
end behave;


