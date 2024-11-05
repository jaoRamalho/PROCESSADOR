library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ULA is
    port(
        a_in       : in  std_logic_vector(15 downto 0);
        b_in       : in  std_logic_vector(15 downto 0);
        operation  : in  std_logic_vector(3 downto 0);
        out_ula    : out std_logic_vector(15 downto 0);
        Flag_zero  : out std_logic;
        Flag_Sinal : out std_logic
    );
end entity ULA;

architecture Behavioral of ULA is

    -- Declaração dos componentes
    component ADD is
        port(
            a_in   : in  unsigned(15 downto 0);
            b_in   : in  unsigned(15 downto 0);
            out_add: out unsigned(15 downto 0)
        );
    end component ADD;

    component SUB is
        port(
            a_in   : in  unsigned(15 downto 0);
            b_in   : in  unsigned(15 downto 0);
            out_sub: out unsigned(15 downto 0)
        );
    end component SUB;

    component Modulo_XOR is
        port(
            xor1    : in  std_logic_vector(15 downto 0);
            xor2    : in  std_logic_vector(15 downto 0);
            out_xor : out std_logic_vector(15 downto 0)
        );
    end component Modulo_XOR;

    component INVERSOR is
        port(
            a_in      : in  std_logic_vector(15 downto 0);
            out_inv   : out std_logic_vector(15 downto 0);
            flag_zero : out std_logic;
            flag_sinal: out std_logic
        );
    end component INVERSOR;

    -- Sinais internos
    signal add_out      : unsigned(15 downto 0);
    signal sub_out      : unsigned(15 downto 0);
    signal xor_out      : std_logic_vector(15 downto 0);
    signal inv_out      : std_logic_vector(15 downto 0);
    signal selected_out : std_logic_vector(15 downto 0);

begin

    -- Instanciação dos componentes

    ADD_inst : ADD
        port map (
            a_in    => unsigned(a_in),
            b_in    => unsigned(b_in),
            out_add => add_out
        );

    SUB_inst : SUB
        port map (
            a_in    => unsigned(a_in),
            b_in    => unsigned(b_in),
            out_sub => sub_out
        );

    MODULO_XOR_inst : Modulo_XOR
        port map (
            xor1    => a_in,
            xor2    => b_in,
            out_xor => xor_out
        );

    INVERSOR_inst : INVERSOR
        port map (
            a_in      => a_in,
            out_inv   => inv_out,
            flag_zero => open,  -- Removemos a atribuição das flags aqui
            flag_sinal=> open
        );

    -- Processo para selecionar a operação
    process(operation, add_out, sub_out, xor_out, inv_out)
    begin
        case to_integer(unsigned(operation)) is
            when 0 =>
                selected_out <= std_logic_vector(add_out);
            when 1 =>
                selected_out <= std_logic_vector(sub_out);
            when 2 =>
                selected_out <= xor_out;
            when 4 =>
                selected_out <= inv_out;
            when others =>
                selected_out <= "0000000000000000";
        end case;
    end process;

    -- Atribuindo a saída selecionada à porta de saída
    out_ula <= selected_out;

    -- Definição das flags com base na saída selecionada
    Flag_zero  <= '1' when selected_out = "0000000000000000" else '0';
    Flag_Sinal <= selected_out(15);

end architecture Behavioral;