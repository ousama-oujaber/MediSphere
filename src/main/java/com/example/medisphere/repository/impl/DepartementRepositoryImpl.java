package com.example.medisphere.repository.impl;

import com.example.medisphere.model.entity.Departement;
import com.example.medisphere.repository.interfaces.IDepartementRepository;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;

import java.util.List;
import java.util.Optional;

public class DepartementRepositoryImpl implements IDepartementRepository {

    private final EntityManagerFactory emf;

    public DepartementRepositoryImpl(EntityManagerFactory emf) {
        this.emf = emf;
    }

    @Override
    public Departement save(Departement departement) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(departement);
            em.getTransaction().commit();
            return departement;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Error saving departement: " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }

    @Override
    public Optional<Departement> findById(Long id) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Departement> query = em.createQuery(
                "SELECT d FROM Departement d LEFT JOIN FETCH d.docteurs WHERE d.idDepartement = :id", 
                Departement.class);
            query.setParameter("id", id);
            return Optional.ofNullable(query.getSingleResult());
        } catch (NoResultException e) {
            return Optional.empty();
        } finally {
            em.close();
        }
    }

    @Override
    public Optional<Departement> findByNom(String nom) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Departement> query = em.createQuery(
                "SELECT d FROM Departement d WHERE d.nom = :nom", Departement.class);
            query.setParameter("nom", nom);
            return Optional.ofNullable(query.getSingleResult());
        } catch (NoResultException e) {
            return Optional.empty();
        } finally {
            em.close();
        }
    }

    @Override
    public List<Departement> findAll() {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Departement> query = em.createQuery(
                "SELECT d FROM Departement d ORDER BY d.nom ASC", Departement.class);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public Departement update(Departement departement) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            Departement updated = em.merge(departement);
            em.getTransaction().commit();
            return updated;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Error updating departement: " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }

    @Override
    public boolean delete(Long id) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            Departement departement = em.find(Departement.class, id);
            if (departement != null) {
                em.remove(departement);
                em.getTransaction().commit();
                return true;
            }
            em.getTransaction().commit();
            return false;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Error deleting departement: " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }

    @Override
    public boolean existsByNom(String nom) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Long> query = em.createQuery(
                "SELECT COUNT(d) FROM Departement d WHERE d.nom = :nom", Long.class);
            query.setParameter("nom", nom);
            return query.getSingleResult() > 0;
        } finally {
            em.close();
        }
    }

    @Override
    public long count() {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Long> query = em.createQuery(
                "SELECT COUNT(d) FROM Departement d", Long.class);
            return query.getSingleResult();
        } finally {
            em.close();
        }
    }

    @Override
    public List<Departement> findDepartementsWithDocteurs() {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Departement> query = em.createQuery(
                "SELECT DISTINCT d FROM Departement d LEFT JOIN FETCH d.docteurs ORDER BY d.nom ASC", 
                Departement.class);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
}
