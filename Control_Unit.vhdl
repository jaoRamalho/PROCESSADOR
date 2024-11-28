library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;



-- Formato de bits: [ [OPCODE(4B)], [FUNCTION()] ]


entity Control_Unit is
    port(
        clk             : in  std_logic;
        reset           : in  std_logic;
        instruction     : in  unsigned(3 downto 0); -- Instrução de 7 bits

        -- Sinais de controle
        pc_inc          : out std_logic;
        write_ir        : out std_logic;
        mux_const_addi  : out std_logic;
        ula_op          : out unsigned(1 downto 0)
    );
end entity Control_Unit;

architecture Behavioral of Control_Unit is


    -- Sinais internos para decodificação
    signal state     : unsigned(1 downto 0)  := "00" ;          -- Bits 1 downto 0
    signal opcode     : unsigned(3 downto 0) := "0000";          -- Bits 16 downto 13

    -- Definição dos opcodes
    constant NOP        : unsigned(3 downto 0) := "0000";   -- FAZ MERDA NENHUMA
    constant LDA        : unsigned(3 downto 0) := "0001";   -- CARREGA UM VALOR NO ACUMULADOR
    constant STA        : unsigned(3 downto 0) := "0010";   -- ARMAZENA O VALOR DO ACUMULADOR EM UM REGISTRADOR
    constant ADD        : unsigned(3 downto 0) := "0011";   -- SOMA O VALOR DO ACUMULADOR COM O VALOR DE UM REGISTRADOR
    constant SUB        : unsigned(3 downto 0) := "0100";   -- SUBTRAI O VALOR DO ACUMULADOR PELO VALOR DE UM REGISTRADOR
    constant INV        : unsigned(3 downto 0) := "0101";   -- INVERTE O VALOR DE UM REGISTRADOR
    constant OP_XOR     : unsigned(3 downto 0) := "0110";   -- FAZ XOR DO VALOR DO ACUMULADOR COM O VALOR DE UM REGISTRADOR
    constant SUBB       : unsigned(3 downto 0) := "0111";   -- SUBTRACAO DIFERENTE
    constant LD         : unsigned(3 downto 0) := "1000";   -- CARREGA UM VALOR EM UM REGISTRADOR
    constant LW         : unsigned(3 downto 0) := "1001";   -- CARREGA UM VALOR NA MEMORIA
    constant JMP        : unsigned(3 downto 0) := "1010";   -- JUMP
    constant ADDI       : unsigned(3 downto 0) := "1011";   -- SOMA UM VALOR CONSTANTE AO ACUMULADOR
    constant WR         : unsigned(3 downto 0) := "1100";   -- ESCREVE EM UM REGISTRADOR O VALOR DO ACUMULADOR
    constant WRI        : unsigned(3 downto 0) := "1101";   -- ESCREVE NA MEMORIA O VALOR DE UMA CONSTANTE
    constant SUBI       : unsigned(3 downto 0) := "1110";   -- SUBTRAI UM VALOR CONSTANTE DO ACUMULADOR

    -- DECLARANDO MAQUINA DE ESTADOS
    component State_Machine is 
        port(
            clk : in std_logic;
            rst : in std_logic;
            state : out unsigned(1 downto 0)
        );
    end component;

begin
    sM : State_Machine port map(
        clk => clk,
        rst => reset,
        state => state
    );


    process(clk, reset)
    begin
        if state = "00" then
            pc_inc <= '1';
        
        elsif state = "01" then
            pc_inc <= '0';
            opcode <= instruction;
            
            case opcode is
                when ADD =>
                    mux_const_addi <= '0';
                    ula_op <= "00";
                when SUB =>
                    mux_const_addi <= '0';
                    ula_op <= "01";
                when ADDI =>
                    mux_const_addi <= '1';
                    ula_op <= "00";
                
                when WRI =>
                    write_ir <= '1';
                

                when others =>
                    pc_inc <= '0';
                    write_ir <= '0';
                    mux_const_addi <= '0';
            end case;

        elsif state = "10" then
            pc_inc <= '0';
            write_ir <= '0';
            mux_const_addi <= '0';
        end if;
    
    end process;

end architecture Behavioral;