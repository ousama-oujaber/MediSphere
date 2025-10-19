package com.example.medisphere.config;

import com.example.medisphere.util.JPAUtil;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import java.sql.Driver;
import java.sql.DriverManager;
import java.sql.SQLException;
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
        
        
        try {
            var drivers = DriverManager.getDrivers();
            while (drivers.hasMoreElements()) {
                Driver driver = drivers.nextElement();
                try {
                    DriverManager.deregisterDriver(driver);
                    logger.info("Deregistered JDBC driver: " + driver);
                } catch (SQLException ex) {
                    logger.severe("Error deregistering JDBC driver " + driver + ": " + ex.getMessage());
                }
            }
        } catch (Exception ex) {
            logger.severe("Error while deregistering JDBC drivers: " + ex.getMessage());
        }

        
        try {
            Class<?> cleanupClass = Class.forName("com.mysql.cj.jdbc.AbandonedConnectionCleanupThread");
            var shutdownMethod = cleanupClass.getDeclaredMethod("checkedShutdown");
            shutdownMethod.invoke(null);
            logger.info("MySQL AbandonedConnectionCleanupThread stopped");
        } catch (ClassNotFoundException e) {
            
        } catch (Exception e) {
            logger.severe("Failed to stop MySQL AbandonedConnectionCleanupThread: " + e.getMessage());
        }

        logger.info("MediSphere application stopped");
    }
}
