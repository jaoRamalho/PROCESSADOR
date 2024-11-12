library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity REGISTER_BANK is
    port (
        clk             : in  std_logic;                           -- Clock
        rst             : in  std_logic;                           -- Reset
        write_en        : in  std_logic;                           -- Sinal de habilitação de escrita
        read_en         : in  std_logic;                           -- Sinal de habilitação de leitura
        write_en_acc    : in  std_logic;                           -- Sinal de habilitação de escrita no acumulador
        address         : in  std_logic_vector(2 downto 0);        -- Endereço de 3 bits para selecionar um dos 8 registradores
        data_in         : in  std_logic_vector(15 downto 0);       -- Dados de entrada (para escrita)
        data_out        : out std_logic_vector(15 downto 0);       -- Dados de saída (para leitura)
        accumulator_out : out std_logic_vector(15 downto 0)        -- Saida do acumulador
    );
end entity REGISTER_BANK;

architecture Behavioral of REGISTER_BANK is

    -- Banco de registradores: um array de 8 registradores de 16 bits
    type registers_array is array (0 to 7) of std_logic_vector(15 downto 0);

    signal registers : registers_array := (others => (others => '0')); -- Inicializa os registradores com zero
    signal accumulator : std_logic_vector(15 downto 0) := (others => '0'); -- Acumulador para operações de leitura e escrita

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
        end if;
    end process;

    -- Leitura dos dados
    process(read_en, registers, address)
    begin
        if read_en = '1' then
            data_out <= registers(to_integer(unsigned(address))); -- Leitura do registrador selecionado
        else
            data_out <= (others => 'Z'); -- Saída em alta impedância se não houver leitura
        end if;
    end process;

end architecture Behavioral;
