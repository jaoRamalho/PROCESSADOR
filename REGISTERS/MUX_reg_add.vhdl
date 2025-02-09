library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity MUX_reg_add is
    port(
        data_default    : in  unsigned(2 downto 0);
        data_operation  : in  unsigned(2 downto 0);
        address_ram     : in  unsigned(2 downto 0);  
        sel             : in  unsigned(1 downto 0);
        out_mux         : out unsigned(2 downto 0)
    );
end entity MUX_reg_add;

architecture Behavioral of MUX_reg_add is
begin
    out_mux <=  data_operation when sel = "01" else 
                data_default when sel = "00" else
                address_ram when sel = "10" else
                data_default;
end architecture Behavioral;