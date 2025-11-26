<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Conclusão de Consulta</title>

    <!-- favicon em SVG -->
    <link rel="icon" type="image/svg+xml" href="imgs_inicio/minilogo.svg">

    <!-- fallback em PNG -->
    <link rel="icon" type="image/png" href="imgs_inicio/minilogo.png">
    <style>
        /* Resetando margens e preenchimentos */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        /* Estilos gerais */
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f4f7f6; /* Uma cor de fundo mais suave */
            color: #333; /* Cor do texto */
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh; /* Garante que ocupa a altura total da viewport */
            margin: 0;
            padding: 20px; /* Um pequeno padding para não colar nas bordas */
        }

        /* Container principal */
        .container {
            text-align: center;
            padding: 30px;
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 500px; /* Um pouco mais largo para melhor leitura */
        }

        /* Mensagem de sucesso */
        .msg-sucesso {
            color: #002f4b; /* Azul escuro da sua paleta */
            font-size: 1.8em; /* Ajustado para um tamanho bom */
            font-weight: bold;
            margin-bottom: 25px; /* Espaço abaixo da mensagem */
        }

        /* Mensagem de erro */
        .msg-erro {
            color: #d9534f; /* Vermelho padrão para erros */
            font-size: 1.2em;
            margin-bottom: 20px;
        }

        /* ID inválido */
        .id-invalido {
            color: red;
            font-size: 1.2em;
            margin-bottom: 20px;
        }

        /* Link de retorno - Estilo corrigido e simplificado */
        .btn-voltar {
            display: inline-block; /* Permite aplicar padding e width/height */
            padding: 12px 25px; /* Padding ajustado para um botão */
            background-color: #002F4B; /* Cor azul escura da sua paleta */
            color: #fff; /* Texto branco */
            text-decoration: none; /* Remove sublinhado */
            border-radius: 8px; /* Cantos mais arredondados */
            font-weight: bold;
            font-size: 1.1em; /* Tamanho de fonte um pouco maior */
            transition: background-color 0.3s ease; /* Transição suave no hover */
            border: none; /* Remove borda padrão */
            cursor: pointer; /* Indica que é clicável */
            margin-top: 20px; /* Espaço acima do botão */
        }

        .btn-voltar:hover {
            background-color: #004d7c; /* Um tom um pouco mais claro no hover */
        }
    </style>
</head>
<body>
    <div class="container">
        <%
            int idConsulta = 0;
            String relatorio = request.getParameter("relatorio");

            try {
                idConsulta = Integer.parseInt(request.getParameter("id"));
            } catch (Exception e) {
                out.println("<p class='id-invalido'>ID inválido.</p>");
                // O link de voltar será exibido aqui também
                out.println("<a href='listarConsulta.jsp' class='btn-voltar'>Voltar para lista de consultas</a>");
                return; // Adicionado return para parar a execução após o erro de ID
            }

            if (idConsulta > 0 && relatorio != null && !relatorio.trim().isEmpty()) {
                  String url = System.getenv("DB_URL");
            String usuario = System.getenv("DB_USERNAME");
            String senhaBD = System.getenv("DB_PASSWORD");

                Connection conexao = null;
                PreparedStatement stmt = null;
                ResultSet rs = null;

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conexao = DriverManager.getConnection(url, usuario, senhaBD);

                    // Busca os dados da consulta original
                    String sqlConsulta = "SELECT cpf, data_inicio FROM dadosconsulta WHERE id = ?";
                    stmt = conexao.prepareStatement(sqlConsulta);
                    stmt.setInt(1, idConsulta);
                    rs = stmt.executeQuery();

                    if (rs.next()) {
                        String cpf = rs.getString("cpf");
                        Timestamp dataInicio = rs.getTimestamp("data_inicio");
                        rs.close();
                        stmt.close();

                        // Insere na tabela consultas_concluidas com todos os campos obrigatórios preenchidos
                        String sqlInsertConcluidas = "INSERT INTO consultas_concluidas (id_consulta, relatorio, cpf, data_encerrada, data_inicio) VALUES (?, ?, ?, NOW(), ?)";
                        stmt = conexao.prepareStatement(sqlInsertConcluidas);
                        stmt.setInt(1, idConsulta); // campo id_consulta
                        stmt.setString(2, relatorio);
                        stmt.setString(3, cpf);
                        stmt.setTimestamp(4, (dataInicio != null) ? dataInicio : new Timestamp(System.currentTimeMillis())); // usa o atual se for null
                        stmt.executeUpdate();
                        stmt.close();

                        // Atualiza o status da consulta original para "concluida"
                        String sqlAtualiza = "UPDATE dadosconsulta SET status = 'concluida' WHERE id = ?";
                        stmt = conexao.prepareStatement(sqlAtualiza);
                        stmt.setInt(1, idConsulta);
                        stmt.executeUpdate();
                        stmt.close();

                        out.println("<p class='msg-sucesso'>Consulta concluída com sucesso!</p>");
                        out.println("<a href='listarConsulta.jsp' class='btn-voltar'>Voltar para lista de consultas</a>");
                    } else {
                        out.println("<p class='msg-erro'>Consulta não encontrada.</p>");
                        out.println("<a href='listarConsulta.jsp' class='btn-voltar'>Voltar para lista de consultas</a>");
                    }

                } catch (Exception e) {
                    out.println("<p class='msg-erro'>Erro ao concluir consulta: " + e.getMessage() + "</p>");
                    out.println("<a href='listarConsulta.jsp' class='btn-voltar'>Voltar para lista de consultas</a>");
                } finally {
                    if (rs != null) try { rs.close(); } catch (Exception ignored) {}
                    if (stmt != null) try { stmt.close(); } catch (Exception ignored) {}
                    if (conexao != null) try { conexao.close(); } catch (Exception ignored) {}
                }
            } else {
                out.println("<p class='msg-erro'>Dados inválidos para conclusão.</p>");
                out.println("<a href='listarConsulta.jsp' class='btn-voltar'>Voltar para lista de consultas</a>");
            }
        %>
    </div>
</body>
</html>