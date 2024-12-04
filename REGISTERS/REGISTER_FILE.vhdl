library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity REGISTER_FILE is
    port (
        clk             : in  std_logic;                           -- Clock
        rst             : in  std_logic;                           -- Reset
        write_en        : in  std_logic; 
        write_address   : in  unsigned(2 downto 0);        -- Endereço do registrador
        read_address1   : in  unsigned(2 downto 0);        -- Endereço do registrador
        read_address2   : in  unsigned(2 downto 0);        -- Endereço do registrador 2
        data_in         : in  unsigned(15 downto 0);       -- Dados de entrada
        read_data1      : out unsigned(15 downto 0);        -- Dados de saída
        read_data2      : out unsigned(15 downto 0)        -- Dados de saída 2
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
                registers(to_integer(write_address)) <= data_in;

            end if;
        end if;
    end process;
    
    read_data1 <= registers(to_integer(read_address1));
    read_data2 <= registers(to_integer(read_address2));

end architecture Behavioral;
