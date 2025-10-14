package com.example.medisphere.util;

import jakarta.persistence.EntityManager;
import java.util.function.Consumer;
import java.util.function.Function;

public final class TransactionUtil {
    
    private TransactionUtil() {
        throw new UnsupportedOperationException("Utility class cannot be instantiated");
    }
    
    public static void executeInTransaction(Consumer<EntityManager> action) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            action.accept(em);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Transaction failed: " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }
    
    public static <T> T executeInTransactionWithResult(Function<EntityManager, T> function) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            T result = function.apply(em);
            em.getTransaction().commit();
            return result;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Transaction failed: " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }
    
    public static <T> T executeReadOnly(Function<EntityManager, T> function) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return function.apply(em);
        } catch (Exception e) {
            throw new RuntimeException("Read operation failed: " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }
}
