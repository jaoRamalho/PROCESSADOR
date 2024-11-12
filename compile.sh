#!/bin/bash

# Criar o diretório de build se não existir
mkdir -p build

# Analisar todos os arquivos VHDL e especificar o diretório de trabalho
ghdl -a --std=08 --workdir=build ULA/Operations/ADD.vhdl
ghdl -a --std=08 --workdir=build ULA/Operations/SUB.vhdl
ghdl -a --std=08 --workdir=build ULA/Operations/INVERSOR.vhdl
ghdl -a --std=08 --workdir=build ULA/Operations/Modulo_XOR.vhdl
ghdl -a --std=08 --workdir=build ULA/MUX.vhdl
ghdl -a --std=08 --workdir=build ULA/ULA.vhdl
ghdl -a --std=08 --workdir=build ULA_Testbench.vhdl

# Elaborar o testbench e especificar o diretório de trabalho
ghdl -e --std=08 --workdir=build ULA_Testbench

# Executar a simulação e gerar um arquivo de forma de onda
ghdl -r --std=08 --workdir=build ULA_Testbench --wave=ula.ghw

# Verificar se a simulação foi bem-sucedida
if [ $? -ne 0 ]; then
    echo "Erro na simulação"
    exit 1
fi

# Visualizar a forma de onda usando o GTKWave
gtkwave ula.ghw