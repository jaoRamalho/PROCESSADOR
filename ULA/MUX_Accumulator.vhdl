library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity MUX_accumulator is
    port(
        constante  : in std_logic_vector(15 downto 0);
        out_ula    : in std_logic_vector(15 downto 0);
        sel        : in std_logic;
        out_mux    : out std_logic_vector(15 downto 0)
    );
end entity MUX_accumulator;


architecture Behavioral of MUX_accumulator is
begin
    process(sel, constante, out_ula)
    begin
        if sel = '1' then
            out_mux <= constante;
        else
            out_mux <= out_ula;
        end if;
    end process;
end architecture Behavioral;