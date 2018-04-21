
library ieee;
use ieee.std_logic_1164.all;

entity CPU_cache_Mem is
  port(
    clk, rst: in std_logic;
    Carry: out std_logic
  );
end CPU_cache_Mem;
--Structural model of CPU, Cache, Bus and Memory
architecture structure of CPU_cache_Mem is
  
component CPUBlock is
  port(
    instr_fetch, loaddata: in std_logic_vector(31 downto 0);
    clk, rst,StoreComplete: in std_logic; 
    memRead, memWrite: inout std_logic;
    ALUresult: out std_logic_vector(31 downto 0);
    pcout: out std_logic_vector(31 downto 0);
    readdata2: inout std_logic_vector(31 downto 0);
    Carry, MemtoReg: out std_logic
  );
end component;

component Cache is
  port (
    Iblocksent: in std_logic;
   clk, rst: in std_logic;
 --  StoreComplete: out std_logic; 
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
end component;


component memory is
  port(
    clk, memWrite, memRead,CacheMiss: in std_logic;
    instr_address: in std_logic_vector(31 downto 0);
    data_address: in std_logic_vector(31 downto 0);
    Iblock_to_cache: out std_logic_vector(127 downto 0);
    Dblock_to_cache: out std_logic_vector(127 downto 0);
    Dword_from_CPU: in std_logic_vector(31 downto 0)
  
);

end component;

component databus is
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

end component;

component mux3 is
   port (
      MemtoReg: in std_logic;
      ALUOut,readdata: in std_logic_vector(31 downto 0);
      writedata: out std_logic_vector(31 downto 0)
   );
 end component;

signal memRead, memWrite, DRflag, DWflag, Iflag, StoreComplete, MemtoReg, Iblocksent,CacheMiss: std_logic;
signal instr_CtoCPU, ALUresult, data_CtoCPU, readdata2, pcout, write_to_reg: std_logic_vector(31 downto 0);
--signal data_from_CPU: std_logic_vector(31 downto 0);
signal instr_addrBtoM, data_addrBtoM, Dword_BtoM: std_logic_vector(31 downto 0);
signal Iblock_BtoC,Iblock_MtoB, Dblock_MtoB, DblockBtoC : std_logic_vector(127 downto 0);

begin

CPU: CPUBlock port map(instr_CtoCPU, write_to_reg, clk, rst, StoreComplete, memRead, memWrite, ALUresult, pcout, readdata2, Carry,MemtoReg);
CAC: Cache port map(Iblocksent,clk, rst, memRead, memWrite, DWflag, DRflag, Iflag,StoreComplete, pcout, ALUresult, Iblock_BtoC,readdata2, DblockBtoC, instr_CtoCPU, data_CtoCPU);
MEM: memory port map(clk, memWrite, memRead,CacheMiss, instr_addrBtoM, data_addrBtoM, Iblock_MtoB, Dblock_MtoB, Dword_BtoM);
BSS: databus port map(Iblocksent,CacheMiss,clk, Iflag, DWflag, DRflag, pcout, instr_addrBtoM, data_addrBtoM, Iblock_BtoC, Iblock_MtoB, ALUresult, Dblock_MtoB, DblockBtoC, readdata2, Dword_BtoM );
Block15: mux3 port map(MemtoReg, ALUresult, data_CtoCPU, write_to_reg);
end structure;


