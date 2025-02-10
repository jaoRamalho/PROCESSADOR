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

      -- 0 => B"1101_001_0000100000", -- WRI r1, 32 (limite superior)
      -- 1 => B"1101_010_0000000010", -- WRI r2, 0 (contador)
      -- 2 => B"0100_010_001_011_0000", -- SUB r3, r1, r2 (indexador)

      0  => B"1101_001_0000100000", -- WRI r1, 32 (limite superior)
      1  => B"1101_010_0000000000", -- WRI r2, 0 (contador)
      2  => B"1101_011_0000000000", -- WRI r3, 0 (indexador)
      
      -- Loop para preencher a RAM com números de 0 a 31
      3  => B"1111_010_010_0000000", -- SW r2, 0(r2) (escreve r2 na RAM no endereço r2)
      4  => B"1011_010_010_0000001", -- ADDI r2, r2, 1 (incrementa r2)
      5  => B"1001_010_001_1111101", -- BGT r2, r1, -3 (volta para a instrução 4 se r2 <= r1)
      
      6  => B"1101_100_0000000010", -- WRI r4, 0 (registrador de controle)
      7  => B"1101_010_0000000000", -- WRI r2, 0 (contador)
      
      8  => B"1100_100_101_0000000", -- LW r5, 0(r4) (carrega o valor a ser eliminado)
      9 => B"0011_100_101_101_0000", -- ADD r5, r5, r4 (incrementa r5 com o valor de multiplos)
      10  => B"1111_101_000_0000000", -- SW r0, 0(r5) (escreve 0 no endereco que está em r5)
      11  => B"1001_101_001_1111101", -- BGT r5, r1, -3 (volta para a instrução 4 se r5 <= r1)
      12  => B"1011_010_010_0000001", -- ADDI r2, r2, 1 (incrementa r2)
      13  => B"1011_100_100_0000001", -- ADDI r4, r4, 1 (incrementa r4)
      14  => B"1101_101_0000000000", -- WRI r5, 0 (zera r5)
      15  => B"1001_010_001_1111000", -- BGT r2, r1, -9 (volta para a instrução 4 se r2 <= r1)

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