library ieee;
use ieee.std_logic_1164.all;

entity CPUBlock is
  port(
    instr_fetch, loaddata : in std_logic_vector(31 downto 0);
    clk, rst,StoreComplete: in std_logic;
    memRead, memWrite: inout std_logic;
    ALUresult: out std_logic_vector(31 downto 0);
    pcout: out std_logic_vector(31 downto 0);
    readdata2: inout std_logic_vector(31 downto 0);
    Carry,MemtoReg: out std_logic
  );
end CPUBlock;
--Structure code for all the components of CPU
architecture structure of CPUBlock is
  
component pc is
   port (
      inaddress: in std_logic_vector(31 downto 0);
      clk, rst:in std_logic; 
      RegisterWriteComplete, StoreComplete, BranchInstrComplete, JumpInstrComplete: in std_logic;
      outaddress: out std_logic_vector(31 downto 0)
   );
end component;
 
component adder is
   port (
     rst: std_logic;
      address: in std_logic_vector(31 downto 0);
      nextaddress: out std_logic_vector(31 downto 0)
   );
end component;

component instructionregister is
  port (
    clk, rst : in std_logic;
    instr_fetch: in std_logic_vector(31 downto 0);
    instruction: out std_logic_vector(31 downto 0) );
end component;


component ControlUnit is
   port (
      instruction: in std_logic_vector(31 downto 26);
      RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch: out std_logic;
      Jump: out std_logic_vector(1 downto 0);
      LUICtr: out std_logic;
      ALUOp: out std_logic_vector(1 downto 0)
   );
end component;

component mux1 is
   port (
      inst1, inst2: in std_logic_vector(4 downto 0);
      RegDst: in std_logic;
      OutReg: out std_logic_vector(4 downto 0)
   );
end component;

component registers is
  port (
   clk,rst: in std_logic;
   regWrite: in std_logic;
   RegisterWriteComplete: out std_logic;
   writeReg: in std_logic_vector(4 downto 0);
   loaddata: in std_logic_vector(31 downto 0);
   readreg1, readreg2: in std_logic_vector(4 downto 0);
   readdata1, readdata2: out std_logic_vector(31 downto 0)
  );
end component;

component signextend is
   port (
      instruction: in std_logic_vector(15 downto 0);
      signextend: out std_logic_vector(31 downto 0)
   );
end component;

component ALUControl is
  port(
        instruction: in std_logic_vector(5 downto 0);
        ALUOp: in std_logic_vector(1 downto 0);
        ALUControl: out std_logic_vector(3 downto 0)
      );
end component;

component ALU is
   port (
      clk: in std_logic;
      readdata1, mux2out: in std_logic_vector(31 downto 0);
      ALUControlOut: in std_logic_vector(3 downto 0);
      ALUresult: out std_logic_vector(31 downto 0);
      carry, BranchCondition: out std_logic;
      
      opcode: in std_logic_vector(5 downto 0)
   );
end component;

component mux2 is
   port (
      readdata2,signExOut: in std_logic_vector(31 downto 0);
      ALUSrc: in std_logic;
      mux2out: out std_logic_vector(31 downto 0)
   );
end component;

component AddressCalculator is
   port (
      nextaddress: in std_logic_vector( 31 downto 0);
      JumpImmediate: in std_logic_vector(31 downto 0);
      Outaddress: out std_logic_vector(31 downto 0)
   );
 end component;
   
component AndGate is
  port(
    Branch, BranchCondition: in std_logic;
    BranchResult: out std_logic
  );
end component;


component mux4 is
   port (
      OutAddress: in std_logic_vector( 31 downto 0);
      nextaddress: in std_logic_vector(31 downto 0);
      mux4out: out std_logic_vector(31 downto 0);
      BranchResult, Branch: in std_logic;
      BranchInstrComplete: out std_logic
   );
end component;

component mux5 is
   port (
      JumpInstrComplete: out std_logic;
      mux4out: in std_logic_vector( 31 downto 0);
      shiftleftaddress: in std_logic_vector(31 downto 0);
      readdata1: in std_logic_vector(31 downto 0);
      finaladdress: out std_logic_vector(31 downto 0);
      Jump: in std_logic_vector(1 downto 0)
   );
end component;

component ShiftLeft is
   port (
      nextaddress: in std_logic_vector( 31 downto 0);
      JumpAddress: in std_logic_vector(25 downto 0);
      shiftleftaddress: out std_logic_vector( 31 downto 0)

   );
end component;

component shiftleft16 is
  port(
        immediate: in std_logic_vector(15 downto 0);
        shiftleft16: out std_logic_vector(31 downto 0)
      );
end component;

component mux6 is
   port (
      mux3out: in std_logic_vector( 31 downto 0);
      LUI: in std_logic_vector(31 downto 0);
      writetoreg: out std_logic_vector(31 downto 0);
      LUICtr: in std_logic
   );
end component; 

signal adder_to_pc : std_logic_vector(31 downto 0);
signal instr_regW: std_logic_vector(4 downto 0);
signal RegDst, ALUSrc, RegWrite, Branch,BranchInstrComplete: std_logic;
signal Jump: std_logic_vector(1 downto 0);
signal LUICtr, en: std_logic;
signal ALUOp: std_logic_vector(1 downto 0);
signal readdata1,signExOut,writetoreg: std_logic_vector(31 downto 0);
signal instruction,LUI: std_logic_vector(31 downto 0);
signal mux2out: std_logic_vector(31 downto 0);
signal ALUControlOut: std_logic_vector(3 downto 0);
signal nextaddress, Outaddress, mux4out, finaladdress, pcoutput,shiftleftaddress: std_logic_vector(31 downto 0);
signal BranchCondition, BranchResult: std_logic;
signal RegisterWriteComplete, JumpInstrComplete: std_logic;



begin
pcout<= pcoutput;
block1: pc port map(finaladdress, clk, rst,RegisterWriteComplete,StoreComplete,BranchInstrComplete,JumpInstrComplete, pcoutput);
block2: adder port map(rst, pcoutput, nextaddress);
block3: instructionregister port map(clk, rst, instr_fetch, instruction);
block4: ControlUnit port map(instruction(31 downto 26),RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, Jump, LUICtr, ALUOp);
block5: mux1 port map(instruction(20 downto 16), instruction(15 downto 11), RegDst, instr_regW );
block6: registers port map(clk, rst, regWrite, RegisterWriteComplete,instr_regW, writetoreg, instruction(25 downto 21), instruction(20 downto 16), readdata1, readdata2);
block7: signextend port map(instruction(15 downto 0), signExOut);
block8: ALUControl port map(instruction(5 downto 0), ALUOp, ALUControlOut);
block9: ALU port map (clk, readdata1, mux2out, ALUControlOut, ALUresult, carry, BranchCondition, instruction(31 downto 26));
block10: mux2 port map (readdata2,signExOut, ALUSrc,mux2out);
Block11: AndGate port map(branch, BranchCondition, BranchResult);
Block12: AddressCalculator port map(nextaddress, signExOut,Outaddress);
Block13: mux4 port map(Outaddress, nextaddress, mux4out, BranchResult, Branch, BranchInstrComplete);
Block14: mux5 port map(JumpInstrComplete, mux4out, shiftleftaddress, readdata1, finaladdress, Jump);
Block15: ShiftLeft port map( nextaddress, instruction(25 downto 0), shiftleftaddress);
Block16: shiftleft16 port map(instruction(15 downto 0), LUI);
Block17: mux6 port map(loaddata, LUI, writetoreg,LUICtr);

end structure;
