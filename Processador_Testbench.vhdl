library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Processador_Testbench is
end Processador_Testbench;

architecture behavior of Processador_Testbench is

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
            address   : in  std_logic_vector(2 downto 0); -- Endereço de leitura/escrita
            data_in   : in  std_logic_vector(15 downto 0); -- Dados de escrita
            write_en  : in  std_logic; -- Habilitação de escrita
            read_en   : in  std_logic; -- Habilitação de leitura
            data_out  : out std_logic_vector(15 downto 0) -- Dados de leitura
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

    -- Signals to connect to the UUT
    signal clk           : std_logic := '0'; -- Clock
    signal rst_acc       : std_logic := '0'; -- Reset do acumulador
    signal write_en_acc  : std_logic := '0'; -- Habilitação de escrita no acumulador
    signal rst_rg        : std_logic := '0'; -- Reset do banco de registradores
    signal write_en_rg   : std_logic := '0'; -- Habilitação de escrita no banco de registradores
    signal Flag_zero     : std_logic := '0'; -- Sinal de flag zero
    signal Flag_sinal    : std_logic := '0'; -- Sinal de flag de sinal

    signal operation     : std_logic_vector(1 downto 0)  := (others => '0'); -- Operação da ULA
    signal address_rg    : std_logic_vector(2 downto 0)  := (others => '0'); -- Endereço do registrador
    signal out_acc       : std_logic_vector(15 downto 0) := (others => '0'); -- Saída do acumulador
    signal data          : std_logic_vector(15 downto 0) := (others => '0'); -- Dados de entrada
    signal data_out_rg   : std_logic_vector(15 downto 0) := (others => '0'); -- Dados de saída do banco de registradores
    signal out_ula       : std_logic_vector(15 downto 0) := (others => '0'); -- Saída da ULA

begin

-- Clock generation
clk_process : process
begin
for i in 0 to 1000 loop  -- Limitar o número de ciclos de clock
    clk <= '0';
    wait for 10 ns;
    clk <= '1';
    wait for 10 ns;
end loop;
wait;  -- Parar o processo após o loop
end process;

    -- Instantiate the ACCUMULATOR
    acc: ACCUMULATOR
    port map (
        clk => clk,
        rst => rst_acc,
        write_en_acc => write_en_acc,
        data_in_acc => out_ula,
        out_acc => out_acc
    );

    -- Instantiate the REGISTER_FILE
    reg: REGISTER_FILE
    port map (
        clk => clk,
        rst => rst_rg,
        write_en => write_en_rg,
        read_en => '1',
        address => address_rg,
        data_in => data,
        data_out => data_out_rg
    );

    -- Instantiate the ULA
    ula_inst: ULA
    port map (
        a_in => data_out_rg,
        b_in => out_acc,
        operation => operation,
        out_ula => out_ula,
        Flag_zero => Flag_zero,
        flag_sinal => Flag_sinal
    );

    -- Stimulus process
    stim_proc: process
    begin


        -- Write to the register file
        write_en_rg <= '1';
        address_rg <= "000";
        data <= x"0002";
        wait for 21 ns;

        write_en_rg <= '0';
        wait for 9 ns;

        -- Read from the register file
        address_rg <= "000";
        wait for 10 ns; -- Ver saida do Banco de Registradores

        write_en_acc <= '1';
        wait for 20 ns;

        write_en_acc <= '0';
        write_en_rg <= '1';
        address_rg <= "001";
        data <= x"0003";
        -- Read from the accumulator
        wait for 20 ns;

        -- End the simulation
        wait;
    end process;

end architecture behavior;