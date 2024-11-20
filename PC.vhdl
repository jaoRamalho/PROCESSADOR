library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC is
    port(
        clk      : in std_logic;
        reset    : in std_logic;
        enable   : in std_logic;
        pc_out   : out std_logic_vector(7 downto 0)
    );
end entity PC;

architecture Behavioral of PC is
    signal pc_reg : std_logic_vector(7 downto 0) := (others => '0');
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                pc_reg <= (others => '0');
            elsif enable = '1' then
                pc_reg <= std_logic_vector(unsigned(pc_reg) + 1);
            end if;
        end if;
    end process;
    
    pc_out <= pc_reg;
end architecture Behavioral;