FROM tomcat:9.0

# Remove aplicação padrão do Tomcat
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Copia seu WAR para o Tomcat e renomeia como ROOT.war (serve direto na raiz /)
COPY dist/ProjetoClinica.war /usr/local/tomcat/webapps/ROOT.war
