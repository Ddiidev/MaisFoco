# Guia de Instalação Docker para o Projeto MaisFoco

Este guia descreve como configurar o projeto MaisFoco usando Docker, Docker Compose e Nginx como balanceador de carga, com suporte para o serviço de tunelamento da Cloudflare para o domínio maisfoco.life.

## Pré-requisitos

- Sistema operacional Linux (Ubuntu recomendado)
- [Docker](https://docs.docker.com/engine/install/) instalado
- [Docker Compose](https://docs.docker.com/compose/install/) instalado
- Serviço de tunelamento da Cloudflare configurado
- Git

## Estrutura do Projeto

Vamos criar a seguinte estrutura de arquivos:

```
MaisFoco-Docker/
├── docker-compose.yml         # Configuração principal
├── .env                       # Variáveis de ambiente
├── nginx/                     # Configuração do Nginx
│   ├── nginx.conf            # Configuração principal do Nginx
│   └── conf.d/               # Configurações adicionais
│       └── maisfoco.conf     # Configuração específica do MaisFoco
├── postgresql/               # Volume persistente para dados do PostgreSQL
└── dockerfiles/              # Arquivos Docker para cada serviço
    └── Dockerfile.maisfoco   # Dockerfile para a aplicação MaisFoco
```

## Passo 1: Configuração do Dockerfile para MaisFoco

Crie o arquivo `dockerfiles/Dockerfile.maisfoco`:

### Geração do arquivo .env

Para gerar o arquivo `.env` a partir do arquivo `.env.local` existente, você pode usar os scripts fornecidos:

**No Windows (PowerShell):**
```powershell
.\generate_env.ps1
```

**No Linux (Bash):**
```bash
chmod +x generate_env.sh
./generate_env.sh
```

Alternativamente, você pode criar o arquivo manualmente:

```bash
cat > .env << 'EOF'
HOST_DB=
NAME_DB=
PASS_DB=
USER_DB=
EOF
```

```dockerfile
FROM ubuntu:20.04

# Evitar interações durante instalação de pacotes
ENV DEBIAN_FRONTEND=noninteractive

# Instalar dependências
RUN apt-get update && apt-get install -y \
    git \
    curl \
    build-essential \
    libssl-dev \
    libpq-dev \
    libsqlite3-dev \
    postgresql \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Instalar V Language
WORKDIR /tmp
RUN git clone https://github.com/vlang/v && \
    cd v && \
    make && \
    ./v symlink

# Verificar a instalação
RUN v --version

# Criar diretório para a aplicação
WORKDIR /app

# Clonar o repositório MaisFoco
COPY . .

# Instalar dependências do projeto
RUN v install

# Compilar o projeto
RUN v -prod .

# Expor a porta que a aplicação usa
EXPOSE 5058

# Script de inicialização
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

# Comando para iniciar a aplicação
CMD ["/app/start.sh"]
```

## Passo 2: Criar script de inicialização

Crie o arquivo `start.sh` no diretório raiz:

```bash
#!/bin/bash

# Tentativas de reinicialização
MAX_RETRIES=10
RETRY_COUNT=0

while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
    echo "Iniciando MaisFoco (tentativa $((RETRY_COUNT+1))/$MAX_RETRIES)"
    
    # Iniciar a aplicação
    ./MaisFoco
    
    # Verificar código de saída
    EXIT_CODE=$?
    
    if [ $EXIT_CODE -eq 0 ]; then
        echo "Aplicação encerrada normalmente."
        exit 0
    else
        echo "Aplicação encerrada com erro (código $EXIT_CODE). Reiniciando..."
        RETRY_COUNT=$((RETRY_COUNT+1))
        sleep 5
    fi
done

echo "Número máximo de tentativas excedido. Saindo."
exit 1
```

## Passo 3: Configuração do Nginx

Crie o arquivo `nginx/nginx.conf`:

```nginx
user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log warn;
pid /var/run/nginx.pid;

events {
    worker_connections 1024;
}

http {
    include /etc/nginx/mime.types;
    default_type application/octet-stream;
    
    log_format main '$remote_addr - $remote_user [$time_local] "$request" '
                    '$status $body_bytes_sent "$http_referer" '
                    '"$http_user_agent" "$http_x_forwarded_for"';
    
    access_log /var/log/nginx/access.log main;
    
    sendfile on;
    keepalive_timeout 65;
    
    include /etc/nginx/conf.d/*.conf;
}
```

Crie o arquivo `nginx/conf.d/maisfoco.conf`:

```nginx
upstream maisfoco_backend {
    # Estratégia de balanceamento: round robin (padrão)
    server maisfoco1:5058;
    server maisfoco2:5058;
    server maisfoco3:5058;
}

server {
    listen 5058;
    server_name localhost;

    # Configurações de buffer para uma melhor performance
    client_max_body_size 20M;
    client_body_buffer_size 128k;
    
    # Health check removido conforme solicitado

    # Proxy reverso para o backend
    location / {
        proxy_pass http://maisfoco_backend;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        # Configurações de timeout
        proxy_connect_timeout 90;
        proxy_send_timeout 90;
        proxy_read_timeout 90;
        
        # WebSocket support (se necessário)
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }
}
```

## Passo 4: Configuração do Docker Compose

Crie o arquivo `docker-compose.yml`:

```yaml
version: '3.8'

services:
  # PostgreSQL
  postgres:
    image: postgres:14
    container_name: maisfoco-postgres
    restart: always
    environment:
      - POSTGRES_DB=${NAME_DB}
      - POSTGRES_PASSWORD=${PASS_DB}
      - POSTGRES_USER=${USER_DB}
    ports:
      - "5432:5432"
    volumes:
      - ./postgresql:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${USER_DB} -d ${NAME_DB}"]
      interval: 10s
      timeout: 5s
      retries: 5

  # Instâncias da aplicação MaisFoco
  maisfoco1:
    build:
      context: .
      dockerfile: dockerfiles/Dockerfile.maisfoco
    container_name: maisfoco-app1
    restart: always
    depends_on:
      postgres:
        condition: service_healthy
    volumes:
      - ./.env.local:/app/.env.local
    environment:
      - HOST_DB=postgres
    # Healthcheck removido conforme solicitado

  maisfoco2:
    build:
      context: .
      dockerfile: dockerfiles/Dockerfile.maisfoco
    container_name: maisfoco-app2
    restart: always
    depends_on:
      postgres:
        condition: service_healthy
    volumes:
      - ./.env.local:/app/.env.local
    environment:
      - HOST_DB=postgres
    # Healthcheck removido conforme solicitado

  maisfoco3:
    build:
      context: .
      dockerfile: dockerfiles/Dockerfile.maisfoco
    container_name: maisfoco-app3
    restart: always
    depends_on:
      postgres:
        condition: service_healthy
    volumes:
      - ./.env.local:/app/.env.local
    environment:
      - HOST_DB=postgres
    # Healthcheck removido conforme solicitado

  # Nginx como balanceador de carga
  nginx:
    image: nginx:latest
    container_name: maisfoco-nginx
    restart: always
    depends_on:
      - maisfoco1
      - maisfoco2
      - maisfoco3
    ports:
      - "5058:5058"
    volumes:
      - ./nginx/nginx.conf:/etc/nginx/nginx.conf
      - ./nginx/conf.d:/etc/nginx/conf.d
    # Healthcheck removido conforme solicitado

networks:
  default:
    name: maisfoco-network
```

## Passo 5: Criar arquivo .env.local

Crie o arquivo `.env.local` na raiz do projeto com as variáveis de ambiente necessárias conforme o .env.template

```
NAME_DB=
NAME_DB_TEST=
HOST_DB=
PORT_DB=5432
USER_DB=
PASS_DB=
PATH_PAGES=./pages
HANDLE_EMAIL_FROM=
HANDLE_EMAIL_PORT=
HANDLE_EMAIL_USERNAME=your_email_username
HANDLE_EMAIL_PASSWORD=your_email_password
HANDLE_EMAIL_TOKEN=your_email_token
BASE_DOMAIN=https://maisfoco.life
EMAIL_MAISFOCO_SUPORTE=
RECAPTCHA=your_recaptcha_cloudflare_key
RECAPTCHA_SECRETKEY=your_recaptcha_cloudflare_secret
```

## Passo 6: Iniciar os Containers

Execute os seguintes comandos para iniciar os containers:

```bash
# Criar as pastas necessárias
mkdir -p nginx/conf.d postgresql postgresql-init dockerfiles

# Copiar os arquivos de configuração
# (Certifique-se de ter criado todos os arquivos mencionados acima)

# Iniciar os containers em modo detached
docker-compose up -d
```

> **Nota**: Os scripts SQL na pasta `postgresql-init` serão executados automaticamente quando o container PostgreSQL for iniciado pela primeira vez. Estes scripts criam o schema `MFMADATABASE` e configuram o search path padrão.

## Passo 7: Verificar o Status dos Containers

```bash
docker-compose ps
```

## Passo 8: Monitorar os Logs

```bash
# Todos os serviços
docker-compose logs -f

# Um serviço específico (ex: nginx)
docker-compose logs -f nginx
```

## Configuração do Cloudflare Tunnel

Já que você tem o serviço de tunelamento da Cloudflare instalado, você precisa configurá-lo para apontar para a porta 5058 exposta pelo Nginx:

1. Certifique-se de que o tunnel está instalado e funcionando
2. Configure-o para encaminhar o tráfego do domínio `maisfoco.life` para `localhost:5058`

## Gerenciamento e Manutenção

### Reiniciar os Serviços

```bash
docker-compose restart
```

### Atualizar a Aplicação

1. Pare os containers:
   ```bash
   docker-compose down
   ```

2. Reconstrua as imagens:
   ```bash
   docker-compose build
   ```

3. Reinicie os containers:
   ```bash
   docker-compose up -d
   ```

### Verificar Logs

```bash
# Ver logs do Nginx
docker logs maisfoco-nginx

# Ver logs de uma instância específica
docker logs maisfoco-app1
```

### Backup do Banco de Dados

```bash
docker exec maisfoco-postgres pg_dump -U postgres MFMADATABASE > backup_$(date +%Y%m%d).sql
```

## Solução de Problemas

### Se uma instância da aplicação não iniciar

Verifique os logs:
```bash
docker logs maisfoco-app1
```

### Se o Nginx não estiver balanceando corretamente

Verifique os logs do Nginx:
```bash
docker logs maisfoco-nginx
```

### Se o Cloudflare Tunnel não estiver funcionando

Verifique se o Nginx está expondo corretamente a porta 5058:
```bash
curl localhost:5058
```

## Considerações de Segurança

- O arquivo `.env.local` contém informações sensíveis. Certifique-se de que ele tenha permissões restritas.
- Considere usar o Docker Swarm ou Kubernetes para ambientes de produção de grande escala.
- Configure o firewall para permitir apenas tráfego necessário.

#

Este guia fornece uma configuração completa para executar o MaisFoco em containers Docker com alta disponibilidade e balanceamento de carga. Você pode ajustar as configurações conforme necessário para atender necessidades específicas.
