library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity MUX_acc is
    port(
        out_acc      : in  unsigned(15 downto 0);
        out_register : in  unsigned(15 downto 0);  
        out_constant : in  unsigned(15 downto 0);
        sel          : in  unsigned (1 downto 0);
        out_mux      : out unsigned(15 downto 0)
    );
end entity MUX_acc;


architecture Behavioral of MUX_acc is
begin
    out_mux <=  out_acc when sel = "01" else 
                out_register when sel = "00" else
                out_constant when sel = "10" else
                out_register;
    
end architecture Behavioral;
