--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- librerias 

library ieee;
use ieee.std_logic_1164.all;

library grlib;
use grlib.amba.all;
use grlib.stdlib.all;
use grlib.devices.all;

library techmap;
use techmap.gencomp.all;
use techmap.allclkgen.all;

library gaisler;
use gaisler.memctrl.all;
use gaisler.leon3.all;
use gaisler.uart.all;
use gaisler.misc.all;
use gaisler.net.all;
use gaisler.jtag.all;

library esa;
use esa.memoryctrl.all;
use work.config.all;

use std.textio.all

--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





entity tb_system_start is
	generic(

		fabtech : integer := CFG_FABTECH;
		memtech : integer := CFG_MEMTECH;
		padtech : integer := CFG_PADTECH;
		clktech : integer := CFG_CLKTECH;
		disas   : integer := CFG_DISAS;     -- Enable disassembly to console
    		dbguart : integer := CFG_DUART;     -- Print UART on console
		pclow   : integer := CFG_PCLOW;

		romwidth  : integer := 16;          -- rom data width (8/32)
		romdepth  : integer := 16;          -- rom address depth
		image : string := "";
		);
	port();

end tb_system_start;





architecture behav of tb_system_start is

constant promfile  : string := "image.srec";   -- rom contents
  -- ddr memory  
  signal ddr_clk  	: std_logic;
  signal ddr_clkb  	: std_logic;
  signal ddr_clk_fb  : std_logic;
  signal ddr_cke  	: std_logic;
  signal ddr_csb  	: std_logic;
  signal ddr_web  	: std_ulogic;                       -- ddr write enable
  signal ddr_rasb  	: std_ulogic;                       -- ddr ras
  signal ddr_casb  	: std_ulogic;                       -- ddr cas
  signal ddr_dm   	: std_logic_vector (1 downto 0);    -- ddr dm
  signal ddr_dqs  	: std_logic_vector (1 downto 0);    -- ddr dqs
  signal ddr_ad      : std_logic_vector (12 downto 0);   -- ddr address
  signal ddr_ba      : std_logic_vector (1 downto 0);    -- ddr bank address
  signal ddr_dq  		: std_logic_vector (15 downto 0); -- ddr data

-- rom memory
  signal address : std_logic_vector(23 downto 0);
  signal data    : std_logic_vector(31 downto 0);
  signal romsn  : std_logic_vector(1 downto 0);
  signal oen    : std_ulogic;
  signal writen : std_ulogic;
  signal iosn : std_ulogic;

-- UART
  signal rxd : std_logic := '1';
  signal txd : std_logic;
begin

-- generacion de la señal clk
process begin
	wait for 25 ns;
	clk<=not clk;
end process;


-- llamar componente leon3mp
d3 : entity work.leon3mp
    port map (
      reset  => reset,
      clk_50mhz     => clk,

--      testdata    => data(15 downto 0),
      ddr_clk0_m		=> ddr_clk,  	
      ddr_clk0b_m  	=> ddr_clkb,	
      ddr_clk_fb	=> ddr_clk_fb,  
      ddr_cke0   	=> ddr_cke,  
      ddr_cs0b   	=> ddr_csb,  
      ddr_web   	=> ddr_web,  
      ddr_rasb  	=> ddr_rasb,	
      ddr_casb  	=> ddr_casb,	
      ddr_dm    	=> ddr_dm,  
      ddr_dqs   	=> ddr_dqs,  
      ddr_ad    	=> ddr_ad,  
      ddr_ba    	=> ddr_ba,  
      ddr_dq 		=> ddr_dq,

-- debug
--      dsuen   => dsuen,
--      dsubre => dsubre,
--      dsuact => dsuactn,
--      dsutx   => dsutx,
--      dsurx   => dsurx,

      address => address(23 downto 0),
      data    => data(31 downto 16),
      oen    => oen,
      writen => writen,
      iosn   => iosn,
      romsn  => romsn(0),

      utxd1   => txd,
      urxd1   => rxd

      );


-- memoria RAM

ram: sdram_memory
	port map(
		sd_addr =>ddr_adr,
		sd_ba =>ddr_ba,
		sd_dq =>ddr_dq,
		ras =>ddr_rasb,
		cas =>ddr_casb,
		wen => ddr_web,
		clk => clk,
		reset => reset
	);
end generate;


-- memoria rom
prom0 : for i in 0 to (romwidth/8)-1 generate
	sr0 : sram generic map (index => i+4, abits => romdepth, fname => promfile)
	port map (address(romdepth downto 1), data(31-i*8 downto 24-i*8), romsn(0), writen, oen);
end generate;





end behav;




