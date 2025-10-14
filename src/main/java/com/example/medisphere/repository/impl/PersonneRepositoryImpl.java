package com.example.medisphere.repository.impl;

import com.example.medisphere.model.entity.Personne;
import com.example.medisphere.model.enums.RoleUtilisateur;
import com.example.medisphere.repository.interfaces.IPersonneRepository;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;

import java.util.Optional;


public class PersonneRepositoryImpl implements IPersonneRepository {

    private final EntityManagerFactory entityManagerFactory;

    public PersonneRepositoryImpl(EntityManagerFactory entityManagerFactory) {
        this.entityManagerFactory = entityManagerFactory;
    }

    @Override
    public Optional<Personne> findByEmail(String email) {
        EntityManager em = entityManagerFactory.createEntityManager();
        try {
            TypedQuery<Personne> query = em.createQuery(
                "SELECT p FROM Personne p WHERE p.email = :email AND p.actif = true",
                Personne.class
            );
            query.setParameter("email", email);
            return Optional.ofNullable(query.getSingleResult());
        } catch (NoResultException e) {
            return Optional.empty();
        } finally {
            em.close();
        }
    }

    @Override
    public Optional<Personne> findById(Long id) {
        EntityManager em = entityManagerFactory.createEntityManager();
        try {
            Personne personne = em.find(Personne.class, id);
            return Optional.ofNullable(personne);
        } finally {
            em.close();
        }
    }

    @Override
    public Personne save(Personne personne) {
        EntityManager em = entityManagerFactory.createEntityManager();
        try {
            em.getTransaction().begin();
            if (personne.getIdPersonne() == null) {
                em.persist(personne);
            } else {
                personne = em.merge(personne);
            }
            em.getTransaction().commit();
            return personne;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Error saving personne: " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }

    @Override
    public boolean existsByEmail(String email) {
        EntityManager em = entityManagerFactory.createEntityManager();
        try {
            Long count = em.createQuery(
                "SELECT COUNT(p) FROM Personne p WHERE p.email = :email",
                Long.class
            ).setParameter("email", email).getSingleResult();
            return count > 0;
        } finally {
            em.close();
        }
    }

    @Override
    public Optional<Personne> findByEmailAndType(String email, RoleUtilisateur type) {
        EntityManager em = entityManagerFactory.createEntityManager();
        try {
            TypedQuery<Personne> query = em.createQuery(
                "SELECT p FROM Personne p WHERE p.email = :email AND p.typePersonne = :type AND p.actif = true",
                Personne.class
            );
            query.setParameter("email", email);
            query.setParameter("type", type);
            return Optional.ofNullable(query.getSingleResult());
        } catch (NoResultException e) {
            return Optional.empty();
        } finally {
            em.close();
        }
    }
}
