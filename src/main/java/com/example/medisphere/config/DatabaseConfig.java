package com.example.medisphere.config;

import javax.sql.DataSource;
import javax.enterprise.context.ApplicationScoped;
import javax.enterprise.inject.Produces;
import javax.annotation.Resource;
import java.util.logging.Logger;


@ApplicationScoped
public class DatabaseConfig {
    
    private static final Logger logger = Logger.getLogger(DatabaseConfig.class.getName());
    
    @Resource(lookup = "jdbc/MediSphereDS")
    private DataSource dataSource;

    @Produces
    @ApplicationScoped
    public DataSource getDataSource() {
        logger.info("Configuring MediSphere database connection");
        return dataSource;
    }

    public static class DatabaseConstants {
        public static final String JNDI_NAME = "jdbc/MediSphereDS";
        public static final String POOL_NAME = "MediSpherePool";
        public static final int MIN_POOL_SIZE = 5;
        public static final int MAX_POOL_SIZE = 20;
        public static final int CONNECTION_TIMEOUT = 30000; // 30 seconds
        public static final String VALIDATION_QUERY = "SELECT 1";
    }
}