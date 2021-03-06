LIBRARY ieee;                                                
USE ieee.std_logic_1164.all;                                 
USE ieee.numeric_std.all;

use work.regsprober.all;

ENTITY cpu_test IS  
END cpu_test;

ARCHITECTURE cpu_test_arch OF cpu_test IS  

-- constants
constant clk_period : time := 20 ns;

-- signals                                                     
SIGNAL clk : STD_LOGIC;  
SIGNAL reset : STD_LOGIC;  
SIGNAL inst_addr : STD_LOGIC_VECTOR(31 downto 0);
SIGNAL inst: STD_LOGIC_VECTOR(31 downto 0);
SIGNAL data_addr : STD_LOGIC_VECTOR(31 downto 0);
SIGNAL data_in : STD_LOGIC_VECTOR(31 downto 0);
SIGNAL data_out : STD_LOGIC_VECTOR(31 downto 0);
SIGNAL data_read : STD_LOGIC;
SIGNAL data_write : STD_LOGIC;

TYPE mem is array(natural range <>) of std_logic_vector(7 downto 0);
signal data_ram : mem(4095 downto 0);
--constant inst_rom : mem(1023 downto 0) := (
--						0=>X"00000000";
--						1=>X"00000004";
--						-- ........
--						others=>X"00000000";
--                                          );
 
COMPONENT cpu  
    PORT (  
    clk : IN STD_LOGIC;  
    reset : IN STD_LOGIC;  
    inst_addr : OUT STD_LOGIC_VECTOR(31 downto 0);
    inst: IN STD_LOGIC_VECTOR(31 downto 0);
    data_addr : OUT STD_LOGIC_VECTOR(31 downto 0);
    data_in : IN STD_LOGIC_VECTOR(31 downto 0);
    data_out : OUT STD_LOGIC_VECTOR(31 downto 0);
    data_read : OUT STD_LOGIC;
    data_write : OUT STD_LOGIC
    );  
END COMPONENT;

BEGIN  
    cpu1 : cpu  
    PORT MAP (  
-- list connections between master ports and signals  
    clk => clk,  
    reset => reset,  
    inst_addr => inst_addr,  
    inst => inst,
    data_addr => data_addr,
    data_in => data_in,
    data_out => data_out,
    data_read => data_read,
    data_write => data_write
    );
 
for_reset : PROCESS                                                
-- variable declarations                                       
BEGIN                                                         
        reset <= '1';
        wait for 5*clk_period;
        reset <= '0';
        WAIT;                                                         
END PROCESS for_reset;                                             

clk_gen : process  
begin  
	for i in 0 to 10 loop
    	clk<='1';  
    	wait for clk_period/2;  
    	clk<='0';  
    	wait for clk_period/2;  
	end loop;
	wait; -- wait forever, this means stop of simulation
end process clk_gen;


inst_fetch : PROCESS(inst_addr)
-- optional sensitivity list                                    
-- (        )                                                   
-- variable declarations                                       
BEGIN                                                           
       case inst_addr is
           when X"00000000" => inst <= X"FFFFF137";
           when X"00000004" => inst <= X"00205463";
           when X"00000008" => inst <= X"00000000";
           when X"0000000C" => inst <= X"40004383";
           when X"00000010" => inst <= X"0081B413";
           when X"00000014" => inst <= X"40215453";
           -- .......
           when others => inst <= X"00000000";
       end case;
END PROCESS inst_fetch;                                            

read_data: PROCESS(data_addr, data_read)
		variable i : integer;
begin
    if data_read='1' then
	i := TO_INTEGER(UNSIGNED(data_addr));
	-- Assume little-endian layout
        data_in <= data_ram(i+3) & data_ram(i+2) & data_ram(i+1) & data_ram(i);
    else
        data_in <= X"00000000";
    end if;
end process read_data;

write_data: PROCESS(data_addr, data_write, data_out)
	variable i : integer;
begin
    if data_write='1' then
	i := TO_INTEGER(UNSIGNED(data_addr));
        data_ram(i+3) <= data_out(31 downto 24);
        data_ram(i+2) <= data_out(23 downto 16);
        data_ram(i+1) <= data_out(15 downto 8);
        data_ram(i) <= data_out(7 downto 0);
    end if;
end process write_data;

END cpu_test_arch;
