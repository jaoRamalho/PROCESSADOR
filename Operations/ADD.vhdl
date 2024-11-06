library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ADD is
    port(
        a_in, b_in : in unsigned(15 downto 0);
        out_add : out unsigned(15 downto 0)
    );
end entity ADD;

architecture Behavioral of ADD is
begin
    out_add <= a_in + b_in;
end architecture Behavioral;