-- memoria ram
library ieee;
use ieee.std_logic_1164.all; 
--use ieee.std_logic_arith.all; 
use ieee.numeric_std.all;


entity sdram_memory is
	generic(
		ram_size: integer := 8388608;
		ram_width: integer := 32
);
	port(
		sd_addr: in std_logic_vector(12 downto 0);
		sd_ba: in std_logic_vector(1 downto 0);
		sd_dq: inout std_logic_vector(15 downto 0);
		ras: in std_logic;
		cas: in std_logic;
		wen: in std_logic;
		clk: in std_logic;
		reset: in std_logic
				
		);
end sdram_memory;



architecture behav of sdram_memory is

type ram_type is array (0 to ram_size-1) of std_logic_vector(1-ram_width downto 0);
signal ram_0, ram_2, ram_3, ram_1: ram_type;
signal data_read: std_logic_vector(ram_width-1 downto 0);


begin

process(data_read, wen) begin

if (wen = '1') then 
	sd_dq <= data_read;
else
	sd_dq <= (others => 'Z');
end if;

end process;

process(clk,reset) begin

	if (reset = '1') then
		for j in 0 to ram_size-1 loop
			ram_0(j) <= (others => '0');
			ram_1(j) <= (others => '0');
			ram_2(j) <= (others => '0');
			ram_3(j) <= (others => '0');
		end loop;
		data_read <= (others => '0');
	elsif (clk'event and clk='1') then
		if (ras = '1' and cas = '0' and wen = '1') then -- read
--			ram_1 <= ram_1;
--			ram_2 <= ram_2;
--			ram_3 <= ram_3;
--			ram_0 <= ram_0;
			case sd_ba is
				when "00" => data_read <= ram_0(to_integer(unsigned(sd_addr)));
				when "01" => data_read <= ram_1(to_integer(unsigned(sd_addr)));
				when "10" => data_read <= ram_2(to_integer(unsigned(sd_addr)));
				when "11" => data_read <= ram_3(to_integer(unsigned(sd_addr)));
				when others => data_read <= (others => '0');
			end case;
		elsif (ras = '1' and cas = '0' and wen = '0') then -- write
			data_read <= (others => '0');
			case sd_ba is
				when "00" => 

					--ram_0(1-ram_size downto sd_addr+1) <= ram_0(1-ram_size downto sd_addr+1);
					--ram_0(sd_addr-1 downto 0) <= ram_0(sd_addr-1 downto 0);
					ram_0(to_integer(unsigned(sd_addr))) <= sd_dq;
					--ram_1 <= ram_1;
					--ram_2 <= ram_2;
					--ram_3 <= ram_3;
				when "01" => 
					--ram_1(1-ram_size downto sd_addr+1) <= ram_1(1-ram_size downto sd_addr+1);
					--ram_1(sd_addr-1 downto 0) <= ram_1(sd_addr-1 downto 0);
					ram_1(to_integer(unsigned(sd_addr))) <= sd_dq;
					--ram_0 <= ram_1;
					--ram_2 <= ram_2;
					--ram_3 <= ram_3;
				when "10" => 
					--ram_2(1-ram_size downto sd_addr+1) <= ram_2(1-ram_size downto sd_addr+1);
					--ram_2(sd_addr-1 downto 0) <= ram_2(sd_addr-1 downto 0);
					ram_2(to_integer(unsigned(sd_addr))) <= sd_dq;
					---ram_1 <= ram_1;
					--ram_0 <= ram_2;
					--ram_3 <= ram_3;
				when "11" => 
					--ram_3(1-ram_size downto sd_addr+1) <= ram_3(1-ram_size downto sd_addr+1);
					--ram_3(sd_addr-1 downto 0) <= ram_3(sd_addr-1 downto 0);
					ram_3(to_integer(unsigned(sd_addr))) <= sd_dq;
					--ram_1 <= ram_1;
					--ram_2 <= ram_2;
					--ram_0 <= ram_0;
				when others =>
					ram_1 <= ram_1;
					ram_2 <= ram_2;
					ram_3 <= ram_3;
					ram_0 <= ram_0;
					data_read <= (others => '0');
			end case;

		else 
			ram_1 <= ram_1;
			ram_2 <= ram_2;
			ram_3 <= ram_3;
			ram_0 <= ram_0;
			data_read <= (others => '0');
		end if;
	end if;
		

end process;



end behav;
