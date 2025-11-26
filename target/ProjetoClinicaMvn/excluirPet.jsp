<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*" %>
<%
     String url = System.getenv("DB_URL");
            String usuario = System.getenv("DB_USERNAME");
            String senhaBD = System.getenv("DB_PASSWORD");
            

    // Obtendo o ID do pet da requisição
    String idPetStr = request.getParameter("idPet");

    if (idPetStr == null || idPetStr.isEmpty()) {
        out.println("<p style='color: red;'>Erro: ID do pet não foi informado.</p>");
        return;
    }

    int idPet = Integer.parseInt(idPetStr);

    Connection conexao = null;
    PreparedStatement stmt = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conexao = DriverManager.getConnection(url, usuario, senhaBD);

        String sql = "DELETE FROM animais WHERE id = ?";
        stmt = conexao.prepareStatement(sql);
        stmt.setInt(1, idPet);

        int rowsAffected = stmt.executeUpdate();

        if (rowsAffected > 0) {
            response.sendRedirect("minhaConta.jsp?msg=sucesso");
        } else {
            response.sendRedirect("minhaConta.jsp?msg=erro");
        }

    } catch (Exception e) {
        e.printStackTrace();
        out.println("<p style='color: red;'>Erro ao excluir o pet: " + e.getMessage() + "</p>");
    } finally {
        try {
            if (stmt != null) stmt.close();
            if (conexao != null) conexao.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>
