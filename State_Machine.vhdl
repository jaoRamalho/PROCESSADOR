library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity State_Machine is
   port( 
        clk   : in std_logic;
        rst   : in std_logic;
        state : out unsigned(1 downto 0)
    );
end entity;

architecture a_State_Machine of State_Machine is
   signal state_s: unsigned(1 downto 0);
begin
   process(clk,rst)
   begin
      if rst='1' then
         state_s <= "00";
      elsif rising_edge(clk) then
         if state_s="10" then        -- se agora esta em 3
            state_s <= "00";         -- o prox vai voltar ao zero
         else
            state_s <= state_s + 1;   -- senao avanca
         end if;
      end if;
   end process;
   state <= state_s;
end architecture;