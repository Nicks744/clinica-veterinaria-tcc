<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>

<%
    // Variáveis para armazenar as estatísticas
    int consultasPendentesHoje = 0;
    int totalPets = 0;
    int totalClientes = 0;

      String url = System.getenv("DB_URL");
    String usuario = System.getenv("DB_USERNAME");
    String senhaBD = System.getenv("DB_PASSWORD");
    
    try (Connection conexao = DriverManager.getConnection(url, usuario, senhaBD)) {
        
        // 1. Contar consultas pendentes para o dia de hoje
        String sqlPendentes = "SELECT COUNT(*) FROM dadosconsulta WHERE status = 'pendente' AND DATE(data_consulta) = CURDATE()";
        try (Statement stmt = conexao.createStatement(); ResultSet rs = stmt.executeQuery(sqlPendentes)) {
            if (rs.next()) {
                consultasPendentesHoje = rs.getInt(1);
            }
        }

        // 2. Contar total de pets cadastrados
        String sqlPets = "SELECT COUNT(*) FROM animais";
        try (Statement stmt = conexao.createStatement(); ResultSet rs = stmt.executeQuery(sqlPets)) {
            if (rs.next()) {
                totalPets = rs.getInt(1);
            }
        }

        // 3. Contar total de clientes (usuários que não são admin)
        String sqlClientes = "SELECT COUNT(*) FROM usuarios WHERE tipo != 'admin'";
        try (Statement stmt = conexao.createStatement(); ResultSet rs = stmt.executeQuery(sqlClientes)) {
            if (rs.next()) {
                totalClientes = rs.getInt(1);
            }
        }

    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bem-vindo</title>
    <!-- favicon em SVG -->
    <link rel="icon" type="image/svg+xml" href="imgs_inicio/minilogo.svg">

    <!-- fallback em PNG -->
    <link rel="icon" type="image/png" href="imgs_inicio/minilogo.png">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', sans-serif;
            color: #333;
        }
        .stat-card {
            background-color: white;
            border: none;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.07);
            text-align: center;
            padding: 2rem;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.1);
        }
        .stat-card .display-4 {
            font-weight: 700;
            color: #002F4B;
        }
        .stat-card p {
            color: #6c757d;
            font-size: 1.1rem;
        }
        .action-card {
            display: flex;
            align-items: center;
            justify-content: center;
            flex-direction: column;
            text-decoration: none;
            color: #fff;
            background-color: #4674A5;
            min-height: 150px;
            font-size: 1.5rem;
            font-weight: 500;
        }
        .action-card.agenda { background-color: #002F4B; }
        .action-card.gerenciar { background-color: #4674A5; }
        .action-card.pets { background-color: #83c5be; color: #002F4B; }
        
        .action-card:hover {
            color: #fff;
            opacity: 0.9;
        }
    </style>
</head>
<body>

<div class="container-fluid p-4 p-md-5">

    <header class="pb-3 mb-4 border-bottom">
        <h1 class="display-5">Painel de Controle</h1>
        <p class="text-muted">Bem-vindo(a) de volta! Aqui está um resumo da sua clínica.</p>
    </header>

    <div class="row g-4 mb-4">
        <div class="col-lg-4 col-md-6">
            <div class="stat-card">
                <h3 class="display-4"><%= consultasPendentesHoje %></h3>
                <p>Consultas Pendentes Hoje</p>
            </div>
        </div>
        <div class="col-lg-4 col-md-6">
            <div class="stat-card">
                <h3 class="display-4"><%= totalPets %></h3>
                <p>Total de Pets Cadastrados</p>
            </div>
        </div>
        <div class="col-lg-4 col-md-12">
            <div class="stat-card">
                <h3 class="display-4"><%= totalClientes %></h3>
                <p>Clientes Ativos</p>
            </div>
        </div>
    </div>

    <h2 class="h4 mb-3">Ações Rápidas</h2>
    <div class="row g-4">
        <div class="col-md-4">
            <a href="agendarConsultaAdm.jsp" class="stat-card action-card agenda">
                Agendar Consulta
            </a>
        </div>
        <div class="col-md-4">
            <a href="listarConsulta.jsp" class="stat-card action-card gerenciar">
                Gerenciar Consultas
            </a>
        </div>
        <div class="col-md-4">
            <a href="listarPets.jsp" class="stat-card action-card pets">
                Gerenciar Pets
            </a>
        </div>
    </div>

</div>

</body>
</html>