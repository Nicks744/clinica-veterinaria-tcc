# Dockerfile - Colocar na RAIZ do projeto
FROM openjdk:21-jdk-slim

WORKDIR /app

# Copiar o JAR da aplicação
COPY build/libs/payment-api-0.0.1-SNAPSHOT.jar app.jar

# Expor porta
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8080/actuator/health || exit 1

# Comando de execução
ENTRYPOINT ["java", "-jar", "app.jar"]