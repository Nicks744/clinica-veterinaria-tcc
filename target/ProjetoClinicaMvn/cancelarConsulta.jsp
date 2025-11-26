<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, jakarta.servlet.http.HttpSession" %>

<%
    // 1. Obter o ID da consulta a ser cancelada
    String idConsultaStr = request.getParameter("id");
    if (idConsultaStr == null || idConsultaStr.trim().isEmpty()) {
        response.sendRedirect("minhaConta.jsp?erro=ID da consulta não fornecido.");
        return;
    }

    int idConsulta = Integer.parseInt(idConsultaStr);

    // 2. Verificar se o usuário está logado e obter o CPF
    HttpSession sessao = request.getSession(false);
    if (sessao == null || sessao.getAttribute("cpf") == null) {
        response.sendRedirect("telaLogin.jsp?erro=Sua sessão expirou.");
        return;
    }
    String cpfSessao = (String) sessao.getAttribute("cpf");

    // 3. Conectar ao banco e deletar a consulta
    String url = System.getenv("DB_URL");
            String usuario = System.getenv("DB_USERNAME");
            String senhaBD = System.getenv("DB_PASSWORD");
    
    Connection conexao = null;
    PreparedStatement stmt = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conexao = DriverManager.getConnection(url, usuario, senhaBD);

        // SQL para deletar a consulta, garantindo que ela pertence ao usuário logado (pelo CPF)
        String sql = "DELETE FROM dadosconsulta WHERE id = ? AND cpf = ?";
        
        stmt = conexao.prepareStatement(sql);
        stmt.setInt(1, idConsulta);
        stmt.setString(2, cpfSessao);

        int linhasAfetadas = stmt.executeUpdate();

        if (linhasAfetadas > 0) {
            // Sucesso
            response.sendRedirect("minhaConta.jsp?sucesso=Consulta cancelada com sucesso!");
        } else {
            // Falha (talvez a consulta não exista ou não pertença ao usuário)
            response.sendRedirect("minhaConta.jsp?erro=Não foi possível cancelar a consulta. Verifique se ela ainda existe.");
        }

    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("minhaConta.jsp?erro=Ocorreu um erro no servidor ao tentar cancelar a consulta.");
    } finally {
        // Fechar recursos
        if (stmt != null) try { stmt.close(); } catch (SQLException e) { /* ignora */ }
        if (conexao != null) try { conexao.close(); } catch (SQLException e) { /* ignora */ }
    }
%>