🏥 PetVida Payment API - Documentação Completa Atualizada
Data: Novembro 2025
Versão: 3.1.0
Status: Produção - Azure MySQL

📋 Índice
Visão Geral

Funcionalidades Principais

Arquitetura Técnica

Endpoints da API

Modelos de Dados

Exemplos de Uso

Configuração de Deploy

Diagnóstico e Monitoramento

Suporte e Manutenção

🎯 Visão Geral
A PetVida Payment API é uma solução completa de backend para clínica veterinária, oferecendo sistema de autenticação, pagamentos PIX automatizados, agendamentos e gestão de pacientes, agora com integração Azure MySQL.

🚀 Funcionalidades Principais
🔐 Sistema de Autenticação
✅ Registro e verificação de usuários por email

✅ Sistema completo de recuperação de senha

✅ Criptografia BCrypt para segurança

✅ Gestão de perfis de usuário

✅ NOVO: Validação de CPF e email únicos

💳 Sistema de Pagamentos PIX
✅ Geração automática de QR Code PIX

✅ Payload PIX 100% compatível com bancos brasileiros

✅ Webhook para confirmação automática

✅ Sistema de polling em tempo real

✅ Integração direta com app React Native

✅ Chave PIX: kaualuiz1512@gmail.com

🏥 Gestão Veterinária
✅ Agendamento unificado (consultas, vacinas, internações, cirurgias)

✅ Sistema de vacinação inteligente

✅ Módulo de internação de emergência

✅ Gestão de cirurgias e procedimentos

✅ Histórico médico completo por pet

✅ NOVO: Relatórios médicos digitais

🏗️ Arquitetura Técnica
Stack Tecnológica
text
Java 17 + Spring Boot 2.7.18
Spring Data JPA + Hibernate
Azure MySQL 8.0 (Produção)
Spring Security + BCrypt
Spring Mail (SMTP)
REST API JSON
Configuração PIX
properties
pix.key=kaualuiz1512@gmail.com
pix.merchant.name=PetVida Saude Animal  
pix.merchant.city=Sao Paulo
pix.expiration.minutes=30
📡 Endpoints da API
👤 Autenticação & Usuários
Método	Endpoint	Descrição
POST	/api/auth/registrar	Registrar novo usuário
POST	/api/auth/verificar	Verificar email
POST	/api/auth/esqueci-senha	Solicitar recuperação
POST	/api/auth/redefinir-senha	Redefinir senha
GET	/api/usuarios/perfil/{id}	Buscar perfil
💰 Sistema de Pagamentos PIX
Método	Endpoint	Descrição
POST	/api/pagamentos/solicitar	Solicitar pagamento PIX
GET	/api/pagamentos/status/{idTransacao}	Verificar status
POST	/api/pagamentos/webhook/pix	Webhook automático
POST	/api/pagamentos/simular-pagamento-pix	Simulação para testes
🏥 Agendamentos (Sistema Unificado)
Método	Endpoint	Descrição
POST	/api/agendamentos/agendar	Agendar qualquer tipo (CONSULTA, VACINACAO, INTERNACAO, CIRURGIA, EXAME)
POST	/api/agendamentos/finalizar-consulta	Finalizar com relatório médico
PUT	/api/agendamentos/{id}/cancelar	Cancelar agendamento
GET	/api/agendamentos/usuario/{usuarioId}	Listar por usuário
GET	/api/agendamentos/usuario/{usuarioId}/tipo/{tipo}	Listar por tipo
GET	/api/agendamentos/usuario/{usuarioId}/historico-medico	Histórico completo
GET	/api/agendamentos/usuario/{usuarioId}/pet/{nomePet}/historico	Histórico por pet
GET	/api/agendamentos/usuario/{usuarioId}/pets	Listar pets do usuário
GET	/api/agendamentos/usuario/{usuarioId}/estatisticas	Estatísticas de uso
🔧 Diagnóstico & Monitoramento
Método	Endpoint	Descrição
GET	/api/debug/health	Health check da aplicação
GET	/api/debug/database	Status conexão Azure MySQL
GET	/api/debug/tables	Listar tabelas do banco
GET	/api/debug/check-entities	Verificar entidades JPA
GET	/api/debug/test-insert	Testar inserção no banco
GET	/api/debug/users-count	Contar usuários
GET	/api/debug/check-repositories	Verificar repositórios
GET	/api/debug/test-registration-flow	Testar fluxo de registro
💳 Fluxo do Pagamento PIX
1. Solicitar Pagamento
   http
   POST /api/pagamentos/solicitar
   Content-Type: application/json

{
"usuarioId": 1,
"plano": "PREMIUM",
"metodoPagamento": "PIX"
}
2. Resposta com QR Code
   json
   {
   "sucesso": true,
   "mensagem": "Pagamento solicitado com sucesso",
   "dados": {
   "idTransacao": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
   "valor": 59.90,
   "plano": "PREMIUM",
   "pixPayload": "00020126580014br.gov.bcb.pix0136kaualuiz1512@gmail.com...",
   "qrCodeBase64": "data:image/svg+xml;base64,PHN2ZyB3aWR0aD0nMjAwJyBoZWlnaHQ9JzIwMCc+...",
   "pixKey": "kaualuiz1512@gmail.com",
   "tempoRestanteSegundos": 1800
   }
   }
3. Verificar Status (Polling)
   http
   GET /api/pagamentos/status/a1b2c3d4-e5f6-7890-abcd-ef1234567890
4. Webhook Automático
   http
   POST /api/pagamentos/webhook/pix
   Content-Type: application/json

{
"idTransacao": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
"status": "CONCLUIDO",
"valor": 59.90
}
🗄️ Modelos de Dados Principais
👤 Usuario (Entidade JPA)
java
@Entity
@Table(name = "usuario")
public class Usuario {
private Long id;
private String nome;
private String email;
private String senha; // BCrypt
private String cpf;
private String celular;
private StatusUsuario status;
private TipoPlano plano;
private LocalDateTime planoValidoAte;
private LocalDateTime criadoEm;

    // Recuperação de senha
    private String codigoRecuperacaoSenha;
    private LocalDateTime codigoRecuperacaoExpiraEm;
    private Integer tentativasRecuperacao;
}
💳 Pagamento (Entidade JPA)
java
@Entity
@Table(name = "pagamento")
public class Pagamento {
private Long id;
private Long usuarioId;
private TipoPlano plano;
private Double valor;
private StatusPagamento status;
private String idTransacao;
private String pixKey;
private String pixPayload; // Payload PIX gerado
private String qrCodeBase64; // QR Code em Base64
private LocalDateTime pixExpiraEm;
private LocalDateTime dataCriacao;
}
🏥 Agendamento (Entidade JPA)
java
@Entity
@Table(name = "agendamento")
public class Agendamento {
private Long id;
private String tipo; // CONSULTA, VACINACAO, INTERNACAO, CIRURGIA, EXAME
private String nomePet;
private Long usuarioId;
private LocalDateTime dataAgendamento;
private String status;
private LocalDateTime criadoEm;

    // Relatório médico
    private String diagnostico;
    private String prescricao;
    private String observacoesMedicas;
    private LocalDateTime dataRealizacao;
    private String nomeVeterinario;
}
🚀 Exemplos de Uso
Fluxo Completo: Usuário + PIX + Agendamento
bash
# 1. Registrar usuário
curl -X POST http://localhost:8081/api/auth/registrar \
-H "Content-Type: application/json" \
-d '{
"nome": "Maria Silva",
"email": "maria@email.com",
"senha": "123456",
"cpf": "123.456.789-00",
"celular": "(11) 98888-7777"
}'

# 2. Solicitar pagamento PIX
curl -X POST http://localhost:8081/api/pagamentos/solicitar \
-H "Content-Type: application/json" \
-d '{
"usuarioId": 1,
"plano": "PREMIUM",
"metodoPagamento": "PIX"
}'

# 3. Agendar consulta
curl -X POST http://localhost:8081/api/agendamentos/agendar \
-H "Content-Type: application/json" \
-d '{
"usuarioId": 1,
"nomePet": "Rex",
"tipo": "CONSULTA",
"dataHora": "2025-11-20T14:30:00",
"veterinario": "Dr. Carlos Silva"
}'

# 4. Verificar histórico
curl -X GET http://localhost:8081/api/agendamentos/usuario/1/historico-medico
Testes de Diagnóstico
bash
# Verificar saúde da aplicação
curl -X GET http://localhost:8081/api/debug/health

# Verificar conexão com Azure MySQL
curl -X GET http://localhost:8081/api/debug/database

# Testar fluxo de registro
curl -X GET http://localhost:8081/api/debug/test-registration-flow
🌐 Configuração de Deploy
Variáveis de Ambiente (Produção Azure)
properties
# Database Azure MySQL
DB_HOST=clinica.mysql.database.azure.com
DB_NAME=clinica
DB_USERNAME=ananda
DB_PASSWORD=Hattori$

# Email
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USERNAME=assistenciaclinicaananda@gmail.com
SMTP_PASSWORD=clinicaAnanda10#

# Security
JWT_SECRET=clinicasecreta

# Server
SERVER_PORT=8081
SPRING_PROFILES_ACTIVE=prod
Comandos de Deploy
bash
# Build para produção
./gradlew clean build -x test

# Executar em produção Azure
java -jar petvida-api-3.1.0.jar --spring.profiles.active=prod

# Health Check
curl http://localhost:8081/actuator/health
🔧 Configuração de Desenvolvimento
application.properties
properties
# Database H2 (Desenvolvimento)
spring.datasource.url=jdbc:h2:mem:petvidadb
spring.datasource.username=sa
spring.datasource.password=

# JPA
spring.jpa.hibernate.ddl-auto=create-drop
spring.jpa.show-sql=true

# H2 Console
spring.h2.console.enabled=true
spring.h2.console.path=/h2-console

# Server
server.port=8080
Executar Localmente
bash
./gradlew bootRun

# Acessos:
# API: http://localhost:8080
# H2 Console: http://localhost:8080/h2-console
📊 Diagnóstico e Monitoramento
Health Checks Disponíveis
Aplicação: /actuator/health

Database: /api/debug/health

Conexão Azure: /api/debug/database

Entidades JPA: /api/debug/check-entities

Logs de Diagnóstico
Conexão HikariCP com Azure MySQL

Criação de tabelas JPA

Operações de banco em tempo real

Status de repositórios Spring Data

🛠️ Suporte e Manutenção
Monitoramento
Health Check: /actuator/health

Métricas: /actuator/metrics

Logs: Application logs + Azure Monitor

Diagnóstico: Endpoints /api/debug/*

Backup e Recovery
Backup automático do Azure MySQL diário

Snapshots de banco a cada 6 horas

Logs de auditoria de pagamentos

Versionamento de esquema de banco

Contato Suporte
Email: suporte@petvida.com

Emergências: +55 (11) 99999-9999

Horário: 24/7

📊 Status do Sistema - Novembro 2025
✅ Funcionalidades em Produção
Sistema de autenticação completo

Pagamentos PIX automatizados

Gestão de agendamentos unificada

Sistema de recuperação de senha

API 100% compatível com app React Native

NOVO: Integração Azure MySQL

NOVO: Sistema de diagnóstico completo

🚀 Próximas Atualizações
Integração com WhatsApp Business

Relatórios analytics

Sistema de fidelidade

API para telemedicina

🔒 Conformidade e Segurança
LGPD compliant

Dados criptografados em trânsito e repouso

Auditoria de logs completa

Backup automático Azure

Autenticação JWT

📅 Última Atualização: Novembro 2025
🏷️ Versão: 3.1.0
👨‍💻 Desenvolvido por: Equipe PetVida Tecnologia
📞 Suporte: suporte@petvida.com
🌐 Documentação: Disponível em /swagger-ui.html