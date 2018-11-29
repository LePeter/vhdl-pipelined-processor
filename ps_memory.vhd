-- ECE 3056: Architecture, Concurrency and Energy in Computation
-- Sudhakar Yalamanchili
-- Pipelined MIPS Processor VHDL Behavioral Mode--
----
-- data memory component.   
--

Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;


entity  memory is  
port(
-- 
-- inputs
--
     address, write_data    : in std_logic_vector(31 downto 0);
     MemWrite, MemRead      : in std_logic;
--
-- outputs
--
     read_data :out std_logic_vector(31 downto 0));

end memory;


architecture behavioral of memory is 

TYPE DATA_RAM IS ARRAY (0 to 31) OF STD_LOGIC_VECTOR (31 DOWNTO 0);
   SIGNAL dram: DATA_RAM := (
      X"00000000", -- 0
      X"11111111", -- 1
      X"22222222", -- 2
      X"33333333", -- 3
      X"44444444", -- 4
      X"55555555", -- 5
      X"66666666", -- 6
      X"77777777", -- 7
      X"0000000A", -- 8
      X"1111111A", -- 9
      X"2222222A", -- 10
      X"00000011", -- 11
      X"4444444A", -- 12
      X"00000011", -- 13
      X"6666666A", -- 14
      X"7777777A", -- 15
      X"0000000B", -- 16
      X"1111111B", -- 17
      X"2222222B", -- 18
      X"3333333B", -- 19
      X"4444444B", -- 20
      X"5555555B", -- 21
      X"6666666B", -- 22
      X"7777777B", -- 23
      X"000000BA", -- 24
      X"111111BA", -- 25
      X"222222BA", -- 26
      X"333333BA", -- 27
      X"444444BA", -- 28
      X"555555BA", -- 29
      X"666666BA", -- 30
      X"777777BA"  -- 31
   );
	
BEGIN 				

-- memory read operation
read_data <= dram(CONV_INTEGER(address(6 downto 2))) when MemRead = '1'
           else X"FFFFFFFF"; 		

-- memory write operation
dram(CONV_INTEGER(address(6 downto 2))) <= write_data when MemWrite = '1' 
            else dram(CONV_INTEGER(address(6 downto 2)));
		 
			 	
end behavioral;

