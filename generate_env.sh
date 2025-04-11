#!/bin/bash

# Script para gerar arquivo .env a partir do .env.local

# Verificar se o arquivo .env.local existe
if [ ! -f ".env.local" ]; then
    echo "Erro: Arquivo .env.local não encontrado. Por favor, crie o arquivo .env.local primeiro."
    exit 1
 fi

# Extrair as variáveis necessárias para o arquivo .env
HOST_DB=$(grep -E "^HOST_DB=" .env.local | cut -d= -f2)
NAME_DB=$(grep -E "^NAME_DB=" .env.local | cut -d= -f2)
PASS_DB=$(grep -E "^PASS_DB=" .env.local | cut -d= -f2)
USER_DB=$(grep -E "^USER_DB=" .env.local | cut -d= -f2)

# Verificar se todas as variáveis necessárias foram encontradas
if [ -z "$HOST_DB" ] || [ -z "$NAME_DB" ] || [ -z "$PASS_DB" ] || [ -z "$USER_DB" ]; then
    echo "Erro: Uma ou mais variáveis necessárias não foram encontradas no arquivo .env.local"
    exit 1
fi

# Criar o arquivo .env
cat > .env << EOF
HOST_DB=$HOST_DB
NAME_DB=$NAME_DB
PASS_DB=$PASS_DB
USER_DB=$USER_DB
EOF

echo "Arquivo .env gerado com sucesso a partir do arquivo .env.local"