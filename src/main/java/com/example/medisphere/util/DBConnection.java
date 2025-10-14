package com.example.medisphere.util;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import java.lang.Exception;

public class DBConnection {
    public static void main(String[] args) {

        System.out.println("Connecting to db...");
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("MediSpherePU");
        EntityManager em = emf.createEntityManager();

        try {
            System.out.println("test to connect to db");
            em.getTransaction().begin();

            Long count = em.createQuery(
                    "SELECT COUNT (d) FROM Departement d", Long.class
            ).getSingleResult();


            System.out.println("connected to db");
            System.out.println("Count: " + count);

            System.out.println("all tables migrate successfully");
            em.getTransaction().commit();
            em.close();
        }catch(Exception e) {
            System.err.println("\nEroor");
            System.err.println("   " + e.getMessage());
            e.printStackTrace();

            if (em != null && em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }

            System.exit(1);
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
            if (emf != null && emf.isOpen()) {
                emf.close();
            }
        }
    }
}
