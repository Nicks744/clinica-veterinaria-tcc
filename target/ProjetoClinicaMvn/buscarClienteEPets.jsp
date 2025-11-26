<%@ page contentType="application/json; charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.util.*" %>
<%@ page import="com.google.gson.Gson" %>
<%
    String cpf = request.getParameter("cpf");

    Map<String, Object> responseData = new HashMap<>();
    boolean clienteEncontrado = false;
    String nomeTutor = "";
    List<Map<String, String>> pets = new ArrayList<>();

       String url = System.getenv("DB_URL");
    String usuario = System.getenv("DB_USERNAME");
    String senhaBD = System.getenv("DB_PASSWORD");

    if (cpf != null && !cpf.trim().isEmpty()) {
        try (Connection conexao = DriverManager.getConnection(url, usuario, senhaBD)) {
            
            // ===== CORREÇÃO PRINCIPAL AQUI =====
            // A função REPLACE remove os pontos e o traço da coluna CPF antes de comparar.
            String sqlTutor = "SELECT nome FROM usuarios WHERE REPLACE(REPLACE(cpf, '.', ''), '-', '') = ?";
            
            try (PreparedStatement stmtTutor = conexao.prepareStatement(sqlTutor)) {
                stmtTutor.setString(1, cpf); // O CPF aqui já vem sem formatação do JavaScript
                ResultSet rsTutor = stmtTutor.executeQuery();
                if (rsTutor.next()) {
                    clienteEncontrado = true;
                    nomeTutor = rsTutor.getString("nome");
                }
            }

            if (clienteEncontrado) {
                // A busca de pets usa o CPF original (com formatação) que está no banco
                // Primeiro, precisamos buscar o CPF formatado para usar na próxima consulta
                String cpfFormatadoNoBanco = "";
                String sqlGetCpf = "SELECT cpf FROM usuarios WHERE REPLACE(REPLACE(cpf, '.', ''), '-', '') = ?";
                 try (PreparedStatement stmtGetCpf = conexao.prepareStatement(sqlGetCpf)) {
                    stmtGetCpf.setString(1, cpf);
                    ResultSet rsCpf = stmtGetCpf.executeQuery();
                    if(rsCpf.next()){
                        cpfFormatadoNoBanco = rsCpf.getString("cpf");
                    }
                }

                // Agora busca os pets usando o CPF formatado
                String sqlPets = "SELECT id, nome FROM animais WHERE cpf = ?";
                try (PreparedStatement stmtPets = conexao.prepareStatement(sqlPets)) {
                    stmtPets.setString(1, cpfFormatadoNoBanco);
                    ResultSet rsPets = stmtPets.executeQuery();
                    while (rsPets.next()) {
                        Map<String, String> pet = new HashMap<>();
                        pet.put("id", rsPets.getString("id"));
                        pet.put("nome", rsPets.getString("nome"));
                        pets.add(pet);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Monta a resposta JSON
    responseData.put("clienteEncontrado", clienteEncontrado);
    responseData.put("nomeTutor", nomeTutor);
    responseData.put("pets", pets);

    // Converte e envia a resposta
    out.print(new Gson().toJson(responseData));
    out.flush();
%>