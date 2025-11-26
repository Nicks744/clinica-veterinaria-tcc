<%
    HttpSession sessao = request.getSession(false);
    // Verifica se o usu�rio est� logado e se � ADMIN
    if (sessao == null || !"admin".equals(sessao.getAttribute("tipo"))) {
        response.sendRedirect("index.html");
        return;
    }
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Painel Administrativo - Clínica Veterinária</title>

    <!-- favicon em SVG -->
    <link rel="icon" type="image/svg+xml" href="imgs_inicio/minilogo.svg">

    <!-- fallback em PNG -->
    <link rel="icon" type="image/png" href="imgs_inicio/minilogo.png">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <style>
        :root {
            --sidebar-width: 280px;
        }
        html, body {
            height: 100%;
            margin: 0;
            overflow-x: hidden;
        }
        .admin-wrapper {
            display: flex;
            height: 100vh;
        }

        /* SIDEBAR (OFFCANVAS) */
        .sidebar-nav {
            background-color: #002F4B !important;
            transition: margin-left 0.3s ease-in-out;
            flex-shrink: 0;
        }

        /* CONTE�DO PRINCIPAL */
        .main-content {
            flex-grow: 1;
            display: flex;
            flex-direction: column;
            overflow-y: auto;
            width: 100%;
        }
        .painel-frame {
            flex-grow: 1;
            border: none;
        }

        /* L�GICA PARA SIDEBAR EM DESKTOP (TELAS GRANDES) */
        @media (min-width: 992px) {
            .sidebar-nav {
                width: var(--sidebar-width);
                transform: none !important; /* Reseta a transforma��o do offcanvas */
                visibility: visible !important; /* Garante que seja sempre vis�vel */
                margin-left: 0;
            }
            .main-content {
                /* Ajusta a largura para n�o ficar embaixo da sidebar */
                width: calc(100% - var(--sidebar-width));
            }
            body.sidebar-collapsed .sidebar-nav {
                margin-left: calc(-1 * var(--sidebar-width));
            }
            body.sidebar-collapsed .main-content {
                width: 100%;
            }
        }

        /* ESTILO PARA O �CONE DO BOT�O */
        .btn .bi {
            font-size: 1.2rem;
            vertical-align: middle;
        }
    </style>
</head>
<body>

    <div class="admin-wrapper">

        <div class="offcanvas-lg offcanvas-start text-bg-dark d-flex flex-column sidebar-nav" tabindex="-1" id="sidebarOffcanvas">

            <div class="offcanvas-header border-bottom">
                <h5 class="offcanvas-title">Administra��o</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="offcanvas" data-bs-target="#sidebarOffcanvas"></button>
            </div>

            <div class="offcanvas-body d-flex flex-column p-0">
                <ul class="nav nav-pills flex-column mb-auto">
                     <li class="nav-item p-2"><a href="bemvindo.jsp" target="painel" class="nav-link text-white">Dashboard</a></li>
                    <li class="nav-item p-2"><a href="agendarConsultaAdm.jsp" target="painel" class="nav-link text-white">Agendar Consulta</a></li>
                    <li class="nav-item p-2"><a href="listarConsulta.jsp" target="painel" class="nav-link text-white">Gerenciar Consultas</a></li>
                    <li class="nav-item p-2"><a href="listarPets.jsp" target="painel" class="nav-link text-white">Gerenciar Pets</a></li>
                </ul>
                <hr>
                <div class="px-3 pb-3">
                     <button class="btn btn-danger w-100" onclick="window.location.href='logout.jsp'">Sair</button>
                </div>
            </div>
        </div>

        <div class="main-content">
            <nav class="navbar bg-light border-bottom sticky-top">
                <div class="container-fluid">
                    <button class="btn d-lg-none" type="button" data-bs-toggle="offcanvas" data-bs-target="#sidebarOffcanvas">
                        <i class="bi bi-list"></i> Menu
                    </button>
                    <button class="btn d-none d-lg-block" type="button" id="desktop-toggle-btn">
                        <i class="bi bi-list"></i>
                    </button>
                    <span class="navbar-text">Painel Administrativo</span>
                </div>
            </nav>

            <iframe name="painel" src="bemvindo.jsp" class="painel-frame"></iframe>
        </div>

    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Script para controlar o menu lateral no DESKTOP
            const toggleBtn = document.getElementById('desktop-toggle-btn');
            if(toggleBtn) {
                toggleBtn.addEventListener('click', function() {
                    document.body.classList.toggle('sidebar-collapsed');
                });
            }

            // ===== NOVO SCRIPT PARA FECHAR O MENU MOBILE AUTOMATICAMENTE =====
            const sidebarLinks = document.querySelectorAll('#sidebarOffcanvas .nav-link');
            const sidebarElement = document.getElementById('sidebarOffcanvas');

            // Pega a inst�ncia do Offcanvas do Bootstrap
            // � importante fazer isso para poder usar o m�todo .hide()
            const bsOffcanvas = bootstrap.Offcanvas.getOrCreateInstance(sidebarElement);

            sidebarLinks.forEach(link => {
                link.addEventListener('click', () => {
                    // Verifica se a tela � de mobile (quando o offcanvas est� ativo)
                    // e se o offcanvas est� vis�vel antes de tentar fechar.
                    if (window.innerWidth < 992 && sidebarElement.classList.contains('show')) {
                        bsOffcanvas.hide();
                    }
                });
            });
        });
    </script>
</body>
</html>