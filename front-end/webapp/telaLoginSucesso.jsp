<%--
  Página principal para utilizadores logados.
  CORREÇÃO: Revertido para usar a lógica original de verificação de sessão
  e busca de dados, mas com as correções técnicas necessárias (jakarta.*,
  try-with-resources e System.getenv).
--%>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="jakarta.servlet.http.HttpSession, java.sql.*" %>

<%
    // =======================================================================================
    //  LÓGICA REVERTIDA PARA USAR OS NOMES DE SESSÃO ORIGINAIS ("usuarioLogado" e "cpf")
    // =======================================================================================
    String nomeUsuario = ""; // Variável para guardar o nome do utilizador

    // Passo 1: Verifica a sessão usando o nome antigo "usuarioLogado"
    if (session.getAttribute("usuarioLogado") == null) {
        // Se o atributo não existir, o utilizador não está logado.
        response.sendRedirect("telaLogin.jsp");
        return; // Impede que o resto da página seja processado
    }

    // Passo 2: Obtém os dados da sessão usando os nomes originais
    String emailSessao = (String) session.getAttribute("usuarioLogado");
    String cpfUsuario = (String) session.getAttribute("cpf");

    // Passo 3: Conecta-se à base de dados para buscar o nome do utilizador
    // (Mantendo a lógica original, mas com gestão de recursos segura)
    String url = System.getenv("DB_URL");
    String usuarioBD = System.getenv("DB_USERNAME");
    String senhaBD = System.getenv("DB_PASSWORD");

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");

        try (Connection conexao = DriverManager.getConnection(url, usuarioBD, senhaBD);
             PreparedStatement stmt = conexao.prepareStatement("SELECT nome FROM usuarios WHERE email = ?")) {

            stmt.setString(1, emailSessao);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    nomeUsuario = rs.getString("nome");
                }
            }
        }
    } catch (Exception e) {
        // Em caso de erro, define um nome padrão e imprime o erro no log do servidor
        nomeUsuario = "Utilizador";
        e.printStackTrace();
    }
%>
<!DOCTYPE HTML>

<html>
<head>
    <title>Clínica Veterinária Ananda</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no" />

    <!-- favicon em SVG -->
    <link rel="icon" type="image/svg+xml" href="favicon.svg">

    <!-- fallback em PNG (caso o SVG não seja suportado) -->
    <link rel="icon" type="image/png" href="imgs_inicio/minilogo.png">

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />

    <link rel="stylesheet" href="assets/css/main.css" />
    <noscript><link rel="stylesheet" href="assets/css/noscript.css" /></noscript>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="assets/sass/main.scss">

    <style>
        /* =================================================================== */
        /* ===== ESTILOS PARA O NOVO MODAL DO APLICATIVO ===== */
        /* =================================================================== */
        .app-modal-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 42, 69, 0.8);
            z-index: 1050;
            opacity: 0;
            transition: opacity 0.3s ease;
        }
        .app-modal-content {
            display: none;
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%) scale(0.95);
            background-color: #fff;
            padding: 2.5em;
            border-radius: 12px;
            width: 90%;
            max-width: 800px;
            box-shadow: 0 5px 25px rgba(0,0,0,0.2);
            z-index: 1051;
            opacity: 0;
            transition: opacity 0.3s ease, transform 0.3s ease;
        }
        .app-modal-overlay.show, .app-modal-content.show {
            display: block;
            opacity: 1;
        }
        .app-modal-content.show {
            transform: translate(-50%, -50%) scale(1);
        }
        .app-modal-close {
            position: absolute;
            top: 15px;
            right: 20px;
            font-size: 2rem;
            font-weight: 300;
            color: #aaa;
            cursor: pointer;
            line-height: 1;
        }
        .app-modal-close:hover {
            color: #333;
        }
        .app-modal-body h2 {
            color: #002a45;
            margin-bottom: 0.5em;
            font-size: 1.8rem;
        }
        .app-modal-body .app-features p {
            color: #555;
            margin-bottom: 0.75em;
            font-size: 1rem;
            display: flex;
            align-items: center;
        }
        .app-modal-body .app-features .fa-check-circle {
            color: #002a45;
            margin-right: 10px;
        }
        .qr-section { text-align: center; }
        .qr-section img { width: 150px; height: 150px; margin-bottom: 1em; }
        .app-download-buttons .app-button img { height: 50px; margin: 0.5em; transition: transform 0.2s ease-in-out; }
        .app-download-buttons .app-button:hover img { transform: scale(1.05); }
        @media (max-width: 767px) {
            .app-modal-body .row {
                text-align: center;
            }
            .app-features {
                margin-bottom: 1.5em;
            }
        }
        
        /* ESTILOS: Gradiente para seções de imagem (exceto banner principal) */
        .spotlight > .image {
            /* Padrão (desktop): gradiente HORIZONTAL do azul para o branco */
            background: linear-gradient(to right, #002a45 0%, #ffffff 100%);
        }

        /* Ajusta o gradiente para mobile */
        @media (max-width: 767px) {
            .spotlight > .image {
                min-height: 350px;
                /* Mobile: gradiente VERTICAL com azul no meio */
                background: linear-gradient(to bottom, #ffffff 0%, #002a45 50%, #ffffff 100%);
            }
        }

        /* Correção para a imagem principal ocupar metade do banner */
        #wrapper .banner.style1 .image {
            background: none !important; /* Garante que não haja fundo */
            padding: 0 !important;
            border-radius: 0 !important;
        }

        .banner.style1 .image img {
            width: 100%;
            height: 100%;
            object-fit: cover; /* Preenche o contêiner sem distorcer */
            object-position: center; /* Centraliza a imagem no contêiner */
            display: block;
        }
    </style>

</head>
<body class="is-preload">


<!-- Header -->
<nav class="navbar navbar-expand-lg navbar-light bg-white fixed-top custom-header">
    <div class="container d-flex align-items-center">
        <a class="navbar-brand" href="#">
            <img src="images/logo.png" alt="Logo" class="img-fluid logo-custom" />
        </a>

        <button class="navbar-toggler ms-auto" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav"
                aria-controls="navbarNav" aria-expanded="false" aria-label="Alternar navegação">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item"><a class="nav-link" href="#first">Sobre</a></li>
                <li class="nav-item"><a class="nav-link" href="#servicos">Serviços</a></li>
                <li class="nav-item"><a class="nav-link" href="https://wa.me/5511953423838">Contato</a></li>

                <li class="nav-item dropdown ms-3">
                    <a class="nav-link dropdown-toggle d-flex align-items-center p-0" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                        <img src="images/usuario.png" alt="Foto do Usuário" class="rounded-circle" style="width:40px; height:40px; object-fit:cover;">
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end">
                        <li><a class="dropdown-item" href="minhaConta.jsp">Minha conta</a></li>
                        <li><a class="dropdown-item" href="agendarConsulta.jsp">Marcar consulta</a></li>
                        <li><a class="dropdown-item text-danger" href="logout.jsp">Sair da conta</a></li>
                    </ul>
                </li>
            </ul>
        </div>
    </div>
</nav>
<!-- Wrapper -->
<div id="wrapper" class="divided">

    <!-- One -->
    <section class="banner style1 orient-left content-align-left image-position-right fullscreen onload-image-fade-in onload-content-fade-right">
        <div class="content">
            <h1>Médica Veterinária em São Paulo</h1>
            <p class="major">A Clínica foi criada com o objetivo de fornecer serviços veterinários de alta qualidade, focados no bem-estar e saúde dos animais. Nossa clínica conta com uma equipe de profissionais experientes e capacitados, além de uma
                infraestrutura moderna, para garantir que seu pet receba o melhor atendimento possível.</a></p>
            <ul class="actions stacked">
                <li><a href="agendarConsulta.jsp" class="button big wide smooth-scroll-middle">Marcar consulta</a></li>
            </ul>
        </div>
        <div class="image">
            <img src="images/ananda.jpeg" alt="" />
        </div>
    </section>

    <!-- Two -->
    <section class="spotlight style1 orient-right content-align-left image-position-center onscroll-image-fade-in" id="first">
        <div class="content">
            <h2>Sobre nós</h2>
            <p>Em nosso centro, acreditamos que a qualidade do atendimento vai além do conhecimento técnico; por isso, prezamos por uma abordagem atenciosa, garantindo que cada animal seja tratado com o máximo de cuidado e respeito. Nosso foco está na prevenção, diagnóstico e tratamento de doenças,
                com ênfase no acompanhamento contínuo da saúde dos nossos pacientes.
            </p>

        </div>
        <div class="image">
            <!-- Imagem de fundo removida -->
        </div>

    </section>

    <!-- Three -->
    <section id="#three" class="spotlight style1 orient-left content-align-left image-position-center onscroll-image-fade-in">
        <div class="content">
            <h2>Nosso compromisso é oferecer cuidados completos para que seu pet tenha uma vida saudável. </h2>
            <p>Oferecemos diagnósticos precisos e tratamentos eficazes, sempre com o carinho e respeito que seu pet merece.
                Nossa equipe está pronta para proporcionar o melhor cuidado, garantindo que seu amigo esteja confortável,
                seguro e em boas mãos
                em todas as etapas do atendimento.</p>

        </div>
        <div class="image">
            <!-- Imagem de fundo removida -->
        </div>
    </section>

    <!-- Four -->
    <section class="spotlight style1 orient-right content-align-left image-position-center onscroll-image-fade-in">
        <div class="content">
            <h2>Clínica Pet & Internação</h2>
            <p> Nossa clínica é especializada em cuidados veterinários, fundada com o objetivo de proporcionar um
                atendimento preciso e confiável para animais de companhia. Nossa estrutura moderna, equipada com tecnologia avançada, permite oferecer um serviço completo para as necessidades de saúde dos pets.</p>
            <ul class="actions stacked">

            </ul>
        </div>
        <div class="image">
            <!-- Imagem de fundo removida -->
        </div>
    </section>

    <!-- Five -->
    <section class="wrapper style1 align-center" id="servicos">
        <div class="inner">
            <h2>Nossos Serviços</h2>
            <p>Nossa clínica dispõe de tecnologias de ponta para diagnósticos e tratamentos, abrangendo uma ampla gama de serviços, como consultas clínicas, vacinação, exames laboratoriais, cirurgias, e atendimento de urgências. </p>
        </div>

        <!-- Gallery Bootstrap -->
        <div class="container mt-5">
            <div class="row">
                <!-- Serviço 1 -->
                <div class="col-md-4 mb-4">
                    <div class="card h-100">
                        <img src="images/gallery/alta-complex.jpeg" class="card-img-top" alt="Alta Complexidade">
                        <div class="card-body">
                            <h5 class="card-title">Cirurgia De Alta Complexidade</h5>
                            <p class="card-text">Realizamos cirurgias de alta complexidade para tratar
                                condições graves.</p>
                        </div>
                    </div>
                </div>

                <!-- Serviço 2 -->
                <div class="col-md-4 mb-4">
                    <div class="card h-100">
                        <img src="images/gallery/vacinas.jpeg" class="card-img-top" alt="Vacinas">
                        <div class="card-body">
                            <h5 class="card-title">Vacinas</h5>
                            <p class="card-text">Oferecemos um calendário de vacinação completo e atualizado.</p>
                        </div>
                    </div>
                </div>

                <!-- Serviço 3 -->
                <div class="col-md-4 mb-4">
                    <div class="card h-100">
                        <img src="images/gallery/exames.jpeg" class="card-img-top" alt="Exames">
                        <div class="card-body">
                            <h5 class="card-title">Exames</h5>
                            <p class="card-text">Realizamos exames completos para avaliar a saúde do seu pet,
                                garantindo diagnósticos rápidos.</p>
                        </div>
                    </div>
                </div>

                <!-- Serviço 4 -->
                <div class="col-md-4 mb-4">
                    <div class="card h-100">
                        <img src="images/gallery/castração.jpeg" class="card-img-top" alt="Castração">
                        <div class="card-body">
                            <h5 class="card-title">Castração</h5>
                            <p class="card-text">Realizamos castração segura e humanizada para cães e gatos.</p>
                        </div>
                    </div>
                </div>

                <!-- Serviço 5 -->
                <div class="col-md-4 mb-4">
                    <div class="card h-100">
                        <img src="images/gallery/clinica-para.jpeg" class="card-img-top" alt="Clínica">
                        <div class="card-body">
                            <h5 class="card-title">Clínica Para Todos</h5>
                            <p class="card-text">Nossa clínica presta atendimento veterinário para todos animais domésticos.</p>
                        </div>
                    </div>
                </div>

                <!-- Serviço 6 -->
                <div class="col-md-4 mb-4">
                    <div class="card h-100">
                        <img src="images/gallery/micro.jpeg" class="card-img-top" alt="Microscopia">
                        <div class="card-body">
                            <h5 class="card-title">Micro chip</h5>
                            <p class="card-text">Oferecemos o serviço de microchipagem para identificação segura de cães e gatos.</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section class="spotlight style1 orient-left content-align-left image-position-center onscroll-image-fade-in">
        <div class="content">
            <h2>Sobre mim</h2>
            <p>Olá, sou a Dra. Ananda Hattori, e minha vida é dedicada ao cuidado e bem-estar dos <br> animais. Desde pequena, sempre soube que queria ser médica veterinária, <br>
                e essa paixão me guiou por toda a minha jornada educacional e profissional.</p>
            <br>
            <p>Mestre pela USP, professora e cirurgiã no Veros Hospital, <br> ofereço um atendimento especializado e humanizado.
                <br>Meu compromisso é com a saúde e bem-estar dos animais,<br> garantindo tratamentos modernos e eficientes.</p>

            <li><a href="#" class="button">Ir para o topo</a></li>

        </div>


        <div class="image">
            <img src="images/ananda2 (1).jpeg" alt="" />
        </div>
    </section>


    <!-- Footer -->
    <footer class="wrapper style1 align-center">
        <div class="inner">
            <ul class="icons">
                <!-- WhatsApp -->
                <li><a href="https://wa.me/5511953423838" target="_blank" class="icon brands style2 fa-whatsapp"></a></li>
                <!-- Instagram -->
                <li><a href="https://www.instagram.com/clinica_veterinaria.hattori/" class="icon brands style2 fa-instagram"><span class="label">Instagram</span></a></li>
                <!-- Localização -->
                <li>
                    <a href="https://www.google.com/maps?q=Rua+Exemplo,+123,+São+Paulo,+SP" target="_blank" class="icon style2">
                        <img src="images/localizacao.png" alt="Localização" class="icon-img localizacao">
                    </a>
                </li>

                <li><a href="#" class="icon style2 fa-envelope"><span class="label">Email</span></a></li>
            </ul>
            <p>&copy; 2025 Copyright</p>
        </div>
    </footer>
</div>

<!-- ============================================= -->
<!-- ===== ESTRUTURA DO NOVO MODAL DO APP ===== -->
<!-- ============================================= -->
<div class="app-modal-overlay" id="appModalOverlay"></div>
<div class="app-modal-content" id="appModalContent">
    <span class="app-modal-close" id="appModalClose">&times;</span>
    <div class="container-fluid">
        <div class="row align-items-center app-modal-body">
            <!-- Coluna da Esquerda: Textos e Benefícios -->
            <div class="col-md-7">
                <h2>Uma Nova Experiência de Cuidado</h2>
                <p>Otimize a saúde do seu pet com nosso aplicativo exclusivo. Agende, acompanhe e acesse tudo em um só lugar.</p>
                <div class="app-features">
                    <p><i class="fas fa-check-circle"></i> Agendamento prioritário para procedimentos.</p>
                    <p><i class="fas fa-check-circle"></i> Acesso completo ao prontuário digital.</p>
                    <p><i class="fas fa-check-circle"></i> Notificações importantes sobre saúde e vacinas.</p>
                </div>
                <div class="app-download-buttons d-none d-md-block">
                    <a href="#" class="app-button" target="_blank"><img src="https://upload.wikimedia.org/wikipedia/commons/7/78/Google_Play_Store_badge_EN.svg" alt="Disponível no Google Play"></a>
                    <a href="#" class="app-button" target="_blank"><img src="https://upload.wikimedia.org/wikipedia/commons/3/3c/Download_on_the_App_Store_Badge.svg" alt="Baixar na App Store"></a>
                </div>
            </div>
            <!-- Coluna da Direita: QR Code e Botões -->
            <div class="col-md-5 qr-section">
                <p class="mb-2"><strong>Aponte a câmera e baixe agora:</strong></p>
                <img src="https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=https://www.google.com/search?q=clinica+veterinaria+ananda" alt="QR Code para baixar o aplicativo">
                <div class="app-download-buttons d-block d-md-none mt-3">
                    <a href="#" class="app-button" target="_blank"><img src="https://upload.wikimedia.org/wikipedia/commons/7/78/Google_Play_Store_badge_EN.svg" alt="Disponível no Google Play"></a>
                    <a href="#" class="app-button" target="_blank"><img src="https://upload.wikimedia.org/wikipedia/commons/3/3c/Download_on_the_App_Store_Badge.svg" alt="Baixar na App Store"></a>
                </div>
            </div>
        </div>
    </div>
</div>


<!-- Scripts -->
<script src="assets/js/jquery.min.js"></script>
<!-- O Bootstrap Bundle deve ser carregado ANTES dos scripts do template (main.js) para evitar conflitos -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="assets/js/jquery.scrollex.min.js"></script>
<script src="assets/js/jquery.scrolly.min.js"></script>
<script src="assets/js/browser.min.js"></script>
<script src="assets/js/breakpoints.min.js"></script>
<script src="assets/js/util.js"></script>
<script src="assets/js/main.js"></script>

<!-- Script para o Modal e Correção do Menu Móvel -->
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const modalOverlay = document.getElementById('appModalOverlay');
        const modalContent = document.getElementById('appModalContent');
        const closeModalBtn = document.getElementById('appModalClose');

        const showModal = () => {
            modalOverlay.classList.add('show');
            modalContent.classList.add('show');
            sessionStorage.setItem('appModalShown', 'true');
        };

        const closeModal = (e) => {
            // Impede que o clique dentro do modal feche o modal
            if (e && e.target !== modalOverlay && e.target !== closeModalBtn) {
                return;
            }
            modalOverlay.classList.remove('show');
            modalContent.classList.remove('show');
        };

        const handleScroll = () => {
            if (sessionStorage.getItem('appModalShown')) {
                window.removeEventListener('scroll', handleScroll);
                return;
            }
            if (window.scrollY > 700) {
                showModal();
                window.removeEventListener('scroll', handleScroll);
            }
        };

        window.addEventListener('scroll', handleScroll);
        closeModalBtn.addEventListener('click', closeModal);
        modalOverlay.addEventListener('click', closeModal);

        // --- CORREÇÃO PARA O MENU MÓVEL ---
        // Seleciona links que devem fechar o menu, EXCLUINDO o toggle do dropdown
        const navLinks = document.querySelectorAll('#navbarNav .nav-link:not(.dropdown-toggle), #navbarNav .dropdown-item');
        const navCollapse = document.getElementById('navbarNav');
        if (navCollapse) {
            const bsCollapse = new bootstrap.Collapse(navCollapse, { toggle: false });
            navLinks.forEach(function(link) {
                link.addEventListener('click', function() {
                    if (navCollapse.classList.contains('show')) {
                        bsCollapse.hide();
                    }
                });
            });
        }
    });
</script>
</body>
</html>

