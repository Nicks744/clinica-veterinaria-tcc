<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, jakarta.servlet.http.HttpSession, java.text.SimpleDateFormat" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Relatório da Consulta</title>
    <!-- favicon em SVG -->
    <link rel="icon" type="image/svg+xml" href="imgs_inicio/minilogo.svg">

    <!-- fallback em PNG -->
    <link rel="icon" type="image/png" href="imgs_inicio/minilogo.png">
    <style>
        body { font-family: Arial, sans-serif; background-color: #f8f9fa; padding: 30px; }
        .container { background-color: #ffffff; border-radius: 10px; padding: 30px; max-width: 800px; margin: auto; box-shadow: 0px 0px 15px rgba(0,0,0,0.1); }
        h1, h2 { color: #333; border-bottom: 1px solid #eee; padding-bottom: 10px; margin-bottom: 15px; }
        p { font-size: 16px; margin: 10px 0; line-height: 1.6; }
        .btn-voltar { display: inline-block; margin-top: 20px; padding: 10px 18px; background-color: #0d1369; color: white; text-decoration: none; border-radius: 8px; }
        .btn-voltar:hover { background-color: #12164d; }
        .btn-imprimir { background-color: #28a745; margin-left: 10px; }
        .btn-imprimir:hover { background-color: #1e7e34; }
        .erro { color: red; }
        @media print {
            body { padding: 0; background-color: #fff; }
            .container { box-shadow: none; border: 1px solid #ddd; }
            .btn-voltar, .btn-imprimir { display: none; }
        }
    </style>
</head>
<body>
<%
    HttpSession sessao = request.getSession(false);
    if (sessao == null || sessao.getAttribute("usuarioLogado") == null) {
        response.sendRedirect("telaLogin.jsp");
        return;
    }

    String tipoUsuario = (String) sessao.getAttribute("tipo");
    String cpfSessao = (String) sessao.getAttribute("cpf");
    String idConsulta = request.getParameter("id");

    Connection conexao = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
      String url = System.getenv("DB_URL");
String usuario = System.getenv("DB_USERNAME");
String senhaBD = System.getenv("DB_PASSWORD");

conexao = DriverManager.getConnection(url, usuario, senhaBD);
        // ===== CORREÇÃO PARA USAR AS DUAS TABELAS: dadosconsulta E consultas_concluidas =====
        String sql = "SELECT " +
                     "  c.sintomas, c.peso, c.numero, " +                 // Dados da consulta inicial
                     "  cc.relatorio, cc.data_inicio, cc.data_encerrada, " + // Dados da consulta concluída
                     "  a.nome as nome_pet, a.especie, a.raca, " +        // Dados do pet
                     "  u.nome as nome_dono, u.cpf " +                     // Dados do dono
                     "FROM " +
                     "  dadosconsulta c " +
                     "JOIN " +
                     "  consultas_concluidas cc ON c.id = cc.id_consulta " + // A LIGAÇÃO ENTRE AS DUAS TABELAS DE CONSULTA
                     "JOIN " +
                     "  animais a ON c.id_animal = a.id " +
                     "JOIN " +
                     "  usuarios u ON c.cpf = u.cpf " +
                     "WHERE " +
                     "  c.id = ?";

        if (!"admin".equals(tipoUsuario)) {
            sql += " AND c.cpf = ?";
        }

        stmt = conexao.prepareStatement(sql);
        stmt.setInt(1, Integer.parseInt(idConsulta));
        if (!"admin".equals(tipoUsuario)) {
            stmt.setString(2, cpfSessao);
        }

        rs = stmt.executeQuery();

        if (rs.next()) {
            // Dados do Tutor
            String nomeDono = rs.getString("nome_dono");
            String numero = rs.getString("numero");
            String cpf = rs.getString("cpf");

            // Dados do Animal
            String nomePet = rs.getString("nome_pet");
            String especie = rs.getString("especie");
            String raca = rs.getString("raca");
            double peso = rs.getDouble("peso");
            String sintomas = rs.getString("sintomas");

            // Dados da Consulta (agora vindo da tabela correta)
            String relatorio = rs.getString("relatorio");
            Timestamp dataInicio = rs.getTimestamp("data_inicio");
            Timestamp dataEncerrada = rs.getTimestamp("data_encerrada");

            SimpleDateFormat formato = new SimpleDateFormat("dd/MM/yyyy HH:mm");
%>

<div class="container">
    <h1>Relatório da Consulta</h1>

    <h2>Informações do Tutor</h2>
    <p><strong>Nome:</strong> <%= nomeDono %></p>
    <p><strong>Telefone:</strong> <%= numero %></p>
    <p><strong>CPF:</strong> <%= cpf %></p>

    <h2>Informações do Animal</h2>
    <p><strong>Nome do Pet:</strong> <%= nomePet %></p>
    <p><strong>Espécie/Raça:</strong> <%= especie %> / <%= raca %></p>
    <p><strong>Peso:</strong> <%= peso %> kg</p>
    <p><strong>Sintomas Iniciais:</strong> <%= sintomas %></p>

    <h2>Datas</h2>
    <p><strong>Início do Atendimento:</strong> <%= (dataInicio != null) ? formato.format(dataInicio) : "Não registrado" %></p>
    <p><strong>Encerramento da Consulta:</strong> <%= (dataEncerrada != null) ? formato.format(dataEncerrada) : "Não registrado" %></p>

    <h2>Relatório Médico</h2>
    <p><%= (relatorio != null && !relatorio.isEmpty()) ? relatorio.replace("\n", "<br>") : "Nenhum relatório preenchido." %></p>

   
    <button onclick="window.print()" class="btn-voltar btn-imprimir">Imprimir</button>
</div>

<%
        } else {
%>
<div class="container">
    <p class="erro">⚠️ Relatório não encontrado ou você não tem permissão para acessá-lo.</p>
   <button onclick="history.back()" class="btn-voltar">Voltar</button>
</div>
<%
        }
    } catch (Exception e) {
%>
<div class="container">
    <p class="erro">Erro ao buscar relatório: <%= e.getMessage() %></p>
    <button onclick="history.back()" class="btn-voltar">Voltar</button>
</div>
<%
    e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception ignored) {}
        if (stmt != null) try { stmt.close(); } catch (Exception ignored) {}
        if (conexao != null) try { conexao.close(); } catch (Exception ignored) {}
    }
%>
</body>
</html>