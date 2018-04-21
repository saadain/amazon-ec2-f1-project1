library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;  

entity Cache is
  port (
    Iblocksent: in std_logic;
   clk, rst: in std_logic;
--   enable: out std_logic;
   memRead, memWrite: in std_logic;
   DWflag, DRflag, Iflag, StoreComplete: out std_logic;
   pcout: in std_logic_vector(31 downto 0);
   ALUresult: in std_logic_vector(31 downto 0);
   instr_in: in std_logic_vector(127 downto 0);
   data_from_CPU: in std_Logic_vector(31 downto 0);
   data_from_mem: in std_logic_vector(127 downto 0);
   instr_out: out std_logic_vector(31 downto 0);
   data_to_CPU: out std_logic_vector(31 downto 0)
  );
   
end Cache;


--write through write allocate strategy
architecture behave of Cache is

type instrcache is array (0 to 64) of std_logic_vector(7 downto 0);
signal Icache : instrcache;
type datacache is array (0 to 64) of std_logic_vector(7 downto 0);
signal Dcache : datacache;
shared variable DataWordAddr: integer;

begin
  
  
  
  process(clk, rst, pcout,instr_in)
    
variable InstrBlockAddr: integer;
variable InstrWordAddr: integer;
    begin
      if(rst='1') then
        for z in 0 to 63 loop
   Icache(z) <= "XXXXXXXX";
  end loop;
end if;
      if(rising_edge(clk)) then
     InstrBlockAddr := to_integer(unsigned(pcout));
     InstrBlockAddr := (InstrBlockAddr - (InstrBlockAddr mod 16)); --Mem block address
    
     --Calculate direct mapped block and word address on cache
     InstrWordAddr := (InstrBlockAddr mod 256) + (to_integer(unsigned(pcout)) - InstrBlockAddr); 
     
     if (Icache(InstrWordAddr)/="XXXXXXXX") then --Instruction HIT
      Iflag<= '1';    --Send instruction to CPU IR
      instr_out(31 downto 24) <= Icache(InstrWordAddr);
      instr_out(23 downto 16) <= Icache(InstrWordAddr+1);
      instr_out(15 downto 8) <= Icache(InstrWordAddr+2);
      instr_out(7 downto 0) <= Icache(InstrWordAddr+3);
      
     else         	 	 	   	                               --Instruction MISS
       Iflag<= '0';
       if (Iblocksent = '1') then
       for i in 0 to 15 loop     --Bring block to cache from mem
         Icache(InstrBlockAddr + i) <= instr_in(((16-i)*8-1) downto ((16-i)*8-8));
       end loop;
     end if;
       
       instr_out(31 downto 24) <= Icache(InstrWordAddr);
       instr_out(23 downto 16) <= Icache(InstrWordAddr+1);
       instr_out(15 downto 8) <= Icache(InstrWordAddr+2);
       instr_out(7 downto 0) <= Icache(InstrWordAddr+3);
     end if;
   end if;
    end process;
 
 process(clk,rst, ALUresult, data_from_CPU, data_from_mem) 
   variable MDataBlockAddr: integer;
variable CDataBlockAddr: integer;
variable storedword: std_logic_vector(31 downto 0);

 begin
   DWflag<= '0';
 if(rst='1') then

  for z in 0 to 63 loop
   Dcache(z) <= "XXXXXXXX";
  end loop;
end if;
 
if(rising_edge(clk)) then
--Dcache read hit and miss
   if(memRead='1') then
      -- Calculate data block address of memory
     MDataBlockAddr := to_integer(unsigned(ALUresult));
     MDataBlockAddr := (MDataBlockAddr - (MDataBlockAddr mod 16)); --Mem block address
    
     --Calculate direct mapped block and word address on cache
     DataWordAddr := (MDataBlockAddr mod 256) + (to_integer(unsigned(ALUresult)) - MDataBlockAddr);  -- word address
    
    if( Dcache(DataWordAddr)/="XXXXXXXX") then --Data Read HIT
      DRflag<= '1','0' after 21 ns; -- Load word to CPU Reg
      data_to_CPU(31 downto 24) <= Dcache(DataWordAddr);
      data_to_CPU(23 downto 16) <= Dcache(DataWordAddr+1);
      data_to_CPU(15 downto 8) <= Dcache(DataWordAddr+2);
      data_to_CPU(7 downto 0) <= Dcache(DataWordAddr+3);
      
    else
       DRflag<= '0'; -- data Read Miss
        
       for i in 0 to 15 loop --Bring data block from mem
          Dcache(MDataBlockAddr + i ) <= data_from_mem((16-i)*8-1 downto (16-i)*8-8);
       end loop;
       
       --read word from Cache
       data_to_CPU(31 downto 24) <= Dcache(DataWordAddr);
       data_to_CPU(23 downto 16) <= Dcache(DataWordAddr+1);
       data_to_CPU(15 downto 8) <= Dcache(DataWordAddr+2);
       data_to_CPU(7 downto 0) <= Dcache(DataWordAddr+3);
   end if;
  end if;



  
--Dcache Write hit and miss

   if(memWrite='1') then   
    -- Calculate data block address of memory
     MDataBlockAddr := to_integer(unsigned(ALUresult));
     MDataBlockAddr := (MDataBlockAddr - (MDataBlockAddr mod 16)); --Mem block address
    
     --Calculate direct mapped block and word address on cache
     DataWordAddr := (MDataBlockAddr mod 256) + (to_integer(unsigned(ALUresult)) - MDataBlockAddr);  -- word address

    if( (Dcache(DataWordAddr) - data_from_CPU(31 downto 24)) /= "00000000") then --Data write MISS
      DWflag<= '0';
      CDataBlockAddr := DataWordAddr - (DataWordAddr mod 16);
    for i in 0 to 15 loop --Update block in cache after write miss
       Dcache(CDataBlockAddr + i) <= data_from_mem((16-i)*8-1 downto (16-i)*8-8);
    end loop;      
    else
      DWflag<= '1';                 	 	 	                     --Data write HIT 
   end if;
  end if;
  
   end if;
end process;



Process(Dcache)--StoreComplete flag
  begin
        if (memWrite = '1' and Dcache(DataWordAddr) = data_from_CPU(31 downto 24)) then
    StoreComplete <= '1','0' after 21 ns;
   end if;
 end process;
end behave;



