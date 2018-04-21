library ieee;
use ieee.std_logic_1164.all;

entity mux3 is
   port (
      MemtoReg: in std_logic;
      ALUOut,readdata: in std_logic_vector(31 downto 0);
      writedata: out std_logic_vector(31 downto 0)
   );
end mux3;

architecture behave of mux3 is

begin
   process(memtoreg, ALUOut,readdata) -- Write back from memory or from ALU
   begin
     if ( memtoreg = '1') then
       writedata<=readdata;
     else
       writedata<=ALUOut;
     end if;
   end process;
end behave;
