package com.petvida.paymentapi.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;

@RestController
@RequestMapping("/api/debug")
@CrossOrigin(origins = "*")
public class DatabaseDebugController {

    @Autowired
    private DataSource dataSource;

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @GetMapping("/database")
    public ResponseEntity<?> checkDatabase() {
        try {
            Connection connection = dataSource.getConnection();
            DatabaseMetaData metaData = connection.getMetaData();

            Map<String, Object> result = new HashMap<>();
            result.put("databaseUrl", metaData.getURL());
            result.put("databaseName", connection.getCatalog());
            result.put("driverName", metaData.getDriverName());
            result.put("databaseVersion", metaData.getDatabaseProductVersion());
            result.put("usingAzure", metaData.getURL().contains("database.azure.com"));
            result.put("usingH2", metaData.getURL().contains("h2"));
            result.put("usingMySQL", metaData.getURL().contains("mysql"));
            result.put("connectionIsValid", connection.isValid(5));

            // Listar tabelas existentes
            ResultSet tables = metaData.getTables(null, null, "%", new String[]{"TABLE"});
            List<String> tableList = new ArrayList<>();
            while (tables.next()) {
                tableList.add(tables.getString("TABLE_NAME"));
            }
            result.put("tables", tableList);
            result.put("totalTables", tableList.size());

            connection.close();

            return ResponseEntity.ok(result);

        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of(
                    "error", "Falha ao conectar com o banco: " + e.getMessage(),
                    "usingAzure", false
            ));
        }
    }

    @GetMapping("/health")
    public ResponseEntity<?> healthCheck() {
        try {
            // Testar conexão com o banco
            Connection connection = dataSource.getConnection();
            boolean isValid = connection.isValid(5);
            String url = connection.getMetaData().getURL();
            connection.close();

            Map<String, Object> health = new HashMap<>();
            health.put("status", isValid ? "UP" : "DOWN");
            health.put("database", "Azure MySQL");
            health.put("connected", isValid);
            health.put("url", url);
            health.put("timestamp", new Date());

            return ResponseEntity.ok(health);

        } catch (Exception e) {
            return ResponseEntity.status(503).body(Map.of(
                    "status", "DOWN",
                    "error", e.getMessage(),
                    "database", "Azure MySQL",
                    "timestamp", new Date()
            ));
        }
    }

    @GetMapping("/tables")
    public ResponseEntity<?> listTables() {
        try {
            List<String> tables = jdbcTemplate.queryForList(
                    "SHOW TABLES", String.class
            );

            return ResponseEntity.ok(Map.of(
                    "success", true,
                    "tables", tables,
                    "count", tables.size()
            ));

        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "error", e.getMessage()
            ));
        }
    }

    @GetMapping("/test-insert")
    public ResponseEntity<?> testInsert() {
        try {
            // Criar tabela de teste se não existir
            jdbcTemplate.execute(
                    "CREATE TABLE IF NOT EXISTS test_table (" +
                            "id INT AUTO_INCREMENT PRIMARY KEY, " +
                            "name VARCHAR(255), " +
                            "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)"
            );

            // Inserir dados de teste
            int affectedRows = jdbcTemplate.update(
                    "INSERT INTO test_table (name) VALUES (?)",
                    "Teste Azure - " + new Date()
            );

            // Ler dados inseridos
            List<Map<String, Object>> results = jdbcTemplate.queryForList(
                    "SELECT * FROM test_table ORDER BY created_at DESC LIMIT 5"
            );

            return ResponseEntity.ok(Map.of(
                    "success", true,
                    "inserted", affectedRows,
                    "testData", results,
                    "message", "Dados inseridos com sucesso no Azure MySQL"
            ));

        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "error", e.getMessage()
            ));
        }
    }

    @GetMapping("/users-count")
    public ResponseEntity<?> countUsers() {
        try {
            // Verificar se tabela usuario existe e contar registros
            Integer count = jdbcTemplate.queryForObject(
                    "SELECT COUNT(*) FROM usuario", Integer.class
            );

            return ResponseEntity.ok(Map.of(
                    "success", true,
                    "tableExists", true,
                    "userCount", count
            ));

        } catch (Exception e) {
            return ResponseEntity.ok(Map.of(
                    "success", false,
                    "tableExists", false,
                    "error", "Tabela usuario não existe: " + e.getMessage()
            ));
        }
    }

    @GetMapping("/check-entities")
    public ResponseEntity<?> checkEntities() {
        try {
            Map<String, Object> result = new HashMap<>();

            // Verificar tabelas JPA esperadas
            String[] expectedTables = {"usuario", "pagamento", "agendamento", "pet"};
            List<String> missingTables = new ArrayList<>();

            List<String> existingTables = jdbcTemplate.queryForList("SHOW TABLES", String.class);
            result.put("existingTables", existingTables);

            for (String table : expectedTables) {
                if (!existingTables.contains(table)) {
                    missingTables.add(table);
                }
            }
            result.put("missingTables", missingTables);
            result.put("allEntitiesExist", missingTables.isEmpty());
            result.put("expectedTables", Arrays.asList(expectedTables));

            return ResponseEntity.ok(result);

        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of(
                    "error", "Falha ao verificar entidades: " + e.getMessage()
            ));
        }
    }

    @GetMapping("/check-repositories")
    public ResponseEntity<?> checkRepositories() {
        try {
            Map<String, Object> result = new HashMap<>();

            // Verificar se repositórios estão funcionando
            List<String> repositoryTests = new ArrayList<>();

            try {
                jdbcTemplate.queryForObject("SELECT 1 FROM usuario LIMIT 1", Integer.class);
                repositoryTests.add("✅ UsuarioRepository - OK");
            } catch (Exception e) {
                repositoryTests.add("❌ UsuarioRepository - Falha: " + e.getMessage());
            }

            try {
                jdbcTemplate.queryForObject("SELECT 1 FROM pagamento LIMIT 1", Integer.class);
                repositoryTests.add("✅ PagamentoRepository - OK");
            } catch (Exception e) {
                repositoryTests.add("❌ PagamentoRepository - Falha: " + e.getMessage());
            }

            try {
                jdbcTemplate.queryForObject("SELECT 1 FROM agendamento LIMIT 1", Integer.class);
                repositoryTests.add("✅ AgendamentoRepository - OK");
            } catch (Exception e) {
                repositoryTests.add("❌ AgendamentoRepository - Falha: " + e.getMessage());
            }

            result.put("repositoryTests", repositoryTests);
            result.put("allRepositoriesWorking", !repositoryTests.stream().anyMatch(test -> test.startsWith("❌")));

            return ResponseEntity.ok(result);

        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of(
                    "error", "Falha ao verificar repositórios: " + e.getMessage()
            ));
        }
    }

    @GetMapping("/test-registration-flow")
    public ResponseEntity<?> testRegistrationFlow() {
        try {
            Map<String, Object> result = new HashMap<>();
            List<String> steps = new ArrayList<>();

            // 1. Verificar tabela usuario
            try {
                jdbcTemplate.execute("SELECT 1 FROM usuario");
                steps.add("✅ Tabela usuario existe");
            } catch (Exception e) {
                steps.add("❌ Tabela usuario não existe: " + e.getMessage());
                result.put("steps", steps);
                return ResponseEntity.badRequest().body(result);
            }

            // 2. Testar inserção manual
            try {
                int inserted = jdbcTemplate.update(
                        "INSERT INTO usuario (nome, email, senha, cpf, celular, status, plano) VALUES (?, ?, ?, ?, ?, ?, ?)",
                        "Teste Manual", "teste@email.com", "senha123", "111.222.333-44", "(11) 99999-8888", "ATIVO", "BASICO"
                );
                steps.add("✅ Inserção manual funcionou - " + inserted + " registros");
            } catch (Exception e) {
                steps.add("❌ Inserção manual falhou: " + e.getMessage());
            }

            // 3. Contar usuários
            try {
                Integer count = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM usuario", Integer.class);
                steps.add("✅ Contagem de usuários: " + count);
            } catch (Exception e) {
                steps.add("❌ Falha na contagem: " + e.getMessage());
            }

            result.put("steps", steps);
            result.put("registrationFlowWorking", steps.stream().allMatch(step -> step.startsWith("✅")));

            return ResponseEntity.ok(result);

        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of(
                    "error", "Falha no teste de fluxo de registro: " + e.getMessage()
            ));
        }
    }
}