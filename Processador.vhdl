library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Processador is
    port(
        clk           : in  std_logic;                         -- Clock
        rst           : in  std_logic                          -- Reset
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
            ula_out      : in  unsigned(15 downto 0);
            out_register : in  unsigned(15 downto 0);  
            sel          : in  std_logic;
            out_mux      : out unsigned(15 downto 0)
        );
    end component;

    component REGISTER_FILE is
        port (
            clk             : in  std_logic;                           -- Clock
            rst             : in  std_logic;                           -- Reset
            write_en        : in  std_logic; 
            address         : in  unsigned(2 downto 0);        -- Endereço do registrador
            address2        : in  unsigned(2 downto 0);        -- Endereço do registrador 2
            data_in         : in  unsigned(15 downto 0);       -- Dados de entrada
            data_out        : out unsigned(15 downto 0);        -- Dados de saída
            data_out2       : out unsigned(15 downto 0)        -- Dados de saída 2
        );
    end component;

    component ULA is
        port (
            a_in       : in  unsigned(15 downto 0);
            b_in       : in  unsigned(15 downto 0);
            operation  : in  unsigned(1 downto 0);
            out_ula    : out unsigned(15 downto 0);
            Flag_zero  : out std_logic;
            flag_sinal : out std_logic
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
        port (
            clk             : in  std_logic;
            reset           : in  std_logic;
            instruction     : in  unsigned(6 downto 0); -- Instrução de 4 bits

            -- Sinais de controle
            pc_inc          : out std_logic;
            write_ir        : out std_logic;
            mux_const_addi  : out std_logic;
            ula_op          : out unsigned(1 downto 0);
            mux_acc_sel     : out std_logic;
            write_en_acc    : out std_logic;
            mux_rg_sel      : out std_logic
        );
    end component;

    component PC is
        port(
            clk      : in std_logic;
            reset    : in std_logic;
            enable   : in std_logic;
            pc_out   : out unsigned(6 downto 0)
        );
    end component;

    component MUX_Constante is
        port(
            constante : in  unsigned(15 downto 0);
            out_register : in  unsigned(15 downto 0);  
            sel       : in  std_logic;
            out_mux   : out unsigned(15 downto 0)
        );
    end component;

    signal instruction    : unsigned(3 downto 0) := (others => '0');
    signal pc_inc         : std_logic;
    signal write_ir       : std_logic;
    signal pc_out         : unsigned(6 downto 0);
    signal mux_const_addi : std_logic;
    signal mux_acc_sel    : std_logic := '0';
    signal ula_op         : unsigned(1 downto 0);
    signal register_out   : unsigned(15 downto 0);
    signal data_out_rg    : unsigned(15 downto 0);
    signal data_out_rg2   : unsigned(15 downto 0);
    signal out_ula        : unsigned(15 downto 0);
    signal out_acc        : unsigned(15 downto 0);
    signal Flag_zero      : std_logic;
    signal Flag_sinal     : std_logic;
    signal data_rom       : unsigned(16 downto 0);
    signal in_ula         : unsigned(15 downto 0);
    signal write_en_acc   : std_logic;
    signal mux_rg_sel     : std_logic;

    signal data_in_registes  : unsigned(15 downto 0);

begin
    
    pc_b : PC
    port map(
        clk    => clk,
        reset  => rst,
        enable => pc_inc,
        pc_out => pc_out
    );

    
    rom_b : ROM
    port map(
        clk     => clk,
        address => pc_out,
        data    => data_rom
    );
    
    control_unit_b : Control_Unit
    port map(
        clk            => clk,
        reset          => rst,
        instruction    => data_rom(16 downto 13) & data_rom(2 downto 0),
        pc_inc         => pc_inc,
        write_ir       => write_ir,
        mux_const_addi => mux_const_addi,
        ula_op         => ula_op,
        mux_acc_sel    => mux_acc_sel,
        write_en_acc   => write_en_acc,
        mux_rg_sel     => mux_rg_sel
    );
            
    mux_rg : MUX_registerFile
    port map(
        data_rom     => "0000000000" & data_rom(8 downto 3),
        data_ula     => out_ula,
        sel          => mux_rg_sel,
        out_mux      => data_in_registes
    );

    rg : REGISTER_FILE
    port map(
        clk       => clk,
        rst       => rst,
        write_en  => write_ir,
        address   => data_rom(12 downto 10),
        address2  => data_rom(9 downto 7),
        data_in   => data_in_registes,
        data_out  => data_out_rg,
        data_out2 => data_out_rg2
    );

    acc : ACCUMULATOR
    port map(
        clk          => clk,
        rst          => rst,
        write_en_acc => write_en_acc,
        data_in_acc  => out_ula,
        out_acc      => out_acc
    );

    muuxccc : MUX_acc
    port map(
        ula_out      => out_ula,
        out_register => data_out_rg2,
        sel          => mux_acc_sel,
        out_mux      => in_ula
    );

    mux_const : MUX_Constante
    port map(
        constante    => "0000000000" & data_rom(8 downto 3),
        out_register => data_out_rg,
        sel          => mux_const_addi,
        out_mux      => register_out
    );

    ula_b : ULA
    port map(
        a_in       => register_out,
        b_in       => in_ula,
        operation  => ula_op,
        out_ula    => out_ula,
        Flag_zero  => Flag_zero,
        flag_sinal => Flag_sinal
    );


end architecture behavior;