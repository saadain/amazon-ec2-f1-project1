library ieee;
use ieee.std_logic_1164.all;

entity mux2 is
   port (
      readdata2,signExOut: in std_logic_vector(31 downto 0);
      ALUSrc: in std_logic;
      mux2out: out std_logic_vector(31 downto 0)
   );
end mux2;

architecture behave of mux2 is
begin
   process (ALUSrc, readdata2, signExOut)
   begin
      if(ALUSrc= '0')then--selection between immediate and rt for ALU operations
      mux2out <= readdata2;
    else
      mux2out<=signExOut;
    end if;
   end process;
   
   
end behave;





