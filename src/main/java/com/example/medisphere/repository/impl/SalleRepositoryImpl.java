package com.example.medisphere.repository.impl;

import com.example.medisphere.model.entity.Salle;
import com.example.medisphere.repository.interfaces.ISalleRepository;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.TypedQuery;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public class SalleRepositoryImpl implements ISalleRepository {

    private final EntityManagerFactory emf;

    public SalleRepositoryImpl(EntityManagerFactory emf) {
        this.emf = emf;
    }

    @Override
    public List<Salle> findAll() {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Salle> query = em.createQuery(
                "SELECT s FROM Salle s ORDER BY s.nomSalle", Salle.class);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public Optional<Salle> findById(Long id) {
        EntityManager em = emf.createEntityManager();
        try {
            Salle salle = em.find(Salle.class, id);
            return Optional.ofNullable(salle);
        } finally {
            em.close();
        }
    }

    @Override
    public Optional<Salle> findByNomSalle(String nomSalle) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Salle> query = em.createQuery(
                "SELECT s FROM Salle s WHERE s.nomSalle = :nomSalle", Salle.class);
            query.setParameter("nomSalle", nomSalle);
            return query.getResultStream().findFirst();
        } finally {
            em.close();
        }
    }

    @Override
    public Salle save(Salle salle) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(salle);
            em.getTransaction().commit();
            return salle;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Error saving room: " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }

    @Override
    public Salle update(Salle salle) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            Salle updated = em.merge(salle);
            em.getTransaction().commit();
            return updated;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Error updating room: " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }

    @Override
    public boolean delete(Long id) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            Salle salle = em.find(Salle.class, id);
            if (salle != null) {
                em.remove(salle);
                em.getTransaction().commit();
                return true;
            }
            em.getTransaction().commit();
            return false;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Error deleting room: " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }

    @Override
    public List<Salle> findAvailableRooms(LocalDateTime dateHeure) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Salle> query = em.createQuery(
                "SELECT s FROM Salle s WHERE s.disponible = true " +
                "AND s.idSalle NOT IN (" +
                "  SELECT c.salle.idSalle FROM Consultation c " +
                "  WHERE c.dateConsultation = :dateHeure" +
                ")", Salle.class);
            query.setParameter("dateHeure", dateHeure);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public boolean isRoomAvailable(Long salleId, LocalDateTime dateHeure) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Long> query = em.createQuery(
                "SELECT COUNT(c) FROM Consultation c " +
                "WHERE c.salle.idSalle = :salleId " +
                "AND c.dateConsultation = :dateHeure", Long.class);
            query.setParameter("salleId", salleId);
            query.setParameter("dateHeure", dateHeure);
            return query.getSingleResult() == 0;
        } finally {
            em.close();
        }
    }

    @Override
    public List<Salle> findByCapaciteGreaterThanEqual(Integer capacite) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Salle> query = em.createQuery(
                "SELECT s FROM Salle s WHERE s.capacite >= :capacite " +
                "ORDER BY s.capacite", Salle.class);
            query.setParameter("capacite", capacite);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public double getOccupationRate(Long salleId, LocalDateTime dateDebut, LocalDateTime dateFin) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Long> totalQuery = em.createQuery(
                "SELECT COUNT(c) FROM Consultation c " +
                "WHERE c.salle.idSalle = :salleId " +
                "AND c.dateConsultation BETWEEN :dateDebut AND :dateFin", Long.class);
            totalQuery.setParameter("salleId", salleId);
            totalQuery.setParameter("dateDebut", dateDebut);
            totalQuery.setParameter("dateFin", dateFin);
            
            long occupiedSlots = totalQuery.getSingleResult();
            // Assuming 8 hours per day, 8 slots per day
            long totalSlots = java.time.Duration.between(dateDebut, dateFin).toDays() * 8;
            
            return totalSlots > 0 ? (double) occupiedSlots / totalSlots * 100 : 0;
        } finally {
            em.close();
        }
    }

    @Override
    public double getGlobalOccupationRate(LocalDateTime dateDebut, LocalDateTime dateFin) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Long> totalQuery = em.createQuery(
                "SELECT COUNT(c) FROM Consultation c " +
                "WHERE c.dateConsultation BETWEEN :dateDebut AND :dateFin", Long.class);
            totalQuery.setParameter("dateDebut", dateDebut);
            totalQuery.setParameter("dateFin", dateFin);
            
            TypedQuery<Long> salleCountQuery = em.createQuery(
                "SELECT COUNT(s) FROM Salle s", Long.class);
            
            long occupiedSlots = totalQuery.getSingleResult();
            long totalRooms = salleCountQuery.getSingleResult();
            long totalSlots = java.time.Duration.between(dateDebut, dateFin).toDays() * 8 * totalRooms;
            
            return totalSlots > 0 ? (double) occupiedSlots / totalSlots * 100 : 0;
        } finally {
            em.close();
        }
    }

    @Override
    public List<LocalDateTime> getOccupiedSlots(Long salleId) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<LocalDateTime> query = em.createQuery(
                "SELECT c.dateConsultation FROM Consultation c " +
                "WHERE c.salle.idSalle = :salleId " +
                "ORDER BY c.dateConsultation", LocalDateTime.class);
            query.setParameter("salleId", salleId);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public List<LocalDateTime> getOccupiedSlotsBetween(Long salleId, LocalDateTime dateDebut, LocalDateTime dateFin) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<LocalDateTime> query = em.createQuery(
                "SELECT c.dateConsultation FROM Consultation c " +
                "WHERE c.salle.idSalle = :salleId " +
                "AND c.dateConsultation BETWEEN :dateDebut AND :dateFin " +
                "ORDER BY c.dateConsultation", LocalDateTime.class);
            query.setParameter("salleId", salleId);
            query.setParameter("dateDebut", dateDebut);
            query.setParameter("dateFin", dateFin);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public boolean existsByNomSalle(String nomSalle) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Long> query = em.createQuery(
                "SELECT COUNT(s) FROM Salle s WHERE s.nomSalle = :nomSalle", Long.class);
            query.setParameter("nomSalle", nomSalle);
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
                "SELECT COUNT(s) FROM Salle s", Long.class);
            return query.getSingleResult();
        } finally {
            em.close();
        }
    }
}
