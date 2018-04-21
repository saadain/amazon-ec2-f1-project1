library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity instructionregister is
  port (
    clk, rst : in std_logic;
    instr_fetch : in std_logic_vector(31 downto 0);
    instruction: out std_logic_vector(31 downto 0) );

end instructionregister;

architecture behave of instructionregister is
begin
  process(clk, rst)
  begin
    if rst = '1' then
    instruction <= (others => 'X'); -- no instruction when rst is 1
    elsif rising_edge(clk) then
    instruction <= instr_fetch; -- send out instruction received from cache
    end if;
  end process;
end behave;
