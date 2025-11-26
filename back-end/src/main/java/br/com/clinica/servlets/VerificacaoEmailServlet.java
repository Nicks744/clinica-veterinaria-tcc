package br.com.clinica.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class VerificacaoEmailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Obtém o token da URL (ex: /verificar?token=abcd-1234...)
        String token = request.getParameter("token");

        if (token == null || token.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Token de verificação inválido.");
            return;
        }

        String url = System.getenv("DB_URL");
        String usuarioBD = System.getenv("DB_USERNAME");
        String senhaBD = System.getenv("DB_PASSWORD");

        // 2. SQL para encontrar o utilizador pelo token e ATIVÁ-LO (ativo = 1)
        String sql = "UPDATE usuarios SET ativo = 1, token_verificacao = NULL WHERE token_verificacao = ?";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            try (Connection conexao = DriverManager.getConnection(url, usuarioBD, senhaBD);
                 PreparedStatement stmt = conexao.prepareStatement(sql)) {

                stmt.setString(1, token);

                // 3. Executa o UPDATE
                int linhasAfetadas = stmt.executeUpdate();

                if (linhasAfetadas > 0) {
                    // Se o update funcionou, o token era válido. Redireciona para a página de sucesso.
                    response.sendRedirect("verificacaoSucesso.jsp");
                } else {
                    // Se não afetou nenhuma linha, o token era inválido ou já foi usado.
                    response.sendRedirect("verificacaoFalha.jsp");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Ocorreu um erro no servidor.");
        }
    }
}

