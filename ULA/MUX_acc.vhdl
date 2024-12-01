library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity MUX_acc is
    port(
        ula_out      : in  unsigned(15 downto 0);
        out_register : in  unsigned(15 downto 0);  
        sel          : in  std_logic;
        out_mux      : out unsigned(15 downto 0)
    );
end entity MUX_acc;


architecture Behavioral of MUX_acc is
begin
    process(sel, ula_out, out_register)
    begin
        if sel = '1' then
            out_mux <= ula_out;
        else
            out_mux <= out_register;
        end if;
    end process;
end architecture Behavioral;
