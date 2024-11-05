library ieee;
use ieee.std_logic_1164.all;

entity INVERSOR is
    port(
        a_in : in std_logic_vector(15 downto 0);
        out_inv : out std_logic_vector(15 downto 0);
        flag_zero : out std_logic;
        flag_sinal : out std_logic
    );
end entity INVERSOR;

architecture Behavioral of INVERSOR is
begin
    out_inv <= not a_in;
    flag_zero <= '1' when a_in = "0000000000000000" else '0';
    flag_sinal <= a_in(15);
end architecture Behavioral;