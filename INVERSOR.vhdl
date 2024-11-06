library ieee;
use ieee.std_logic_1164.all;

entity INVERSOR is
    port(
        a_in : in std_logic_vector(15 downto 0);
        out_inv : out std_logic_vector(15 downto 0)
    );
end entity INVERSOR;

architecture Behavioral of INVERSOR is
begin
    out_inv <= not a_in;
end architecture Behavioral;