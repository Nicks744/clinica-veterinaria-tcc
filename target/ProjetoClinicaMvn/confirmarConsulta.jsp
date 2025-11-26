<%@ page import="java.sql.*" %>
<%
    String id = request.getParameter("id");
    if (id != null) {
        Connection conexao = null;
        try {
            // Buscando as variáveis de ambiente do Azure para a conexão
            String url = System.getenv("DB_URL");
            String usuario = System.getenv("DB_USERNAME");
            String senhaBD = System.getenv("DB_PASSWORD");
            
            Class.forName("com.mysql.cj.jdbc.Driver");
            conexao = DriverManager.getConnection(url, usuario, senhaBD);

            String sql = "UPDATE dadosconsulta SET status = 'Confirmada' WHERE id = ?";
            PreparedStatement stmt = conexao.prepareStatement(sql);
            stmt.setInt(1, Integer.parseInt(id));
            stmt.executeUpdate();

            stmt.close();
            conexao.close();

            response.sendRedirect("listarConsulta.jsp");
        } catch (Exception e) {
            out.println("Erro: " + e.getMessage());
        }
    }
%>
