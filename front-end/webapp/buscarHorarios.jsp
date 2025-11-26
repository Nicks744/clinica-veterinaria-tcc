<%@ page contentType="application/json; charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.util.*, java.time.LocalDate" %>
<%
    // PASSO 1: Define todos os horários de atendimento possíveis
    List<String> todosHorarios = new ArrayList<>(Arrays.asList(
        "08:00", "09:00", "10:00", "11:00", "12:00", "13:00",
        "14:00", "15:00", "16:00", "17:00", "18:00", "19:00"
    ));

    // PASSO 2: Pega a data que o usuário selecionou no formulário
    String dataSelecionada = request.getParameter("data");
    
    // Cria a lista que será retornada
    List<String> horariosDisponiveis = new ArrayList<>();

    if (dataSelecionada != null && !dataSelecionada.trim().isEmpty()) {
        Connection conexao = null;
        try {
            // PASSO 3: Conexão com o banco de dados.
            // AQUI ESTÁ A MUDANÇA: AGORA USAMOS VARIÁVEIS DE AMBIENTE.
            String url = System.getenv("DB_URL");
            String usuario = System.getenv("DB_USERNAME");
            String senhaBD = System.getenv("DB_PASSWORD");
            
            Class.forName("com.mysql.cj.jdbc.Driver");
            conexao = DriverManager.getConnection(url, usuario, senhaBD);

            // PASSO 4: Busca no banco os horários JÁ OCUPADOS para a data selecionada
            List<String> horariosOcupados = new ArrayList<>();
            String sql = "SELECT DATE_FORMAT(data_consulta, '%H:%i') as horario_formatado " +
                         "FROM dadosconsulta " +
                         "WHERE data_consulta >= ? AND data_consulta < ?";
            
            PreparedStatement stmt = conexao.prepareStatement(sql);
            
            // Define o início e o fim do dia para a consulta
            stmt.setString(1, dataSelecionada + " 00:00:00");
            LocalDate proximoDia = LocalDate.parse(dataSelecionada).plusDays(1);
            stmt.setString(2, proximoDia.toString() + " 00:00:00");
            
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                horariosOcupados.add(rs.getString("horario_formatado"));
            }

            // PASSO 5: Compara a lista de todos os horários com a lista de ocupados
            // e adiciona apenas os que sobraram (os disponíveis)
            for (String horario : todosHorarios) {
                if (!horariosOcupados.contains(horario)) {
                    horariosDisponiveis.add(horario);
                }
            }

        } catch (Exception e) {
            // Se der qualquer erro, o console do servidor (Tomcat) mostrará os detalhes
            e.printStackTrace(); 
        } finally {
            if (conexao != null) try { conexao.close(); } catch (SQLException e) {}
        }
    }

    // PASSO 6: Converte a lista de horários disponíveis para o formato JSON
    // Exemplo de saída: ["09:00", "11:00", "14:00"]
    if (horariosDisponiveis.isEmpty()) {
        out.print("[]");
    } else {
        out.print("[\"" + String.join("\",\"", horariosDisponiveis) + "\"]");
    }
    out.flush();
%>
