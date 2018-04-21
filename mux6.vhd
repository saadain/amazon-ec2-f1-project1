
library ieee;
use ieee.std_logic_1164.all;

entity mux6 is
   port (
      mux3out: in std_logic_vector( 31 downto 0);
      LUI: in std_logic_vector(31 downto 0);
      writetoreg: out std_logic_vector(31 downto 0);
      LUICtr: in std_logic
   );
end mux6;

architecture behave of mux6 is
begin
   process (LUI, mux3out)--Write back from either mux3 or from shiftleft16
   begin
     If LUICtr = '1' then
      writetoreg <= LUI;
    else
      writetoreg <= mux3out;
    end if;
   end process;
   
   
end behave;




