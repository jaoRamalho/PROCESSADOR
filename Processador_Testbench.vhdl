library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Processador_Testbench is
end entity;

architecture behavior of Processador_Testbench is

    -- Component Declaration for the Unit Under Test (UUT)
    component Processador is
        port(
            clk : in std_logic; -- Clock
            rst : in std_logic; -- rst
            debug : out unsigned(15 downto 0) -- Dados de saída para debug
        );
    end component;

    -- Sinais para conectar ao UUT
    signal clk   : std_logic := '0';
    signal rst : std_logic := '0';
    signal debug : unsigned(15 downto 0);
begin
    -- Instantiate the Unit Under Test (UUT)
    pr : Processador
        port map(
            clk   => clk,
            rst => rst,
            debug => debug
        );

    -- Geração de Clock
    clk_process : process
    begin
        while now < 200000 ns loop
            clk <= '0';
            wait for 10 ns;
            clk <= '1';
            wait for 10 ns;
        end loop;
        wait;
    end process;


    -- Processo de Estímulo
    stim_proc: process
    begin
        -- Inicialização e rst
        rst <= '1';
        wait for 20 ns;
        rst <= '0';
        wait for 200 ns; -- Espera 10 ciclos de clock (20 ns por ciclo)

        -- Finalizar Simulação
        wait;
    end process;

end architecture behavior;