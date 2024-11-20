library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ROM is
   port( 
        clk      : in std_logic;
        address : in unsigned(6 downto 0);
        dado     : out unsigned(16 downto 0) 
   );
end entity;

architecture a_ROM of ROM is

   type mem is array (0 to 127) of unsigned(16 downto 0);
   constant conteudo_ROM : mem := (
      -- caso address => conteudo
      others => (others=>'0')
   );

begin

   process(clk)
   begin
      if(rising_edge(clk)) then
         dado <= conteudo_ROM(to_integer(address));
      end if;
   end process;

end architecture;