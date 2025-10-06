package com.example.medisphere.config;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import java.util.logging.Logger;

public class JPAConfig {
    
    private static final Logger logger = Logger.getLogger(JPAConfig.class.getName());
    private static EntityManagerFactory entityManagerFactory;
    
    static {
        try {
            entityManagerFactory = Persistence.createEntityManagerFactory("MediSpherePU");
            logger.info("EntityManagerFactory created successfully for MediSphere application");
        } catch (Exception e) {
            logger.severe("Failed to create EntityManagerFactory: " + e.getMessage());
            throw new RuntimeException("Failed to initialize JPA", e);
        }
    }
    
    public static EntityManager getEntityManager() {
        return entityManagerFactory.createEntityManager();
    }
    
    public static EntityManagerFactory getEntityManagerFactory() {
        return entityManagerFactory;
    }
    
    public static void close() {
        if (entityManagerFactory != null && entityManagerFactory.isOpen()) {
            entityManagerFactory.close();
            logger.info("EntityManagerFactory closed");
        }
    }

    public static class JPAConstants {
        public static final String PERSISTENCE_UNIT_NAME = "MediSpherePU";
        public static final String DIALECT = "org.hibernate.dialect.MySQLDialect";
        public static final String DRIVER_CLASS = "com.mysql.cj.jdbc.Driver";
        public static final String DATABASE_URL = "jdbc:mysql://localhost:3306/medisphere";
        public static final String DATABASE_USER = "user";
        public static final String DATABASE_PASSWORD = "pass";
        public static final boolean SHOW_SQL = true;
        public static final boolean FORMAT_SQL = true;
        public static final String HBM2DDL_AUTO = "update";
        public static final String NAMING_STRATEGY = "org.hibernate.boot.model.naming.CamelCaseToUnderscoresNamingStrategy";
    }
}