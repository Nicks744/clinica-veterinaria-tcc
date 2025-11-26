<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, jakarta.servlet.http.HttpSession, java.util.ArrayList, java.util.List, java.util.Map, java.util.HashMap" %>

<%
    // --- BLOCO DE BUSCA DE DADOS UNIFICADO ---
    HttpSession sessao = request.getSession(false);
    if (sessao == null || sessao.getAttribute("usuarioLogado") == null) {
        response.sendRedirect("telaLogin.jsp");
        return;
    }
    
    String cpfTutor = (String) sessao.getAttribute("cpf");
    String nomeTutor = "";
    List<Map<String, String>> petsDoTutor = new ArrayList<>();
    boolean hasPets = false;

    String url = System.getenv("DB_URL");
    String usuario = System.getenv("DB_USERNAME");
    String senhaBD = System.getenv("DB_PASSWORD");


    try (Connection conexao = DriverManager.getConnection(url, usuario, senhaBD)) {
        // Busca nome do tutor
        String sqlTutor = "SELECT nome FROM usuarios WHERE cpf = ?";
        try (PreparedStatement stmtTutor = conexao.prepareStatement(sqlTutor)) {
            stmtTutor.setString(1, cpfTutor);
            ResultSet rsTutor = stmtTutor.executeQuery();
            if (rsTutor.next()) {
                nomeTutor = rsTutor.getString("nome");
            }
        }
        // Busca pets do tutor
        String sqlPets = "SELECT id, nome FROM animais WHERE cpf = ?";
        try (PreparedStatement stmtPets = conexao.prepareStatement(sqlPets)) {
            stmtPets.setString(1, cpfTutor);
            ResultSet rsPets = stmtPets.executeQuery();
            while (rsPets.next()) {
                hasPets = true;
                Map<String, String> pet = new HashMap<>();
                pet.put("id", rsPets.getString("id"));
                pet.put("nome", rsPets.getString("nome"));
                petsDoTutor.add(pet);
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Agende sua Consulta - Clínica Vet</title>
    <!-- favicon em SVG -->
    <link rel="icon" type="image/svg+xml" href="imgs_inicio/minilogo.svg">

    <!-- fallback em PNG -->
    <link rel="icon" type="image/png" href="imgs_inicio/minilogo.png">

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after {
            box-sizing: border-box;
        }
        body {
            font-family: 'Montserrat', sans-serif;
            color: #3a414e;
            background-color: #f4f7fc;
            background-image: url("data:image/svg+xml,%3Csvg width='52' height='60' viewBox='0 0 52 60' xmlns='http://www.w3.org/2000/svg'%3E%3Cg fill='none' fill-rule='evenodd'%3E%3Cg fill='%23dce7f4' fill-opacity='0.5'%3E%3Cpath d='M26 60V34.894L52 20.106V0L26 14.894L0 0v20.106L26 34.894V60zM26 30L52 15.106V5.9L26 20.106L0 5.9v9.206L26 30z'/%3E%3C/g%3E%3C/g%3E%3C/svg%3E");
            margin: 0;
            padding: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
        }
        .agendamento-wrapper { display: flex; width: 100%; max-width: 1100px; background: #fff; border-radius: 15px; box-shadow: 0 10px 30px rgba(0,0,0,0.1); overflow: hidden; }
        .info-coluna { width: 45%; background: linear-gradient(rgba(0, 47, 75, 0.85), rgba(0, 47, 75, 0.85)), url('https://images.unsplash.com/photo-1548199973-03cce0bbc87b?q=80&w=2069&auto=format&fit=crop') center/cover; color: #fff; padding: 40px; display: flex; flex-direction: column; justify-content: center; }
        .info-coluna h1 { font-size: 2.5rem; margin-bottom: 20px; line-height: 1.2; }
        .info-coluna p { font-size: 1.1rem; line-height: 1.6; opacity: 0.9; }
        .info-contato { margin-top: 30px; border-top: 1px solid rgba(255,255,255,0.3); padding-top: 20px; }
        .form-coluna { width: 55%; padding: 40px; overflow-y: auto; max-height: 90vh; }
        .form-coluna h2 { font-size: 1.8rem; color: #002F4B; margin-bottom: 25px; }
        .form-group { margin-bottom: 18px; }
        label { display: block; margin-bottom: 8px; font-weight: 600; color: #555; }
        input[type="text"], input[type="tel"], input[type="date"], input[type="number"], select, textarea { width: 100%; padding: 12px; border: 1px solid #ccc; border-radius: 8px; font-size: 1rem; font-family: 'Montserrat', sans-serif; transition: border-color 0.3s; }
        input:focus, select:focus, textarea:focus { border-color: #004d7c; outline: none; }
        input[readonly] { background-color: #e9ecef; cursor: not-allowed; }
        button[type="submit"] { width: 100%; padding: 15px; border: none; border-radius: 8px; background-color: #002F4B; color: #fff; font-size: 1.1rem; font-weight: 700; cursor: pointer; transition: background-color 0.3s; }
        button[type="submit"]:hover { background-color: #004d7c; }
        #petSelecionado option.cadastrar-pet { font-style: italic; color: #007bff; font-weight: bold; }
        .btn-voltar { display: block; text-align: center; margin-top: 25px; padding: 12px; border: 2px solid #fff; color: #fff; background-color: transparent; text-decoration: none; border-radius: 8px; font-weight: 600; transition: all 0.3s ease; }
        .btn-voltar:hover { background-color: #fff; color: #002F4B; }
        
        /* --- RESPONSIVE STYLES --- */
        @media (max-width: 992px) {
            body {
                display: block; /* Remove o alinhamento central para permitir rolagem natural */
                padding: 20px;
            }
            .agendamento-wrapper { flex-direction: column; }
            .info-coluna, .form-coluna { width: 100%; max-height: none; }
            .info-coluna { text-align: center; }
        }
        @media (max-width: 576px) {
            body {
                padding: 10px; /* Reduz o espaçamento nas laterais da página */
            }
            .info-coluna, .form-coluna {
                padding: 20px; /* Reduz o espaçamento interno das colunas */
            }
            .info-coluna h1 {
                font-size: 2rem; /* Diminui o tamanho do título principal */
            }
            .form-coluna h2 {
                font-size: 1.6rem; /* Diminui o tamanho do título do formulário */
            }
            .info-coluna p {
                font-size: 1rem;
            }
        }
    </style>
</head>
<body>
    <div class="agendamento-container">
        <div class="agendamento-wrapper">
            <div class="info-coluna">
                <h1>Agende uma Consulta</h1>
                <p>Preencha o formulário ao lado para solicitar um horário. Nossa equipe entrará em contato para confirmar a disponibilidade.</p>
                <div class="info-contato">
                    <p><strong>Horário de Atendimento:</strong><br>Segunda a Sexta, das 08:00 às 19:00</p>
                    <p><strong>Emergências 24h:</strong><br>(11) 95342-3838</p>
                </div>
                <a href="telaLoginSucesso.jsp" class="btn-voltar">Voltar ao Início</a>
            </div>
            <div class="form-coluna">
                <h2>Dados para Agendamento</h2>
                <form id="consulta-form" method="post" action="processaAgendamento.jsp">
                    <div class="form-group">
                        <label for="nome">Nome do Dono:</label>
                        <input type="text" id="nome" name="nome" value="<%= nomeTutor %>" readonly required>
                    </div>
                    <div class="form-group">
                        <label for="numero">Número de Contato:</label>
                        <input type="tel" id="numero" name="numero" placeholder="(DDD) 9XXXX-XXXX" required>
                    </div>
                    <div class="form-group">
                        <label for="cpf">CPF do Dono:</label>
                        <input type="text" id="cpf" name="cpf" value="<%= cpfTutor %>" readonly required>
                    </div>
                    <hr style="margin: 25px 0;">
                    <div class="form-group">
                        <label for="petSelecionado">Selecione o Pet:</label>
                        <select name="petSelecionado" id="petSelecionado" required>
                            <option value="" disabled selected>-- Escolha um dos seus pets --</option>
                            <% for (Map<String, String> pet : petsDoTutor) { out.println("<option value='" + pet.get("id") + "'>" + pet.get("nome") + "</option>"); } %>
                            <option value="cadastrar_novo" class="cadastrar-pet">+ Cadastrar um novo pet</option>
                        </select>
                    </div>
                    <div id="dados-consulta-div">
                        <div class="form-group">
                            <label for="sintomas">Sintomas:</label>
                            <input type="text" id="sintomas" name="sintomas" placeholder="Descreva os sintomas apresentados" required>
                        </div>
                        <div class="form-group">
                            <label for="peso">Peso do Animal (kg):</label>
                            <input type="number" id="peso" name="peso" step="0.1" placeholder="Ex: 5.2" required min="0.1" max="150">
                        </div>
                        <hr style="margin: 25px 0;">
                        <div class="form-group">
                            <label for="data_consulta">Data da Consulta:</label>
                            <input type="date" id="data_consulta" name="data_consulta" required> 
                        </div>
                        <div class="form-group">
                            <label for="horario_consulta">Horário da Consulta:</label>
                            <select id="horario_consulta" name="horario_consulta" required>
                                <option value="" disabled selected>Selecione uma data primeiro</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="observacoes">Observações adicionais:</label>
                            <textarea id="observacoes" name="observacoes" rows="3" placeholder="Alguma informação extra"></textarea>
                        </div>
                        <button type="submit" id="btnSalvar">Solicitar Agendamento</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const form = document.getElementById('consulta-form');
            if (!form) return;

            const petSelect = document.getElementById('petSelecionado');
            const dadosConsultaDiv = document.getElementById('dados-consulta-div');
            const numeroInput = document.getElementById("numero");
            const dataInput = document.getElementById('data_consulta');
            const horarioSelect = document.getElementById('horario_consulta');

            const temPetsCadastrados = <%= hasPets %>;

            function toggleFormVisibility() {
                dadosConsultaDiv.style.display = temPetsCadastrados ? 'block' : 'none';
            }
            toggleFormVisibility();

            petSelect.addEventListener('change', function() {
                if (this.value === 'cadastrar_novo') {
                    window.location.href = 'minhaConta.jsp';
                }
            });

            if(numeroInput) {
                numeroInput.addEventListener("input", function (e) {
                    let v = e.target.value.replace(/\D/g, "").slice(0, 11);
                    v = v.replace(/(\d{2})(\d)/, "($1) $2");
                    if (v.length > 9) { v = v.replace(/(\d{5})(\d)/, "$1-$2"); }
                    e.target.value = v;
                });
            }
            
            if(dataInput) {
                const hoje = new Date();
                
                // Define a data MÍNIMA (amanhã)
                const amanha = new Date(hoje);
                amanha.setDate(amanha.getDate() + 1);
                const amanhaFormatado = amanha.toISOString().split('T')[0];
                dataInput.setAttribute('min', amanhaFormatado);

                // VALIDAÇÃO DE DATA MÁXIMA ADICIONADA AQUI
                const dataMaxima = new Date();
                dataMaxima.setDate(dataMaxima.getDate() + 60); // Limite de 60 dias no futuro
                const dataMaximaFormatada = dataMaxima.toISOString().split('T')[0];
                dataInput.setAttribute('max', dataMaximaFormatada);
                
                dataInput.addEventListener('change', function() {
                    const dataSelecionada = this.value;
                    const dataObj = new Date(dataSelecionada + 'T00:00:00'); 
                    const diaDaSemana = dataObj.getDay();
                    if (diaDaSemana === 0 || diaDaSemana === 6) {
                        alert("Agendamentos não são permitidos aos sábados e domingos.");
                        this.value = '';
                        horarioSelect.innerHTML = '<option value="">Selecione uma data primeiro</option>';
                        horarioSelect.disabled = true;
                        return;
                    }
                    
                    horarioSelect.innerHTML = '<option value="">Carregando...</option>';
                    horarioSelect.disabled = true;

                    fetch('buscarHorarios.jsp?data=' + dataSelecionada)
                        .then(response => response.json())
                        .then(horariosDisponiveis => {
                            horarioSelect.innerHTML = ''; 
                            if (horariosDisponiveis.length === 0) {
                                horarioSelect.innerHTML = '<option value="">Nenhum horário disponível</option>';
                            } else {
                                horarioSelect.innerHTML = '<option value="" disabled selected>Selecione um horário</option>';
                                horariosDisponiveis.forEach(horario => {
                                    const option = new Option(horario, horario);
                                    horarioSelect.add(option);
                                });
                                horarioSelect.disabled = false;
                            }
                        })
                        .catch(error => {
                            console.error('Erro ao buscar horários:', error);
                            horarioSelect.innerHTML = '<option value="">Erro ao carregar horários</option>';
                        });
                });
            }
        });
    </script>
</body>
</html>

