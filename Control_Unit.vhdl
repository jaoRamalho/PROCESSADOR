library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--- NÃO ESTÁ PRONTO, TEM APENAS O O CORPO PARA O CONTROL UNIT ---
-- FALTA ADICIONAR MAIS SINAIS DE CONTROLE (PROVAVELMENTE) E ADICIONAR AS INSTRUÇÕES RESTANTES
-- MAQUINA DE ESTADOS ESTÁ PRATICAMENTE PRONTA, INCREMENTADOR NO PC TBM



---- Formato das instrucoes -----------------
-- 0000 0 000 
-- Primeiros 4 bits (16:13): opcode
-- Proximos 1 bit(12): dado antigo da ula (0) ou constante (1)
-- Proximos 3 bits(11:9): registrador de saida

--- Provavelmente diminuir o numero de bits de sinais




entity Control_Unit is
    port(
        clk         : in std_logic;
        reset       : in  std_logic;
        instruction : in std_logic_vector(16 downto 0);

        ---- sinais de controle ----
        mem_read       : out std_logic;
        pc_inc         : out std_logic;
        
        mux_const_addi : out std_logic;
        mux_control_acc: out std_logic;
        write_en_acc   : out std_logic;

        ula_op         : out std_logic_vector(1 downto 0);
        ula_enable     : out std_logic;
        
        reg_write      : out std_logic;
        write_reg      : out std_logic_vector(2 downto 0);
        read_reg       : out std_logic_vector(2 downto 0)

        --- Talvez add mais sinais de controle ---
    );
end entity Control_Unit;


architecture Behavioral of Control_Unit is
    type state_type is (IDLE, FETCH, DECODE, EXECUTE);
    signal current_state, next_state : state_type;

    signal opcode : std_logic_vector(3 downto 0);

    -- Opcode Definitions
    constant ADD   : std_logic_vector(3 downto 0) := "0001";
    constant ADDI  : std_logic_vector(3 downto 0) := "0010";
    constant SUB   : std_logic_vector(3 downto 0) := "0011";
    constant SUBB  : std_logic_vector(3 downto 0) := "0100";
    constant LD    : std_logic_vector(3 downto 0) := "0101";
    constant BGT   : std_logic_vector(3 downto 0) := "0110";
    constant BVC   : std_logic_vector(3 downto 0) := "0111";
    constant CJNE  : std_logic_vector(3 downto 0) := "1000";
    constant JMP   : std_logic_vector(3 downto 0) := "1001";

begin

    ---------- Logic for State Machine ---------------
    process(clk, reset)
    begin
        if reset = '1' then
            current_state <= IDLE;
        elsif rising_edge(clk) then
            current_state <= next_state;
        end if;
    end process;
    -----------------------------------------------------


    process(current_state, instruction)
    begin
        next_state  <= current_state;

        case current_state is
            when IDLE =>
                if enable = '1' then
                    next_state <= FETCH;
                end if;

            when FETCH =>
                -- Fetch Instruction from ROM
                mem_read   <= '1';  -- mem_read
                pc_inc     <= '1';  -- pc_inc
                next_state <= DECODE;

            when DECODE =>
                -- Decode Opcode
                case instruction(16 downto 13) is
                    when ADD  =>
                        next_state <= EXECUTE;
                    when ADDI =>
                        next_state <= EXECUTE;
                    when SUB  =>
                        next_state <= EXECUTE;
                    when SUBB =>
                        next_state <= EXECUTE;
                    when LD   =>
                        next_state <= EXECUTE;
                    when BGT  =>
                        next_state <= EXECUTE;
                    when BVC  =>
                        next_state <= EXECUTE;
                    when CJNE =>
                        next_state <= EXECUTE;
                    when JMP  =>
                        next_state <= EXECUTE;
                    when others =>
                        next_state <= IDLE;
                end case;

            
                when EXECUTE =>
                case instruction(16 downto 13) is
                    when ADD =>
                        ula_enable <= '1';
                        ula_op <= "00";
                        mux_const_addi <= '0';

                    when ADDI =>
                        ula_enable <= '1';
                        ula_op <= "00";
                        mux_const_addi <= '1';

                    when SUB =>
                        ula_enable <= '1';
                        ula_op <= "01";

                    when SUBB =>
                        --- Mudar para adiconar o carry ---
                        ula_enable <= '1';
                        ula_op <= "11";

                    when LD =>

                    when BGT =>

                    when BVC =>

                    when CJNE =>

                    when JMP =>

                    when others =>
                        ula_enable <= '0';
                    
                end case;

            when others =>
                next_state <= IDLE;
        end case;
    end process;
