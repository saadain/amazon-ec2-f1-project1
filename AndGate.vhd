library ieee;
use ieee.std_logic_1164.all;

entity AndGate is
  port(
    Branch, BranchCondition: in std_logic;
    BranchResult: out std_logic
  );
end entity;

architecture behave of AndGate is
begin
  process(Branch, BranchCondition)-- Determine if branch has to be taken or not
    begin
      BranchResult<= Branch and BranchCondition ;
  end process;
end behave;
