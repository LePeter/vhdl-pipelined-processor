-- ECE 3056: Architecture, Concurrency and Energy in Computation
-- Sudhakar Yalamanchili
-- Pipelined MIPS Processor VHDL Behavioral Mode--
--
--
-- instruction decode unit.
--
-- Note that this module differs from the text in the following ways
-- 1. The MemToReg Mux is implemented in this module instead of a (syntactically) 
-- different pipeline stage. 
--

Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;


entity decode is
port(
--
-- inputs 
--
     PC4 : in std_logic_vector(31 downto 0);
     instruction : in std_logic_vector(31 downto 0);
     memory_data, alu_result :in std_logic_vector(31 downto 0);
     RegWrite, MemToReg, reset : in std_logic;
     wreg_address : in std_logic_vector(4 downto 0);
--
-- outputs
--
     Branch_PC :out std_logic_vector(31 downto 0);
     register_rs, register_rt :out std_logic_vector(31 downto 0);
     Sign_extend :out std_logic_vector(31 downto 0);
     wreg_rd, wreg_rt : out std_logic_vector (4 downto 0);
     equal :out std_logic);
end decode;


architecture behavioral of decode is 
TYPE register_file IS ARRAY ( 0 TO 31 ) OF STD_LOGIC_VECTOR( 31 DOWNTO 0 );

	SIGNAL register_array: register_file := (
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
      X"3333333A", -- 11
      X"4444444A", -- 12
      X"5555555A", -- 13
      X"6666666A", -- 14
      X"7777777A", -- 15
      X"0000000B", -- 16
      X"00000000", -- 17
      X"0000000F", -- 18
      X"0000000F", -- 19
      X"00000007", -- 20
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
	SIGNAL write_data					            : STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL read_register_1_address		  : STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL read_register_2_address		  : STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL Instruction_immediate_value	: STD_LOGIC_VECTOR( 15 DOWNTO 0 );
	SIGNAL register_rs_internal		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL register_rt_internal		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL Sign_extend_internal		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	
	begin
        read_register_1_address 	<= Instruction( 25 DOWNTO 21 );
   	read_register_2_address 	<= Instruction( 20 DOWNTO 16 );
        Instruction_immediate_value 	<= Instruction( 15 DOWNTO 0 );
	
	-- MemToReg Mux for Writeback
	   write_data <= ALU_result( 31 DOWNTO 0 ) 
			           WHEN ( MemtoReg = '0' ) 	
			           ELSE memory_data;

	-- Sign Extend 16-bits to 32-bits

    	Sign_extend_internal <= X"0000" & Instruction_immediate_value
		         WHEN Instruction_immediate_value(15) = '0'
		         ELSE	X"FFFF" & Instruction_immediate_value;
	Sign_extend <= Sign_extend_internal;
		
	-- Read Register 1 Operation		 

		register_rs_internal <= register_array( 
			      CONV_INTEGER( read_register_1_address ) );
		register_rs <= register_rs_internal;

	-- Read Register 2 Operation		
 
	   register_rt_internal <= register_array( 
			      CONV_INTEGER( read_register_2_address ) );
	   register_rt <= register_rt_internal;

	-- Register write operation
		
		register_array( CONV_INTEGER(wreg_address)) <= write_data
		                  when RegWrite = '1' else
		                      register_array(conv_integer(wreg_address));
	
	-- move possible write destinations to execute stage                   
		wreg_rd <= instruction(15 downto 11);
      wreg_rt <= instruction(20 downto 16);

	-- compute branch address
	Branch_PC <= PC4 + (Sign_extend_internal(29 downto 0) & "00");

	-- comparator
	equal <= '1'
		WHEN (register_rs_internal xor register_rt_internal) = X"00000000"
		ELSE '0';
		
end behavioral;




