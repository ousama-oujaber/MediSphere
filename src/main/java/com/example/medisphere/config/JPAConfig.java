package com.example.medisphere.config;

import javax.enterprise.context.ApplicationScoped;
import javax.enterprise.inject.Produces;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.EntityManagerFactory;
import javax.persistence.PersistenceUnit;
import java.util.logging.Logger;

@ApplicationScoped
public class JPAConfig {
    
    private static final Logger logger = Logger.getLogger(JPAConfig.class.getName());
    
    @PersistenceContext(unitName = "MediSpherePU")
    private EntityManager entityManager;
    
    @PersistenceUnit(unitName = "MediSpherePU")
    private EntityManagerFactory entityManagerFactory;

    @Produces
    @ApplicationScoped
    public EntityManager getEntityManager() {
        logger.info("Providing EntityManager for MediSphere application");
        return entityManager;
    }

    @Produces
    @ApplicationScoped
    public EntityManagerFactory getEntityManagerFactory() {
        logger.info("Providing EntityManagerFactory for MediSphere application");
        return entityManagerFactory;
    }

    public static class JPAConstants {
        public static final String PERSISTENCE_UNIT_NAME = "MediSpherePU";
        public static final String DIALECT = "org.hibernate.dialect.PostgreSQLDialect";
        public static final String DRIVER_CLASS = "org.postgresql.Driver";
        public static final boolean SHOW_SQL = true;
        public static final boolean FORMAT_SQL = true;
        public static final String HBM2DDL_AUTO = "update";
        public static final String NAMING_STRATEGY = "org.hibernate.cfg.ImprovedNamingStrategy";
    }
}