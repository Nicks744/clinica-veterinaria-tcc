<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String token = request.getParameter("token");
    if (token == null || token.trim().isEmpty()) {
        out.println("<h1>Erro: Token inválido ou em falta.</h1>");
        return;
    }
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Redefinir Senha</title>
    <style>
        body { font-family: Arial, sans-serif; display: flex; justify-content: center; align-items: center; min-height: 100vh; background-color: #f4f7fc; }
        .container { background: #fff; padding: 40px; border-radius: 10px; box-shadow: 0 4px 12px rgba(0,0,0,0.1); width: 100%; max-width: 450px; }
        h1 { text-align: center; color: #002F4B; }
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; margin-bottom: 5px; }
        .form-group input { width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 5px; }
        .btn { width: 100%; padding: 12px; border: none; background-color: #002F4B; color: white; cursor: pointer; }
    </style>
</head>
<body>
<div class="container">
    <h1>Crie uma Nova Senha</h1>

    <form method="POST" action="${pageContext.request.contextPath}/redefinir-senha">
        <input type="hidden" name="token" value="<%= token %>">

        <div class="form-group">
            <label for="novaSenha">Nova Senha:</label>
            <input type="password" id="novaSenha" name="novaSenha" required>
        </div>
        <div class="form-group">
            <label for="confirmarNovaSenha">Confirmar Nova Senha:</label>
            <input type="password" id="confirmarNovaSenha" name="confirmarNovaSenha" required>
        </div>
        <button type="submit" class="btn">Redefinir Senha</button>
    </form>
</div>
</body>
</html>

