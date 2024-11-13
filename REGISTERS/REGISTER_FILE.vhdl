library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity REGISTER_FILE is
    port (
        clk             : in  std_logic;                           -- Clock
        rst             : in  std_logic;                           -- Reset
        write_en        : in  std_logic; 
        read_en         : in  std_logic;                          -- Sinal de habilitação de escrita
        address         : in  std_logic_vector(2 downto 0);        -- Endereço do registrador
        data_in         : in  std_logic_vector(15 downto 0);       -- Dados de entrada
        data_out        : out std_logic_vector(15 downto 0)        -- Dados de saída
    );
end entity REGISTER_FILE;

architecture Behavioral of REGISTER_FILE is

    -- Banco de registradores: um array de 8 registradores de 16 bits
    type registers_array is array (0 to 7) of std_logic_vector(15 downto 0);
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
            
            if read_en = '1' then
                -- Leitura: lê o conteúdo de um registrador específico quando habilitado
                data_out <= registers(to_integer(unsigned(address)));
            end if;
            
        end if;
    end process;

end architecture Behavioral;
