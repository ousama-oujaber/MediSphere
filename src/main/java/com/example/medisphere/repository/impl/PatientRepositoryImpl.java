package com.example.medisphere.repository.impl;

import com.example.medisphere.model.entity.Patient;
import com.example.medisphere.repository.interfaces.IPatientRepository;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;
import java.util.List;
import java.util.Optional;

public class PatientRepositoryImpl implements IPatientRepository {
    
    private final EntityManagerFactory emf;
    
    public PatientRepositoryImpl(EntityManagerFactory emf) {
        this.emf = emf;
    }
    
    @Override
    public Patient save(Patient patient) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(patient);
            em.getTransaction().commit();
            return patient;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Erreur lors de la création du patient", e);
        } finally {
            em.close();
        }
    }
    
    @Override
    public Optional<Patient> findById(Long id) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Patient> query = em.createQuery(
                "SELECT p FROM Patient p LEFT JOIN FETCH p.personne WHERE p.idPatient = :id",
                Patient.class
            );
            query.setParameter("id", id);
            try {
                return Optional.of(query.getSingleResult());
            } catch (NoResultException e) {
                return Optional.empty();
            }
        } finally {
            em.close();
        }
    }
    
    @Override
    public Optional<Patient> findByEmail(String email) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Patient> query = em.createQuery(
                "SELECT p FROM Patient p LEFT JOIN FETCH p.personne per WHERE per.email = :email",
                Patient.class
            );
            query.setParameter("email", email);
            try {
                return Optional.of(query.getSingleResult());
            } catch (NoResultException e) {
                return Optional.empty();
            }
        } finally {
            em.close();
        }
    }
    
    @Override
    public Optional<Patient> findByNumeroDossier(String numeroDossier) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Patient> query = em.createQuery(
                "SELECT p FROM Patient p LEFT JOIN FETCH p.personne WHERE p.numeroDossier = :numeroDossier",
                Patient.class
            );
            query.setParameter("numeroDossier", numeroDossier);
            try {
                return Optional.of(query.getSingleResult());
            } catch (NoResultException e) {
                return Optional.empty();
            }
        } finally {
            em.close();
        }
    }
    
    @Override
    public List<Patient> findAll() {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Patient> query = em.createQuery(
                "SELECT p FROM Patient p LEFT JOIN FETCH p.personne ORDER BY p.personne.nom, p.personne.prenom",
                Patient.class
            );
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    @Override
    public List<Patient> searchByKeyword(String keyword) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Patient> query = em.createQuery(
                "SELECT p FROM Patient p LEFT JOIN FETCH p.personne per " +
                "WHERE LOWER(per.nom) LIKE LOWER(:keyword) " +
                "OR LOWER(per.prenom) LIKE LOWER(:keyword) " +
                "OR LOWER(per.email) LIKE LOWER(:keyword) " +
                "OR LOWER(p.numeroDossier) LIKE LOWER(:keyword) " +
                "ORDER BY per.nom, per.prenom",
                Patient.class
            );
            query.setParameter("keyword", "%" + keyword + "%");
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    @Override
    public List<Patient> findByGroupeSanguin(String groupeSanguin) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Patient> query = em.createQuery(
                "SELECT p FROM Patient p LEFT JOIN FETCH p.personne WHERE p.groupeSanguin = :groupeSanguin " +
                "ORDER BY p.personne.nom, p.personne.prenom",
                Patient.class
            );
            query.setParameter("groupeSanguin", groupeSanguin);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    @Override
    public boolean delete(Long id) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            Patient patient = em.find(Patient.class, id);
            if (patient != null) {
                em.remove(patient);
                em.getTransaction().commit();
                return true;
            }
            em.getTransaction().commit();
            return false;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Erreur lors de la suppression du patient", e);
        } finally {
            em.close();
        }
    }
    
    @Override
    public boolean existsByEmail(String email) {
        return existsByEmail(email, null);
    }
    
    @Override
    public boolean existsByEmail(String email, Long excludeId) {
        EntityManager em = emf.createEntityManager();
        try {
            String jpql = "SELECT COUNT(p) FROM Patient p WHERE p.personne.email = :email";
            if (excludeId != null) {
                jpql += " AND p.idPatient != :excludeId";
            }
            
            TypedQuery<Long> query = em.createQuery(jpql, Long.class);
            query.setParameter("email", email);
            if (excludeId != null) {
                query.setParameter("excludeId", excludeId);
            }
            
            return query.getSingleResult() > 0;
        } finally {
            em.close();
        }
    }
    
    @Override
    public boolean existsByNumeroDossier(String numeroDossier, Long excludeId) {
        EntityManager em = emf.createEntityManager();
        try {
            String jpql = "SELECT COUNT(p) FROM Patient p WHERE p.numeroDossier = :numeroDossier";
            if (excludeId != null) {
                jpql += " AND p.idPatient != :excludeId";
            }
            
            TypedQuery<Long> query = em.createQuery(jpql, Long.class);
            query.setParameter("numeroDossier", numeroDossier);
            if (excludeId != null) {
                query.setParameter("excludeId", excludeId);
            }
            
            return query.getSingleResult() > 0;
        } finally {
            em.close();
        }
    }
    
    @Override
    public long count() {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Long> query = em.createQuery("SELECT COUNT(p) FROM Patient p", Long.class);
            return query.getSingleResult();
        } finally {
            em.close();
        }
    }
    
    @Override
    public Patient update(Patient patient) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            Patient updated = em.merge(patient);
            em.getTransaction().commit();
            return updated;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Erreur lors de la mise à jour du patient", e);
        } finally {
            em.close();
        }
    }
}

