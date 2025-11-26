<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Verifique o seu E-mail</title>
    <style>
        body { font-family: Arial, sans-serif; display: flex; justify-content: center; align-items: center; min-height: 100vh; background-color: #f4f7fc; text-align: center; }
        .container { background: #fff; padding: 40px; border-radius: 10px; box-shadow: 0 4px 12px rgba(0,0,0,0.1); width: 100%; max-width: 500px; }
        h1 { color: #002F4B; margin-bottom: 20px; }
        p { font-size: 1.2em; color: #555; line-height: 1.6; }
        .icon { font-size: 3em; color: #002F4B; margin-bottom: 20px; }
        /* Estilo para o novo botão de voltar */
        .btn-voltar {
            display: inline-block;
            margin-top: 30px;
            padding: 12px 25px;
            background-color: #6c757d;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            font-weight: bold;
            transition: background-color 0.3s ease;
        }
        .btn-voltar:hover {
            background-color: #5a6268;
        }
    </style>
    <!-- Para o ícone de e-mail -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body>
<div class="container">
    <div class="icon">
        <i class="fas fa-envelope-open-text"></i>
    </div>
    <h1>Quase lá!</h1>
    <p>Enviámos um link de verificação para o seu e-mail. Por favor, clique no link para ativar a sua conta antes de fazer o login.</p>

    <%-- BOTÃO ADICIONADO --%>
    <a href="telaLogin.jsp" class="btn-voltar">Voltar para o Login</a>
</div>
</body>
</html>

