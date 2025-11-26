package br.com.clinica.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

public class RedefinirSenhaServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String token = request.getParameter("token");
        String novaSenha = request.getParameter("novaSenha");
        String confirmarNovaSenha = request.getParameter("confirmarNovaSenha");

        if (!novaSenha.equals(confirmarNovaSenha)) {
            response.getWriter().println("<h1>As senhas não coincidem. Tente novamente.</h1>");
            return;
        }

        BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
        String novaSenhaHasheada = passwordEncoder.encode(novaSenha);

        String url = System.getenv("DB_URL");
        String usuarioBD = System.getenv("DB_USERNAME");
        String senhaBD = System.getenv("DB_PASSWORD");

        String sql = "UPDATE usuarios SET senha_hash = ?, token_verificacao = NULL, data_expiracao_token = NULL " +
                "WHERE token_verificacao = ? AND data_expiracao_token > ?";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            try (Connection conexao = DriverManager.getConnection(url, usuarioBD, senhaBD);
                 PreparedStatement stmt = conexao.prepareStatement(sql)) {

                stmt.setString(1, novaSenhaHasheada);
                stmt.setString(2, token);
                stmt.setTimestamp(3, Timestamp.valueOf(LocalDateTime.now()));

                int linhasAfetadas = stmt.executeUpdate();

                if (linhasAfetadas > 0) {
                    response.sendRedirect("senhaRedefinida.jsp");
                } else {
                    response.getWriter().println("<h1>Token inválido ou expirado.</h1>");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Ocorreu um erro no servidor.");
        }
    }
}

