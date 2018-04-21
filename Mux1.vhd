library ieee;
use ieee.std_logic_1164.all;

entity mux1 is
   port (
      inst1, inst2: in std_logic_vector(4 downto 0);
      RegDst: in std_logic;
      OutReg: out std_logic_vector(4 downto 0)
   );
end mux1;

architecture behave of mux1 is


begin
   process(inst1,inst2,RegDst)
     begin
   if (RegDst = '0') then --selection between rt and rd for write address
      OutReg<=inst1;
   else
      OutReg<=inst2;
   end if;
   end process;
     
end behave;







