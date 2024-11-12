#!/bin/bash

# Criar o diretório de build se não existir
mkdir -p build

# Analisar todos os arquivos VHDL no diretório ULA/Operations
for file in ULA/Operations/*.vhdl; do
    ghdl -a --std=08 --workdir=build "$file"
done

# Analisar todos os arquivos VHDL no diretório ULA
for file in ULA/*.vhdl; do
    ghdl -a --std=08 --workdir=build "$file"
done


# Analisar o arquivo Processador_Testbench.vhdl
ghdl -a --std=08 --workdir=build Processador_Testbench.vhdl

# Elaborar o testbench e especificar o diretório de trabalho
ghdl -e --std=08 --workdir=build Processador_Testbench

# Executar a simulação e gerar um arquivo de forma de onda
ghdl -r --std=08 --workdir=build Processador_Testbench --wave=build/processador.ghw

# Verificar se a simulação foi bem-sucedida
if [ $? -ne 0 ]; then
    echo "Erro na simulação"
    exit 1
fi

# Visualizar a forma de onda usando o GTKWave
gtkwave build/processador.ghw