library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MUX_Operation is
    port(
        add_out : in unsigned(15 downto 0);
        sub_out : in unsigned(15 downto 0);
        inv_out : in unsigned(15 downto 0);
        xor_out : in unsigned(15 downto 0);
        sel     : in unsigned(1 downto 0);
        out_mux : out unsigned(15 downto 0)
    );
end entity MUX_Operation;

architecture Behavioral of MUX_Operation is
begin
    with sel select
        out_mux <= add_out when "00",
                sub_out when "01",
                inv_out when "10",
                xor_out when "11",
                (others => '0') when others;
                
end architecture Behavioral;