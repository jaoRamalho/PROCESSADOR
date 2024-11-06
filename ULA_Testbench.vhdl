library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ULA_Testbench is
end ULA_Testbench;

architecture behavior of ULA_Testbench is

    -- Component Declaration for the Unit Under Test (UUT)
    component ULA
    port(
        a_in       : in  std_logic_vector(15 downto 0);
        b_in       : in  std_logic_vector(15 downto 0);
        operation  : in  std_logic_vector(1 downto 0);
        out_ula    : out std_logic_vector(15 downto 0);
        Flag_zero  : out std_logic;
        flag_sinal : out std_logic -- Add this line if flag_sinal is a port in ULA
    );
    end component;

    -- Signals to connect to the UUT
    signal a_in       : std_logic_vector(15 downto 0) := (others => '0');
    signal b_in       : std_logic_vector(15 downto 0) := (others => '0');
    signal operation  : std_logic_vector(1 downto 0) := (others => '0');
    signal out_ula    : std_logic_vector(15 downto 0);
    signal Flag_zero  : std_logic;
    signal flag_sinal : std_logic; -- Add this line if flag_sinal is a port in ULA

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: ULA
    port map (
        a_in => a_in,
        b_in => b_in,
        operation => operation,
        out_ula => out_ula,
        Flag_zero => Flag_zero,
        flag_sinal => flag_sinal -- Add this line if flag_sinal is a port in ULA
    );

    -- Stimulus process
    stim_proc: process
    begin
        -- Initialize Inputs
        a_in <= (others => '0');
        b_in <= (others => '0');
        operation <= "00"; -- Example operation code

        -- Wait for 100 ns for global reset to finish
        wait for 100 ns;

        -- Add stimulus here
        a_in <= "0000000000000001";
        b_in <= "0000000000000010";
        operation <= "00"; -- Example operation code -> ADD

        wait for 100 ns;

        -- Add more stimulus as needed
        a_in <= "0000000000000101";
        b_in <= "0000000000000100";
        operation <= "01"; -- Example operation code -> SUB

        wait for 100 ns;

        a_in <= "0000000000000010";
        operation <= "10"; -- Example operation code -> INV
        
        wait for 100 ns;
        
        a_in <= "0000000000000011";
        b_in <= "0000000000000110";
        operation <= "11"; -- Example operation code -> XOR

        wait for 100 ns;

        -- ADD operation with negative numbers
        a_in <= "1111111111111111"; -- -1 em complemento de dois
        b_in <= "1111111111111110"; -- -2 em complemento de dois
        operation <= "00"; -- Código de operação para ADD

        wait for 100 ns;

        -- SUB operation with negative numbers
        a_in <= "1111111111111101"; -- -3 em complemento de dois
        b_in <= "1111111111111100"; -- -4 em complemento de dois
        operation <= "01"; -- Código de operação para SUB

        wait for 100 ns;

        -- XOR operation with negative numbers
        a_in <= "1111111111111011"; -- -5 em complemento de dois
            operation <= "10"; -- Código de operação para INV
            
        wait for 100 ns;
            
        -- INV operation with negative number
        a_in <= "1111111111111001"; -- -7 em complemento de dois
        b_in <= "1111111111111010"; -- -6 em complemento de dois
        operation <= "11"; -- Código de operação para XOR

        wait for 100 ns;


        -- End simulation
        wait;
    end process;

end behavior;