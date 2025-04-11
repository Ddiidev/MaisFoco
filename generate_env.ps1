# Script para gerar arquivo .env a partir do .env.local

# Verificar se o arquivo .env.local existe
if (-not (Test-Path ".env.local")) {
    Write-Error "Arquivo .env.local não encontrado. Por favor, crie o arquivo .env.local primeiro."
    exit 1
}

# Ler o conteúdo do arquivo .env.local
$envLocalContent = Get-Content ".env.local" -Raw

# Extrair as variáveis necessárias para o arquivo .env
$hostDB = ""
$nameDB = ""
$passDB = ""
$userDB = ""

# Procurar por cada variável no arquivo .env.local
foreach ($line in (Get-Content ".env.local")) {
    if ($line -match "^HOST_DB=(.*)$") {
        $hostDB = $matches[1]
    }
    elseif ($line -match "^NAME_DB=(.*)$") {
        $nameDB = $matches[1]
    }
    elseif ($line -match "^PASS_DB=(.*)$") {
        $passDB = $matches[1]
    }
    elseif ($line -match "^USER_DB=(.*)$") {
        $userDB = $matches[1]
    }
}

# Verificar se todas as variáveis necessárias foram encontradas
if ([string]::IsNullOrEmpty($hostDB) -or [string]::IsNullOrEmpty($nameDB) -or 
    [string]::IsNullOrEmpty($passDB) -or [string]::IsNullOrEmpty($userDB)) {
    Write-Error "Uma ou mais variáveis necessárias não foram encontradas no arquivo .env.local"
    exit 1
}

# Criar o conteúdo do arquivo .env
$envContent = @"
HOST_DB=$hostDB
NAME_DB=$nameDB
PASS_DB=$passDB
USER_DB=$userDB
"@

# Escrever o conteúdo no arquivo .env
$envContent | Out-File -FilePath ".env" -Encoding utf8 -NoNewline

Write-Host "Arquivo .env gerado com sucesso a partir do arquivo .env.local"