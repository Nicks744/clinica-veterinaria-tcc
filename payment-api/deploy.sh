#!/bin/bash
# deploy.sh - Colocar na RAIZ do projeto

echo "🚀 Iniciando deploy da Payment API..."

# Build da aplicação
echo "📦 Executando build..."
./gradlew clean build

# Verificar se build foi bem sucedido
if [ $? -eq 0 ]; then
    echo "✅ Build realizado com sucesso!"
    echo "📊 Arquivo gerado: build/libs/payment-api-0.0.1-SNAPSHOT.jar"

    # Listar dependências (opcional)
    echo "📋 Dependências do projeto:"
    ./gradlew dependencies --configuration runtimeClasspath | grep -E '(mysql|spring)'
else
    echo "❌ Erro no build!"
    exit 1
fi

echo "🎯 Comandos para deploy:"
echo "1. Para Railway:  railway up"
echo "2. Para Docker:   docker build -t petvida-api . && docker run -p 8080:8080 petvida-api"
echo "3. Para Heroku:   heroku container:push web -a sua-app"