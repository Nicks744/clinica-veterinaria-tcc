# --- Etapa 1: Build da aplicação Java ---
FROM maven:3.8.6-openjdk-17 as build-stage

# Define o diretório de trabalho
WORKDIR /app

# Copia o arquivo de configuração do Maven e o código-fonte
COPY pom.xml .
COPY src ./src

# Compila o projeto e gera o arquivo .war
RUN mvn clean package -DskipTests

# --------------------------------------------------------------------------------------------------

# --- Etapa 2: Criação da imagem final ---
FROM tomcat:9.0-jre17-temurin

# Remove a aplicação de exemplo que vem com o Tomcat
RUN rm -rf /usr/local/tomcat/webapps/ROOT*

# Copia o .war gerado na etapa de build para o diretório de webapps do Tomcat
# O nome do arquivo 'ROOT.war' fará com que sua aplicação seja a principal (na raiz)
COPY --from=build-stage /app/target/clinica-veterinaria-senai.war /usr/local/tomcat/webapps/ROOT.war

# Expõe a porta padrão do Tomcat
EXPOSE 8080

# Inicia o Tomcat quando o contêiner for executado
CMD ["catalina.sh", "run"]
