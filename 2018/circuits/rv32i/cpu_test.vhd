LIBRARY ieee;                                                
USE ieee.std_logic_1164.all;                                 

ENTITY cpu_test IS  
END cpu_test;

ARCHITECTURE cpu_test_arch OF cpu_test IS  

-- constants
clk_period : time := 20ns;

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
 
COMPONENT cpu  
    PORT (  
    clk : IN STD_LOGIC;  
    reset : IN STD_LOGIC;  
    inst_addr : STD_LOGIC_VECTOR(31 downto 0);
    inst: STD_LOGIC_VECTOR(31 downto 0);
    data_addr : STD_LOGIC_VECTOR(31 downto 0);
    data_in : STD_LOGIC_VECTOR(31 downto 0);
    data_out : STD_LOGIC_VECTOR(31 downto 0);
    data_read : STD_LOGIC;
    data_write : STD_LOGIC
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
init : PROCESS                                                
-- variable declarations                                       
BEGIN                                                         
        reset = '1';
        wait for 5*clk_period;
        reset = '0';
WAIT;                                                         
END PROCESS init;                                             

clk_gen:process  
begin  
    clk='1';  
    wait for clk_period/2;  
    clk='0';  
    wait for clk_period/2;  
end process;  


inst_fetch : PROCESS(inst_addr)
-- optional sensitivity list                                    
-- (        )                                                   
-- variable declarations                                       
BEGIN                                                           
       case inst_addr is
           when X"00000000" => inst <= X"instruction at 0";
           when X"00000004" => inst <= X"instruction at 4";
           -- .......
           when others => inst <= X"00000000";
       end case;
WAIT;                                                         
END PROCESS inst_fetch;                                            

END cpu_test_arch;  