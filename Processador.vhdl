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

    component RAM is
        port (
            clk      : in std_logic;
            endereco : in unsigned(6 downto 0);
            wr_en    : in std_logic;
            dado_in  : in unsigned(15 downto 0);
            dado_out : out unsigned(15 downto 0) 
        );
    end component;

    component MUX_acc is
        port(
            out_acc      : in  unsigned(15 downto 0);
            out_register : in  unsigned(15 downto 0); 
            out_constant : in  unsigned(15 downto 0); 
            sel          : in  unsigned (1 downto 0);
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
            Flag_borrow: out std_logic;
            update_flags: in  std_logic;
            clk        : in  std_logic
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
            data_ram : in  unsigned(15 downto 0);
            sel       : in  unsigned(1 downto 0);
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
            mux_accumulator_select      : out unsigned(1 downto 0);
            accumulator_write_enable    : out std_logic;
            register_file_mux_select    : out unsigned(1 downto 0);
            register_address_mux_select : out unsigned(1 downto 0);
            pc_source_select            : out unsigned(1 downto 0);
            update_flags                : out std_logic;
            write_ram                   : out std_logic
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

    component Mux_pc_in is
        port(
            jmp   : in  unsigned(6 downto 0);
            b     : in  unsigned(6 downto 0);
            sel   : in  std_logic;
            out_mux : out unsigned(6 downto 0)
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
            address_ram     : in  unsigned(2 downto 0);  
            sel            : in  unsigned(1 downto 0);
            out_mux        : out unsigned(2 downto 0)
        );
    end component;

    -- Sinais internos renomeados para maior clareza
    signal opcode                      : unsigned(3 downto 0) := (others => '0');
    signal pc_increment                : std_logic;
    signal write_instruction_register  : std_logic;
    signal pc_output                   : unsigned(6 downto 0);
    signal mux_constant_addi_select    : std_logic;
    signal mux_accumulator_select      : unsigned(1 downto 0);
    signal alu_operation               : unsigned(1 downto 0);
    signal register_output             : unsigned(15 downto 0);
    signal register_file_output1       : unsigned(15 downto 0);
    signal register_file_output2       : unsigned(15 downto 0);
    signal alu_output                  : unsigned(15 downto 0);
    signal accumulator_output          : unsigned(15 downto 0);
    signal rom_data                    : unsigned(16 downto 0);
    signal mux_output                  : unsigned(15 downto 0);
    signal accumulator_write_enable    : std_logic;
    signal register_file_mux_select    : unsigned(1 downto 0);
    signal register_address            : unsigned(2 downto 0);
    signal register_address_mux_select : unsigned(1 downto 0);
    signal pc_source_select            : unsigned(1 downto 0);
    signal update_flags                : std_logic;
    signal write_ram                   : std_logic;
    signal ram_data                    : unsigned(15 downto 0);
    
    signal flag_borrow                 : std_logic;
    signal flag_zero                   : std_logic;
    signal flag_sinal                  : std_logic;

    signal pc_in                       : unsigned(6 downto 0);

    signal register_file_data_in       : unsigned(15 downto 0);

    signal data_rom_condicional        : unsigned(15 downto 0);
    signal data_const_condicional       : unsigned(15 downto 0);

begin
    data_rom_condicional <= ("111111" & rom_data(9 downto 0)) when rom_data(9) = '1' else ("000000" & rom_data(9 downto 0));
    data_const_condicional <= ("111111111" & rom_data(6 downto 0)) when rom_data(6) = '1' else ("000000000" & rom_data(6 downto 0));

    program_counter : PC
    port map(
        clk              => clk,
        reset            => rst,
        pc_increment     => pc_increment,
        pc_source_select => pc_source_select,
        pc_in            => pc_in,
        pc_out           => pc_output
    );

    ram_a : RAM
    port map(
        clk      => clk,
        endereco => alu_output(6 downto 0),
        wr_en    => write_ram,
        dado_in  => register_file_output2,
        dado_out => ram_data
    );

    mux_pc : Mux_pc_in  
    port map(
        jmp     => rom_data(9 downto 3),
        b       => rom_data(6 downto 0),
        sel     => pc_source_select(1),
        out_mux => pc_in
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
        Flag_borrow                 => flag_borrow,
        update_flags                => update_flags,
        write_ram                   => write_ram
    );

    register_file_mux : MUX_registerFile
    port map(
        data_rom  => data_rom_condicional,
        data_ula  => alu_output,
        data_ram  => ram_data,
        sel       => register_file_mux_select,
        out_mux   => register_file_data_in
    );

    register_address_mux : MUX_reg_add
    port map(
        data_default   => rom_data(12 downto 10),
        data_operation => rom_data(6 downto 4),
        address_ram     => rom_data(9 downto 7),
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
        out_constant => data_const_condicional,
        sel          => mux_accumulator_select,
        out_mux      => mux_output
    );

    constant_mux : MUX_Constante
    port map(
        constante    => data_const_condicional,
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
        Flag_borrow => flag_borrow,
        clk         => clk,
        update_flags => update_flags
    );

end architecture behavior;