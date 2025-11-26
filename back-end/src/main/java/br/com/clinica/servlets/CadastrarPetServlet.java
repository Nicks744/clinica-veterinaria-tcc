package br.com.clinica.servlets;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.Period;
import java.time.format.DateTimeParseException;
import java.util.UUID;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.azure.storage.blob.BlobClient;
import com.azure.storage.blob.BlobContainerClient;
import com.azure.storage.blob.BlobServiceClient;
import com.azure.storage.blob.BlobServiceClientBuilder;

@MultipartConfig
public class CadastrarPetServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(CadastrarPetServlet.class);

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("cpf") == null) {
            response.sendRedirect("login.jsp?erro=Sessão expirada.");
            return;
        }
        String cpfSessao = (String) session.getAttribute("cpf");

        String fotoUrl = null;

        try {
            Part filePart = request.getPart("fotoPet");
            String nomeArquivo = filePart.getSubmittedFileName();

            if (nomeArquivo != null && !nomeArquivo.isEmpty()) {
                String azureStorageConnectionString = System.getenv("AZURE_STORAGE_CONNECTION_STRING");

                // =========================================================================
                //  CORREÇÃO CRÍTICA: Usando a string de conexão COMPLETA para teste local
                // =========================================================================
                if (azureStorageConnectionString == null || azureStorageConnectionString.trim().isEmpty()) {
                    logger.warn("Variável de ambiente AZURE_STORAGE_CONNECTION_STRING não encontrada. A usar valor 'hardcoded' para teste local.");
                    azureStorageConnectionString = "DefaultEndpointsProtocol=https;AccountName=clinicaimgsenai;AccountKey=sfLxOyGz15/iyHQhUwEn9kA4x6dbsDgunwbUTSKPapwUcQRmrzFktk7INlpHNoe45LSWtzOpSB3A+ASt72CTTw==;EndpointSuffix=core.windows.net";
                }

                String containerName = "clinica-imagens";
                BlobServiceClient blobServiceClient = new BlobServiceClientBuilder().connectionString(azureStorageConnectionString).buildClient();
                BlobContainerClient containerClient = blobServiceClient.getBlobContainerClient(containerName);
                String nomeUnico = UUID.randomUUID().toString() + "_" + nomeArquivo;
                BlobClient blobClient = containerClient.getBlobClient(nomeUnico);

                try (InputStream inputStream = filePart.getInputStream()) {
                    blobClient.upload(inputStream, filePart.getSize(), true);
                }
                fotoUrl = blobClient.getBlobUrl();
            }

            String nomePet = request.getParameter("nomePet");
            String dataNascimentoStr = request.getParameter("data_nascimento");

            int idadeCalculada = 0;
            java.sql.Date dataNascimentoSQL = null;
            if (dataNascimentoStr != null && !dataNascimentoStr.isEmpty()) {
                LocalDate dataNascimento = LocalDate.parse(dataNascimentoStr);
                idadeCalculada = Period.between(dataNascimento, LocalDate.now()).getYears();
                dataNascimentoSQL = java.sql.Date.valueOf(dataNascimento);
            }

            inserirPetNoBanco(cpfSessao, request, fotoUrl, idadeCalculada, dataNascimentoSQL);

            response.sendRedirect("minhaConta.jsp?sucesso=Pet cadastrado com sucesso!");

        } catch (Exception e) {
            logger.error("Ocorreu um erro inesperado ao cadastrar o pet.", e);
            request.setAttribute("erro", "Ocorreu um erro ao cadastrar o pet: " + e.getMessage());
            request.getRequestDispatcher("minhaConta.jsp").forward(request, response);
        }
    }

    private void inserirPetNoBanco(String cpfSessao, HttpServletRequest request, String fotoUrl, int idade, java.sql.Date dataNascimento) throws SQLException, ClassNotFoundException, ServletException {
        String url = System.getenv("DB_URL");
        String usuario = System.getenv("DB_USERNAME");
        String senhaBD = System.getenv("DB_PASSWORD");
        if (url == null) {
            url = "jdbc:mysql://server-senai-clinica-vet.mysql.database.azure.com:3306/clinica?useUnicode=true&characterEncoding=UTF-8";
            usuario = "Nicks";
            senhaBD = "Fdte1508150@74";
        }

        Class.forName("com.mysql.cj.jdbc.Driver");

        String sql = "INSERT INTO animais (nome, especie, raca, idade, sexo, cpf, data_nascimento, status_castracao, microchip, alergias, doencas_cronicas, medicamentos_uso, temperamento, foto_url, cor) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conexao = DriverManager.getConnection(url, usuario, senhaBD);
             PreparedStatement stmt = conexao.prepareStatement(sql)) {

            stmt.setString(1, request.getParameter("nomePet"));
            stmt.setString(2, request.getParameter("especiePet"));
            stmt.setString(3, request.getParameter("racaPet"));
            stmt.setInt(4, idade);
            stmt.setString(5, request.getParameter("sexoPet"));
            stmt.setString(6, cpfSessao);
            stmt.setDate(7, dataNascimento);
            stmt.setString(8, request.getParameter("status_castracao"));
            stmt.setString(9, request.getParameter("microchip"));
            stmt.setString(10, request.getParameter("alergias"));
            stmt.setString(11, request.getParameter("doencas_cronicas"));
            stmt.setString(12, request.getParameter("medicamentos_uso"));
            stmt.setString(13, request.getParameter("temperamento"));
            stmt.setString(14, fotoUrl);
            stmt.setString(15, request.getParameter("corPet"));

            stmt.executeUpdate();
        }
    }
}

