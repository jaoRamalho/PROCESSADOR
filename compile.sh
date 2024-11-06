#!/bin/bash

# Analisar todos os arquivos VHDL
ghdl -a --std=08 ADD.vhdl
ghdl -a --std=08 SUB.vhdl
ghdl -a --std=08 INVERSOR.vhdl
ghdl -a --std=08 Modulo_XOR.vhdl
ghdl -a --std=08 MUX.vhdl
ghdl -a --std=08 ULA.vhdl
ghdl -a --std=08 ULA_Testbench.vhdl


# Elaborar o testbench
ghdl -e --std=08 ULA_Testbench

# Executar a simulação e gerar um arquivo de forma de onda
ghdl -r --std=08 ULA_Testbench --wave=ula.ghw

# Verificar se a simulação foi bem-sucedida
if [ $? -ne 0 ]; then
    echo "Erro na simulação"
    exit 1
fi

# Visualizar a forma de onda usando o GTKWave
gtkwave ula.ghw