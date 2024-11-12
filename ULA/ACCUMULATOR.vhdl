library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity ACCUMULATOR is
    port(
        clk             : in std_logic;
        rst             : in std_logic;
        write_en_acc    : in std_logic;
        data_in_acc     : in std_logic_vector(15 downto 0);
        out_acc         : out std_logic_vector(15 downto 0)
    );
end entity ACCUMULATOR;


architecture Behavioral of ACCUMULATOR is
    signal acc : std_logic_vector(15 downto 0) := (others => '0');
begin
        
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                acc <= (others => '0');  --- reseta o acumulador
            elsif write_en_acc = '1' then
                acc <= data_in_acc;     --- escreve no acumulador (acumulador recebe saida da ula)
            end if;
        end if;
    end process;

    out_acc <= acc;

end architecture Behavioral;