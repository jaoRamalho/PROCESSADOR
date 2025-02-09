library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ULA is
    port(
        a_in        : in  unsigned(15 downto 0);
        b_in        : in  unsigned(15 downto 0);
        operation   : in  unsigned(1 downto 0);
        out_ula     : out unsigned(15 downto 0);
        Flag_zero   : out std_logic;
        Flag_Sinal  : out std_logic;
        Flag_borrow : out std_logic;
        update_flags: in  std_logic;
        clk         : in  std_logic  
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
            out_sub: out unsigned(15 downto 0);
            borrow_in : in std_logic;
            borrow_out : out std_logic
        );
    end component SUB;

    component Modulo_XOR is
        port(
            xor1    : in  unsigned(15 downto 0);
            xor2    : in  unsigned(15 downto 0);
            out_xor : out unsigned(15 downto 0)
        );
    end component Modulo_XOR;

    component INVERSOR is
        port(
            a_in      : in  unsigned(15 downto 0);
            out_inv   : out unsigned(15 downto 0)
        );
    end component INVERSOR;

    component MUX_Operation is
        port(
            add_out     : in  unsigned(15 downto 0);
            sub_out     : in  unsigned(15 downto 0);
            xor_out     : in  unsigned(15 downto 0);
            inv_out     : in  unsigned(15 downto 0);
            sel         : in  unsigned(1 downto 0);
            out_mux     : out unsigned(15 downto 0)
        );
    end component MUX_Operation;
    ---------------------------------------------------------------------------------------
    
    ----------- Sinais internos -----------------------------------------------------------

    signal add_out      : unsigned(15 downto 0);
    signal sub_out      : unsigned(15 downto 0);
    signal xor_out      : unsigned(15 downto 0);
    signal inv_out      : unsigned(15 downto 0);
    signal selected_out : unsigned(15 downto 0);

    signal reg_flag_zero : std_logic := '0';
    signal reg_flag_sinal: std_logic := '0';
    signal reg_flag_borrow: std_logic := '0';

    signal comb_flag_zero : std_logic;
    signal comb_flag_sinal: std_logic;
    signal comb_flag_borrow: std_logic;

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
            out_sub => sub_out,
            borrow_in => '0',
            borrow_out => comb_flag_borrow
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

    MUX_inst : MUX_Operation
        port map (
            add_out => unsigned(add_out),
            sub_out => unsigned(sub_out),
            xor_out => xor_out,
            inv_out => inv_out,
            sel     => operation,
            out_mux => selected_out
        );

    -- Lógica de controle de flags
    comb_flag_zero <= '1' when selected_out = "0000000000000000" else '0';
    comb_flag_sinal <= selected_out(15);

    process(clk)
    begin
        if falling_edge(clk) then
            if update_flags = '1' then
                reg_flag_zero <= comb_flag_zero;
                reg_flag_sinal <= comb_flag_sinal;
                reg_flag_borrow <= comb_flag_borrow;
            end if;
        end if;
    end process;

    Flag_zero   <= reg_flag_zero;
    Flag_Sinal  <= reg_flag_sinal;
    Flag_borrow <= reg_flag_borrow;

    out_ula <= selected_out;
end architecture Behavioral;