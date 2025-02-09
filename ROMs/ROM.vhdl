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

      0 => B"1101_001_0000011110", -- WRI r1, 30
      1 => B"1101_011_0000000000", -- WRI r3, 0
      2 => B"1101_100_0000000000", -- WRI r4, 0
      3 => B"0011_100_011_100_0000", -- ADD r4, r3, r4
      4 => B"1011_011_011_0000001", -- ADDI r3, r3, 1
      5 => B"1001_011_001_1111101", -- BGT r3, r1, -3
      6 => B"1101_101_0000000000", -- WRI r5, 0
      7 => B"0011_100_101_101_0000", -- ADD r5, r4, r5


      27 => B"1101_110_0000000011", -- WRI r6, 3
      28 => B"1111_001_110_0000000", -- SW r6, 0(r1) (r1 enderecoe r6 conteudo)
      29 => B"1101_101_0011111111", -- WRI r1, 0
      30 => B"1101_110_0000000000", -- WRI r6, 0
      31 => B"1111_110_101_0000000", --


      32 => B"1100_110_010_0000000", -- LW r2, 0(r1) (edereco de leitura e endereco de destino)
      33 => B"1100_001_011_0000000",

      
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