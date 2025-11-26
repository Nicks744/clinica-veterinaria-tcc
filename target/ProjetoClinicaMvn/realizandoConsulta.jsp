<%
    HttpSession sessao = request.getSession(false);

    // Verifica se o usu�rio est� logado e se � ADMIN
    if (sessao == null || !"admin".equals(sessao.getAttribute("tipo"))) {
        response.sendRedirect("telaLogin.jsp"); // ou outra p�gina de acesso negado
        return;
    }
%>

<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Realizar Consulta</title>

    <!-- favicon em SVG -->
    <link rel="icon" type="image/svg+xml" href="imgs_inicio/minilogo.svg">

    <!-- fallback em PNG -->
    <link rel="icon" type="image/png" href="imgs_inicio/minilogo.png">
    <link rel="stylesheet" href="realizandoConsulta.css"> 
    <style>
    /* realizandoConsulta.css */
body {
    margin: 0;
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    background-color: #f8f9fa;
    color: #333;
}

.container {
    max-width: 800px;
    margin: 40px auto;
    background-color: #ffffff;
    border-radius: 16px;
    box-shadow: 0 8px 20px rgba(0, 0, 0, 0.08);
    padding: 40px;
    transition: all 0.3s ease-in-out;
}

h2 {
    text-align: center;
    color: #002F4B;
    font-size: 30px;
    margin-bottom: 32px;
}

h3 {
    color: #444;
    margin-bottom: 16px;
}

.info-block {
    margin-bottom: 30px;
    border-left: 4px solid #4674A5;
    padding-left: 16px;
    background-color: rgba(70, 116, 165, 0.3); /* transparência aplicada */
    padding: 20px;
    border-radius: 8px;
}


.info-block p {
    margin: 8px 0;
    font-size: 16px;
    line-height: 1.6;
}

label {
    font-weight: 600;
    font-size: 16px;
    display: block;
    margin-top: 20px;
}

textarea {
    width: 100%;
    min-height: 120px;
    resize: vertical;
    padding: 12px;
    font-size: 16px;
    border: 2px solid #dcdcdc;
    border-radius: 8px;
    margin-top: 8px;
    transition: border 0.3s ease;
    font-weight: bold;
}

textarea:focus {
    border-color: #BECFE0;
    outline: none;
      
}

input[type="submit"] {
    width: 100%;
    background-color: #002F4B;
    color: #fff;
    border: none;
    padding: 14px;
    font-size: 16px;
    border-radius: 10px;
    cursor: pointer;
    font-weight: bold;
    margin-top: 24px;
    transition: background-color 0.3s ease;
}

input[type="submit"]:hover {
    background-color: #35577B;
}

.voltarbtn{
    width: 100%;
    background-color: #4674A5;
    color: #fff;
    border: none;
    padding: 14px;
    font-size: 16px;
    border-radius: 10px;
    cursor: pointer;
    font-weight: bold;
    margin-top: 24px;
    transition: background-color 0.3s ease;
}
    
 
.voltarbtn:hover {
    animation: pulse 0.6s ease;
}
/* Responsivo */
@media (max-width: 600px) {
    .container {
        padding: 20px;
    }

    h2 {
        font-size: 24px;
    }
}


       @keyframes pulse {
  0% {
    transform: scale(1);
    box-shadow: 0 0 0 rgba(0, 0, 0, 0);
  }
  50% {
    transform: scale(1.02);
    box-shadow: 0 0 8px rgba(0, 0, 0, 0.1);
  }
  100% {
    transform: scale(1);
    box-shadow: 0 0 0 rgba(0, 0, 0, 0);
  }
}
    </style>
</head>
<body>

<div class="container">
<%
    int idConsulta = 0;
    try {
        idConsulta = Integer.parseInt(request.getParameter("id"));
    } catch (Exception e) {
        out.println("<p style='color:red;'>ID da consulta é inválido.</p>");
        return; 
    }

    String url = System.getenv("DB_URL");
    String usuario = System.getenv("DB_USERNAME");
    String senhaBD = System.getenv("DB_PASSWORD");

    Connection conexao = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conexao = DriverManager.getConnection(url, usuario, senhaBD);

        // A consulta une as 3 tabelas para pegar todos os dados necessários
        String sql = "SELECT c.*, u.nome as nome_dono, a.nome as nome_pet, a.especie, a.raca " +
                     "FROM dadosconsulta c " +
                     "JOIN usuarios u ON c.cpf = u.cpf " +
                     "JOIN animais a ON c.id_animal = a.id " +
                     "WHERE c.id = ?";
        
        stmt = conexao.prepareStatement(sql);
        stmt.setInt(1, idConsulta);
        rs = stmt.executeQuery();

        if (rs.next()) {
            // DADOS DO DONO
            String nomeDono = rs.getString("nome_dono");
            String numero = rs.getString("numero");
            String cpf = rs.getString("cpf");

            // DADOS DO PET
            String nomePet = rs.getString("nome_pet");
            String especie = rs.getString("especie");
            String raca = rs.getString("raca");
            double peso = rs.getDouble("peso");

            // DADOS DA CONSULTA
            String sintomas = rs.getString("sintomas");
            String obs = rs.getString("observacoes");
            Timestamp dataConsultaTimestamp = rs.getTimestamp("data_consulta");
            Timestamp dataInicio = rs.getTimestamp("data_inicio");

            // LÓGICA SIMPLIFICADA PARA ATUALIZAR data_inicio
            if (dataInicio == null) {
                String sqlAtualizaInicio = "UPDATE dadosconsulta SET data_inicio = NOW() WHERE id = ?";
                try (PreparedStatement stmtAtualiza = conexao.prepareStatement(sqlAtualizaInicio)) {
                    stmtAtualiza.setInt(1, idConsulta);
                    stmtAtualiza.executeUpdate();
                }
                // Pega o valor recém-inserido para exibir na página
                dataInicio = new Timestamp(System.currentTimeMillis());
            }

            // FORMATAÇÃO DAS DATAS
            SimpleDateFormat sdfDataHora = new SimpleDateFormat("dd/MM/yyyy HH:mm");
            String dataConsultaFormatada = sdfDataHora.format(new Date(dataConsultaTimestamp.getTime()));
            String inicioFormatado = sdfDataHora.format(new Date(dataInicio.getTime()));
%>
    <h2>Consulta de <%= nomePet %></h2>

    <div class="info-block">
        <h3>Dados do Atendimento</h3>
        <p><strong>Tutor:</strong> <%= nomeDono %> (CPF: <%= cpf %>)</p>
        <p><strong>Telefone:</strong> <%= numero %></p>
        <hr>
        <p><strong>Pet:</strong> <%= nomePet %></p>
        <p><strong>Espécie/Raça:</strong> <%= especie %> / <%= raca %></p>
        <p><strong>Peso:</strong> <%= peso %> kg</p>
        <hr>
        <p><strong>Data Agendada:</strong> <%= dataConsultaFormatada %></p>
        <p><strong>Sintomas Iniciais:</strong> <%= sintomas %></p>
        <p><strong>Observações do Tutor:</strong> <%= obs %></p>
        <p><strong>Início do Atendimento:</strong> <%= inicioFormatado %></p>
    </div>

    <form action="concluirConsulta.jsp" method="post">
        <input type="hidden" name="id" value="<%= idConsulta %>">
        
        <label for="relatorio">Relatório Médico:</label>
        <textarea name="relatorio" id="relatorio" rows="6" placeholder="Descreva o atendimento, diagnóstico e procedimentos realizados..." required></textarea>

        <input type="submit" value="Concluir Consulta">
        <button type="button" class="voltarbtn" onclick="window.location.href='listarConsulta.jsp'">Voltar</button>
    </form>

<%
        } else {
            out.println("<p style='color:red;'>Consulta não encontrada.</p>");
        }
    } catch (Exception e) {
        out.println("<p style='color:red;'>Erro: " + e.getMessage() + "</p>");
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException ex) {}
        if (stmt != null) try { stmt.close(); } catch (SQLException ex) {}
        if (conexao != null) try { conexao.close(); } catch (SQLException ex) {}
    }
%>
</div>

</body>
</html>