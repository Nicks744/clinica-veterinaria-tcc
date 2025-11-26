<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, jakarta.servlet.http.HttpSession, java.time.LocalDateTime, java.time.format.DateTimeFormatter" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Status do Agendamento</title>

    <!-- favicon em SVG -->
    <link rel="icon" type="image/svg+xml" href="imgs_inicio/minilogo.svg">

    <!-- fallback em PNG -->
    <link rel="icon" type="image/png" href="imgs_inicio/minilogo.png">
    <style>
        /* O CSS continua o mesmo */
        body { font-family: 'Arial', sans-serif; background-color: #f4f7f6; color: #333; display: flex; justify-content: center; align-items: center; min-height: 100vh; padding: 20px; }
        .container { background: #fff; padding: 30px; width: 100%; max-width: 500px; border-radius: 10px; box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1); text-align: center; }
        h1 { color: #002f4b; margin-bottom: 25px; font-size: 2em; }
        .message p { font-size: 1.2em; margin-bottom: 20px; padding: 15px; border-radius: 5px; }
        .message .success { color: #155724; background-color: #d4edda; border: 1px solid #c3e6cb; }
        .message .error { color: #721c24; background-color: #f8d7da; border: 1px solid #f5c6cb; }
        .btn-voltar { display: inline-block; padding: 12px 25px; background-color: #002F4B; color: #fff; text-decoration: none; border-radius: 8px; font-weight: bold; font-size: 1.1em; transition: background-color 0.3s ease; border: none; cursor: pointer; margin-top: 25px; }
        .btn-voltar:hover { background-color: #004d7c; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Status do Agendamento</h1>
        <div class="message">
        <%
            request.setCharacterEncoding("UTF-8");

            String cpf = request.getParameter("cpf");
            String numero = request.getParameter("numero");
            String idAnimalStr = request.getParameter("petSelecionado");
            String dataConsultaStr = request.getParameter("data_consulta");
            String horarioConsultaStr = request.getParameter("horario_consulta");
            String sintomas = request.getParameter("sintomas");
            String pesoStr = request.getParameter("peso");
            String observacoes = request.getParameter("observacoes");
            String mensagem = "";

            if (cpf == null || idAnimalStr == null || dataConsultaStr == null || horarioConsultaStr == null ||
                cpf.trim().isEmpty() || idAnimalStr.trim().isEmpty() || dataConsultaStr.trim().isEmpty() || horarioConsultaStr.trim().isEmpty()) {
                
                mensagem = "<p class='error'>Erro: Todos os campos obrigatórios devem ser preenchidos.</p>";

            } else {
                Connection conexao = null;
                PreparedStatement stmt = null;
                ResultSet rs = null;
                
                try {
                    int idAnimal = Integer.parseInt(idAnimalStr);
                    double peso = Double.parseDouble(pesoStr);
                    
                    String dataHoraCompleta = dataConsultaStr + " " + horarioConsultaStr;
                    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
                    LocalDateTime ldt = LocalDateTime.parse(dataHoraCompleta, formatter);
                    Timestamp dataConsultaTimestamp = Timestamp.valueOf(ldt);

                    Class.forName("com.mysql.cj.jdbc.Driver");
                   String url = System.getenv("DB_URL");
    String usuario = System.getenv("DB_USERNAME");
    String senhaBD = System.getenv("DB_PASSWORD");
                    conexao = DriverManager.getConnection(url, usuario, senhaBD);

                    String checkSql = "SELECT COUNT(*) FROM dadosconsulta WHERE data_consulta = ?";
                    stmt = conexao.prepareStatement(checkSql);
                    stmt.setTimestamp(1, dataConsultaTimestamp);
                    rs = stmt.executeQuery();
                    
                    int count = 0;
                    if (rs.next()) {
                        count = rs.getInt(1);
                    }
                    rs.close();
                    stmt.close();

                    if (count > 0) {
                        mensagem = "<p class='error'>Erro: Já existe uma consulta agendada para esta data e horário.</p>";
                    } else {
                        String sql = "INSERT INTO dadosconsulta (cpf, id_animal, data_consulta, numero, sintomas, peso, observacoes, status) VALUES (?, ?, ?, ?, ?, ?, ?, 'pendente')";
                        
                        // ===== MUDANÇA 1: Prepara o statement para retornar o ID gerado =====
                        stmt = conexao.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);

                        stmt.setString(1, cpf);
                        stmt.setInt(2, idAnimal);
                        stmt.setTimestamp(3, dataConsultaTimestamp);
                        stmt.setString(4, numero);
                        stmt.setString(5, sintomas);
                        stmt.setDouble(6, peso);
                        stmt.setString(7, observacoes);

                        int rowsAffected = stmt.executeUpdate();
                        
                        if (rowsAffected > 0) {
                            // ===== MUDANÇA 2: Pega o ID que foi gerado no INSERT acima =====
                            ResultSet generatedKeys = stmt.getGeneratedKeys();
                            if (generatedKeys.next()) {
                                int idGerado = generatedKeys.getInt(1);
                                
                                // ===== MUDANÇA 3: Faz o UPDATE para clonar o ID em id_consulta =====
                                String updateSql = "UPDATE dadosconsulta SET id_consulta = ? WHERE id = ?";
                                try (PreparedStatement updateStmt = conexao.prepareStatement(updateSql)) {
                                    updateStmt.setInt(1, idGerado);
                                    updateStmt.setInt(2, idGerado);
                                    updateStmt.executeUpdate();
                                }
                            }
                            
                            mensagem = "<p class='success'>Consulta agendada com sucesso! Aguarde a confirmação da nossa equipe.</p>";
                        } else {
                            mensagem = "<p class='error'>Erro: A consulta não pôde ser agendada. Tente novamente.</p>";
                        }
                    }

                } catch (Exception e) {
                    mensagem = "<p class='error'>Ocorreu um erro inesperado: " + e.getMessage() + "</p>";
                    e.printStackTrace();
                } finally {
                    if (rs != null) try { rs.close(); } catch (SQLException e) {}
                    if (stmt != null) try { stmt.close(); } catch (SQLException e) {}
                    if (conexao != null) try { conexao.close(); } catch (SQLException e) {}
                }
            }
            out.println(mensagem);
        %>
        </div>
<button onclick="window.history.back()" class="btn-voltar">Voltar</button>

    </div>
</body>
</html>