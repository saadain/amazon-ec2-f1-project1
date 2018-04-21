library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;  

entity registers is
  port (
   clk,rst: in std_logic;
   RegisterWriteComplete: out std_logic;
   regWrite: in std_logic;
   writeReg: in std_logic_vector(4 downto 0);
   loaddata: in std_logic_vector(31 downto 0);
   readreg1, readreg2: in std_logic_vector(4 downto 0);
   readdata1, readdata2: out std_logic_vector(31 downto 0)
  );
end registers;

architecture behave of registers is
type reg is array (0 to 31) of std_logic_vector(31 downto 0);
signal regArray : reg;
begin
  
 process(clk,rst)
 begin
 if( rst='1') then
  for z in 0 to 31 loop --if rst is 1 empty the registers
   regArray(z) <= x"00000000";
 end loop;
 end if;
 
 regArray(18) <= x"00000004"; -- value in $s2 for lw $t1, 100($s2)
 
 regArray(15) <= x"FFFFFFFF"; -- arbitrary value in $t7 for SW $T7, 300($S2)
 
 regArray(20) <= x"00000258"; -- arbitrary value in $s4 for add $t2, $s4, $t4
 regArray(12) <= x"00000190"; -- arbitrary value in $t4 for add $t2, $s4, $t4
 
 regArray(22) <= x"FFFFFFFF"; -- arbitrary value in $s6 for beq $s6, $s1, 300
 regArray(17) <= x"00000000"; -- arbitrary value in $s1 for beq $s6, $s1, 300
 
 regArray(13) <= x"000001F4"; -- arbitrary value in $t5 for xori $s3, $t5, 200
 
 regArray(23) <= x"000000C8"; -- arbitrary value in $s7 for addi $t9, $s7,500
 
 regArray(8) <= x"00000010"; -- arbitrary value in $s7 for jr $t0
 
 
  if(rising_edge(clk) and regWrite = '1') then --Write data to register
    regArray(to_integer(unsigned(writeReg))) <= loaddata;
  end if;
 end process;
 

 process begin --Register Write instructions complete flag
   
   wait on regarray;
   if (regWrite = '1'
       and regArray(to_integer(unsigned(writeReg))) = loaddata 
       and regArray(to_integer(unsigned(writeReg))) /= "UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU") then
    
    RegisterWriteComplete <= '1';
    wait for 21 ns;
    RegisterWriteComplete <= '0';
    wait for 50 ns;
   end if;
end process;
 readdata1<= regArray(to_integer(unsigned(readreg1)));
 readdata2 <= regArray(to_integer(unsigned(readreg2))); 
       
end behave;

