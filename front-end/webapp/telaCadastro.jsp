<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cadastro - Clínica Veterinária</title>
    <link rel="icon" type="image/svg+xml" href="imgs_inicio/minilogo.svg">
    <link rel="icon" type="image/png" href="imgs_inicio/minilogo.png">
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Montserrat', sans-serif;
            color: #3a414e;
            background-color: #f4f7fc;
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            padding: 20px;
        }
        .cadastro-wrapper {
            display: flex;
            width: 100%;
            max-width: 1000px;
            background-color: #ffffff;
            border-radius: 15px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }

        .info-column {
            width: 40%;
            background: linear-gradient(to top, rgba(0, 47, 75, 0.8), rgba(0, 0, 0, 0.3)),
            url('https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?q=80&w=2043&auto=format&fit=crop') center/cover;
            display: flex;
            flex-direction: column;
            justify-content: center;
            padding: 40px;
            color: #fff;
            text-align: center;
        }
        .info-column h2 { font-size: 2.2rem; font-weight: 700; line-height: 1.3; margin-bottom: 15px; }
        .info-column p { font-size: 1.1rem; line-height: 1.6; opacity: 0.9; }

        .form-column {
            width: 60%;
            padding: 30px 40px;
            overflow-y: auto;
            max-height: 90vh;
        }
        .form-header { text-align: center; margin-bottom: 25px; }
        .form-header h1 { color: #002F4B; font-size: 1.8rem; font-weight: 700; margin: 0; }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px 20px;
        }
        .form-group { text-align: left; }
        .form-group.full-width { grid-column: 1 / -1; }
        .form-group label { display: block; font-size: 0.9rem; color: #555; margin-bottom: 8px; font-weight: 600; }
        .form-group input { width: 100%; padding: 12px 15px; font-size: 1rem; border: 1px solid #ddd; border-radius: 8px; transition: all 0.3s ease; }
        .form-group input:focus { outline: none; border-color: #004d7c; box-shadow: 0 0 0 3px rgba(0, 77, 124, 0.15); }

        .btn-action { color: white; padding: 14px 20px; font-size: 1rem; border: none; border-radius: 8px; width: 100%; cursor: pointer; transition: all 0.3s ease; margin-top: 10px; font-weight: 700; text-transform: uppercase; }
        .primary-btn { background-color: #002F4B; }
        .primary-btn:hover { background-color: #004d7c; transform: translateY(-2px); }
        .secondary-btn { background-color: #6c757d; }
        .secondary-btn:hover { background-color: #5a6268; }

        .login-text { margin-top: 20px; font-size: 0.9rem; color: #666; text-align: center; grid-column: 1 / -1; }
        .login-link { color: #002F4B; text-decoration: none; font-weight: 600; }
        .login-link:hover { text-decoration: underline; }

        .error-list { list-style-type: none; padding: 0; margin: 5px 0 0 0; color: #d9534f; font-size: 0.85em; }
        .error-message { color: #d9534f; font-size: 0.85em; margin-top: 5px; min-height: 1em; }

        @media (max-width: 900px) {
            body {
                padding: 0;
                align-items: flex-start;
            }
            .cadastro-wrapper {
                flex-direction: column;
                width: 100%;
                min-height: 100vh;
                border-radius: 0;
                box-shadow: none;
            }
            .info-column {
                display: none;
            }
            .form-column {
                width: 100%;
                max-height: none;
                padding: 40px 25px;
            }
            .form-grid {
                grid-template-columns: 1fr;
            }
            .form-group.full-width {
                grid-column: auto;
            }
        }
    </style>
</head>
<body>
<div class="cadastro-wrapper">
    <div class="info-column">
        <h2>Crie sua conta e junte-se à nossa família.</h2>
        <p>O cuidado que seu pet merece começa aqui. Um cadastro rápido para um atendimento completo.</p>
    </div>

    <div class="form-column">
        <header class="form-header">
            <h1>Formulário de Cadastro</h1>
        </header>
        <main>
            <form method="POST" action="cadastrar" id="cadastro-form">
                <div class="form-grid">
                    <div class="form-group full-width">
                        <label for="nomeUsuario">Nome de Usuário:</label>
                        <input type="text" id="nomeUsuario" name="username" placeholder="Digite o nome de usuário" required />
                    </div>

                    <div class="form-group full-width">
                        <label for="email">E-mail:</label>
                        <input type="email" id="email" name="email" placeholder="Digite o seu e-mail" required />
                    </div>

                    <div class="form-group">
                        <label for="cpf">CPF:</label>
                        <input type="text" id="cpf" name="cpf" maxlength="14" placeholder="000.000.000-00" required />
                        <ul id="erro-cpf" class="error-list"></ul>
                    </div>

                    <div class="form-group">
                        <!-- Espaço vazio para alinhar o grid em desktop -->
                    </div>

                    <div class="form-group">
                        <label for="senhaUsuario">Senha:</label>
                        <input type="password" id="senhaUsuario" name="password" placeholder="Digite a senha" required />
                        <ul id="erro-senha" class="error-list"></ul>
                    </div>

                    <div class="form-group">
                        <label for="confirm-password">Confirmar Senha:</label>
                        <input type="password" id="confirm-password" name="confirm-password" placeholder="Confirme a senha" required />
                        <span id="erro-confirmar-senha" class="error-message"></span>
                    </div>

                    <div class="form-group full-width">
                        <button type="submit" class="btn-action primary-btn">Cadastrar</button>
                    </div>

                    <div class="form-group full-width">
                        <button type="button" class="btn-action secondary-btn" onclick="window.location.href='index.html'">Cancelar</button>
                    </div>

                    <div class="login-text">
                        Já possui uma conta?
                        <a href="login.jsp" class="login-link">Faça o login aqui.</a>
                    </div>
                </div>
            </form>
        </main>
    </div>
</div>

<script>
    function validarCPF(cpf) {
        cpf = cpf.replace(/[^\d]+/g, "");
        if (cpf.length !== 11 || /^(\d)\1+$/.test(cpf)) return false;
        let soma = 0, resto;
        for (let i = 0; i < 9; i++) { soma += parseInt(cpf.charAt(i)) * (10 - i); }
        resto = (soma * 10) % 11;
        if (resto === 10 || resto === 11) resto = 0;
        if (resto !== parseInt(cpf.charAt(9))) return false;
        soma = 0;
        for (let i = 0; i < 10; i++) { soma += parseInt(cpf.charAt(i)) * (11 - i); }
        resto = (soma * 10) % 11;
        if (resto === 10 || resto === 11) resto = 0;
        if (resto !== parseInt(cpf.charAt(10))) return false;
        return true;
    }
    document.addEventListener("DOMContentLoaded", function () {
        const cadastroForm = document.getElementById("cadastro-form");
        const cpfInput = document.getElementById("cpf");
        const erroCPF = document.getElementById("erro-cpf");
        const senhaInput = document.getElementById("senhaUsuario");
        const confirmSenhaInput = document.getElementById("confirm-password");
        const erroSenha = document.getElementById("erro-senha");
        const erroConfirmarSenha = document.getElementById("erro-confirmar-senha");
        cadastroForm.addEventListener("submit", function (event) {
            let formValido = true;
            erroCPF.innerHTML = "";
            erroSenha.innerHTML = "";
            erroConfirmarSenha.textContent = "";
            const cpf = cpfInput.value.trim();
            if (!validarCPF(cpf)) {
                erroCPF.innerHTML = "<li>CPF inválido.</li>";
                formValido = false;
            }
            const senha = senhaInput.value;
            const confirmSenha = confirmSenhaInput.value;
            if (senha.length < 6) {
                erroSenha.innerHTML += "<li>A senha deve ter pelo menos 6 caracteres.</li>";
                formValido = false;
            }
            if (senha !== confirmSenha) {
                erroConfirmarSenha.textContent = "As senhas não coincidem.";
                formValido = false;
            }
            if (!formValido) {
                event.preventDefault();
            }
        });
        cpfInput.addEventListener("input", function (e) {
            let v = e.target.value.replace(/\D/g, "");
            v = v.slice(0, 11);
            v = v.replace(/^(\d{3})(\d)/, "$1.$2").replace(/^(\d{3})\.(\d{3})(\d)/, "$1.$2.$3").replace(/^(\d{3})\.(\d{3})\.(\d{3})(\d)/, "$1.$2.$3-$4");
            e.target.value = v;
        });
    });
</script>
</body>
</html>

