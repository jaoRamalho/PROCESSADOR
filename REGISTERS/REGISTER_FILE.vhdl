library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity REGISTER_FILE is
    port (
        clk             : in  std_logic;                           -- Clock
        rst             : in  std_logic;                           -- Reset
        write_en        : in  std_logic; 
        address         : in  unsigned(2 downto 0);        -- Endereço do registrador
        address2        : in  unsigned(2 downto 0);        -- Endereço do registrador 2
        data_in         : in  unsigned(15 downto 0);       -- Dados de entrada
        data_out        : out unsigned(15 downto 0);        -- Dados de saída
        data_out2       : out unsigned(15 downto 0)        -- Dados de saída 2
    );
end entity REGISTER_FILE;

architecture Behavioral of REGISTER_FILE is

    -- Banco de registradores: um array de 8 registradores de 16 bits
    type registers_array is array (0 to 7) of unsigned(15 downto 0);
    signal registers : registers_array := (others => (others => '0')); -- Inicializa os registradores com zero

begin
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                -- Reset: Zera todos os registradores
                registers <= (others => (others => '0'));
            elsif write_en = '1' then
                -- Escrita: grava em um registrador específico quando habilitado
                registers(to_integer(unsigned(address))) <= data_in;
            end if;
            
            data_out <= registers(to_integer(unsigned(address)));
            data_out2 <= registers(to_integer(unsigned(address2)));
        end if;
    end process;

end architecture Behavioral;
