library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Processador is
    port(
        clk : in std_logic;  -- Clock
        rst : in std_logic   -- Reset
    );
end Processador;

architecture behavior of Processador is

    -- Component Declaration for the Unit Under Test (UUT)
    component ACCUMULATOR is
        port (
            clk           : in  std_logic;
            rst           : in  std_logic;
            write_en_acc  : in  std_logic;
            data_in_acc   : in  unsigned(15 downto 0);
            out_acc       : out unsigned(15 downto 0)
        );
    end component;

    component MUX_acc is
        port(
            out_acc      : in  unsigned(15 downto 0);
            out_register : in  unsigned(15 downto 0);  
            sel          : in  std_logic;
            out_mux      : out unsigned(15 downto 0)
        );
    end component;

    component REGISTER_FILE is
        port (
            clk             : in  std_logic;
            rst             : in  std_logic;
            write_en        : in  std_logic; 
            write_address   : in  unsigned(2 downto 0);
            read_address1   : in  unsigned(2 downto 0);
            read_address2   : in  unsigned(2 downto 0);
            data_in         : in  unsigned(15 downto 0);
            read_data1      : out unsigned(15 downto 0);
            read_data2      : out unsigned(15 downto 0)
        );
    end component;

    component ULA is
        port (
            a_in       : in  unsigned(15 downto 0);
            b_in       : in  unsigned(15 downto 0);
            operation  : in  unsigned(1 downto 0);
            out_ula    : out unsigned(15 downto 0);
            Flag_zero  : out std_logic;
            Flag_sinal : out std_logic;
            Flag_borrow: out std_logic
        );
    end component;

    component ROM is
        port (
            clk     : in  std_logic;
            address : in  unsigned(6 downto 0);
            data    : out unsigned(16 downto 0)
        );
    end component;

    component MUX_registerFile is
        port(
            data_rom : in  unsigned(15 downto 0);
            data_ula : in  unsigned(15 downto 0);  
            sel       : in  std_logic;
            out_mux   : out unsigned(15 downto 0)
        );
    end component;

    component Control_Unit is
        port(
            clk                         : in  std_logic;
            rst                         : in  std_logic;
            instruction                 : in  unsigned(6 downto 0); -- Instrução de 7 bits

            Flag_zero                   : in  std_logic; -- Flag de zero
            Flag_sinal                  : in  std_logic; -- Flag de sinal
            Flag_borrow                 : in  std_logic; -- Flag de borrow

            -- Sinais de controle
            pc_increment                : out std_logic;
            write_instruction_register  : out std_logic;
            mux_constant_addi_select    : out std_logic;
            alu_operation               : out unsigned(1 downto 0);
            mux_accumulator_select      : out std_logic;
            accumulator_write_enable    : out std_logic;
            register_file_mux_select    : out std_logic;
            register_address_mux_select : out std_logic;
            pc_source_select            : out unsigned(1 downto 0)
        );
    end component;

    component PC is
        port(
            clk              : in std_logic;
            reset            : in std_logic;
            pc_increment     : in std_logic;
            pc_source_select : in unsigned(1 downto 0);
            pc_in            : in unsigned(6 downto 0);
            pc_out           : out unsigned(6 downto 0)
        );
    end component;

    component MUX_Constante is
        port(
            constante    : in  unsigned(15 downto 0);
            out_register : in  unsigned(15 downto 0);  
            sel          : in  std_logic;
            out_mux      : out unsigned(15 downto 0)
        );
    end component;

    component MUX_reg_add is
        port(
            data_default   : in  unsigned(2 downto 0);
            data_operation : in  unsigned(2 downto 0);  
            sel            : in  std_logic;
            out_mux        : out unsigned(2 downto 0)
        );
    end component;

    -- Sinais internos renomeados para maior clareza
    signal opcode                      : unsigned(3 downto 0) := (others => '0');
    signal pc_increment                : std_logic;
    signal write_instruction_register  : std_logic;
    signal pc_output                   : unsigned(6 downto 0);
    signal mux_constant_addi_select    : std_logic;
    signal mux_accumulator_select      : std_logic := '0';
    signal alu_operation               : unsigned(1 downto 0);
    signal register_output             : unsigned(15 downto 0);
    signal register_file_output1       : unsigned(15 downto 0);
    signal register_file_output2       : unsigned(15 downto 0);
    signal alu_output                  : unsigned(15 downto 0);
    signal accumulator_output          : unsigned(15 downto 0);
    signal rom_data                    : unsigned(16 downto 0);
    signal mux_output                  : unsigned(15 downto 0);
    signal accumulator_write_enable    : std_logic;
    signal register_file_mux_select    : std_logic;
    signal register_address            : unsigned(2 downto 0);
    signal register_address_mux_select : std_logic;
    signal pc_source_select            : unsigned(1 downto 0);
    
    signal flag_borrow                 : std_logic;
    signal flag_zero                   : std_logic;
    signal flag_sinal                  : std_logic;

    signal register_file_data_in       : unsigned(15 downto 0);

begin

    program_counter : PC
    port map(
        clk              => clk,
        reset            => rst,
        pc_increment     => pc_increment,
        pc_source_select => pc_source_select,
        pc_in            => rom_data(9 downto 3),
        pc_out           => pc_output
    );

    instruction_memory : ROM
    port map(
        clk     => clk,
        address => pc_output,
        data    => rom_data
    );

    cu : Control_Unit
    port map(
        clk                         => clk,
        rst                         => rst,
        instruction                 => rom_data(16 downto 13) & rom_data(2 downto 0),
        pc_increment                => pc_increment,
        write_instruction_register  => write_instruction_register,
        mux_constant_addi_select    => mux_constant_addi_select,
        alu_operation               => alu_operation,
        mux_accumulator_select      => mux_accumulator_select,
        accumulator_write_enable    => accumulator_write_enable,
        register_file_mux_select    => register_file_mux_select,
        register_address_mux_select => register_address_mux_select,
        pc_source_select            => pc_source_select,
        Flag_zero                   => flag_zero,
        Flag_sinal                  => flag_sinal,
        Flag_borrow                 => flag_borrow
    );

    register_file_mux : MUX_registerFile
    port map(
        data_rom  => "000000000000" & rom_data(6 downto 3),
        data_ula  => alu_output,
        sel       => register_file_mux_select,
        out_mux   => register_file_data_in
    );

    register_address_mux : MUX_reg_add
    port map(
        data_default   => rom_data(12 downto 10),
        data_operation => rom_data(6 downto 4),
        sel            => register_address_mux_select,
        out_mux        => register_address
    );

    rg : REGISTER_FILE
    port map(
        clk           => clk,
        rst           => rst,
        write_en      => write_instruction_register,
        write_address => register_address,
        read_address1 => rom_data(12 downto 10),
        read_address2 => rom_data(9 downto 7),
        data_in       => register_file_data_in,
        read_data1    => register_file_output1,
        read_data2    => register_file_output2
    );

    acc : ACCUMULATOR
    port map(
        clk          => clk,
        rst          => rst,
        write_en_acc => accumulator_write_enable,
        data_in_acc  => alu_output,
        out_acc      => accumulator_output
    );

    accumulator_mux : MUX_acc
    port map(
        out_acc      => accumulator_output,
        out_register => register_file_output2,
        sel          => mux_accumulator_select,
        out_mux      => mux_output
    );

    constant_mux : MUX_Constante
    port map(
        constante    => "000000000000" & rom_data(6 downto 3),
        out_register => register_file_output1,
        sel          => mux_constant_addi_select,
        out_mux      => register_output
    );

    alu : ULA
    port map(
        a_in        => mux_output,
        b_in        => register_output,
        operation   => alu_operation,
        out_ula     => alu_output,
        Flag_zero   => flag_zero,
        Flag_sinal  => flag_sinal,
        Flag_borrow => flag_borrow
    );

end architecture behavior;