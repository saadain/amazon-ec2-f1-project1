
library ieee;
use ieee.std_logic_1164.all;

entity mux4 is
   port (
      OutAddress: in std_logic_vector( 31 downto 0);
      nextaddress: in std_logic_vector(31 downto 0);
      mux4out: out std_logic_vector(31 downto 0);
      BranchResult, Branch: in std_logic;
      BranchInstrComplete: out std_logic
   );
end mux4;

architecture behave of mux4 is
begin
   process (BranchResult,nextaddress)
   begin
     
     If BranchResult = '1' then --if branch condition true then go to branch address
      mux4out <= OutAddress;
    else
      mux4out <= nextaddress; --if branch condition false then go to next PC
    end if;
   end process;
   
   process --Branch Instruction Complete flag
     begin
       wait on BranchResult;
       if (Branch = '1') then
         if(BranchResult = '1') then
          BranchInstrComplete <= '1';
          wait for 41 ns;
          BranchInstrComplete <= '0';
        else if(BranchResult = '0') then
          BranchInstrComplete <= '1';
          wait for 31 ns;
          BranchInstrComplete <= '0';
        end if;
        end if;
    end if;
  end process;
end behave;


