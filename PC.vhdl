library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC is
    port(
        clk              : in std_logic;
        reset            : in std_logic;
        pc_increment     : in std_logic;
        pc_source_select : in unsigned(1 downto 0);
        pc_in            : in unsigned(6 downto 0);
        pc_out           : out unsigned(6 downto 0)
    );
end entity PC;

architecture Behavioral of PC is
    signal pc_reg : unsigned(6 downto 0) := (others => '0');
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                pc_reg <= (others => '0');
            elsif pc_increment = '1' then
                if pc_source_select = "01" then
                    pc_reg <= pc_in; -- Salta para o endereço especificado
                elsif pc_source_select = "10" then
                    pc_reg <= pc_reg + pc_in; -- Salta para o endereço relativo
                elsif pc_source_select = "11" then
                    pc_reg <= pc_reg - pc_in; -- Salta para o endereço relativo
                else
                    if pc_reg = "1111111" then
                        pc_reg <= (others => '0');
                    else
                        pc_reg <= pc_reg + 1;
                    end if;
                end if;
            end if;
        end if;
    end process;

    pc_out <= pc_reg;
end architecture Behavioral;