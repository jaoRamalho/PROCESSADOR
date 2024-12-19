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

for file in PC/*.vhdl; do
    ghdl -a --std=08 --workdir=build "$file"
done
# Analisar todos os arquivos VHDL no diretório REGISTERS
for file in REGISTERS/*.vhdl; do
    ghdl -a --std=08 --workdir=build "$file"
done

# Analisar todos os arquivos VHDL no diretório ROMs
for file in ROMs/*.vhdl; do
    ghdl -a --std=08 --workdir=build "$file"
done

for file in CONTROL/*.vhdl; do
    ghdl -a --std=08 --workdir=build "$file"
done

# Analisar os demais arquivos VHDL
ghdl -a --std=08 --workdir=build Processador.vhdl
ghdl -a --std=08 --workdir=build Processador_Testbench.vhdl

# Entrar no diretório de build
cd build

# Elaborar o testbench (aqui não precisa do --workdir, pois já estamos no diretório build)
ghdl -e --std=08 Processador_Testbench

# Mensagem antes de executar a simulação
echo "Executando a simulação..."

# Executar a simulação e gerar o arquivo de forma de onda
ghdl -r --std=08 Processador_Testbench --wave=processador.ghw

# Verificar se a simulação foi bem-sucedida
if [ $? -ne 0 ]; then
    echo "Erro na simulação"
    exit 1
fi

# Mensagem após a simulação
echo "Simulação concluída com sucesso, abrindo GTKWave..."

# Verificar se o arquivo de forma de onda foi gerado
if [ ! -f processador.ghw ]; then
    echo "Arquivo de forma de onda não encontrado"
    exit 1
fi

# Abrir o GTKWave com o arquivo de forma de onda
gtkwave processador.ghw

# Voltar para o diretório anterior
cd ..

# Mensagem final
echo "GTKWave foi chamado"