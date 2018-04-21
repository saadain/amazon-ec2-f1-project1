library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;  

entity databus is
  port(
    Iblocksent,CacheMiss: out std_logic;
    clk, Iflag, DWflag, DRflag: in std_logic;
    pcout:in std_logic_vector(31 downto 0);
    instr_address:out std_logic_vector(31 downto 0);
    data_address:out std_logic_vector(31 downto 0);
    Iblock_to_cache:out std_logic_vector(127 downto 0);
    Iblock_from_mem:in std_logic_vector(127 downto 0);
    ALUresult:in std_logic_vector(31 downto 0);
    Dblock_from_mem: in std_logic_vector(127 downto 0);
    Dblock_to_cache: out std_logic_vector(127 downto 0);
    Dword_from_CPU: in std_logic_vector(31 downto 0);
    Dword_to_mem: out std_logic_vector(31 downto 0)
  
);

end entity;

architecture behave of databus is
  
  begin
    
    
    process
      begin
          wait until Iflag ='0';-- send instruction address to memory
            
            instr_address <= pcout;
             
       end process;
       
       process(Iblock_from_mem) -- bring instruction block from memory to cache
         begin
           Iblock_to_cache <= 	Iblock_from_mem;
            Iblocksent <= '1','0' after 21 ns;
         end process;
       
  process(clk, pcout, ALUresult, DWflag, DRflag, Dblock_from_mem, Iblock_from_mem)
    begin
      
      if (rising_edge(clk)) then        
        if (DRflag /= '1') then-- Read miss bring data block from memory
          Dblock_to_cache <=  Dblock_from_mem;
          data_address <= ALUresult;
        end if;
      end if;
      end process;
      
      
    process
      begin
      
      if(rising_edge(clk)) then
        if (DWflag = '1') then
          CacheMiss <= '0';
          Dword_to_mem <= Dword_from_CPU;
          data_address <= ALUresult;
        else      --Write miss. Write in memory then bring updated block to cache
          CacheMiss <= '1';
          Dword_to_mem <= Dword_from_CPU;
          data_address <= ALUresult;
          end if;
         end if;
         
        if(rising_edge(clk)) then
          Dblock_to_cache <=  Dblock_from_mem;  
        end if;
    end process;
 
end behave;

