package br.com.clinica.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

// O mapeamento da URL "/logout" é feito no arquivo web.xml
public class LogoutServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false); // Pega a sessão, se existir
        if (session != null) {
            session.invalidate(); // Invalida e encerra a sessão
        }
        response.sendRedirect("telaLogin.jsp"); // Redireciona para a página de login
    }
}
