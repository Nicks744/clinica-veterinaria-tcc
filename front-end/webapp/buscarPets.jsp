<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.text.SimpleDateFormat, java.util.Date, java.sql.Timestamp" %>

<%!
    private final SimpleDateFormat formatoNascimento = new SimpleDateFormat("dd/MM/yyyy");
    private final SimpleDateFormat formatoDataBR = new SimpleDateFormat("dd/MM/yyyy HH:mm");

    public String formatarNascimento(java.sql.Date data) {
        if (data == null) { return "Não informada"; }
        return formatoNascimento.format(data);
    }
    
    public String formatarDataConsulta(Timestamp timestamp) {
        if (timestamp == null) { return "Data não informada"; }
        return formatoDataBR.format(new Date(timestamp.getTime()));
    }
%>

<%
    request.setCharacterEncoding("UTF-8");
    String termoBusca = request.getParameter("termo");
    if (termoBusca == null) {
        termoBusca = "";
    }
    String termoLike = "%" + termoBusca + "%";

      String url = System.getenv("DB_URL");
            String usuario = System.getenv("DB_USERNAME");
            String senhaBD = System.getenv("DB_PASSWORD");
    
    Connection conexao = null;

    try {
        // A conexão principal é aberta aqui para ser reutilizada
        conexao = DriverManager.getConnection(url, usuario, senhaBD);
        
        String sql = "SELECT a.*, u.nome as nome_dono FROM animais a " +
                     "LEFT JOIN usuarios u ON a.cpf = u.cpf " +
                     "WHERE a.nome LIKE ? OR a.especie LIKE ? OR a.raca LIKE ? OR u.nome LIKE ? OR a.cpf LIKE ? " +
                     "ORDER BY a.nome ASC";

        PreparedStatement stmt = conexao.prepareStatement(sql);
        stmt.setString(1, termoLike);
        stmt.setString(2, termoLike);
        stmt.setString(3, termoLike);
        stmt.setString(4, termoLike);
        stmt.setString(5, termoLike);

        ResultSet rsPets = stmt.executeQuery();
        boolean hasPets = false;

        while (rsPets.next()) {
            hasPets = true;
            int idPet = rsPets.getInt("id");
            String nomePet = rsPets.getString("nome");
            // ... (restante das variáveis do pet e dono) ...
            String especie = rsPets.getString("especie");
            String raca = rsPets.getString("raca");
            String sexo = rsPets.getString("sexo");
            java.sql.Date dataNascimento = rsPets.getDate("data_nascimento");
            String statusCastracao = rsPets.getString("status_castracao");
            String fotoUrl = rsPets.getString("foto_url");
            String cor = rsPets.getString("cor");
            String microchip = rsPets.getString("microchip");
            String temperamento = rsPets.getString("temperamento");
            String alergias = rsPets.getString("alergias");
            String doencasCronicas = rsPets.getString("doencas_cronicas");
            String medicamentosUso = rsPets.getString("medicamentos_uso");
            String nomeDono = rsPets.getString("nome_dono");
            String cpfDono = rsPets.getString("cpf");
            
            if (nomeDono == null) {
                nomeDono = "Dono não encontrado";
            }
%>
        <div class="pet-card" onclick="abrirModal('modalPet<%= idPet %>')" style="cursor: pointer;">
             <%-- ... (código do pet-card continua o mesmo) ... --%>
             <div class="pet-card-main">
                <div class="pet-photo-container">
                    <% if (fotoUrl != null && !fotoUrl.isEmpty()) { %>
                        <img src="<%= fotoUrl %>" alt="Foto de <%= nomePet %>" class="pet-photo-card">
                    <% } else { %>
                        <img src="imgs/pet-placeholder.png" alt="Foto padrão" class="pet-photo-card">
                    <% } %>
                </div>
                <div class="pet-details">
                    <h3><%= nomePet %></h3>
                    <div class="pet-info-grid">
                        <div class="pet-info-item">
                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/></svg>
                            <span><b>Dono(a):</b> <%= nomeDono %></span>
                        </div>
                        <div class="pet-info-item">
                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 18c-4.41 0-8-3.59-8-8s3.59-8 8-8 8 3.59 8 8-3.59 8-8 8zm-1-13h2v6h-2zm0 8h2v2h-2z"/></svg>
                            <span><b>Espécie/Raça:</b> <%= especie %> - <%= raca %></span>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div id="modalPet<%= idPet %>" class="modal" role="dialog">
            <div class="modal-content">
                 <button class="close" onclick="fecharModal('modalPet<%= idPet %>')">&times;</button>

                 <div class="modal-header">
                    <%-- ... (código do modal-header continua o mesmo) ... --%>
                    <div class="modal-photo-container">
                        <% if (fotoUrl != null && !fotoUrl.isEmpty()) { %>
                            <img src="<%= fotoUrl %>" alt="Foto de <%= nomePet %>" class="modal-photo">
                        <% } else { %>
                            <img src="imgs/pet-placeholder.png" alt="Foto padrão" class="modal-photo">
                        <% } %>
                    </div>
                    <div class="modal-header-text">
                        <h2><%= nomePet %></h2>
                        <p>Tutor(a): <%= nomeDono %></p>
                    </div>
                 </div>

                 <div class="modal-body">
                    <div class="details-grid">
                        <%-- ... (código dos detail-item continua o mesmo) ... --%>
                        <div class="detail-item"><strong>Espécie</strong><span><%= especie %></span></div>
                        <div class="detail-item"><strong>Raça</strong><span><%= raca %></span></div>
                        <div class="detail-item"><strong>Sexo</strong><span><%= sexo %></span></div>
                        <div class="detail-item"><strong>Nascimento</strong><span><%= formatarNascimento(dataNascimento) %></span></div>
                        <div class="detail-item"><strong>Cor/Pelagem</strong><span><%= (cor != null && !cor.trim().isEmpty()) ? cor : "Não informado" %></span></div>
                        <div class="detail-item"><strong>Status de Castração</strong><span><%= statusCastracao %></span></div>
                    </div>

                    <div class="health-section">
                        <h4>Histórico de Saúde</h4>
                        <%-- ... (código da seção de saúde continua o mesmo) ... --%>
                        <p><strong>Alergias:</strong> <%= (alergias != null && !alergias.trim().isEmpty()) ? alergias : "Nenhuma registrada" %></p>
                        <p><strong>Doenças Crônicas:</strong> <%= (doencasCronicas != null && !doencasCronicas.trim().isEmpty()) ? doencasCronicas : "Nenhuma registrada" %></p>
                    </div>
                    
                    <div class="health-section">
                        <h4>Histórico de Consultas</h4>
                        <ul class="history-list">
                        <%
                            // Nova busca no banco, específica para o histórico deste pet
                            String sqlHistorico = "SELECT data_consulta, sintomas FROM dadosconsulta WHERE id_animal = ? ORDER BY data_consulta DESC";
                            try (PreparedStatement stmtHistorico = conexao.prepareStatement(sqlHistorico)) {
                                stmtHistorico.setInt(1, idPet);
                                ResultSet rsHistorico = stmtHistorico.executeQuery();
                                boolean hasHistory = false;
                                while(rsHistorico.next()) {
                                    hasHistory = true;
                                    Timestamp dataConsultaTs = rsHistorico.getTimestamp("data_consulta");
                                    String sintomas = rsHistorico.getString("sintomas");
                        %>
                                    <li class="history-item">
                                        <span class="date"><%= formatarDataConsulta(dataConsultaTs) %></span>
                                        <span class="reason">Motivo: <%= sintomas %></span>
                                    </li>
                        <%
                                }
                                if (!hasHistory) {
                                    out.println("<li>Nenhum registro de consulta encontrado para este pet.</li>");
                                }
                            } catch (Exception e_hist) {
                                out.println("<li>Erro ao carregar histórico.</li>");
                            }
                        %>
                        </ul>
                    </div>
                 </div>
            </div>
        </div>
<%
        } // Fim do while principal
        if (!hasPets) {
            out.println("<p>Nenhum pet encontrado com os critérios da busca.</p>");
        }
        rsPets.close();
        stmt.close();

    } catch (Exception e) {
        out.println("<p style='color: red;'>Erro na busca: " + e.getMessage() + "</p>");
        e.printStackTrace();
    } finally {
        if (conexao != null) try { conexao.close(); } catch(SQLException e) {}
    }
%>