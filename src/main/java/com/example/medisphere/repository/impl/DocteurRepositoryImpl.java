package com.example.medisphere.repository.impl;

import com.example.medisphere.model.entity.Departement;
import com.example.medisphere.model.entity.Docteur;
import com.example.medisphere.repository.interfaces.IDocteurRepository;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.TypedQuery;

import java.util.List;
import java.util.Optional;

public class DocteurRepositoryImpl implements IDocteurRepository {

    private final EntityManagerFactory emf;

    public DocteurRepositoryImpl(EntityManagerFactory emf) {
        this.emf = emf;
    }

    @Override
    public List<Docteur> findAll() {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Docteur> query = em.createQuery(
                    "SELECT d FROM Docteur d " +
                    "JOIN FETCH d.personne p " +
                    "LEFT JOIN FETCH d.departement " +
                    "WHERE p.actif = true " +
                    "ORDER BY p.nom, p.prenom", 
                    Docteur.class);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public Optional<Docteur> findById(Long id) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Docteur> query = em.createQuery(
                    "SELECT d FROM Docteur d " +
                    "JOIN FETCH d.personne p " +
                    "LEFT JOIN FETCH d.departement " +
                    "WHERE d.idDocteur = :id AND p.actif = true", 
                    Docteur.class);
            query.setParameter("id", id);
            return query.getResultStream().findFirst();
        } finally {
            em.close();
        }
    }

    @Override
    public Optional<Docteur> findByEmail(String email) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Docteur> query = em.createQuery(
                    "SELECT d FROM Docteur d " +
                    "JOIN FETCH d.personne p " +
                    "WHERE p.email = :email AND p.actif = true", 
                    Docteur.class);
            query.setParameter("email", email);
            return query.getResultStream().findFirst();
        } finally {
            em.close();
        }
    }

    @Override
    public Docteur save(Docteur docteur) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(docteur);
            em.getTransaction().commit();
            return docteur;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Error saving doctor: " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }

    @Override
    public Docteur update(Docteur docteur) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            Docteur updated = em.merge(docteur);
            em.getTransaction().commit();
            return updated;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Error updating doctor: " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }

    @Override
    public boolean delete(Long id) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            
            
            Docteur docteur = em.find(Docteur.class, id);
            if (docteur != null && docteur.getPersonne() != null) {
                docteur.getPersonne().setActif(false);
                em.merge(docteur);
                em.getTransaction().commit();
                return true;
            }
            
            em.getTransaction().rollback();
            return false;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Error deleting doctor: " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }

    @Override
    public List<Docteur> findByDepartement(Departement departement) {
        return findByDepartementId(departement.getIdDepartement());
    }

    @Override
    public List<Docteur> findByDepartementId(Long departementId) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Docteur> query = em.createQuery(
                    "SELECT d FROM Docteur d " +
                    "JOIN FETCH d.personne p " +
                    "LEFT JOIN FETCH d.departement dept " +
                    "WHERE dept.idDepartement = :deptId AND p.actif = true " +
                    "ORDER BY p.nom, p.prenom", 
                    Docteur.class);
            query.setParameter("deptId", departementId);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public List<Docteur> findBySpecialite(String specialite) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Docteur> query = em.createQuery(
                    "SELECT d FROM Docteur d " +
                    "JOIN FETCH d.personne p " +
                    "LEFT JOIN FETCH d.departement " +
                    "WHERE d.specialite = :specialite AND p.actif = true " +
                    "ORDER BY p.nom, p.prenom", 
                    Docteur.class);
            query.setParameter("specialite", specialite);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public boolean existsByEmail(String email) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Long> query = em.createQuery(
                    "SELECT COUNT(d) FROM Docteur d " +
                    "JOIN d.personne p " +
                    "WHERE p.email = :email AND p.actif = true", 
                    Long.class);
            query.setParameter("email", email);
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
                    "SELECT COUNT(d) FROM Docteur d " +
                    "JOIN d.personne p " +
                    "WHERE p.actif = true", 
                    Long.class);
            return query.getSingleResult();
        } finally {
            em.close();
        }
    }
}
