package br.com.clinica.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class ExcluirPetServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(ExcluirPetServlet.class);

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("cpf") == null) {
            response.sendRedirect("login.jsp?erro=Sessão expirada.");
            return;
        }

        try {
            int idPet = Integer.parseInt(request.getParameter("idPet"));
            String cpfSessao = (String) session.getAttribute("cpf");

            // Executa a exclusão no banco de dados
            excluirPetDoBanco(idPet, cpfSessao);

            response.sendRedirect("minhaConta.jsp?sucesso=Pet excluído com sucesso!");

        } catch (NumberFormatException e) {
            logger.error("ID do pet inválido fornecido para exclusão.", e);
            response.sendRedirect("minhaConta.jsp?erro=ID do pet inválido.");
        } catch (Exception e) {
            logger.error("Ocorreu um erro inesperado ao excluir o pet.", e);
            response.sendRedirect("minhaConta.jsp?erro=Ocorreu um erro ao excluir o pet.");
        }
    }

    private void excluirPetDoBanco(int idPet, String cpfProprietario) throws SQLException, ClassNotFoundException, ServletException {
        String url = System.getenv("DB_URL");
        String usuario = System.getenv("DB_USERNAME");
        String senhaBD = System.getenv("DB_PASSWORD");

        if (url == null) { // Fallback para teste local
            url = "jdbc:mysql://server-senai-clinica-vet.mysql.database.azure.com:3306/clinica?useUnicode=true&characterEncoding=UTF-8";
            usuario = "Nicks";
            senhaBD = "Fdte1508150@74";
        }

        Class.forName("com.mysql.cj.jdbc.Driver");

        // O SQL deleta o pet APENAS se o ID corresponder E o CPF for do utilizador logado.
        // Isto é uma medida de segurança para impedir que um utilizador delete o pet de outro.
        String sql = "DELETE FROM animais WHERE id = ? AND cpf = ?";

        try (Connection conexao = DriverManager.getConnection(url, usuario, senhaBD);
             PreparedStatement stmt = conexao.prepareStatement(sql)) {

            stmt.setInt(1, idPet);
            stmt.setString(2, cpfProprietario);

            int linhasAfetadas = stmt.executeUpdate();

            if (linhasAfetadas == 0) {
                // Isto pode acontecer se o pet não existir ou não pertencer ao utilizador.
                logger.warn("Tentativa de exclusão do pet com ID " + idPet + " falhou. Nenhuma linha afetada.");
            }
        }
    }
}
