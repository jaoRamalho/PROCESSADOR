library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity MUX_Constante is
    port(
        constante : in  unsigned(15 downto 0);
        out_register : in  unsigned(15 downto 0);  
        sel       : in  std_logic;
        out_mux   : out unsigned(15 downto 0)
    );
end entity MUX_Constante;


architecture Behavioral of MUX_Constante is
begin
    process(sel, constante, out_register)
    begin
        if sel = '1' then
            out_mux <= constante;
        else
            out_mux <= out_register;
        end if;
    end process;
end architecture Behavioral;
