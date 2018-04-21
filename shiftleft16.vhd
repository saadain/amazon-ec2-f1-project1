library ieee;
use ieee.std_logic_1164.all;

entity shiftleft16 is
  port(
        immediate: in std_logic_vector(15 downto 0);
        shiftleft16: out std_logic_vector(31 downto 0)
      );
end entity;

architecture behave of shiftleft16 is
begin
  process (immediate) -- Shiftleft process for LUI instruction
  begin
        shiftleft16 <= immediate & "0000000000000000";
  end process;
end behave;

