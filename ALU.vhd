library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity ALU is
   port (
      clk: in std_logic;
      readdata1, mux2out: in std_logic_vector(31 downto 0);
      ALUControlOut: in std_logic_vector(3 downto 0);
      ALUresult: out std_logic_vector(31 downto 0);
      carry, BranchCondition: out std_logic;
      
      opcode: in std_logic_vector(5 downto 0)
   );
end ALU;

architecture behave of ALU is
   signal sum : std_logic_vector(32 downto 0);
begin
   process (clk)
   begin
     if(rising_edge(clk)) then
      if (opcode = "001101")then --XOR
          ALUresult <= readdata1 xor mux2out;
        
      else
      case ALUControlOut is
         when "0010" => --ADD LW SW 
            sum <= ("0" &(readdata1 + mux2out));
            ALUresult<=sum(31 downto 0);
            carry<=sum(32);
         when "0110" => --beq
            If ((readdata1 - mux2out) = x"00000000") then
              BranchCondition<= '1';
            else
              BranchCondition<='0';
            end if;
         when others =>
            ALUresult <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
      end case;
    end if;
    end if;
   end process;   
   
end behave;
