library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ULA is
    port(
        a_in       : in  std_logic_vector(15 downto 0);
        b_in       : in  std_logic_vector(15 downto 0);
        operation  : in  std_logic_vector(1 downto 0);
        out_ula    : out std_logic_vector(15 downto 0);
        Flag_zero  : out std_logic;
        Flag_Sinal : out std_logic
    );
end entity ULA;

architecture Behavioral of ULA is

    ---------------- Declaração dos componentes -------------------------
    
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
            out_inv   : out std_logic_vector(15 downto 0)
        );
    end component INVERSOR;

    component MUX is
        port(
            add_out    : in  std_logic_vector(15 downto 0);
            sub_out    : in  std_logic_vector(15 downto 0);
            xor_out    : in  std_logic_vector(15 downto 0);
            inv_out    : in  std_logic_vector(15 downto 0);
            sel        : in  std_logic_vector(1 downto 0);
            out_mux    : out std_logic_vector(15 downto 0)
        );
    end component MUX;
    ---------------------------------------------------------------------------------------
    
    ----------- Sinais internos -----------------------------------------------------------

    signal add_out      : unsigned(15 downto 0);
    signal sub_out      : unsigned(15 downto 0);
    signal xor_out      : std_logic_vector(15 downto 0);
    signal inv_out      : std_logic_vector(15 downto 0);
    signal selected_out : std_logic_vector(15 downto 0);

    ---------------------------------------------------------------------------------------
    
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
            out_inv   => inv_out
        );

    MUX_inst : MUX
        port map (
            add_out => std_logic_vector(add_out),
            sub_out => std_logic_vector(sub_out),
            xor_out => xor_out,
            inv_out => inv_out,
            sel     => operation,
            out_mux => selected_out
        );

    -- Lógica de controle de flags
    Flag_zero <= '1' when selected_out = "0000000000000000" else '0';
    Flag_Sinal <= selected_out(15);

    out_ula <= selected_out;
end architecture Behavioral;