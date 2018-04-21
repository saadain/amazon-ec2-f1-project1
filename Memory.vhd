library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;  

entity memory is
  port(
    clk, memWrite, memRead,CacheMiss: in std_logic; 
    instr_address: in std_logic_vector(31 downto 0);
    data_address: in std_logic_vector(31 downto 0);
    Iblock_to_cache: out std_logic_vector(127 downto 0);
    Dblock_to_cache: out std_logic_vector(127 downto 0);
    Dword_from_CPU: in std_logic_vector(31 downto 0)
  
);

end entity;

architecture behave of memory is
  
  type memory is array (0 to 128) of std_logic_vector(7 downto 0);
  signal mem : memory;
  signal StoredIblock: std_logic_vector(127 downto 0);
  signal StoredDblock: std_logic_vector(127 downto 0);  
  begin
    
  process   --Instruction Read process
    variable InstrBlockAddr: integer;
  begin
    --calculate instruction block address
    InstrBlockAddr := to_integer(unsigned(instr_address)); 
    InstrBlockAddr := (InstrBlockAddr - (InstrBlockAddr mod 16));
    
      if(rising_edge(clk)) then--8cycles/block to read from memory
      for i in 0 to 15 loop
            StoredIblock(((16-i)*8-1) downto ((16-i)*8-8))<= mem(InstrBlockAddr + i);
          end loop;
          end if;
          
          if(rising_edge(clk)) then
          Iblock_to_cache<=StoredIblock;
          end if;
  wait on instr_address;
  end process;  

  
    process(clk, memWrite, memRead, instr_address, data_address)--data read and write process
    variable DataBlockReadAddress: integer;
    variable DataBlockMeMAddr: integer;

    
    begin

      mem(0 to 3) <=   ("10001110","01001001","00000000","01100100"); --lw $t1, 100($s2)
      mem(4 to 7) <=   ("10101110","01001111","00000001","00101100"); --sw $t7, 300($s2)
      mem(8 to 11) <=  ("00000010","10001100","01010000","00100000"); --add $t2, $s4, $t4
     
      mem(12 to 15) <= ("00000101","00000000","00000000","00000000"); --jr $t0
      mem(16 to 19) <= ("00110101","10110011","00000000","11001000"); --xori $s3, $t5, 200
      mem(20 to 23) <= ("00100010","11111001","00000001","11110100"); --addi $t9, $s7,500
      mem(24 to 27) <= ("00111100","00010000","00000011","11101000"); --lui $s0, 1000

      mem(28 to 31) <= ("00010010","11010001","00000000","01000011"); --beq $s6, $s1, 300 
      mem(32 to 35) <= ("00001000","00000000","00000000","01000010"); --j300
                                                       
      mem(104 to 107) <= ("11111111","00000000","11111111","00000000"); --arbitrary value for LW


          --calculating data block address
          if(memRead='1' and data_address>= "00000000000000000000000000000000") then
          DataBlockReadAddress := to_integer(unsigned(data_address)); 
          DataBlockReadAddress := (DataBlockReadAddress - (DataBlockReadAddress mod 16));
        end if;
        for i in 0 to 7 loop-- 8cycles/block to read from memory
        if(rising_edge(clk) and memRead='1'and data_address>= "00000000000000000000000000000000") then

            StoredDblock((16-i)*8-1 downto (16-i)*8-8)<= mem(DataBlockReadAddress + i);

            StoredDblock((16-(i+8))*8-1 downto (16-(i+8))*8-8)<= mem(DataBlockReadAddress + (i+8));

        end if;
        end loop;
        Dblock_to_cache<=StoredDblock;
        
          if (memWrite='1') then --Store data to mem
            
            if(rising_edge(clk)) then--3cycles/word to write to memory
              mem(to_integer(unsigned(data_address))) <= Dword_from_CPU(31 downto 24);
            end if;
            if(rising_edge(clk)) then
              mem(to_integer(unsigned(data_address))+1) <= Dword_from_CPU(23 downto 16);
            end if;
            if(rising_edge(clk)) then
             mem(to_integer(unsigned(data_address))+2) <= Dword_from_CPU(15 downto 8);
             mem(to_integer(unsigned(data_address))+3) <= Dword_from_CPU(7 downto 0);
            end if;

            --Write back to cache the updated block
            if(CacheMiss='1') then--write back to cache is write miss
            DataBlockReadAddress := to_integer(unsigned(data_address)); 
          DataBlockReadAddress := (DataBlockReadAddress - (DataBlockReadAddress mod 16));
            
        for i in 0 to 7 loop
        if(rising_edge(clk)) then

            StoredDblock((16-i)*8-1 downto (16-i)*8-8)<= mem(DataBlockReadAddress + i);

            StoredDblock((16-(i+8))*8-1 downto (16-(i+8))*8-8)<= mem(DataBlockReadAddress + (i+8));

        end if;
        end loop;
        Dblock_to_cache<=StoredDblock;
        end if;
      end if;
    end process;
end behave;


