Clínica Veterinária Ananda Hattori

Visão Geral do Projeto:
Este é o repositório do Sistema de Gerenciamento para Clínica Veterinária Ananda Hattori, um projeto desenvolvido como Trabalho de Conclusão de Curso (TCC) pelo grupo da TURMA B SEDUC 2 da ESCOLA SENAI SUIÇO BRASILEIRA PAULO ERNESTO TOLLE.

Nosso sistema é uma aplicação web completa, focada em otimizar os processos de uma clínica veterinária fictícia em São Paulo. Ele visa aprimorar a gestão de dados de animais e o fluxo de atendimento, beneficiando tanto os tutores de pets quanto os profissionais da clínica. Com uma interface moderna e intuitiva, a plataforma busca integrar tecnologia e cuidado animal, promovendo maior agilidade, transparência e eficiência.

Funcionalidades Principais
O sistema oferece uma gama de funcionalidades projetadas para simplificar a rotina da clínica e a interação com os tutores:

Para Tutores:
Cadastro de Animais: Registro completo de pets com informações detalhadas (nome, idade, peso, raça, gênero, alergias, histórico de saúde).
Agendamento de Consultas: Formulário interativo para marcar consultas, com detalhes sobre sintomas e observações.
Visualização e Histórico: Acompanhamento de consultas agendadas e acesso ao histórico de atendimentos realizados.
Gestão de Dados: Possibilidade de editar ou excluir informações e consultas conforme necessário.
Para Administradores da Clínica:
Painel de Controle Completo: Acesso centralizado a todos os registros de usuários, animais e consultas.
Gerenciamento de Cadastros: Inserção, edição, listagem e exclusão de informações de tutores, animais e atendimentos.
Controle de Status de Consultas: Gerenciamento dos estados de cada atendimento (agendada, em andamento, finalizada, etc.).
Segurança Reforçada: Interface protegida por autenticação (e.g., JWT) para evitar acessos indevidos.
Relatórios Básicos: Visão geral da operação da clínica para facilitar a tomada de decisões.
Tecnologias Utilizadas
Este projeto foi construído utilizando as seguintes tecnologias:

Frontend:
HTML
CSS
JavaScript
Responsividade: Design adaptável a diferentes tamanhos de tela (smartphones, tablets, desktops).
Backend:
Java (Apache NetBeans 17)
Banco de Dados:
MySQL
XAMPP (para ambiente de desenvolvimento local)
Design/Prototipagem:
Figma
Integração:
Link direto para agendamento via WhatsApp (se aplicável na funcionalidade final).
Diagramas e Modelagem
Para estruturar e visualizar o sistema, foram utilizados os seguintes diagramas:

Diagrama de Banco de Dados: Representação da estrutura do banco de dados e seus relacionamentos.
Diagrama de Casos de Uso: Ilustra as interações entre os usuários (atores) e o sistema.
Fluxogramas (Cliente e Administrador): Detalhamento dos fluxos de trabalho e processos para cada tipo de usuário.
Modelo Conceitual: Esboço inicial que define as informações essenciais e suas relações.
Como Rodar o Projeto (Instruções Breves)
Para configurar e executar o projeto em seu ambiente local, siga os passos abaixo:

Pré-requisitos:
Instale o Java Development Kit (JDK).
Instale o Apache NetBeans 17.
Instale o XAMPP para o servidor Apache e MySQL.
Configuração do Banco de Dados:
Inicie o Apache e o MySQL no painel de controle do XAMPP.
Acesse o phpMyAdmin (geralmente http://localhost/phpmyadmin/) e crie um novo banco de dados com o nome anandahattori.
Importe o script SQL da estrutura do banco de dados (provavelmente localizado na pasta src/main/resources ou database do projeto) para o banco de dados anandahattori.
Configuração do Projeto no NetBeans:
Clone este repositório para o seu computador.
Abra o Apache NetBeans 17.
Vá em File > Open Project... e selecione a pasta raiz do projeto clonado.
Certifique-se de que as configurações de conexão com o banco de dados no código Java estejam apontando corretamente para o seu ambiente local (geralmente jdbc:mysql://localhost:3306/anandahattori).
Execução:
Com o projeto aberto no NetBeans, clique no botão "Run Project" (geralmente um ícone de seta verde).
A aplicação deverá ser implantada em um servidor local (como Tomcat, se configurado no NetBeans) e abrirá no seu navegador.
Contribuição
Este projeto foi desenvolvido por uma equipe de alunos do SENAI. Se você tiver sugestões ou encontrar problemas, sinta-se à vontade para abrir uma issue.

Colaboradores:
Ananda Hattori Rodrigues
Bruna Casemiro
Kauã Luiz Dias Faria
Lavinia
Miguel Fernandes
Lucas Nicolas
Davi Alencar
Elias Alencar
Guilherme Henrique
Agradecimentos Especiais
Gostaríamos de expressar nossa gratidão aos nossos orientadores, Professor Sérgio Gal e Professor Átila, por sua dedicação, paciência e valiosas orientações que foram fundamentais para a concretização deste trabalho. Agradecemos também a todo o corpo docente do SENAI pela formação e apoio contínuo.
