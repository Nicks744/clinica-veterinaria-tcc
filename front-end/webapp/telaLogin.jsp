<%@ page isELIgnored="false" contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Clínica Veterinária - Login</title>
    <link rel="icon" type="image/svg+xml" href="imgs_inicio/minilogo.svg">
    <link rel="icon" type="image/png" href="imgs_inicio/minilogo.png">
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
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
        .login-container {
            display: flex;
            width: 100%;
            max-width: 900px;
            min-height: 600px;
            background-color: #ffffff;
            border-radius: 15px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }
        .image-column {
            width: 45%;
            background: linear-gradient(to top, rgba(0, 47, 75, 0.85), rgba(0, 47, 75, 0.4)), url('https://images.unsplash.com/photo-1548199973-03cce0bbc87b?q=80&w=2069&auto=format&fit=crop') center/cover;
            display: flex;
            flex-direction: column;
            justify-content: flex-end;
            padding: 40px;
            color: #fff;
            text-shadow: 1px 1px 3px rgba(0,0,0,0.3);
        }
        .image-column h2 { font-size: 2.5rem; } .image-column p { font-size: 1.1rem; }
        .form-column {
            width: 55%;
            padding: 40px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }
        .form-header { text-align: center; margin-bottom: 30px; }
        .form-header img.logo { width: 166px; margin-bottom: 10px; }
        .form-header h1 { color: #002F4B; font-size: 1.8rem; }
        .input-group { margin-bottom: 20px; text-align: left; }
        .input-group label { display: block; font-size: 0.9rem; color: #555; margin-bottom: 8px; font-weight: 600; }
        .input-group input { width: 100%; padding: 12px 15px; font-size: 1rem; border: 1px solid #ddd; border-radius: 8px; transition: all 0.3s ease; }
        .input-group input:focus { outline: none; border-color: #004d7c; box-shadow: 0 0 0 3px rgba(0, 77, 124, 0.15); }
        .forgot-password { text-align: right; margin-bottom: 20px; font-size: 0.9rem; }
        .forgot-password a { color: #002F4B; text-decoration: none; font-weight: 600; cursor: pointer; }
        .forgot-password a:hover { text-decoration: underline; }
        .btn-login { color: white; padding: 14px 20px; font-size: 1rem; border: none; border-radius: 8px; width: 100%; cursor: pointer; transition: all 0.3s ease; margin-top: 10px; font-weight: 700; text-transform: uppercase; }
        .primary-btn { background-color: #002F4B; }
        .secondary-btn { background-color: transparent; color: #6c757d; border: 1px solid #ccc; }
        .register-text { margin-top: 25px; font-size: 0.9rem; color: #666; text-align: center; }
        .register-link { color: #002F4B; text-decoration: none; font-weight: 600; }
        .modal-overlay { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0, 0, 0, 0.6); z-index: 1000; justify-content: center; align-items: center; }
        .modal-content { background: #fff; padding: 30px; border-radius: 10px; width: 90%; max-width: 450px; text-align: center; position: relative; }
        .modal-close { position: absolute; top: 10px; right: 15px; font-size: 1.5rem; color: #aaa; cursor: pointer; }
        .modal-content h2 { color: #002F4B; }
        .message { margin-bottom: 15px; padding: 10px; border-radius: 5px; text-align: center; font-weight: 600; }
        .message.success { color: #155724; background-color: #d4edda; }
        .message.error { color: #721c24; background-color: #f8d7da; }

        /* ============================================= */
        /* == AJUSTES PARA DISPOSITIVOS MÓVEIS == */
        /* ============================================= */
        @media (max-width: 768px) {
            body {
                padding: 0; /* Remove o padding do corpo em telemóveis */
                align-items: flex-start; /* Alinha o conteúdo ao topo */
            }
            .login-container {
                flex-direction: column;
                min-height: 100vh; /* Ocupa a altura total da tela */
                width: 100%;
                border-radius: 0; /* Remove as bordas arredondadas */
                box-shadow: none; /* Remove a sombra */
            }
            .image-column {
                display: none; /* Mantém a imagem escondida */
            }
            .form-column {
                width: 100%;
                padding: 40px 25px; /* Mais espaço vertical, menos horizontal */
                justify-content: center;
                flex-grow: 1; /* Permite que o formulário ocupe o espaço vertical */
            }
            .form-header h1 {
                font-size: 1.6rem; /* Título ligeiramente menor */
            }
        }
    </style>
</head>
<body>

<div class="login-container">
    <div class="image-column">
        <h2>Cuidando de quem te faz feliz.</h2>
        <p>Acesse sua conta para gerenciar a saúde do seu pet e agendar consultas com nossos especialistas.</p>
    </div>

    <div class="form-column">
        <header class="form-header">
            <img src="images/logo.png" alt="Logo Clínica Vet" class="logo">
            <h1>Bem-vindo(a) de volta!</h1>
        </header>

        <main>
            <%-- CÓDIGO PARA MOSTRAR AS MENSAGENS DOS SERVLETS --%>
            <% if (request.getAttribute("erro") != null) { %>
            <p class="message error"><%= request.getAttribute("erro") %></p>
            <% } %>
            <% if ("success".equals(request.getParameter("reset"))) { %>
            <p class="message success">Um link para redefinir sua senha foi enviado para o seu e-mail.</p>
            <% } %>
            <% if ("failed".equals(request.getParameter("reset"))) { %>
            <p class="message error">O e-mail informado não foi encontrado em nosso sistema.</p>
            <% } %>
            <% if ("sucesso".equals(request.getParameter("cadastro"))) { %>
            <p class="message success">Cadastro realizado com sucesso! Por favor, verifique o seu e-mail para ativar a conta.</p>
            <% } %>

            <form method="POST" action="${pageContext.request.contextPath}/login">
                <div class="input-group">
                    <label for="email">E-mail:</label>
                    <input type="email" id="email" name="email" placeholder="seuemail@exemplo.com" required>
                </div>
                <div class="input-group">
                    <label for="password">Senha:</label>
                    <input type="password" id="password" name="password" placeholder="Sua senha" required>
                </div>
                <div class="forgot-password">
                    <a id="forgot-password-link">Esqueci minha senha</a>
                </div>
                <button type="submit" class="btn-login primary-btn">Entrar</button>
                <button type="button" class="btn-login secondary-btn" onclick="window.location.href='index.html'">Cancelar</button>
                <p class="register-text">
                    Não possui uma conta?
                    <a href="telaCadastro.jsp" class="register-link">Cadastre-se aqui.</a>
                </p>
            </form>
        </main>
    </div>
</div>

<!-- Modal de Recuperação de Senha -->
<div class="modal-overlay" id="recovery-modal">
    <div class="modal-content">
        <span class="modal-close" id="modal-close-btn">&times;</span>
        <h2>Recuperar Senha</h2>
        <p>Insira o seu e-mail abaixo. Enviaremos um link para que você possa redefinir a sua senha.</p>
        <form method="POST" action="${pageContext.request.contextPath}/esqueci-senha">
            <div class="input-group">
                <label for="recovery-email">E-mail:</label>
                <input type="email" id="recovery-email" name="email" required>
            </div>
            <button type="submit" class="btn-login primary-btn">Enviar Link</button>
        </form>
    </div>
</div>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const forgotPasswordLink = document.getElementById('forgot-password-link');
        const recoveryModal = document.getElementById('recovery-modal');
        const closeModalBtn = document.getElementById('modal-close-btn');
        forgotPasswordLink.addEventListener('click', function() { recoveryModal.style.display = 'flex'; });
        closeModalBtn.addEventListener('click', function() { recoveryModal.style.display = 'none'; });
        recoveryModal.addEventListener('click', function(event) { if (event.target === recoveryModal) { recoveryModal.style.display = 'none'; } });
    });
</script>

</body>
</html>

