library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Formato de bits: [OPCODE(4b), FUNCTION(3b)]

entity Control_Unit is
    port(
        clk                         : in  std_logic;
        rst                         : in  std_logic;
        instruction                 : in  unsigned(6 downto 0); -- Instrução de 7 bits, 4b de opcode e 3b de função
        
        Flag_zero                   : in std_logic; -- Sinal de flag zero
        Flag_sinal                  : in std_logic; -- Sinal de flag de sinal
        Flag_borrow                 : in std_logic; -- Sinal de flag de borrow

        -- Sinais de controle
        pc_increment                : out std_logic;
        write_instruction_register  : out std_logic;
        mux_constant_addi_select    : out std_logic;
        alu_operation               : out unsigned(1 downto 0);
        mux_accumulator_select      : out unsigned(1 downto 0);
        accumulator_write_enable    : out std_logic;
        register_file_mux_select    : out unsigned(1 downto 0);
        register_address_mux_select : out std_logic;
        pc_source_select            : out unsigned(1 downto 0);
        update_flags                : out std_logic;
        write_ram                   : out std_logic
    );
end entity Control_Unit;

architecture Behavioral of Control_Unit is

    -- Definição dos opcodes
    constant NOP    : unsigned(3 downto 0) := "0000"; -- Nenhuma operação
    constant LDA    : unsigned(3 downto 0) := "0001"; -- Carrega um valor direto no acumulador
    constant STA    : unsigned(3 downto 0) := "0010"; -- Armazena o valor do acumulador em um registrador
    constant ADD    : unsigned(3 downto 0) := "0011"; -- Soma o valor do acumulador com o valor de um registrador
    constant SUB    : unsigned(3 downto 0) := "0100"; -- Subtrai o valor do acumulador pelo valor de um registrador
    constant INV    : unsigned(3 downto 0) := "0101"; -- Inverte o valor de um registrador
    constant OP_XOR : unsigned(3 downto 0) := "0110"; -- XOR entre acumulador e registrador
    constant SUBI   : unsigned(3 downto 0) := "0111"; -- Subtrai um valor constante do acumulador
    constant CPY    : unsigned(3 downto 0) := "1000"; -- Copia o valor de um registrador para outro
    constant BGT    : unsigned(3 downto 0) := "1001"; -- Branch if greater than
    constant BVC    : unsigned(3 downto 0) := "1010"; -- Branch if overflow clear
    constant ADDI   : unsigned(3 downto 0) := "1011"; -- Soma um valor constante ao acumulador
    constant LW     : unsigned(3 downto 0) := "1100"; -- Carrega um valor da memória para um registrador
    constant WRI    : unsigned(3 downto 0) := "1101"; -- Escreve no registrador o valor de uma constante
    constant JMP    : unsigned(3 downto 0) := "1110"; -- Salto incondicional
    constant SW     : unsigned(3 downto 0) := "1111"; -- Armazena um valor de um registrador na memória
    
    -- Sinais internos para decodificação
    signal state      : unsigned(1 downto 0) := "00";
    signal opcode     : unsigned(3 downto 0) := "0000";
    signal funct      : unsigned(2 downto 0) := "000";

    -- Declaração da máquina de estados
    component State_Machine is
        port(
            clk   : in std_logic;
            rst   : in std_logic;
            state : out unsigned(1 downto 0)
        );
    end component;

begin
    -- Instância da máquina de estados
    sM : State_Machine
        port map(
            clk   => clk,
            rst   => rst,
            state => state
        );
        
    -- Atribuição do opcode e funct
    opcode <= instruction(6 downto 3) when (state = "01") else (others => '0');
    funct  <= instruction(2 downto 0) when (state = "01") else (others => '0');

    write_ram <= '1' when (opcode = SW and state = "01") else '0';

    -- Incremento do PC
    pc_increment <= '1' when state = "00" else '0';
    
    pc_source_select <= "01" when (opcode = JMP and state = "01") else 
    "11" when (opcode = BGT and state = "01" and Flag_zero = '0') else 
    "11" when (opcode = BVC and state = "01" and Flag_borrow = '0') else 
    "00";
    
    -- Lógica dos sinais de controle
    register_file_mux_select <= "00" when (state = "01" and (opcode = LDA or opcode = ADD  or opcode = ADDI or opcode = SUBI or opcode = BGT or opcode = SUB )) else 
                                "10" when (state = "01" and opcode = LW) else
                                "11";
                                
                                
    write_instruction_register <= '1' when (state = "01" and (opcode = WRI or opcode = ADD or opcode = SUBI or opcode = ADDI or opcode = SUB)) else '0';
    
    accumulator_write_enable <= '1' when (opcode = LDA and state = "01") else '0';
    register_address_mux_select <= '1' when (state = "01" and opcode = ADD) else '0';
    
    mux_accumulator_select <= "00" when ((opcode = ADD or opcode = WRI or opcode = ADDI or opcode = SUBI or opcode = SUB or opcode = BGT) and state = "01") else 
                              "10" when (opcode = SW and state = "01") else
                              "01";
    -- Seleção do mux constante/addi (comentado caso não seja usado)
    mux_constant_addi_select <= '1' when (state = "01" and (opcode = SUBI or opcode = ADDI)) else '0';
    
    -- Operação da ULA
    alu_operation <=
        "00" when ((opcode = ADD or opcode = ADDI or opcode = SW) and state = "01") else
        "01" when (((opcode = SUB or opcode = SUBI or opcode = BGT) and state = "01")) else
        "10" when (opcode = OP_XOR and state = "01") else
        "11" when (opcode = INV and state = "01") else
        (others => '0');

    update_flags <= '1' when (opcode = ADD or opcode = SUB or opcode = ADDI or opcode = SUBI or opcode = BGT) else '0';

end architecture Behavioral;