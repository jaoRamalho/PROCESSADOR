library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SUB is
    port(
        a_in, b_in : in unsigned(15 downto 0);
        out_sub : out unsigned(15 downto 0)
    );
end entity SUB;

architecture Behavioral of SUB is
begin
    out_sub <= a_in - b_in;
end architecture Behavioral;