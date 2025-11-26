package br.com.clinica.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.util.UUID; // Para gerar o token de segurança
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import br.com.clinica.util.EmailService; // Importa o nosso "carteiro"

public class CadastroServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Recebe os dados do formulário
        String nome = request.getParameter("username");
        String email = request.getParameter("email");
        String senha = request.getParameter("password");
        String confirmarSenha = request.getParameter("confirm-password");
        String cpf = request.getParameter("cpf");

        if (!senha.equals(confirmarSenha)) {
            request.setAttribute("erro", "As senhas não coincidem.");
            request.getRequestDispatcher("telaCadastro.jsp").forward(request, response);
            return;
        }

        // 2. Prepara os dados para o banco de dados
        BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
        String senhaHasheada = passwordEncoder.encode(senha);
        String token = UUID.randomUUID().toString(); // Gera um token único

        String url = System.getenv("DB_URL");
        String usuarioBD = System.getenv("DB_USERNAME");
        String senhaBD = System.getenv("DB_PASSWORD");

        // 3. Insere o utilizador como INATIVO (ativo = 0) e com o token gerado
        String sql = "INSERT INTO usuarios (nome, email, senha_hash, tipo, cpf, ativo, token_verificacao) VALUES (?, ?, ?, 'cliente', ?, 0, ?)";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            try (Connection conexao = DriverManager.getConnection(url, usuarioBD, senhaBD);
                 PreparedStatement stmt = conexao.prepareStatement(sql)) {

                stmt.setString(1, nome);
                stmt.setString(2, email);
                stmt.setString(3, senhaHasheada);
                stmt.setString(4, cpf);
                stmt.setString(5, token); // Guarda o token no banco

                stmt.executeUpdate();

                // 4. Pede ao "carteiro" para enviar o e-mail de verificação
                String urlBase = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath();
                EmailService.enviarEmailVerificacao(email, token, urlBase);

                // 5. Redireciona para a página de "Aguardando Verificação"
                response.sendRedirect("aguardandoVerificacao.jsp");

            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("erro", "Ocorreu um erro durante o cadastro. Verifique se o e-mail ou CPF já não estão em uso.");
                request.getRequestDispatcher("telaCadastro.jsp").forward(request, response);
            }

        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            request.setAttribute("erro", "Erro interno do servidor.");
            request.getRequestDispatcher("telaCadastro.jsp").forward(request, response);
        }
    }
}

