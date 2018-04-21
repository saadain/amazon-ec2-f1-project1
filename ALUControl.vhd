library ieee;
use ieee.std_logic_1164.all;

entity ALUControl is
  port(
        instruction: in std_logic_vector(5 downto 0);
        ALUOp: in std_logic_vector(1 downto 0);
        ALUControl: out std_logic_vector(3 downto 0)
      );
end entity;

architecture behave of ALUControl is
begin
process (instruction, ALUOp)
begin
   if (ALUOp = "00") then
      ALUControl <= "0010"; -- LW SW ADDI
   elsif (ALUOp = "01") then  --J type beq
      ALUControl <= "0110";
   elsif (ALUOp(1) = '1') then -- R type ADD
      case instruction is
         when "000000" => 
            ALUControl <= "0010";
         when "100000" => -- ADD     
            ALUControl <= "0010";
         when others =>
            ALUControl <= "XXXX";
      end case;
   end if;
end process;


end behave;




