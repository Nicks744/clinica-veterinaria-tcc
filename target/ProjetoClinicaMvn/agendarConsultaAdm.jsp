<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, jakarta.servlet.http.HttpSession" %>

<%
    // Lógica de sessão para garantir que apenas o Admin acesse esta página
    HttpSession sessao = request.getSession(false);
    if (sessao == null || !"admin".equals(sessao.getAttribute("tipo"))) {
        response.sendRedirect("telaLogin.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Agendamento (Atendente)</title>

    <!-- favicon em SVG -->
    <link rel="icon" type="image/svg+xml" href="imgs_inicio/minilogo.svg">

    <!-- fallback em PNG -->
    <link rel="icon" type="image/png" href="imgs_inicio/minilogo.png">
    <link rel="stylesheet" href="agendarConsulta.css">
    
    <h2>Agendamento de Consulta (Atendimento)</h2>
    <div class="barra-azul">
        <img src="imgs_adm/orelhinhas.png" alt="" class="img-decorativa">
    </div>
    <style>
        .error-message { color: #d9534f; font-size: 0.9em; margin-top: 5px; height: 1em; }
        .cpf-container { display: flex; align-items: stretch; gap: 10px; margin-bottom: 10px; }
        .cpf-container input { flex-grow: 1; }
        .cpf-container button { padding: 0 15px; cursor: pointer; border: 1px solid #ccc; background: #f0f0f0; border-radius: 5px; }
        .cpf-container button:hover { background: #e0e0e0; }
    </style>
</head>
<body>
    
<div class="form-container">
    <form id="consulta-form" method="post" action="processaAgendamentoAdm.jsp">
        
        <h3>Dados do Tutor</h3>

        <label for="cpf">CPF do Dono:</label>
        <div class="cpf-container">
            <input type="text" id="cpf" name="cpf" placeholder="Digite o CPF e clique em Buscar" required>
            <button type="button" onclick="buscarCliente()">Buscar</button>
        </div>
        <div class="error-message" id="erro-cpf"></div>
        
        <label for="nome">Nome do Dono:</label>
        <input type="text" id="nome" name="nome" placeholder="Preenchido após a busca ou digitar manualmente" required>

        <label for="numero">Número de Contato:</label>
        <input type="tel" id="numero" name="numero" placeholder="(DDD) 9XXXX-XXXX" required>
        
        <h3>Dados do Animal</h3>
        
        <div class="form-group">
            <label for="petSelecionado">Selecione o Pet:</label>
            <select name="petSelecionado" id="petSelecionado" required>
                <option value="" disabled selected>-- Digite o CPF do dono primeiro --</option>
            </select>
        </div>
        
        <label for="sintomas">Sintomas:</label>
        <input type="text" id="sintomas" name="sintomas" placeholder="Descreva os sintomas apresentados" required>

        <label for="peso">Peso do Animal (kg):</label>
        <input type="number" id="peso" name="peso" step="0.1" placeholder="Ex: 5.2" required>

        <h3>Dados da Consulta</h3>
        
        <label for="data_consulta">Data da Consulta:</label>
        <input type="date" id="data_consulta" name="data_consulta" required> 
        
        <label for="horario_consulta">Horário da Consulta:</label>
        <select id="horario_consulta" name="horario_consulta" required>
            <option value="" disabled selected>Selecione uma data primeiro</option>
        </select>

        <label for="observacoes">Observações adicionais:</label>
        <textarea id="observacoes" name="observacoes" placeholder="Alguma informação extra"></textarea>
        
        <div class="buttons">
            <button type="submit" class="btnSalvar" id="btnSalvar">Agendar Consulta</button>
            <button type="button" class="btnCancelar" onclick="history.back(-1)">Cancelar</button>
        </div>
    </form>
</div>

<script>
    function buscarCliente() {
        const cpfInput = document.getElementById('cpf');
        const nomeInput = document.getElementById('nome');
        const petSelect = document.getElementById('petSelecionado');
        const cpf = cpfInput.value.replace(/\D/g, '');

        if (cpf.length !== 11) {
            alert('Por favor, digite um CPF válido com 11 dígitos.');
            return;
        }

        fetch('buscarClienteEPets.jsp?cpf=' + cpf)
            .then(response => response.json())
            .then(data => {
                if (data.clienteEncontrado) {
                    nomeInput.value = data.nomeTutor;
                    nomeInput.readOnly = true;
                    petSelect.innerHTML = '<option value="" disabled selected>-- Selecione um pet --</option>';
                    if (data.pets.length > 0) {
                        data.pets.forEach(pet => {
                            const option = new Option(pet.nome, pet.id);
                            petSelect.add(option);
                        });
                    } else {
                         petSelect.innerHTML = '<option value="" disabled>Nenhum pet cadastrado para este cliente</option>';
                    }
                } else {
                    alert('Cliente não encontrado. Por favor, preencha os dados manualmente.');
                    nomeInput.value = '';
                    nomeInput.readOnly = false;
                    petSelect.innerHTML = '<option value="" disabled>Cadastre o cliente e o pet primeiro</option>';
                }
            })
            .catch(error => {
                console.error('Erro na busca:', error);
                alert('Ocorreu um erro ao buscar os dados do cliente.');
            });
    }

    function validarCPF(cpf) {
        cpf = cpf.replace(/[^\d]+/g, '');
        if (cpf.length !== 11 || /^(\d)\1+$/.test(cpf)) return false;
        let soma = 0, resto;
        for (let i = 1; i <= 9; i++) soma += parseInt(cpf.substring(i - 1, i)) * (11 - i);
        resto = (soma * 10) % 11;
        if ((resto === 10) || (resto === 11)) resto = 0;
        if (resto !== parseInt(cpf.substring(9, 10))) return false;
        soma = 0;
        for (let i = 1; i <= 10; i++) soma += parseInt(cpf.substring(i - 1, i)) * (12 - i);
        resto = (soma * 10) % 11;
        if ((resto === 10) || (resto === 11)) resto = 0;
        if (resto !== parseInt(cpf.substring(10, 11))) return false;
        return true;
    }

    document.addEventListener("DOMContentLoaded", function () {
        const form = document.getElementById('consulta-form');
        if (!form) return;

        const cpfInput = document.getElementById("cpf");
        const numeroInput = document.getElementById("numero");
        const erroCPFDiv = document.getElementById("erro-cpf");
        const dataInput = document.getElementById('data_consulta');
        const horarioSelect = document.getElementById('horario_consulta');

        form.addEventListener("submit", function (event) {
            erroCPFDiv.textContent = ""; 
            const cpf = cpfInput.value;
            if (!validarCPF(cpf)) {
                erroCPFDiv.textContent = "CPF inválido. Por favor, verifique os dígitos.";
                event.preventDefault(); 
            }
        });

        cpfInput.addEventListener("input", function (e) {
            let v = e.target.value.replace(/\D/g, "").slice(0, 11);
            v = v.replace(/(\d{3})(\d)/, "$1.$2").replace(/(\d{3})(\d)/, "$1.$2").replace(/(\d{3})(\d{1,2})$/, "$1-$2");
            e.target.value = v;
        });

        numeroInput.addEventListener("input", function (e) {
            let v = e.target.value.replace(/\D/g, "").slice(0, 11);
            v = v.replace(/(\d{2})(\d)/, "($1) $2");
            if (v.length > 9) {
                 v = v.replace(/(\d{5})(\d)/, "$1-$2");
            }
            e.target.value = v;
        });

        const hoje = new Date();
        const amanha = new Date(hoje);
        amanha.setDate(amanha.getDate() + 1);
        const amanhaFormatado = amanha.toISOString().split('T')[0];
        dataInput.setAttribute('min', amanhaFormatado);
        
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

            // ===== CORREÇÃO DA URL DO FETCH =====
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
    });
</script>

</body>
</html>