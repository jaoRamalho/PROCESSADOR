library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Estrutura da Instrução:
-- Vamos considerar que a instrução de 17 bits pode ser dividida em diferentes campos, como opcode, registradores, e valores imediatos. Por exemplo:
--
-- Type R:
--
-- | Bits         | Campo                     | Descrição                                                                 |
-- |--------------|---------------------------|---------------------------------------------------------------------------|
-- | 16 downto 13 | Opcode                    | Código de operação (4 bits)                                               |
-- | 12 downto 9  | Registrador Destino (Rd)  | Seleciona qual registrador será escrito                                   |
-- | 8 downto 6   | Registrador Fonte 1 (Rs1) | Seleciona o primeiro registrador a ser lido                               |
-- | 5 downto 3   | Registrador Fonte 2 (Rs2) | Seleciona o segundo registrador a ser lido ou indica operação específica  |
-- | 2 downto 0   | Imediato/Função           | Utilizado para constantes em instruções imediatas ou funções adicionais   |
--
-- Type I: 
--
-- | Bits         | Campo                     | Descrição                                                                 |
-- |--------------|---------------------------|---------------------------------------------------------------------------|
-- | 16 downto 13 | Opcode                    | Código de operação (4 bits)                                               |
-- | 12 downto 9  | Registrador Destino (Rd)  | Seleciona qual registrador será escrito                                   |
-- | 8 downto 3   | Constante                 | Seleciona o primeiro registrador a ser lido                               |
-- | 2 downto 0   | Funçao                    | Valor da constante que será escrita no registrador                        |
--
-- Type J:
--
-- | Bits         | Campo                     | Descrição                                                                 |
-- |--------------|---------------------------|---------------------------------------------------------------------------|
-- | 16 downto 13 | Opcode                    | Código de operação (4 bits)                                               |
-- | 12 downto 0  | Endereço                  | Endereço de destino da instrução                                          |

entity ROM is
   port( 
        clk      : in std_logic;
        address  : in unsigned(6 downto 0);
        data     : out unsigned(16 downto 0) -- Saída da instrução de 17 bits
   );
end entity;

architecture a_ROM of ROM is

   type mem is array (0 to 127) of unsigned(16 downto 0);
   constant conteudo_ROM : mem := (
      -- Programa que realiza a soma de dois números
      -- Posição => Instrução (Opcode & Operandos)

      -- Instrução 0: ADDI reg0, 1
      0 => "00000000000000000", -- 17 bits 110
      1 => "11010110000101010", -- 17 bits 110
      2 => "11011000001000010", -- 17 bits 110

    
      -- Instruções adicionais podem ser adicionadas conforme necessário
      others => (others => '0')
   );

begin

   process(clk)
   begin
      if rising_edge(clk) then
         data <= conteudo_ROM(to_integer(address));
      end if;
   end process;

end architecture;