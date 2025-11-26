<%@ page contentType="text/html; charset=UTF-8" isErrorPage="true" %>
<%@ page import="java.io.PrintWriter, java.io.StringWriter" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Ocorreu um Erro</title>
    <style>
        body { font-family: Arial, sans-serif; padding: 20px; background-color: #f4f4f4; }
        .container { background: #fff; padding: 30px; border-radius: 10px; box-shadow: 0 4px 12px rgba(0,0,0,0.1); max-width: 800px; margin: auto; }
        h1 { color: #d9534f; }
        pre { background-color: #f9f9f9; border: 1px solid #ddd; padding: 15px; white-space: pre-wrap; word-wrap: break-word; }
    </style>
</head>
<body>
<div class="container">
    <h1>Ocorreu um Erro Inesperado</h1>
    <p>A operação não pôde ser concluída. Por favor, contacte o suporte técnico com a seguinte informação:</p>

    <h3>Mensagem de Erro:</h3>
    <p><strong><%= exception.getMessage() %></strong></p>

    <h3>Detalhes Técnicos:</h3>
    <pre><%
        // Imprime a stack trace completa para depuração
        StringWriter sw = new StringWriter();
        exception.printStackTrace(new PrintWriter(sw));
        out.print(sw.toString());
    %></pre>
</div>
</body>
</html>
