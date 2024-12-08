library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SUB is
    port(
        a_in      : in  unsigned(15 downto 0);   -- Minuendo
        b_in      : in  unsigned(15 downto 0);   -- Subtraendo
        borrow_in : in  std_logic;               -- Borrow da operação anterior
        out_sub   : out unsigned(15 downto 0);   -- Resultado da subtração
        borrow_out: out std_logic                -- Borrow para a próxima operação
    );
end entity SUB;

architecture Behavioral of SUB is
    signal sum_borrow_in : unsigned(15 downto 0);
begin
    -- Subtração, considerando o borrow_in
    sum_borrow_in <= b_in + 1 when borrow_in = '1' else b_in;
    out_sub <= a_in - sum_borrow_in;

    -- Calcula se ocorreu borrow_out
    borrow_out <= '1' when (a_in < sum_borrow_in) else '0';
end architecture Behavioral;