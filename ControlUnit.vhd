library ieee;
use ieee.std_logic_1164.all;

entity ControlUnit is
   port (
      instruction: in std_logic_vector(31 downto 26);
      RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch: out std_logic;
      Jump: out std_logic_vector(1 downto 0);
      LUICtr: out std_logic;
      ALUOp: out std_logic_vector(1 downto 0)
   );
end ControlUnit;

architecture behave of ControlUnit is
   signal controlout : std_logic_vector(11 downto 0);
begin
   process (instruction)
   begin
      case instruction is
         when "100011" => --LW
            controlout <= "011110000000";
         when "101011" => --SW
            controlout <= "X1X001000000";
         when "000000" => --add
            controlout <= "100100000100";
         when "000100" => --beq
            controlout <= "X0X000100010";
         when "001101" => --xori
            controlout <= "010100000110";
         when "000010" => --J
            controlout <= "XXX000001000";
         when "001000" => --addi
            controlout <= "010100000000";
         when "001111" => --lui
            controlout <= "000100000001";
         when "000001" => --jr
            controlout <= "XXX000010XXX";
         when others =>
            controlout <= "XXXXXXXXXXXX";
      end case;
         
   end process;
   --Signals from conrol unit
   RegDst <= controlout(11);
   ALUSrc <= controlout(10);
   MemtoReg <= controlout(9);
   RegWrite <= controlout(8);
   MemRead <= controlout(7);
   MemWrite <= controlout(6);
   Branch <= controlout(5);
   Jump <= controlout(4 downto 3);
   ALUOp <= controlout(2 downto 1);
   LUICtr <=controlout(0);

   
end behave;





