library ieee;
use ieee.std_logic_1164.all;

entity pc is
   port (
      inaddress: in std_logic_vector(31 downto 0);
      clk, rst: in std_logic;
      RegisterWriteComplete, StoreComplete, BranchInstrComplete, JumpInstrComplete: in std_logic;
      outaddress: out std_logic_vector(31 downto 0)
   );
end pc;

architecture behave of pc is

begin
 process(clk)
   
   begin
    if (rising_edge(clk)) then
         if (rst = '1') then
            outaddress <= "00000000000000000000000000000000";
         else if (RegisterWriteComplete = '1' --All the instruction Complete flags
                  or StoreComplete = '1'
                  or BranchInstrComplete = '1'
                  or JumpInstrComplete = '1') then
            outaddress <= inaddress;
         end if;
       end if;
     end if;

    end process;

   
   
end behave;



