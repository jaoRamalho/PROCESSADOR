library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity MUX_registerFile is
    port(
        data_rom  : in  unsigned(15 downto 0);
        data_ula  : in  unsigned(15 downto 0);  
        sel       : in  std_logic;
        out_mux   : out unsigned(15 downto 0)
    );
end entity MUX_registerFile;

architecture Behavioral of MUX_registerFile is
begin
    out_mux <= data_rom when sel = '1' else data_ula;
end architecture Behavioral;