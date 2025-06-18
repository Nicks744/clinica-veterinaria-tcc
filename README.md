Clínica Veterinária Ananda Hattori
1. Visão Geral do Projeto
Este repositório contém o Sistema de Gerenciamento para a Clínica Veterinária Ananda Hattori, desenvolvido como Trabalho de Conclusão de Curso (TCC) pela equipe da TURMA B SEDUC 2 da ESCOLA SENAI SUIÇO BRASILEIRA PAULO ERNESTO TOLLE.

A aplicação web foi projetada para otimizar e modernizar os processos operacionais de clínicas veterinárias, tendo como modelo a entidade fictícia “Clínica Ananda Hattori” localizada em São Paulo. O sistema digitaliza procedimentos essenciais, desde o agendamento de consultas até o gerenciamento completo do histórico de pacientes, com o objetivo de aprimorar a experiência dos tutores e dos profissionais da clínica. Através de uma interface estruturada e intuitiva, o projeto integra tecnologia e práticas veterinárias, promovendo maior eficiência, transparência e agilidade nos serviços.

2. Benefícios da Solução
O Sistema Ananda Hattori oferece as seguintes vantagens estratégicas:

Otimização Operacional: Centralização de dados e eliminação de processos manuais, resultando em maior eficiência administrativa.

Acesso Facilitado ao Histórico: Disponibilização rápida e segura de informações sobre saúde e atendimentos dos animais.

Atendimento Aprimorado: Redução do tempo de espera e melhoria na qualidade dos serviços mediante processos padronizados.

Usabilidade e Acessibilidade: Interface responsiva, compatível com desktops, tablets e smartphones.

Escalabilidade: Arquitetura modular que permite futuras expansões e integração de novas funcionalidades.

Melhora na Comunicação: Facilita a interação entre a clínica e os tutores, promovendo maior transparência e engajamento.

3. Funcionalidades Principais
3.1 Para Tutores (Clientes)
Cadastro detalhado e gerenciamento de animais (nome, idade, raça, peso, alergias, histórico de saúde).

Agendamento interativo de consultas com registro de sintomas e observações.

Visualização dos agendamentos futuros e do histórico de atendimentos.

Gestão e atualização de dados pessoais e informações dos pets.

3.2 Para Administradores da Clínica
Painel de controle centralizado para gestão de usuários, animais e agendamentos.

Operações completas de inclusão, edição, listagem e exclusão de dados.

Monitoramento do status das consultas (agendada, em andamento, finalizada, internação).

Segurança por autenticação robusta (e.g., JWT) garantindo integridade e confidencialidade.

Geração de relatórios e métricas para análise e suporte à decisão.

4. Telas Desenvolvidas
Página Inicial (Home)

Tela de Login

Tela de Cadastro de Animais

Tela de Listagem de Consultas

Tela de Exclusão de Animais

Tela do Usuário Comum (Perfil do Tutor)

Tela de Cadastro de Consulta

Tela do Administrador (Painel Admin)

Tela de Relatório (Painel Admin)

Tela de Internação

5. Tecnologias Utilizadas
Frontend:

HTML

CSS (Flexbox e Grid)

JavaScript

Backend:

Java

Apache NetBeans 17 (IDE)

Banco de Dados:

MySQL

XAMPP (Apache, MySQL, PHP, phpMyAdmin)

Design e Prototipagem:

Figma

Integração:

Link direto para agendamento via WhatsApp

6. Modelagem e Diagramas
Diagrama do Banco de Dados relacional

Diagrama de Casos de Uso

Fluxogramas dos processos para Cliente e Administrador

Modelo Conceitual com entidades e relacionamentos

7. Instruções para Execução Local
Pré-requisitos:

Java Development Kit (JDK)

Apache NetBeans 17

XAMPP instalado

Configuração do Banco de Dados:

Inicie Apache e MySQL pelo painel XAMPP.

No phpMyAdmin, crie o banco de dados anandahattori.

Importe o script SQL presente no diretório database/ ou raiz do projeto.

Configuração no NetBeans:

Clone este repositório localmente.

Abra o projeto no Apache NetBeans 17.

Verifique e ajuste, se necessário, a string de conexão JDBC para:
jdbc:mysql://localhost:3306/anandahattori

Execução:

Execute o projeto no NetBeans (botão de “play”).

A aplicação será iniciada em servidor local e aberta no navegador padrão.

8. Equipe de Desenvolvimento
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
Agradecemos aos Professores Sérgio Gal e Átila pela orientação e suporte durante o desenvolvimento do projeto. Estendemos nossos agradecimentos à equipe docente da Escola SENAI Suíço Brasileira Paulo Ernesto Tolle pela formação acadêmica e apoio contínuo.

