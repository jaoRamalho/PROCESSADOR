library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity INVERSOR is
    port(
        a_in : in unsigned(15 downto 0);
        out_inv : out unsigned(15 downto 0)
    );
end entity INVERSOR;

architecture Behavioral of INVERSOR is
begin
    out_inv <= not a_in;
end architecture Behavioral;