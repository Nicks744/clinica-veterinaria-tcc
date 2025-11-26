package br.com.clinica.util;

import jakarta.persistence.EntityManager;      // <-- MUDANÇA CRÍTICA
import jakarta.persistence.EntityManagerFactory; // <-- MUDANÇA CRÍTICA
import jakarta.persistence.Persistence;          // <-- MUDANÇA CRÍTICA
import java.util.HashMap;
import java.util.Map;

public class JPAUtil {

    private static EntityManagerFactory FACTORY;

    static {
        Map<String, String> properties = new HashMap<>();

        String dbUrl = System.getenv("DB_URL");
        String dbUser = System.getenv("DB_USERNAME");
        String dbPassword = System.getenv("DB_PASSWORD");

        // As chaves das propriedades também mudam de "javax" para "jakarta"
        properties.put("jakarta.persistence.jdbc.url", dbUrl);         // <-- MUDANÇA CRÍTICA
        properties.put("jakarta.persistence.jdbc.user", dbUser);       // <-- MUDANÇA CRÍTICA
        properties.put("jakarta.persistence.jdbc.password", dbPassword); // <-- MUDANÇA CRÍTICA
        properties.put("jakarta.persistence.jdbc.driver", "com.mysql.cj.jdbc.Driver");

        properties.put("hibernate.dialect", "org.hibernate.dialect.MySQLDialect");
        properties.put("hibernate.hbm2ddl.auto", "update");
        properties.put("hibernate.show_sql", "true");

        FACTORY = Persistence.createEntityManagerFactory("clinica-vet-pu", properties);
    }

    public static EntityManager getEntityManager() {
        return FACTORY.createEntityManager();
    }
}

