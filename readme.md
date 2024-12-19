# Esclarecimentos

Junto com esse readme tem um arquivo chamado "formas_de_onda.gkw" nele estão as formas de onda do lab6.

O top_level é o "processador.vhdl".

# OBBS:
Estou utilizando o README do laboratório anterior; contudo, existem alterações que ainda não foram documentadas. Portanto, a explicação do protocolo pode diferir um pouco da versão atual. Apesar disso, continua sendo uma boa referência.

# Protocolo de Instruções

## Estrutura da Instrução

As instruções têm 17 bits e podem ser divididas em diferentes tipos: Tipo R, Tipo I e Tipo J. Cada tipo de instrução usa os bits de maneira diferente para representar o opcode, registradores e valores imediatos.

### Tipo R (Register)

As instruções do Tipo R realizam operações entre registradores. A estrutura é a seguinte:

| Bits         | Campo                     | Descrição                                                                 |
|--------------|---------------------------|---------------------------------------------------------------------------|
| 16 downto 13 | Opcode                    | Código de operação (4 bits)                                               |
| 12 downto 9  | Registrador Destino (Rd)  | Seleciona qual registrador será escrito                                   |
| 8 downto 6   | Registrador Fonte 1 (Rs1) | Seleciona o primeiro registrador a ser lido                               |
| 5 downto 3   | Registrador Fonte 2 (Rs2) | Seleciona o segundo registrador a ser lido ou indica operação específica  |
| 2 downto 0   | Função                    | Utilizado para funções adicionais                                         |

**Exemplo:**

- `0011_100_011_101_0001` (ADD r5, r4, r3)
  - Opcode: `0011` (ADD)
  - Rd: `100` (r5)
  - Rs1: `011` (r4)
  - Rs2: `101` (r3)
  - Função: `0001`

### Tipo I (Immediate)

As instruções do Tipo I utilizam um valor imediato. A estrutura é a seguinte:

| Bits         | Campo                     | Descrição                                                                 |
|--------------|---------------------------|---------------------------------------------------------------------------|
| 16 downto 13 | Opcode                    | Código de operação (4 bits)                                               |
| 12 downto 9  | Registrador Destino (Rd)  | Seleciona qual registrador será escrito                                   |
| 8 downto 3   | Constante                 | Valor imediato a ser utilizado                                            |
| 2 downto 0   | Função                    | Função adicional                                                          |

**Exemplo:**

- `1101_011_0000101_010` (LI r3, 5)
  - Opcode: `1101` (LI)
  - Rd: `011` (r3)
  - Constante: `0000101` (5)
  - Função: `010`

### Tipo J (Jump)

As instruções do Tipo J realizam saltos para um endereço específico. A estrutura é a seguinte:

| Bits         | Campo                     | Descrição                                                                 |
|--------------|---------------------------|---------------------------------------------------------------------------|
| 16 downto 13 | Opcode                    | Código de operação (4 bits)                                               |
| 12 downto 0  | Endereço                  | Endereço de destino da instrução                                          |

**Exemplo:**

- `1110_0000010100_000` (J 20)
  - Opcode: `1110` (JMP)
  - Endereço: `0000010100` (20)

## Exemplos de Instruções

Vamos revisar as instruções definidas no seu arquivo `ROM.vhdl`:

```vhdl
0 => B"0000_0000000000000", -- faz nada - nop
1 => B"1101_011_0000101_010", -- coloca 5 no registrador 3 - li r3, 5
2 => B"1101_100_0001000_010", -- coloca 8 no registrador 4 - li r4, 8
3 => B"0011_100_011_101_0001", -- soma os valores dos registradores 4 e 3 e coloca no registrador 5 - add r5, r4, r3
4 => B"0111_101_101_0001_010", -- subtrai 1 do valor do registrador 5 e coloca no registrador 5 - subi r5, r5, 1
5 => B"1110_0000010100_000", -- salta para o endereco 20 - j 20
6 => B"1101_011_0000000_010", -- coloca 0 no registrador 3 - li r3, 0
7 => B"0000_0000000000000", -- faz nada - nop
8 => B"0000_0000000000000", -- faz nada - nop
9 => B"0000_0000000000000", -- faz nada - nop
10 => B"0000_0000000000000", -- faz nada - nop
11 => B"0000_0000000000000", -- faz nada - nop
12 => B"0000_0000000000000", -- faz nada - nop
13 => B"0000_0000000000000", -- faz nada - nop
14 => B"0000_0000000000000", -- faz nada - nop
15 => B"0000_0000000000000", -- faz nada - nop
16 => B"0000_0000000000000", -- faz nada - nop
17 => B"0000_0000000000000", -- faz nada - nop
18 => B"0000_0000000000000", -- faz nada - nop
19 => B"0000_0000000000000", -- faz nada - nop
20 => B"0011_000_101_011_0001", -- soma os valores dos registradores 0 e 3 e coloca no registrador 5 - add r5, r0, r3
21 => B"1110_0000000011_000", -- salta para o endereco 3 - j 3