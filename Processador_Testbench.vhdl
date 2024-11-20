library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Processador_Testbench is
end Processador_Testbench;

architecture behavior of Processador_Testbench is

        component Processador is
            port(
                clk           : in std_logic; -- Clock
                rst_acc       : in std_logic; -- Reset do acumulador
                write_en_acc  : in std_logic; -- Habilitação de escrita no acumulador
                rst_rg        : in std_logic; -- Reset do banco de registradores
                write_en_rg   : in std_logic; -- Habilitação de escrita no banco de registradores
                operation     : in std_logic_vector(1 downto 0); -- Operação da ULA
                address_rg    : in std_logic_vector(2 downto 0); -- Endereço do registrador
                data          : in std_logic_vector(15 downto 0); -- Dados de entrada
                
                out_acc       : out std_logic_vector(15 downto 0); -- Saída do acumulador
                data_out_rg   : out std_logic_vector(15 downto 0); -- Dados de saída do banco de registradores
                out_ula       : out std_logic_vector(15 downto 0); -- Saída da ULA
                Flag_zero     : out std_logic; -- Sinal de flag zero
                Flag_sinal    : out std_logic -- Sinal de flag de sinal
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

    -- Instantiate the Unit Under Test (UUT)
    pr : Processador
    port map(
        clk           => clk,
        rst_acc       => rst_acc,
        write_en_acc  => write_en_acc,
        rst_rg        => rst_rg,
        write_en_rg   => write_en_rg,
        operation     => operation,
        address_rg    => address_rg,
        data          => data,
        out_acc       => out_acc,
        data_out_rg   => data_out_rg,
        out_ula       => out_ula,
        Flag_zero     => Flag_zero,
        Flag_sinal    => Flag_sinal
    );

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

    -- Stimulus process
    stim_proc: process
    begin

        -- Write to the register file
        write_en_rg <= '1';
        address_rg <= "000";
        data <= x"0002";
        wait for 21 ns;

        write_en_rg <= '0';
        wait for 10 ns;

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