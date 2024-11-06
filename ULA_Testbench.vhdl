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
        operation <= "00"; -- Example operation code

        wait for 100 ns;

        -- Add more stimulus as needed
        a_in <= "0000000000000101";
        b_in <= "0000000000000100";
        operation <= "01"; -- Example operation code

        wait for 100 ns;

        a_in <= "0000000000000011";
        b_in <= "0000000000000010";
        operation <= "10"; -- Example operation code

        wait for 100 ns;

        a_in <= "0000000000000111";
        b_in <= "0000000000000110";
        operation <= "11"; -- Example operation code

        wait for 100 ns;

        -- End simulation
        wait;
    end process;

end behavior;