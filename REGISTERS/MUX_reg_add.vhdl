library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity MUX_reg_add is
    port(
        data_default : in  unsigned(2 downto 0);
        data_operation  : in  unsigned(2 downto 0);  
        sel       : in  std_logic;
        out_mux   : out unsigned(2 downto 0)
    );
end entity MUX_reg_add;

architecture Behavioral of MUX_reg_add is
begin
    out_mux <= data_operation when sel = '1' else data_default;
end architecture Behavioral;