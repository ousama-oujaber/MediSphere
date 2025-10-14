package com.example.medisphere.config;

import com.example.medisphere.util.JPAUtil;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import java.util.logging.Logger;


@WebListener
public class AppContextListener implements ServletContextListener {
    
    private static final Logger logger = Logger.getLogger(AppContextListener.class.getName());
    
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        logger.info("MediSphere application starting...");
        logger.info("JPA EntityManagerFactory initialized via JPAUtil");
    }
    
    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        logger.info("MediSphere application shutting down...");
        
        try {
            JPAUtil.shutdown();
            logger.info("JPA resources closed successfully");
        } catch (Exception e) {
            logger.severe("Error closing JPA resources: " + e.getMessage());
        }
        
        logger.info("MediSphere application stopped");
    }
}
