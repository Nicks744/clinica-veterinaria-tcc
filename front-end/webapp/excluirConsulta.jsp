<%@ page import="java.sql.*" %>
<%
    int id = Integer.parseInt(request.getParameter("id"));

    String url = System.getenv("DB_URL");
            String usuario = System.getenv("DB_USERNAME");
            String senhaBD = System.getenv("DB_PASSWORD");
            

    Connection conexao = null;
    PreparedStatement stmt = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conexao = DriverManager.getConnection(url, usuario, senhaBD);

        String sql = "DELETE FROM dadosconsulta WHERE id = ?";
        stmt = conexao.prepareStatement(sql);
        stmt.setInt(1, id);
        stmt.executeUpdate();

        response.sendRedirect("listarConsulta.jsp");
    } catch (Exception e) {
        out.println("<p style='color:red;'>Erro ao excluir: " + e.getMessage() + "</p>");
    } finally {
        if (stmt != null) stmt.close();
        if (conexao != null) conexao.close();
    }
%>
