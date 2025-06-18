1. Visão Geral do Projeto
Este repositório contém o Sistema de Gerenciamento para Clínica Veterinária Ananda Hattori, um projeto desenvolvido como Projeto Integrador pela equipe da TURMA B SEDUC 2 da ESCOLA SENAI SUIÇO BRASILEIRA PAULO ERNESTO TOLLE.

A aplicação web foi concebida para otimizar e modernizar os processos operacionais de clínicas veterinárias, utilizando como modelo a entidade fictícia "Clínica Ananda Hattori" localizada em São Paulo. O objetivo central é a digitalização de procedimentos essenciais, desde o agendamento de consultas até o gerenciamento completo do histórico de pacientes, visando aprimorar a experiência tanto para os tutores de animais quanto para os profissionais da clínica. Através de uma interface bem estruturada e intuitiva, o sistema busca integrar tecnologia e práticas veterinárias, promovendo maior eficiência, transparência e agilidade nos serviços.

2. Benefícios da Solução
O Sistema Ananda Hattori oferece uma série de vantagens estratégicas para a gestão de clínicas veterinárias:

Otimização Operacional: Centralização de dados e eliminação de processos manuais, resultando em maior eficiência administrativa.
Acesso Facilitado ao Histórico: Disponibilização rápida e segura de informações de saúde e histórico de atendimento dos animais.
Atendimento Aprimorado: Redução do tempo de espera e melhoria na qualidade dos serviços prestados por meio de processos padronizados.
Usabilidade e Acessibilidade: Interface responsiva e de fácil utilização, adaptável a diversos dispositivos (desktops, tablets, smartphones).
Escalabilidade do Sistema: Arquitetura modular que permite futuras expansões e a integração de novas funcionalidades.
Melhora na Comunicação: Facilitação da interação entre a clínica e os tutores, promovendo maior transparência e engajamento.
3. Funcionalidades Principais
O sistema foi desenvolvido para atender às necessidades específicas de diferentes perfis de usuários:

3.1. Para Tutores (Clientes)
Cadastro e Gerenciamento de Animais: Permite o registro detalhado de informações sobre os pets (nome, idade, raça, peso, alergias, histórico de saúde).
Agendamento de Consultas: Funcionalidade interativa para marcar atendimentos, incluindo a inserção de sintomas e observações pertinentes.
Visualização de Consultas e Histórico: Acesso completo a agendamentos futuros e ao histórico de serviços realizados.
Gestão de Dados Pessoais: Capacidade de editar informações de perfil do tutor e dos animais cadastrados.
3.2. Para Administradores da Clínica
Painel de Controle Centralizado: Gestão unificada de usuários, animais e agendamentos.
Gerenciamento Abrangente de Cadastros: Operações completas de inclusão, edição, listagem e exclusão de dados.
Controle de Status de Atendimento: Monitoramento do progresso de cada consulta (agendada, em andamento, finalizada, internação, etc.).
Segurança de Acesso: Implementação de mecanismos de autenticação (e.g., JWT) para garantir a integridade e confidencialidade dos dados.
Relatórios e Métricas: Geração de dados agregados para análise de desempenho e suporte à decisão.
4. Telas Desenvolvidas
A interface do usuário foi projetada com foco na clareza e funcionalidade, incluindo as seguintes telas principais:

Página Inicial (Home): Ponto de entrada do sistema, apresentando a clínica e direcionando para o cadastro.
Tela de Login: Interface para autenticação de usuários e administradores.
Tela de Cadastro de Animais: Formulário para o registro de novos animais de estimação.
Tela de Listagem de Consultas: Exibição organizada de todos os agendamentos.
Tela de Exclusão de Animais: Procedimento seguro para remoção de registros de animais.
Tela do Usuário Comum (Perfil do Tutor): Área dedicada à gestão de informações pessoais e de pets pelo tutor.
Tela de Cadastro de Consulta: Formulário detalhado para o agendamento de novos atendimentos veterinários.
Tela do Administrador (Painel Admin): Central de controle com acesso total às operações da clínica.
Tela de Relatório (Painel Admin): Apresentação de dados e métricas operacionais.
Tela de Internação: Funcionalidade específica para o registro e acompanhamento de animais internados.
5. Tecnologias Utilizadas
O projeto foi desenvolvido com base nas seguintes tecnologias:

Frontend:
HTML: Linguagem de marcação para a estrutura das páginas web.
CSS: Linguagem de estilos para o design e responsividade (incluindo Flexbox e Grid).
JavaScript: Linguagem de programação para interatividade e dinamismo.
Backend:
Java: Linguagem principal de desenvolvimento do lado do servidor.
Apache NetBeans 17: Ambiente de Desenvolvimento Integrado (IDE).
Banco de Dados:
MySQL: Sistema de Gerenciamento de Banco de Dados Relacional (SGBDR).
XAMPP: Pacote para ambiente de desenvolvimento local (servidor Apache, MySQL, PHP, phpMyAdmin).
Design e Prototipagem:
Figma: Ferramenta para criação e prototipagem da interface do usuário.
Integração:
Link direto para agendamento via WhatsApp.
6. Modelagem e Diagramas
A concepção e a arquitetura do sistema foram documentadas através dos seguintes diagramas e modelos:

Diagrama de Banco de Dados: Representação visual da estrutura do banco de dados relacional.
Diagrama de Casos de Uso: Modelagem das interações entre os usuários (atores) e as funcionalidades do sistema.
Fluxogramas (Cliente e Administrador): Ilustração dos fluxos de trabalho e processos lógicos para cada perfil de usuário.
Modelo Conceitual: Esboço inicial do sistema, definindo as entidades e seus relacionamentos de alto nível.
7. Instruções para Execução Local
Para configurar e executar o projeto em seu ambiente de desenvolvimento:

Pré-requisitos: Certifique-se de que o Java Development Kit (JDK), Apache NetBeans 17 e XAMPP estejam instalados em sua máquina.
Configuração do Banco de Dados:
Inicie os serviços Apache e MySQL através do painel de controle do XAMPP.
Acesse o phpMyAdmin e crie um novo banco de dados denominado anandahattori.
Importe o script SQL da estrutura do banco de dados (geralmente localizado na raiz do repositório ou em uma pasta database/) para o banco de dados recém-criado.
Configuração no NetBeans:
Clone este repositório para o seu ambiente local.
Abra o projeto no Apache NetBeans 17.
Verifique e, se necessário, ajuste as configurações de conexão com o banco de dados no código Java para apontar corretamente para o seu ambiente local (jdbc:mysql://localhost:3306/anandahattori).
Execução:
No NetBeans, execute o projeto (ícone de seta verde). A aplicação será implantada em um servidor local e aberta em seu navegador padrão.
8. Equipe de Desenvolvimento
Este projeto é o resultado do trabalho colaborativo de:

Ananda Hattori Rodrigues
Bruna Casemiro
Kauã Luiz Dias Faria
Lavinia
Miguel Fernandes
Lucas Nicolas
Davi Alencar
Elias Alencar
Guilherme Henrique
9. Agradecimentos
Expressamos nossa sincera gratidão aos orientadores Professor Sérgio Gal e Professor Átila por seu valioso suporte, paciência e orientação ao longo de todo o desenvolvimento deste trabalho. Agradecemos também a toda a equipe docente da Escola SENAI Suíço Brasileira Paulo Ernesto Tolle pela formação acadêmica e apoio contínuo.
