package com.example.medisphere.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Logger;

public class DatabaseConfig {
    
    private static final Logger logger = Logger.getLogger(DatabaseConfig.class.getName());
    
    public static Connection getConnection() throws SQLException {
        try {
            Class.forName(DatabaseConstants.DRIVER_CLASS);
            logger.info("Connecting to MediSphere database");
            return DriverManager.getConnection(
                DatabaseConstants.DATABASE_URL,
                DatabaseConstants.DATABASE_USER,
                DatabaseConstants.DATABASE_PASSWORD
            );
        } catch (ClassNotFoundException e) {
            logger.severe("MySQL Driver not found: " + e.getMessage());
            throw new SQLException("Database driver not found", e);
        }
    }

    public static class DatabaseConstants {
        public static final String DRIVER_CLASS = "com.mysql.cj.jdbc.Driver";
        public static final String DATABASE_URL = "jdbc:mysql://localhost:3306/medisphere?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
        public static final String DATABASE_USER = "user";
        public static final String DATABASE_PASSWORD = "pass";
        public static final String JNDI_NAME = "jdbc/MediSphereDS";
        public static final String POOL_NAME = "MediSpherePool";
        public static final int MIN_POOL_SIZE = 5;
        public static final int MAX_POOL_SIZE = 20;
        public static final int CONNECTION_TIMEOUT = 30000; // 30 seconds
        public static final String VALIDATION_QUERY = "SELECT 1";
    }
}