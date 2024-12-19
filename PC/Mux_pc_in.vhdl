library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity Mux_pc_in is
    port(
        jmp      : in  unsigned(6 downto 0);
        b        : in  unsigned(6 downto 0);  
        sel      : in  std_logic;
        out_mux  : out unsigned(6 downto 0)
    );
end entity Mux_pc_in;

architecture Behavioral of Mux_pc_in is
begin
    out_mux <= b when sel = '1' else jmp;
end architecture Behavioral;