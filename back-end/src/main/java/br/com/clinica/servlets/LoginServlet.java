package br.com.clinica.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String senhaDigitada = request.getParameter("password");

        if (email == null || email.trim().isEmpty() || senhaDigitada == null || senhaDigitada.trim().isEmpty()) {
            request.setAttribute("erro", "E-mail e senha são obrigatórios.");
            request.getRequestDispatcher("telaLogin.jsp").forward(request, response);
            return;
        }

        // Lendo as credenciais da base de dados (para teste local)


        String url = System.getenv("DB_URL");
        String usuarioBD = System.getenv("DB_USERNAME");
        String senhaBD = System.getenv("DB_PASSWORD");

        String sql = "SELECT nome, tipo, cpf, senha_hash, ativo FROM usuarios WHERE email = ?";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            try (Connection conexao = DriverManager.getConnection(url, usuarioBD, senhaBD);
                 PreparedStatement stmt = conexao.prepareStatement(sql)) {

                stmt.setString(1, email);

                try (ResultSet resultado = stmt.executeQuery()) {
                    if (resultado.next()) {
                        String senhaHashDoBanco = resultado.getString("senha_hash");
                        boolean contaAtiva = resultado.getBoolean("ativo");

                        BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

                        if (passwordEncoder.matches(senhaDigitada, senhaHashDoBanco)) {
                            if (contaAtiva) {
                                // =========================================================================
                                //  CORREÇÃO FINAL: Guardando os dados na sessão com os nomes
                                //  que o seu `telaLoginSucesso.jsp` espera ("usuarioLogado" e "cpf").
                                // =========================================================================
                                String tipoUsuario = resultado.getString("tipo");
                                String cpfUsuario = resultado.getString("cpf");
                                String nomeUsuario = resultado.getString("nome");
                                HttpSession session = request.getSession();
                                session.setAttribute("usuarioLogado", email); // <-- NOME CORRIGIDO
                                session.setAttribute("tipo", tipoUsuario);     // <-- Adicionado para consistência
                                session.setAttribute("cpf", cpfUsuario);       // <-- NOME CORRIGIDO
                                session.setAttribute("nomeUsuario", nomeUsuario);
                                if ("admin".equals(tipoUsuario)) {
                                    response.sendRedirect("indexAdm.jsp");
                                } else {
                                    response.sendRedirect("telaLoginSucesso.jsp");
                                }
                            } else {
                                request.setAttribute("erro", "A sua conta ainda não foi ativada.");
                                request.getRequestDispatcher("telaLogin.jsp").forward(request, response);
                            }
                        } else {
                            request.setAttribute("erro", "E-mail ou senha inválidos.");
                            request.getRequestDispatcher("telaLogin.jsp").forward(request, response);
                        }
                    } else {
                        request.setAttribute("erro", "E-mail ou senha inválidos.");
                        request.getRequestDispatcher("telaLogin.jsp").forward(request, response);
                    }
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            request.setAttribute("erro", "Erro ao conectar com o banco de dados. Verifique as credenciais e o firewall.");
            request.getRequestDispatcher("telaLogin.jsp").forward(request, response);
        }
    }
}

