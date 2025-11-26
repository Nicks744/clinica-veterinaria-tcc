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
public class AtualizarPetServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(AtualizarPetServlet.class);

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("cpf") == null) {
            response.sendRedirect("login.jsp?erro=Sessão expirada.");
            return;
        }

        String fotoUrl = null;

        try {
            // 1. PROCESSA O UPLOAD DO FICHEIRO E OS CAMPOS DO FORMULÁRIO
            Part filePart = request.getPart("fotoPet");
            String nomeArquivo = filePart.getSubmittedFileName();

            if (nomeArquivo != null && !nomeArquivo.isEmpty()) {
                String azureStorageConnectionString = System.getenv("AZURE_STORAGE_CONNECTION_STRING");
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
                fotoUrl = blobClient.getBlobUrl(); // Guarda a URL da nova foto
            }

            // 2. OBTÉM OS DADOS DO FORMULÁRIO E PREPARA-OS PARA O UPDATE
            int idPet = Integer.parseInt(request.getParameter("idPet"));
            String dataNascimentoStr = request.getParameter("data_nascimento");

            int idadeCalculada = 0;
            java.sql.Date dataNascimentoSQL = null;
            if (dataNascimentoStr != null && !dataNascimentoStr.isEmpty()) {
                LocalDate dataNascimento = LocalDate.parse(dataNascimentoStr);
                idadeCalculada = Period.between(dataNascimento, LocalDate.now()).getYears();
                dataNascimentoSQL = java.sql.Date.valueOf(dataNascimento);
            }

            // 3. EXECUTA O UPDATE NA BASE DE DADOS
            atualizarPetNoBanco(idPet, request, fotoUrl, idadeCalculada, dataNascimentoSQL);

            response.sendRedirect("minhaConta.jsp?sucesso=Pet atualizado com sucesso!");

        } catch (Exception e) {
            logger.error("Ocorreu um erro inesperado ao atualizar o pet.", e);
            request.setAttribute("erro", "Ocorreu um erro ao atualizar o pet: " + e.getMessage());
            request.getRequestDispatcher("minhaConta.jsp").forward(request, response);
        }
    }

    private void atualizarPetNoBanco(int idPet, HttpServletRequest request, String novaFotoUrl, int idade, java.sql.Date dataNascimento) throws SQLException, ClassNotFoundException, ServletException {
        String url = System.getenv("DB_URL");
        String usuario = System.getenv("DB_USERNAME");
        String senhaBD = System.getenv("DB_PASSWORD");
        if (url == null) {
            url = "jdbc:mysql://server-senai-clinica-vet.mysql.database.azure.com:3306/clinica?useUnicode=true&characterEncoding=UTF-8";
            usuario = "Nicks";
            senhaBD = "Fdte1508150@74";
        }

        Class.forName("com.mysql.cj.jdbc.Driver");

        // Monta o SQL dinamicamente para atualizar a foto apenas se uma nova foi enviada
        StringBuilder sqlBuilder = new StringBuilder("UPDATE animais SET nome = ?, especie = ?, raca = ?, sexo = ?, data_nascimento = ?, idade = ?, status_castracao = ?, microchip = ?, alergias = ?, doencas_cronicas = ?, medicamentos_uso = ?, temperamento = ?, cor = ?");
        if (novaFotoUrl != null) {
            sqlBuilder.append(", foto_url = ?");
        }
        sqlBuilder.append(" WHERE id = ?");

        try (Connection conexao = DriverManager.getConnection(url, usuario, senhaBD);
             PreparedStatement stmt = conexao.prepareStatement(sqlBuilder.toString())) {

            int paramIndex = 1;
            stmt.setString(paramIndex++, request.getParameter("nomePet"));
            stmt.setString(paramIndex++, request.getParameter("especiePet"));
            stmt.setString(paramIndex++, request.getParameter("racaPet"));
            stmt.setString(paramIndex++, request.getParameter("sexoPet"));
            stmt.setDate(paramIndex++, dataNascimento);
            stmt.setInt(paramIndex++, idade);
            stmt.setString(paramIndex++, request.getParameter("status_castracao"));
            stmt.setString(paramIndex++, request.getParameter("microchip"));
            stmt.setString(paramIndex++, request.getParameter("alergias"));
            stmt.setString(paramIndex++, request.getParameter("doencas_cronicas"));
            stmt.setString(paramIndex++, request.getParameter("medicamentos_uso"));
            stmt.setString(paramIndex++, request.getParameter("temperamento"));
            stmt.setString(paramIndex++, request.getParameter("corPet"));

            if (novaFotoUrl != null) {
                stmt.setString(paramIndex++, novaFotoUrl);
            }
            stmt.setInt(paramIndex++, idPet);

            stmt.executeUpdate();
        }
    }
}

