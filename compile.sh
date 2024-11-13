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

for file in REGISTERS/*.vhdl; do
    ghdl -a --std=08 --workdir=build "$file"
done


for file in REGISTERS/*.vhdl; do
    ghdl -a --std=08 --workdir=build "$file"
done

# Analisar o arquivo Processador_Testbench.vhdl
ghdl -a --std=08 --workdir=build Processador_Testbench.vhdl

# Elaborar o testbench e especificar o diretório de trabalho
ghdl -e --std=08 --workdir=build Processador_Testbench

# Mensagem de depuração antes de executar a simulação
echo "Executando a simulação..."

# Executar a simulação e gerar um arquivo de forma de onda
ghdl -r --std=08 --workdir=build Processador_Testbench --wave=build/processador.ghw

# Verificar se a simulação foi bem-sucedida
if [ $? -ne 0 ]; then
    echo "Erro na simulação"
    exit 1
fi

# Mensagem de depuração
echo "Simulação concluída com sucesso, abrindo GTKWave..."

# Verificar se o arquivo de forma de onda foi gerado
if [ ! -f build/processador.ghw ]; then
    echo "Arquivo de forma de onda não encontrado"
    exit 1
fi

# Mensagem de depuração antes de abrir o GTKWave
echo "Chamando gtkwave..."

# Visualizar a forma de onda usando o GTKWave
gtkwave build/processador.ghw

# Mensagem de depuração após chamar o GTKWave
echo "GTKWave foi chamado"