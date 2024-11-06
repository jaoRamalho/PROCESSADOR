library ieee;
use ieee.std_logic_1164.all;

entity MUX is
    port(
        add_out : in std_logic_vector(15 downto 0);
        sub_out : in std_logic_vector(15 downto 0);
        inv_out : in std_logic_vector(15 downto 0);
        xor_out : in std_logic_vector(15 downto 0);
        sel  : in std_logic_vector(1 downto 0);
        out_mux : out std_logic_vector(15 downto 0)
    );
end entity MUX;

architecture Behavioral of MUX is
begin
    process(sel, add_out, sub_out, inv_out, xor_out)
    begin
        case sel is
            when "00" =>
                out_mux <= add_out;
            when "01" =>
                out_mux <= sub_out;
            when "10" =>
                out_mux <= inv_out;
            when "11" =>
                out_mux <= xor_out;
            when others =>
                out_mux <= (others => '0');
        end case;
    end process;
end architecture Behavioral;