library ieee;
use ieee.std_logic_1164.all;

entity TestBench is
end TestBench;
 
architecture test of TestBench is 

component CPU_cache_Mem is
  port(
    clk, rst: in std_logic;
    Carry: out std_logic
  );
end component;

component CPUBlock is
  port(
    instr_fetch, loaddata : in std_logic_vector(31 downto 0);
    clk, rst: in std_logic;
    ALUresult: out std_logic_vector(31 downto 0);
    pcout: inout std_logic_vector(31 downto 0);
    data_CPUtoM: out std_logic_vector(31 downto 0);
    Carry: out std_logic
  );
end component;

   signal clk, rst, Carry, enable : std_logic;
 
     
begin
 
  process
   begin
    rst<='1'; 
    wait for 11 ns; 
    rst<='0';
    wait;
  end process;
  
  process
   begin
     While(true) loop
      clk <= '0';
      wait for 10 ns;
      clk <= '1';
      wait for 10 ns;
    end loop;
  end process;
Test1: CPU_Cache_mem port map(clk, rst, Carry);
end test;

