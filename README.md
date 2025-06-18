
---

# 🐾 Clínica Veterinária Ananda Hattori - Sistema de Gerenciamento

Este repositório contém o **Sistema de Gerenciamento para a Clínica Veterinária Ananda Hattori**, desenvolvido como **Trabalho de Conclusão de Curso (TCC)** pela equipe da **TURMA B SEDUC 2** da **ESCOLA SENAI SUIÇO BRASILEIRA PAULO ERNESTO TOLLE**.

---

## 📑 Sumário

1. [Visão Geral do Projeto](#-1-visão-geral-do-projeto)
2. [Benefícios da Solução](#-2-benefícios-da-solução)
3. [Funcionalidades Principais](#%EF%B8%8F-3-funcionalidades-principais)
     • [Para Tutores (Clientes)](#-para-tutores-clientes)
     • [Para Administradores da Clínica](#-para-administradores-da-clínica)
4. [Telas Desenvolvidas](#%EF%B8%8F-4-telas-desenvolvidas)
5. [Tecnologias Utilizadas](#%EF%B8%8F-5-tecnologias-utilizadas)
6. [Modelagem e Diagramas](#-6-modelagem-e-diagramas)
7. [Instruções para Execução Local](#-7-instruções-para-execução-local)
8. [Equipe de Desenvolvimento](#-8-equipe-de-desenvolvimento)
9. [Agradecimentos](#-9-agradecimentos)

---


## 📌 1. Visão Geral do Projeto

A aplicação web foi projetada para **otimizar e modernizar** os processos operacionais de clínicas veterinárias, tendo como modelo a entidade fictícia “Clínica Ananda Hattori”, localizada em São Paulo.

O sistema digitaliza processos essenciais — desde o agendamento de consultas até o gerenciamento completo do histórico de pacientes — com o objetivo de aprimorar a experiência dos tutores e profissionais da clínica.

## 🚀 2. Benefícios da Solução

* **🔧 Otimização Operacional:** Centraliza dados e elimina processos manuais.
* **📋 Acesso Facilitado ao Histórico:** Informações rápidas e seguras sobre os animais.
* **🏥 Atendimento Aprimorado:** Reduz tempo de espera e padroniza os serviços.
* **📱 Usabilidade e Acessibilidade:** Interface responsiva para todos os dispositivos.
* **📈 Escalabilidade:** Estrutura modular com suporte a expansões.
* **💬 Melhora na Comunicação:** Facilita o contato entre clínica e tutores.

## ⚙️ 3. Funcionalidades Principais

### 👤 Para Tutores (Clientes)

* Cadastro e gerenciamento de pets (nome, idade, raça, peso, alergias, histórico).
* Agendamento de consultas com registro de sintomas.
* Visualização de consultas futuras e passadas.
* Atualização de dados pessoais e dos pets.

### 🩺 Para Administradores da Clínica

* Painel centralizado para gestão de usuários, pets e agendamentos.
* Operações CRUD completas.
* Monitoramento do status de consultas.
* Geração de relatórios e métricas.

## 🖥️ 4. Telas Desenvolvidas

* Página Inicial (Home)
* Tela de Login
* Cadastro de Animais
* Listagem de Consultas
* Exclusão de Animais
* Perfil do Tutor (Usuário Comum)
* Cadastro de Consulta
* Painel do Administrador
* Relatórios (Admin)
* Tela de Internação

## 🛠️ 5. Tecnologias Utilizadas

### Frontend:

* HTML
* CSS (Flexbox e Grid)
* JavaScript

### Backend:

* Java
* Apache NetBeans 17

### Banco de Dados:

* MySQL
* XAMPP (Apache, MySQL, PHP, phpMyAdmin)

### Design e Prototipagem:

* Figma

### Integração:

* Link direto para agendamento via WhatsApp

## 🧩 6. Modelagem e Diagramas

* Diagrama do Banco de Dados Relacional
* Diagrama de Casos de Uso
* Fluxogramas dos Processos (Cliente e Administrador)
* Modelo Conceitual com Entidades e Relacionamentos

## 💻 7. Instruções para Execução Local

### Pré-requisitos:

* Java Development Kit (JDK)
* Apache NetBeans 17
* XAMPP

### Configuração do Banco de Dados:

1. Inicie o Apache e o MySQL pelo painel XAMPP.
2. No phpMyAdmin, crie o banco de dados: `clinica`.
3. Importe o script SQL localizado em `database/` ou na raiz do projeto.

### Configuração no NetBeans:

1. Clone este repositório:

   ```bash
   git clone https://github.com/seu-usuario/clinica-veterinaria-tcc.git
   ```
2. Abra o projeto no **Apache NetBeans 17**.
3. Verifique e, se necessário, ajuste a string de conexão JDBC:

   ```java
   jdbc:mysql://localhost:3306/anandahattori
   ```

### Execução:

* Clique no botão **"Play"** no NetBeans.
* O sistema será executado em servidor local e abrirá automaticamente no navegador padrão.

## 👩‍💻 8. Equipe de Desenvolvimento

* Bruna Casemiro
* Kauã Luiz Dias Faria
* Lavinia
* Miguel Fernandes
* Lucas Nicolas
* Davi Alencar
* Elias Alencar
* Guilherme Henrique

## 🙏 9. Agradecimentos

Agradecemos aos **Professores Sérgio Gal e Átila** pela orientação e suporte durante o desenvolvimento. Também estendemos nossos agradecimentos à equipe docente da **Escola SENAI Suíço Brasileira Paulo Ernesto Tolle** por sua dedicação e contribuição à nossa formação.

---


