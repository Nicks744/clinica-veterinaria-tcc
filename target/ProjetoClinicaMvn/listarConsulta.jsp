<%
    HttpSession sessao = request.getSession(false);
    // Verifica se o usuário está logado e se é ADMIN
    if (sessao == null || !"admin".equals(sessao.getAttribute("tipo"))) {
        response.sendRedirect("telaLogin.jsp"); // ou outra página de acesso negado
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
    <title>Consultas Agendadas</title>
    <!-- favicon em SVG -->
    <link rel="icon" type="image/svg+xml" href="imgs_inicio/minilogo.svg">

    <!-- fallback em PNG -->
    <link rel="icon" type="image/png" href="imgs_inicio/minilogo.png">
    <link rel="stylesheet" href="listarConsulta.css">
    <script src="scriptListarConsulta.js"></script>
</head>
<body>

<%
    SimpleDateFormat formatoCompleto = new SimpleDateFormat("dd/MM/yyyy HH:mm");
%>

<h2>Consultas Agendadas</h2>

<div class="barra-azul">
    <img src="imgs_adm/orelhinhas.png" alt="" class="img-decorativa">
    <form method="get" class="filtro-form">
        <label for="status">Filtrar por Status:</label>
        <select id="status" name="status" onchange="this.form.submit()">
            <option value="">Todos</option>
            <option value="pendente" <%= "pendente".equals(request.getParameter("status")) ? "selected" : "" %>>Pendente</option>
            <option value="confirmada" <%= "confirmada".equals(request.getParameter("status")) ? "selected" : "" %>>Confirmada</option>
            <option value="concluida" <%= "concluida".equals(request.getParameter("status")) ? "selected" : "" %>>Concluída</option>
        </select>

        <label for="busca">Buscar:</label>
        <div class="input-clearable">
            <input type="text" id="busca" name="busca" placeholder="Nome do Dono ou Pet"
                   value="<%= request.getParameter("busca") != null ? request.getParameter("busca") : "" %>">
            <span class="clear-btn" onclick="limparCampo('busca'); this.form.submit();">&times;</span>
        </div>
        <button type="submit">Filtrar</button>
    </form>
</div>

<div class="card-container">
    <%
         String url = System.getenv("DB_URL");
            String usuario = System.getenv("DB_USERNAME");
            String senhaBD = System.getenv("DB_PASSWORD");
            

        Connection conexao = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conexao = DriverManager.getConnection(url, usuario, senhaBD);

            String statusFiltro = request.getParameter("status");
            String busca = request.getParameter("busca");

            // SQL CORRIGIDO: Une as 3 tabelas para pegar todos os dados necessários
            String sql = "SELECT c.*, u.nome as nome_dono, a.nome as nome_pet, a.especie, a.raca " +
                         "FROM dadosconsulta c " +
                         "JOIN usuarios u ON c.cpf = u.cpf " +
                         "JOIN animais a ON c.id_animal = a.id " +
                         "WHERE 1=1";
            
            if (statusFiltro != null && !statusFiltro.isEmpty()) {
                sql += " AND c.status = ?";
            }
            if (busca != null && !busca.trim().isEmpty()) {
                sql += " AND (u.nome LIKE ? OR a.nome LIKE ?)";
            }
            sql += " ORDER BY c.data_consulta ASC";

            stmt = conexao.prepareStatement(sql);

            int paramIndex = 1;
            if (statusFiltro != null && !statusFiltro.isEmpty()) {
                stmt.setString(paramIndex++, statusFiltro);
            }
            if (busca != null && !busca.trim().isEmpty()) {
                stmt.setString(paramIndex++, "%" + busca + "%");
                stmt.setString(paramIndex++, "%" + busca + "%");
            }

            rs = stmt.executeQuery();

            while (rs.next()) {
                Integer id = rs.getInt("id");
                String nomeDono = rs.getString("nome_dono");
                String numero = rs.getString("numero");
                String cpf = rs.getString("cpf");
                String nomePet = rs.getString("nome_pet");
                String especie = rs.getString("especie");
                String raca = rs.getString("raca");
                Timestamp dataConsultaTimestamp = rs.getTimestamp("data_consulta");
                String dataConsultaFormatada = formatoCompleto.format(dataConsultaTimestamp);
                
                String sintomas = rs.getString("sintomas");
                String peso = rs.getString("peso");
                String obs = rs.getString("observacoes");
                String status = rs.getString("status");

                String classeStatus = "badge-status status-" + status.toLowerCase();
    %>

    <div class="consulta-card" onclick="abrirModal(
            '<%= nomeDono.replace("'", "\\'") %>', '<%= numero %>', '<%= cpf %>',
            '<%= nomePet.replace("'", "\\'") %>', '<%= especie %>', '<%= raca %>',
            '<%= dataConsultaFormatada %>', '<%= sintomas.replace("'", "\\'") %>', 
            '<%= peso %>', '<%= obs.replace("'", "\\'") %>', '<%= status %>')">

        <h3><%= nomeDono %> (<%= nomePet %>)</h3>
        <p><strong>Data:</strong> <%= dataConsultaFormatada %></p>
        <p><strong>CPF:</strong> <%= cpf %></p>
        <p><strong>Status:</strong> <span class="<%= classeStatus %>"><%= status %></span></p>

        <% if ("concluida".equalsIgnoreCase(status)) { %>
            <button type="button" class="ver" onclick="event.stopPropagation(); window.location.href='verRelatorioAdm.jsp?id=<%= id %>'">Ver Relatório</button>
        <% } else if ("confirmada".equalsIgnoreCase(status)) { %>
            <button type="button" class="realizar" onclick="event.stopPropagation(); window.location.href='realizandoConsulta.jsp?id=<%= id %>'">Realizar Consulta</button>
        <% } else if ("pendente".equalsIgnoreCase(status)) { %>
            <button type="button" class="confirmar" onclick="event.stopPropagation(); confirmarConsulta(<%= id %>)">Confirmar</button>
        <% } %>

        <button type="button" class="btnExcluirConsulta" onclick="event.stopPropagation(); confirmarExclusao(<%= id %>)">
            <span class="icone-lixeira"></span>
        </button>
    </div>

    <%
            } // Fim do while
        } catch (Exception e) {
            out.println("<p style='color:red;'>Erro: " + e.getMessage() + "</p>");
            e.printStackTrace();
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conexao != null) conexao.close();
        }
    %>
</div>

<div id="modal" class="modal">
    <div class="modal-content">
        <span class="close" onclick="fecharModal()">&times;</span>
        <h1>Detalhes da Consulta</h1>

        <div class="modal-section">
            <h2>Informações do Tutor</h2>
            <p><strong>Nome:</strong> <span id="modal-nome-dono"></span></p>
            <p><strong>Telefone:</strong> <span id="modal-numero"></span></p>
            <p><strong>CPF:</strong> <span id="modal-cpf"></span></p>
        </div>

        <div class="modal-section">
            <h2>Detalhes do Animal</h2>
            <p><strong>Nome do Pet:</strong> <span id="modal-nome-pet"></span></p>
            <p><strong>Espécie:</strong> <span id="modal-especie"></span></p>
            <p><strong>Raça:</strong> <span id="modal-raca"></span></p>
            <p><strong>Peso:</strong> <span id="modal-peso"></span> kg</p>
            <p><strong>Sintomas:</strong> <span id="modal-sintomas"></span></p>
        </div>

        <div class="modal-section">
            <h2>Agendamento</h2>
            <p><strong>Data e Hora:</strong> <span id="modal-data"></span></p>
            <p><strong>Status:</strong> <span id="modal-status"></span></p>
        </div>

        <div class="modal-section">
            <h2>Observações</h2>
            <p id="modal-obs"></p>
        </div>
    </div>
</div>
<script>
    function confirmarExclusao(id) {
        if (confirm("Tem certeza que deseja excluir esta consulta?")) {
            window.location.href = 'excluirConsulta.jsp?id=' + id;
        }
    }

    function confirmarConsulta(id) {
        if (confirm("Deseja marcar esta consulta como CONFIRMADA?")) {
            window.location.href = 'confirmarConsulta.jsp?id=' + id;
        }
    }

    // A função abrirModal precisa ser atualizada para receber os novos dados
    function abrirModal(nomeDono, numero, cpf, nomePet, especie, raca, data, sintomas, peso, obs, status) {
        document.getElementById('modal-nome-dono').innerText = nomeDono;
        document.getElementById('modal-numero').innerText = numero;
        document.getElementById('modal-cpf').innerText = cpf;
        document.getElementById('modal-nome-pet').innerText = nomePet;
        document.getElementById('modal-especie').innerText = especie;
        document.getElementById('modal-raca').innerText = raca;
        document.getElementById('modal-data').innerText = data;
        document.getElementById('modal-sintomas').innerText = sintomas;
        document.getElementById('modal-peso').innerText = peso;
        document.getElementById('modal-obs').innerText = obs || "Nenhuma observação.";
        document.getElementById('modal-status').innerText = status;
        
        document.getElementById('modal').style.display = 'flex';
    }

    function fecharModal() {
        document.getElementById('modal').style.display = 'none';
    }

    function limparCampo(idCampo) {
        document.getElementById(idCampo).value = '';
    }
</script>

</body>
</html>