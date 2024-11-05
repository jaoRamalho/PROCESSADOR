library ieee;
use ieee.std_logic_1164.all;

entity Modulo_XOR is
    port(
        xor1    : in  std_logic_vector(15 downto 0);
        xor2    : in  std_logic_vector(15 downto 0);
        out_xor : out std_logic_vector(15 downto 0)
    );
end entity Modulo_XOR;

architecture Behavioral of Modulo_XOR is
begin
    out_xor <= xor1 xor xor2;
end architecture Behavioral;