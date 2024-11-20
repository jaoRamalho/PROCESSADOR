library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Processador is
    port(
        clk           : in  std_logic;                         -- Clock
        rst_acc       : in  std_logic;                         -- Reset do acumulador
        write_en_acc  : in  std_logic;                         -- Habilitação de escrita no acumulador
        rst_rg        : in  std_logic;                         -- Reset do banco de registradores
        write_en_rg   : in  std_logic;                         -- Habilitação de escrita no banco de registradores
        operation     : in  std_logic_vector(1 downto 0);      -- Operação da ULA
        address_rg    : in  std_logic_vector(2 downto 0);      -- Endereço do registrador
        data          : in  std_logic_vector(15 downto 0);     -- Dados de entrada
        
        Flag_sinal    : out std_logic;                         -- Sinal de flag de sinal
        Flag_zero     : out std_logic;                         -- Sinal de flag zero
        out_acc       : out std_logic_vector(15 downto 0);     -- Saída do acumulador
        data_out_rg   : out std_logic_vector(15 downto 0);     -- Dados de saída do banco de registradores
        out_ula       : out std_logic_vector(15 downto 0)      -- Saída da ULA
    );
end Processador;

architecture behavior of Processador is

    -- Component Declaration for the Unit Under Test (UUT)
    component ACCUMULATOR is
        port (
            clk           : in  std_logic;
            rst           : in  std_logic;
            write_en_acc  : in  std_logic;
            data_in_acc   : in  std_logic_vector(15 downto 0);
            out_acc       : out std_logic_vector(15 downto 0)
        );
    end component;

    component REGISTER_FILE is
        port (
            clk       : in  std_logic;
            rst       : in  std_logic;
            address   : in  std_logic_vector(2 downto 0);    -- Endereço de leitura/escrita
            data_in   : in  std_logic_vector(15 downto 0);   -- Dados de escrita
            write_en  : in  std_logic;                       -- Habilitação de escrita
            read_en   : in  std_logic;                       -- Habilitação de leitura
            data_out  : out std_logic_vector(15 downto 0)    -- Dados de leitura
        );
    end component;

    component ULA is
        port (
            a_in       : in  std_logic_vector(15 downto 0);
            b_in       : in  std_logic_vector(15 downto 0);
            operation  : in  std_logic_vector(1 downto 0);
            out_ula    : out std_logic_vector(15 downto 0);
            Flag_zero  : out std_logic;
            flag_sinal : out std_logic
        );
    end component;

    -- Sinais internos para conectar os componentes
    signal signal_out_acc     : std_logic_vector(15 downto 0) := (others => '0');  -- Saída do acumulador
    signal signal_data_out_rg : std_logic_vector(15 downto 0) := (others => '0');  -- Dados de saída do banco de registradores
    signal signal_out_ula     : std_logic_vector(15 downto 0) := (others => '0');  -- Saída da ULA

begin

    -- Instanciar o ACCUMULATOR
    acc: ACCUMULATOR
        port map (
            clk          => clk,
            rst          => rst_acc,
            write_en_acc => write_en_acc,
            data_in_acc  => signal_out_ula,   -- Conectado à saída da ULA
            out_acc      => signal_out_acc    -- Saída do acumulador
        );

    -- Instanciar o REGISTER_FILE
    reg: REGISTER_FILE
        port map (
            clk       => clk,
            rst       => rst_rg,
            address   => address_rg,
            data_in   => data,               -- Dados de entrada vindos das portas do Processador
            write_en  => write_en_rg,
            read_en   => '1',                -- Habilitação de leitura sempre ativa para teste
            data_out  => signal_data_out_rg  -- Saída do banco de registradores
        );

    -- Instanciar a ULA
    ula_inst: ULA
        port map (
            a_in       => signal_data_out_rg,  -- Saída do banco de registradores
            b_in       => signal_out_acc,      -- Saída do acumulador
            operation  => operation,           -- Operação proveniente das portas do Processador
            out_ula    => signal_out_ula,      -- Saída da ULA
            Flag_zero  => Flag_zero,           -- Sinais de flag provenientes das portas do Processador
            flag_sinal => Flag_sinal
        );

    -- Atribuições concorrentes para conectar sinais internos às portas do Processador
    out_ula     <= signal_out_ula;
    data_out_rg <= signal_data_out_rg;
    out_acc     <= signal_out_acc;

end architecture behavior;