package com.example.medisphere.util;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import java.util.logging.Logger;

public class JPAUtil {
    
    private static final Logger logger = Logger.getLogger(JPAUtil.class.getName());
    private static EntityManagerFactory entityManagerFactory;
    
    static {
        try {
            entityManagerFactory = Persistence.createEntityManagerFactory("MediSpherePU");
            logger.info("JPA EntityManagerFactory initialized successfully");
        } catch (Exception e) {
            logger.severe("Failed to initialize JPA EntityManagerFactory: " + e.getMessage());
            throw new ExceptionInInitializerError(e);
        }
    }
    
    private JPAUtil() {
        throw new UnsupportedOperationException("Utility class cannot be instantiated");
    }
    
    public static EntityManager getEntityManager() {
        return entityManagerFactory.createEntityManager();
    }
    
    public static EntityManagerFactory getEntityManagerFactory() {
        return entityManagerFactory;
    }
    
    public static void shutdown() {
        if (entityManagerFactory != null && entityManagerFactory.isOpen()) {
            entityManagerFactory.close();
            logger.info("JPA EntityManagerFactory closed");
        }
    }
}
