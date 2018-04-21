library ieee;
use ieee.std_logic_1164.all;


entity signextend is
   port (
      instruction: in std_logic_vector(15 downto 0);
      signextend: out std_logic_vector(31 downto 0)
   );
end signextend;

architecture behave of signextend is
begin
   process (instruction)
   begin
      if (instruction(15) = '1') then
         signextend(31 downto 16) <= "1111111111111111";-- negative integer
         signextend(15 downto 0) <= instruction(15 downto 0);
      else
         signextend(31 downto 16) <= "0000000000000000";-- positive integer
         signextend(15 downto 0) <= instruction(15 downto 0);
      end if;
   end process;
   
   
end behave;



