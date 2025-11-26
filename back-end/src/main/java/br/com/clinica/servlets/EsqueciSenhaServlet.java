package br.com.clinica.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.UUID;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import br.com.clinica.util.EmailService;

public class EsqueciSenhaServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");

        String url = System.getenv("DB_URL");
        String usuarioBD = System.getenv("DB_USERNAME");
        String senhaBD = System.getenv("DB_PASSWORD");

        // Lógica de fallback para teste local
        if (url == null) {
            url = "jdbc:mysql://server-senai-clinica-vet.mysql.database.azure.com:3306/clinica?useUnicode=true&characterEncoding=UTF-8";
            usuarioBD = "Nicks";
            senhaBD = "Fdte1508150@74";
        }

        String sql = "UPDATE usuarios SET token_verificacao = ?, data_expiracao_token = ? WHERE email = ?";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            try (Connection conexao = DriverManager.getConnection(url, usuarioBD, senhaBD);
                 PreparedStatement stmt = conexao.prepareStatement(sql)) {

                String token = UUID.randomUUID().toString();
                Timestamp dataExpiracao = Timestamp.valueOf(LocalDateTime.now().plusHours(1));

                stmt.setString(1, token);
                stmt.setTimestamp(2, dataExpiracao);
                stmt.setString(3, email);

                int linhasAfetadas = stmt.executeUpdate();

                if (linhasAfetadas > 0) {
                    // Se o e-mail foi encontrado, envia o e-mail de recuperação
                    String urlBase = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath();
                    EmailService.enviarEmailRecuperacao(email, token, urlBase);
                }

                // =========================================================================
                //  MUDANÇA APLICADA AQUI:
                //  Redireciona para a nova página de confirmação em AMBOS os casos
                //  (e-mail encontrado ou não). Isto é uma prática de segurança para não
                //  confirmar a um potencial atacante se um e-mail existe ou não.
                // =========================================================================
                response.sendRedirect("emailRecuperacaoEnviado.jsp");

            }

        } catch (Exception e) {
            e.printStackTrace();
            // Em caso de erro grave, redireciona para uma página de erro genérica
            request.setAttribute("erro", "Ocorreu um erro no servidor. Tente novamente mais tarde.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}

