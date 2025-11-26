<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Conta Ativada com Sucesso!</title>
    <style>
        body { font-family: Arial, sans-serif; display: flex; justify-content: center; align-items: center; min-height: 100vh; background-color: #f4f7fc; text-align: center; }
        .container { background: #fff; padding: 40px; border-radius: 10px; box-shadow: 0 4px 12px rgba(0,0,0,0.1); width: 100%; max-width: 500px; }
        h1 { color: #28a745; margin-bottom: 20px; }
        p { font-size: 1.2em; color: #555; line-height: 1.6; }
        .icon { font-size: 3em; color: #28a745; margin-bottom: 20px; }
        .btn-login {
            display: inline-block;
            margin-top: 30px;
            padding: 12px 25px;
            background-color: #002F4B;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            font-weight: bold;
            transition: background-color 0.3s ease;
        }
        .btn-login:hover {
            background-color: #004d7c;
        }
    </style>
    <!-- Para o ícone -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body>
<div class="container">
    <div class="icon">
        <i class="fas fa-check-circle"></i>
    </div>
    <h1>Conta Ativada!</h1>
    <p>A sua conta foi verificada com sucesso. Agora você já pode fazer o login.</p>
    <a href="telaLogin.jsp" class="btn-login">Ir para a Página de Login</a>
</div>
</body>
</html>

