<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, jakarta.servlet.http.HttpSession, java.util.Date, java.sql.Timestamp, java.time.LocalDate, java.time.format.DateTimeFormatter" %>
<%@ page import="java.text.SimpleDateFormat, java.util.Date, java.sql.Timestamp, java.time.LocalDate, java.time.format.DateTimeFormatter" %>
<%!
    // Função para formatar Data de Nascimento (dd/MM/yyyy)
    private final SimpleDateFormat formatoNascimento = new SimpleDateFormat("dd/MM/yyyy");
    public String formatarNascimento(java.sql.Date data) {
        if (data == null) { return "Não informada"; }
        return formatoNascimento.format(data);
    }

    // Função para formatar Timestamp de Consulta (dd/MM/yyyy HH:mm)
    private final SimpleDateFormat formatoDataBR = new SimpleDateFormat("dd/MM/yyyy HH:mm");
    public String formatarDataBR(Timestamp timestamp) {
        if (timestamp == null) { return "Data não informada"; }
        return formatoDataBR.format(new Date(timestamp.getTime()));
    }
%>

<%
    // Bloco de verificação de sessão e busca de dados do usuário
    HttpSession sessao = request.getSession(false);
    if (sessao == null || sessao.getAttribute("usuarioLogado") == null) {
        response.sendRedirect("telaLogin.jsp");
        return;
    }
    String emailSessao = (String) sessao.getAttribute("usuarioLogado");
    String cpf = (String) sessao.getAttribute("cpf");
    String url = System.getenv("DB_URL");
    String usuario = System.getenv("DB_USERNAME");
    String senhaBD = System.getenv("DB_PASSWORD");
    String nome = "";

    try (Connection conexao = DriverManager.getConnection(url, usuario, senhaBD)) {
        String sql = "SELECT nome FROM usuarios WHERE email = ?";
        PreparedStatement stmt = conexao.prepareStatement(sql);
        stmt.setString(1, emailSessao);
        ResultSet rs = stmt.executeQuery();
        if (rs.next()) {
            nome = rs.getString("nome");
        }
    } catch (Exception e) {
        // Erro silencioso
    }
    
    // Lógica para validação de datas
    LocalDate hoje = LocalDate.now();
    LocalDate dataMinima = hoje.minusYears(100);
    DateTimeFormatter formatador = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    String hojeFormatado = hoje.format(formatador);
    String dataMinimaFormatada = dataMinima.format(formatador);
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Minha Conta - Clínica Veterinária</title>

    <!-- favicon em SVG -->
    <link rel="icon" type="image/svg+xml" href="imgs_inicio/minilogo.svg">

    <!-- fallback em PNG -->
    <link rel="icon" type="image/png" href="imgs_inicio/minilogo.png">
    <link rel="stylesheet" href="minhaConta.css">
</head>
<body>

<div id="modalCadastroPet" class="modal" role="dialog" aria-modal="true" aria-labelledby="modalCadastroPetTitle">
    <div class="modal-content">
        <h2 id="modalCadastroPetTitle">Cadastrar Novo Pet</h2>
        <button class="close" onclick="fecharModal('modalCadastroPet')" aria-label="Fechar">&times;</button>
        <form action="${pageContext.request.contextPath}/cadastrar-pet" method="POST" class="pet-form" enctype="multipart/form-data">
            <fieldset>
                <legend>Dados Básicos</legend>
                <div class="fieldset-grid">
                    <div class="form-group">
                        <label for="nomePet">Nome:</label>
                        <input type="text" id="nomePet" name="nomePet" required>
                    </div>
                    <div class="form-group">
                        <label for="data_nascimento">Data de Nascimento:</label>
                        <input type="date" id="data_nascimento" name="data_nascimento" required max="<%= hojeFormatado %>" min="<%= dataMinimaFormatada %>">
                    </div>
                    <div class="form-group">
                        <label for="especiePet">Espécie:</label>
                        <input type="text" id="especiePet" name="especiePet" required>
                    </div>
                    <div class="form-group">
                        <label for="racaPet">Raça:</label>
                        <input type="text" id="racaPet" name="racaPet" required>
                    </div>
                    <div class="form-group">
                        <label for="sexoPet">Sexo:</label>
                        <select name="sexoPet" id="sexoPet" required>
                            <option value="" disabled selected>Selecione</option>
                            <option value="Macho">Macho</option>
                            <option value="Femea">Fêmea</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="corPet">Cor/Pelagem:</label>
                        <input type="text" id="corPet" name="corPet">
                    </div>
                </div>
            </fieldset>
            <fieldset>
                <legend>Histórico de Saúde e Identificação</legend>
                <div class="fieldset-grid">
                    <div class="form-group">
                        <label for="status_castracao">Castrado(a)?</label>
                        <select name="status_castracao" id="status_castracao">
                            <option value="Não">Não</option>
                            <option value="Sim">Sim</option>
                            <option value="Não Aplicável">Não Aplicável</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="microchip">Nº do Microchip:</label>
                        <input type="text" id="microchip" name="microchip" placeholder="Se possuir...">
                    </div>
                    <div class="form-group form-full-width">
                        <label for="alergias">Alergias Conhecidas:</label>
                        <textarea id="alergias" name="alergias" placeholder="Liste medicamentos, alimentos, etc."></textarea>
                    </div>
                    <div class="form-group form-full-width">
                        <label for="doencas_cronicas">Doenças Crônicas/Pré-existentes:</label>
                        <textarea id="doencas_cronicas" name="doencas_cronicas" placeholder="Liste condições como diabetes..."></textarea>
                    </div>
                    <div class="form-group form-full-width">
                        <label for="medicamentos_uso">Medicamentos em Uso:</label>
                        <textarea id="medicamentos_uso" name="medicamentos_uso" placeholder="Liste medicamentos de uso contínuo..."></textarea>
                    </div>
                </div>
            </fieldset>
            <fieldset>
                <legend>Informações Adicionais</legend>
                <div class="fieldset-grid">
                    <div class="form-group">
                        <label for="temperamento">Temperamento:</label>
                        <input type="text" id="temperamento" name="temperamento" placeholder="Ex: Dócil, Ansioso, Agitado">
                    </div>
                    <div class="form-group">
                        <label for="fotoPet">Foto do Pet:</label>
                        <input type="file" id="fotoPet" name="fotoPet" accept="image/*">
                    </div>
                </div>
            </fieldset>
            <button type="submit" class="submit-button">Cadastrar Pet</button>
        </form>
    </div>
</div>

<div class="container">
    <h1>Minha Conta</h1>
    <section class="user-info">
        <h2>Dados do Cliente</h2>
        <p><strong>Nome:</strong> <%= nome %></p>
        <p><strong>Email:</strong> <%= emailSessao %></p>
    </section>

   <section class="pets">
        <h2>Meus Pets</h2>
        <%
            try (Connection conexao2 = DriverManager.getConnection(url, usuario, senhaBD)) {
                String sqlPets = "SELECT * FROM animais WHERE cpf = ?";
                PreparedStatement stmtPets = conexao2.prepareStatement(sqlPets);
                stmtPets.setString(1, cpf);
                ResultSet rsPets = stmtPets.executeQuery();
                boolean hasPets = false;
                while (rsPets.next()) {
                    hasPets = true;
                    int idPet = rsPets.getInt("id");
                    String nomePet = rsPets.getString("nome");
                    String especie = rsPets.getString("especie");
                    String raca = rsPets.getString("raca");
                    String sexo = rsPets.getString("sexo");
                    java.sql.Date dataNascimento = rsPets.getDate("data_nascimento");
                    String statusCastracao = rsPets.getString("status_castracao");
                    String microchip = rsPets.getString("microchip");
                    String alergias = rsPets.getString("alergias");
                    String doencasCronicas = rsPets.getString("doencas_cronicas");
                    String medicamentosUso = rsPets.getString("medicamentos_uso");
                    String temperamento = rsPets.getString("temperamento");
                    String fotoUrl = rsPets.getString("foto_url");
                    String cor = rsPets.getString("cor");

                    microchip = (microchip == null) ? "" : microchip;
                    alergias = (alergias == null) ? "" : alergias;
                    doencasCronicas = (doencasCronicas == null) ? "" : doencasCronicas;
                    medicamentosUso = (medicamentosUso == null) ? "" : medicamentosUso;
                    temperamento = (temperamento == null) ? "" : temperamento;
                    cor = (cor == null) ? "" : cor;
        %>
        <div class="pet-card">
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
                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 18c-4.41 0-8-3.59-8-8s3.59-8 8-8 8 3.59 8 8-3.59 8-8 8zm-1-13h2v6h-2zm0 8h2v2h-2z"/></svg>
                            <span><%= especie %> - <%= raca %></span>
                        </div>
                        <div class="pet-info-item">
                             <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M9 11.75c-.69 0-1.25.56-1.25 1.25s.56 1.25 1.25 1.25 1.25-.56 1.25-1.25-.56-1.25-1.25-1.25zm6 0c-.69 0-1.25.56-1.25 1.25s.56 1.25 1.25 1.25 1.25-.56 1.25-1.25-.56-1.25-1.25-1.25zM12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 18c-4.41 0-8-3.59-8-8s3.59-8 8-8 8 3.59 8 8-3.59 8-8 8z"/></svg>
                            <span><%= sexo %></span>
                        </div>
                        <div class="pet-info-item">
                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M19 3h-1V1h-2v2H8V1H6v2H5c-1.11 0-2 .9-2 2v14c0 1.1.89 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm0 16H5V8h14v11zM7 10h5v5H7z"/></svg>
                            <span><%= formatarNascimento(dataNascimento) %></span>
                        </div>
                        <div class="pet-info-item">
                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M12 1L3 5v6c0 5.55 3.84 10.74 9 12 5.16-1.26 9-6.45 9-12V5l-9-4zm0 10.99h7c-.53 4.12-3.28 7.79-7 8.94V12H5V6.3l7-3.11v8.8z"/></svg>
                            <span>Castrado: <%= statusCastracao %></span>
                        </div>
                    </div>
                </div>
            </div>
            <div class="card-actions">
                <button onclick="abrirModalEditar(
                    '<%= idPet %>', '<%= nomePet %>', '<%= especie %>', '<%= raca %>', '<%= sexo %>',
                    '<%= dataNascimento %>', '<%= statusCastracao %>', '<%= microchip %>',
                    '<%= alergias.replace("'", "\\'") %>', '<%= doencasCronicas.replace("'", "\\'") %>',
                    '<%= medicamentosUso.replace("'", "\\'") %>', '<%= temperamento.replace("'", "\\'") %>',
                    '<%= cor.replace("'", "\\'") %>'
                )">Editar</button>
                <button class="delete-btn" onclick="excluirPet(<%= idPet %>)">Excluir</button>
            </div>
        </div>
        <%
                }
                if (!hasPets) { out.println("<p>Nenhum pet cadastrado.</p>"); }
            } catch (Exception e) {
                out.println("<p style='color: red;'>Erro ao buscar pets: " + e.getMessage() + "</p>");
            }
        %>
        <button onclick="abrirModal('modalCadastroPet')">Cadastrar Novo Pet</button>
    </section>
        
        <section class="aviso-cadastro-pet">
        <h3><span style="font-size: 20px;">🐾</span> Por que cadastrar seu pet?</h3>
        <p>
            Manter as informações do seu amiguinho em nosso sistema nos ajuda a preparar um atendimento mais rápido e personalizado. Com o cadastro completo, já teremos em mãos o histórico e os detalhes essenciais para cuidar da saúde dele com a máxima atenção durante a consulta.
        </p>
    </section>
      
  <section class="consultas">
    <h2>Consultas Futuras</h2>
    <%
        boolean hasFutureConsultas = false;
        try (Connection conexao3 = DriverManager.getConnection(url, usuario, senhaBD)) {
            // ===== CORREÇÃO AQUI: SQL com JOIN para buscar o nome do pet =====
            String sqlConsultas = "SELECT c.*, a.nome as nome_pet " +
                                  "FROM dadosconsulta c " +
                                  "JOIN animais a ON c.id_animal = a.id " +
                                  "WHERE c.cpf = ? AND (c.status = 'pendente' OR c.status = 'confirmada') " +
                                  "ORDER BY c.data_consulta ASC";
            
            PreparedStatement stmtConsultas = conexao3.prepareStatement(sqlConsultas);
            stmtConsultas.setString(1, cpf);
            ResultSet rsConsultas = stmtConsultas.executeQuery();

            while (rsConsultas.next()) {
                hasFutureConsultas = true;
                int idConsulta = rsConsultas.getInt("id");
                Timestamp dataConsultaTs = rsConsultas.getTimestamp("data_consulta");
                String status = rsConsultas.getString("status");
                String sintomas = rsConsultas.getString("sintomas");
                String observacoes = rsConsultas.getString("observacoes");
                
                // ===== CORREÇÃO AQUI: Pega o nome do pet pelo alias 'nome_pet' =====
                String nomePetDaConsulta = rsConsultas.getString("nome_pet");

                String statusClass = "";
                if ("pendente".equalsIgnoreCase(status)) {
                    statusClass = "status-pendente";
                } else if ("confirmada".equalsIgnoreCase(status)) {
                    statusClass = "status-confirmada";
                }
    %>
    <div class="consulta-card">
        <p><strong>Data:</strong> <%= formatarDataBR(dataConsultaTs) %></p>
        <p><strong>Pet:</strong> <%= nomePetDaConsulta %></p>
        <p><strong>Status:</strong> <span class="badge-status <%= statusClass %>"><%= status %></span></p>
        <div class="card-actions">
            <button onclick="abrirModal('modalConsulta<%= idConsulta %>')">Ver Detalhes</button>
            <button class="delete-btn" onclick="cancelarConsulta(<%= idConsulta %>)">Cancelar Consulta</button>
        </div>
    </div>
    
    <div id="modalConsulta<%= idConsulta %>" class="modal" role="dialog">
        <div class="modal-content">
             <h2>Detalhes da Consulta</h2>
             <button class="close" onclick="fecharModal('modalConsulta<%= idConsulta %>')">&times;</button>
             <p><strong>Data:</strong> <%= formatarDataBR(dataConsultaTs) %></p>
             <p><strong>Status:</strong> <span class="badge-status <%= statusClass %>"><%= status %></span></p>
             <p><strong>Pet:</strong> <%= nomePetDaConsulta %></p>
             <p><strong>Sintomas:</strong> <%= sintomas %></p>
             <p><strong>Observações:</strong> <%= observacoes %></p>
        </div>
    </div>
    <%
            }
            if (!hasFutureConsultas) {
                out.println("<p>Nenhuma consulta futura agendada.</p>");
            }
        } catch (Exception e) {
            out.println("<p style='color:red;'>Erro ao buscar consultas futuras: " + e.getMessage() + "</p>");
            e.printStackTrace();
        }
    %>
</section>

       <section class="aviso-importante">
        <h3><span style="font-size: 20px;">&#9888;</span> Atenção!</h3>
        <p>
            Por favor, compareça à clínica para sua consulta <strong>apenas</strong> quando o status do agendamento estiver como 
            <span class="status-confirmada-aviso">Confirmada</span>.
        </p>
        <p style="margin-top: 5px; font-size: 0.9em;">
            Agendamentos com status "Pendente" ainda estão aguardando nossa aprovação de horário e podem sofrer alterações.
        </p>
    </section>
    
    <section class="consultas">
    <h2>Histórico de Consultas</h2>
    <%
        boolean hasHistoryConsultas = false;
        try (Connection conexao4 = DriverManager.getConnection(url, usuario, senhaBD)) {
            
            // ===== CORREÇÃO AQUI: SQL com JOIN para buscar o nome do pet =====
            String sqlHistorico = "SELECT c.*, a.nome as nome_pet " +
                                  "FROM dadosconsulta c " +
                                  "JOIN animais a ON c.id_animal = a.id " +
                                  "WHERE c.cpf = ? AND c.status = 'concluida' " +
                                  "ORDER BY c.data_consulta DESC";
            
            PreparedStatement stmtHistorico = conexao4.prepareStatement(sqlHistorico);
            stmtHistorico.setString(1, cpf);
            ResultSet rsHistorico = stmtHistorico.executeQuery();

            while (rsHistorico.next()) {
                hasHistoryConsultas = true;
                int idConsulta = rsHistorico.getInt("id");
                Timestamp dataConsultaTs = rsHistorico.getTimestamp("data_consulta");
                String status = rsHistorico.getString("status");
                String sintomas = rsHistorico.getString("sintomas");
                String observacoes = rsHistorico.getString("observacoes");

                // ===== CORREÇÃO AQUI: Pega o nome do pet pelo alias 'nome_pet' =====
                String nomePetDoHistorico = rsHistorico.getString("nome_pet");
    %>
    <div class="consulta-card">
        <p><strong>Data:</strong> <%= formatarDataBR(dataConsultaTs) %></p>
        <p><strong>Pet:</strong> <%= nomePetDoHistorico %></p>
        <p><strong>Status:</strong> <span class="badge-status status-concluida"><%= status %></span></p>
        <div class="card-actions">
            <button onclick="abrirModalConsulta('modalHistorico<%= idConsulta %>')">Ver Detalhes</button>
            <button onclick="abrirRelatorio(<%= idConsulta %>)">Abrir Relatório</button>
        </div>
    </div>

    <div id="modalHistorico<%= idConsulta %>" class="modal" role="dialog">
        <div class="modal-content">
            <h2>Detalhes do Histórico</h2>
            <button class="close" onclick="fecharModal('modalHistorico<%= idConsulta %>')">&times;</button>
            <p><strong>Data:</strong> <%= formatarDataBR(dataConsultaTs) %></p>
            <p><strong>Status:</strong> <%= status %></p>
            <p><strong>Pet:</strong> <%= nomePetDoHistorico %></p>
            <p><strong>Sintomas:</strong> <%= sintomas %></p>
            <p><strong>Observações:</strong> <%= observacoes %></p>
        </div>
    </div>
    <%
            }
            if (!hasHistoryConsultas) {
                out.println("<p>Nenhum histórico de consultas concluídas encontrado.</p>");
            }
        } catch (Exception e) {
            out.println("<p style='color:red;'>Erro ao buscar histórico: " + e.getMessage() + "</p>");
            e.printStackTrace();
        }
    %>
</section>

    <div class="actions">
        <button onclick="window.location.href='logout.jsp'" class="logout">Sair da Conta</button>
        <button onclick="window.location.href='telaLoginSucesso.jsp'">Voltar</button>
    </div>
</div>

<div id="modalEditarPet" class="modal" role="dialog" aria-modal="true" aria-labelledby="modalEditarPetTitle">
    <div class="modal-content">
        <h2 id="modalEditarPetTitle">Editar Pet</h2>
        <button class="close" onclick="fecharModal('modalEditarPet')" aria-label="Fechar">&times;</button>
        <form action="${pageContext.request.contextPath}/atualizar-pet" method="POST" class="pet-form" enctype="multipart/form-data">
            <input type="hidden" id="idPetEditar" name="idPet">
            <fieldset>
                <legend>Dados Básicos</legend>
                <div class="fieldset-grid">
                    <div class="form-group">
                        <label for="nomePetEditar">Nome:</label>
                        <input type="text" id="nomePetEditar" name="nomePet" required>
                    </div>
                    <div class="form-group">
                        <label for="data_nascimentoEditar">Data de Nascimento:</label>
                        <input type="date" id="data_nascimentoEditar" name="data_nascimento" required max="<%= hojeFormatado %>" min="<%= dataMinimaFormatada %>">
                    </div>
                    <div class="form-group">
                        <label for="especiePetEditar">Espécie:</label>
                        <input type="text" id="especiePetEditar" name="especiePet" required>
                    </div>
                    <div class="form-group">
                        <label for="racaPetEditar">Raça:</label>
                        <input type="text" id="racaPetEditar" name="racaPet" required>
                    </div>
                    <div class="form-group">
                        <label for="sexoPetEditar">Sexo:</label>
                        <select name="sexoPet" id="sexoPetEditar" required>
                            <option value="Macho">Macho</option>
                            <option value="Femea">Fêmea</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="corPetEditar">Cor/Pelagem:</label>
                        <input type="text" id="corPetEditar" name="corPet">
                    </div>
                </div>
            </fieldset>
            <fieldset>
                <legend>Histórico de Saúde e Identificação</legend>
                <div class="fieldset-grid">
                    <div class="form-group">
                        <label for="status_castracaoEditar">Castrado(a)?</label>
                        <select name="status_castracao" id="status_castracaoEditar">
                            <option value="Não">Não</option>
                            <option value="Sim">Sim</option>
                            <option value="Não Aplicável">Não Aplicável</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="microchipEditar">Nº do Microchip:</label>
                        <input type="text" id="microchipEditar" name="microchip">
                    </div>
                    <div class="form-group form-full-width">
                        <label for="alergiasEditar">Alergias Conhecidas:</label>
                        <textarea id="alergiasEditar" name="alergias"></textarea>
                    </div>
                    <div class="form-group form-full-width">
                        <label for="doencas_cronicasEditar">Doenças Crônicas:</label>
                        <textarea id="doencas_cronicasEditar" name="doencas_cronicas"></textarea>
                    </div>
                    <div class="form-group form-full-width">
                        <label for="medicamentos_usoEditar">Medicamentos em Uso:</label>
                        <textarea id="medicamentos_usoEditar" name="medicamentos_uso"></textarea>
                    </div>
                </div>
            </fieldset>
             <fieldset>
                <legend>Informações Adicionais</legend>
                <div class="fieldset-grid">
                    <div class="form-group">
                        <label for="temperamentoEditar">Temperamento:</label>
                        <input type="text" id="temperamentoEditar" name="temperamento">
                    </div>
                    <div class="form-group">
                        <label for="fotoPetEditar">Alterar Foto:</label>
                        <input type="file" id="fotoPetEditar" name="fotoPet" accept="image/*">
                    </div>
                </div>
            </fieldset>
            <button type="submit" class="submit-button">Atualizar Pet</button>
        </form>
    </div>
</div>

<script>
    function abrirModalEditar(idPet, nomePet, especie, raca, sexo, dataNascimento, statusCastracao, microchip, alergias, doencasCronicas, medicamentosUso, temperamento, cor) {
        document.getElementById('idPetEditar').value = idPet;
        document.getElementById('nomePetEditar').value = nomePet;
        document.getElementById('especiePetEditar').value = especie;
        document.getElementById('racaPetEditar').value = raca;
        document.getElementById('sexoPetEditar').value = sexo;
        document.getElementById('data_nascimentoEditar').value = dataNascimento;
        document.getElementById('status_castracaoEditar').value = statusCastracao;
        document.getElementById('microchipEditar').value = microchip;
        document.getElementById('alergiasEditar').value = alergias;
        document.getElementById('doencas_cronicasEditar').value = doencasCronicas;
        document.getElementById('medicamentos_usoEditar').value = medicamentosUso;
        document.getElementById('temperamentoEditar').value = temperamento;
        document.getElementById('corPetEditar').value = cor;

        abrirModal('modalEditarPet');
    }

    function excluirPet(idPet) {
        if (confirm("Tem certeza que deseja excluir este pet? Esta ação é irreversível.")) {
            const form = document.createElement('form');
            form.method = 'POST';
            // CORREÇÃO: Aponta para a URL do novo servlet
            form.action = '${pageContext.request.contextPath}/excluir-pet';
            const input = document.createElement('input');
            input.type = 'hidden';
            input.name = 'idPet';
            input.value = idPet;
            form.appendChild(input);
            document.body.appendChild(form);
            form.submit();
        }
    }

    function abrirModal(modalId) { 
        var modal = document.getElementById(modalId);
        if(modal) modal.style.display = 'flex';
    }
    function fecharModal(modalId) { 
        var modal = document.getElementById(modalId);
        if(modal) modal.style.display = 'none';
    }
    function abrirModalConsulta(modalId) { 
        var modal = document.getElementById(modalId);
        if(modal) modal.style.display = 'flex';
    }
    function abrirRelatorio(idConsulta) { 
        window.open('verRelatorio.jsp?id=' + idConsulta, '_blank'); 
    }

    document.addEventListener('DOMContentLoaded', function() {
        const allModals = document.querySelectorAll('.modal');
        allModals.forEach(modal => {
            modal.style.display = 'none';
        });
    });
</script>

<script>
    // ... suas funções existentes (abrirModalEditar, excluirPet, etc) ...

    // NOVA FUNÇÃO PARA CANCELAR CONSULTA
    function cancelarConsulta(idConsulta) {
        if (confirm("Tem certeza que deseja cancelar esta consulta?")) {
            // Redireciona para o script JSP que faz a exclusão
            window.location.href = 'cancelarConsulta.jsp?id=' + idConsulta;
        }
    }

 
</script>
</body>
</html>