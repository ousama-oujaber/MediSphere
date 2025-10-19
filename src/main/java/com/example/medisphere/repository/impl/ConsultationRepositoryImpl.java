package com.example.medisphere.repository.impl;

import com.example.medisphere.model.entity.Consultation;
import com.example.medisphere.model.entity.Docteur;
import com.example.medisphere.model.entity.Patient;
import com.example.medisphere.model.enums.StatutConsultation;
import com.example.medisphere.repository.interfaces.IConsultationRepository;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public class ConsultationRepositoryImpl implements IConsultationRepository {
    
    private final EntityManagerFactory emf;
    
    public ConsultationRepositoryImpl(EntityManagerFactory emf) {
        this.emf = emf;
    }
    
    @Override
    public Consultation save(Consultation consultation) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(consultation);
            em.getTransaction().commit();
            return consultation;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Erreur lors de la création de la consultation", e);
        } finally {
            em.close();
        }
    }
    
    @Override
    public Optional<Consultation> findById(Long id) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Consultation> query = em.createQuery(
                "SELECT c FROM Consultation c " +
                "LEFT JOIN FETCH c.patient p " +
                "LEFT JOIN FETCH p.personne pp " +
                "LEFT JOIN FETCH c.docteur d " +
                "LEFT JOIN FETCH d.personne dp " +
                "LEFT JOIN FETCH c.salle " +
                "WHERE c.idConsultation = :id",
                Consultation.class
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
    public List<Consultation> findAll() {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Consultation> query = em.createQuery(
                "SELECT c FROM Consultation c " +
                "LEFT JOIN FETCH c.patient p " +
                "LEFT JOIN FETCH p.personne " +
                "LEFT JOIN FETCH c.docteur d " +
                "LEFT JOIN FETCH d.personne " +
                "LEFT JOIN FETCH c.salle " +
                "ORDER BY c.dateConsultation DESC",
                Consultation.class
            );
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    @Override
    public List<Consultation> findByPatient(Patient patient) {
        return findByPatientId(patient.getIdPatient());
    }
    
    @Override
    public List<Consultation> findByPatientId(Long patientId) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Consultation> query = em.createQuery(
                "SELECT c FROM Consultation c " +
                "LEFT JOIN FETCH c.patient p " +
                "LEFT JOIN FETCH p.personne " +
                "LEFT JOIN FETCH c.docteur d " +
                "LEFT JOIN FETCH d.personne " +
                "LEFT JOIN FETCH c.salle " +
                "WHERE c.patient.idPatient = :patientId " +
                "ORDER BY c.dateConsultation DESC",
                Consultation.class
            );
            query.setParameter("patientId", patientId);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    @Override
    public List<Consultation> findByDocteur(Docteur docteur) {
        return findByDocteurId(docteur.getIdDocteur());
    }
    
    @Override
    public List<Consultation> findByDocteurId(Long docteurId) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Consultation> query = em.createQuery(
                "SELECT c FROM Consultation c " +
                "LEFT JOIN FETCH c.patient p " +
                "LEFT JOIN FETCH p.personne " +
                "LEFT JOIN FETCH c.docteur d " +
                "LEFT JOIN FETCH d.personne " +
                "LEFT JOIN FETCH c.salle " +
                "WHERE c.docteur.idDocteur = :docteurId " +
                "ORDER BY c.dateConsultation DESC",
                Consultation.class
            );
            query.setParameter("docteurId", docteurId);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    @Override
    public List<Consultation> findByStatut(StatutConsultation statut) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Consultation> query = em.createQuery(
                "SELECT c FROM Consultation c " +
                "LEFT JOIN FETCH c.patient p " +
                "LEFT JOIN FETCH p.personne " +
                "LEFT JOIN FETCH c.docteur d " +
                "LEFT JOIN FETCH d.personne " +
                "LEFT JOIN FETCH c.salle " +
                "WHERE c.statut = :statut " +
                "ORDER BY c.dateConsultation DESC",
                Consultation.class
            );
            query.setParameter("statut", statut);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    @Override
    public List<Consultation> findByDateBetween(LocalDateTime dateDebut, LocalDateTime dateFin) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Consultation> query = em.createQuery(
                "SELECT c FROM Consultation c " +
                "LEFT JOIN FETCH c.patient p " +
                "LEFT JOIN FETCH p.personne " +
                "LEFT JOIN FETCH c.docteur d " +
                "LEFT JOIN FETCH d.personne " +
                "LEFT JOIN FETCH c.salle " +
                "WHERE c.dateConsultation BETWEEN :dateDebut AND :dateFin " +
                "ORDER BY c.dateConsultation ASC",
                Consultation.class
            );
            query.setParameter("dateDebut", dateDebut);
            query.setParameter("dateFin", dateFin);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    @Override
    public List<Consultation> findByPatientIdAndStatut(Long patientId, StatutConsultation statut) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Consultation> query = em.createQuery(
                "SELECT c FROM Consultation c " +
                "LEFT JOIN FETCH c.patient p " +
                "LEFT JOIN FETCH p.personne " +
                "LEFT JOIN FETCH c.docteur d " +
                "LEFT JOIN FETCH d.personne " +
                "LEFT JOIN FETCH c.salle " +
                "WHERE c.patient.idPatient = :patientId AND c.statut = :statut " +
                "ORDER BY c.dateConsultation DESC",
                Consultation.class
            );
            query.setParameter("patientId", patientId);
            query.setParameter("statut", statut);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    @Override
    public List<Consultation> findByDocteurIdAndStatut(Long docteurId, StatutConsultation statut) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Consultation> query = em.createQuery(
                "SELECT c FROM Consultation c " +
                "LEFT JOIN FETCH c.patient p " +
                "LEFT JOIN FETCH p.personne " +
                "LEFT JOIN FETCH c.docteur d " +
                "LEFT JOIN FETCH d.personne " +
                "LEFT JOIN FETCH c.salle " +
                "WHERE c.docteur.idDocteur = :docteurId AND c.statut = :statut " +
                "ORDER BY c.dateConsultation DESC",
                Consultation.class
            );
            query.setParameter("docteurId", docteurId);
            query.setParameter("statut", statut);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    @Override
    public List<Consultation> findByDocteurIdAndDateBetween(Long docteurId, LocalDate dateDebut, LocalDate dateFin) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Consultation> query = em.createQuery(
                "SELECT c FROM Consultation c " +
                "LEFT JOIN FETCH c.patient p " +
                "LEFT JOIN FETCH p.personne " +
                "LEFT JOIN FETCH c.docteur d " +
                "LEFT JOIN FETCH d.personne " +
                "LEFT JOIN FETCH c.salle " +
                "WHERE c.docteur.idDocteur = :docteurId " +
                "AND c.dateConsultation BETWEEN :dateDebut AND :dateFin " +
                "ORDER BY c.dateConsultation ASC",
                Consultation.class
            );
            query.setParameter("docteurId", docteurId);
            query.setParameter("dateDebut", dateDebut);
            query.setParameter("dateFin", dateFin);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    @Override
    public boolean existsByPatientIdAndDate(Long patientId, LocalDateTime dateConsultation) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Long> query = em.createQuery(
                "SELECT COUNT(c) FROM Consultation c " +
                "WHERE c.patient.idPatient = :patientId " +
                "AND c.dateConsultation = :dateConsultation",
                Long.class
            );
            query.setParameter("patientId", patientId);
            query.setParameter("dateConsultation", dateConsultation);
            return query.getSingleResult() > 0;
        } finally {
            em.close();
        }
    }
    
    @Override
    public boolean existsByDocteurIdAndDate(Long docteurId, LocalDateTime dateConsultation) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Long> query = em.createQuery(
                "SELECT COUNT(c) FROM Consultation c " +
                "WHERE c.docteur.idDocteur = :docteurId " +
                "AND c.dateConsultation = :dateConsultation",
                Long.class
            );
            query.setParameter("docteurId", docteurId);
            query.setParameter("dateConsultation", dateConsultation);
            return query.getSingleResult() > 0;
        } finally {
            em.close();
        }
    }
    
    @Override
    public Consultation update(Consultation consultation) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            Consultation updated = em.merge(consultation);
            em.getTransaction().commit();
            return updated;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Erreur lors de la mise à jour de la consultation", e);
        } finally {
            em.close();
        }
    }
    
    @Override
    public boolean delete(Long id) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            Consultation consultation = em.find(Consultation.class, id);
            if (consultation != null) {
                em.remove(consultation);
                em.getTransaction().commit();
                return true;
            }
            em.getTransaction().rollback();
            return false;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Erreur lors de la suppression de la consultation", e);
        } finally {
            em.close();
        }
    }
    
    @Override
    public long count() {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Long> query = em.createQuery(
                "SELECT COUNT(c) FROM Consultation c",
                Long.class
            );
            return query.getSingleResult();
        } finally {
            em.close();
        }
    }
    
    @Override
    public long countByStatut(StatutConsultation statut) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Long> query = em.createQuery(
                "SELECT COUNT(c) FROM Consultation c WHERE c.statut = :statut",
                Long.class
            );
            query.setParameter("statut", statut);
            return query.getSingleResult();
        } finally {
            em.close();
        }
    }
    
    @Override
    public List<Consultation> getHistoriqueByPatientId(Long patientId) {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Consultation> query = em.createQuery(
                "SELECT c FROM Consultation c " +
                "LEFT JOIN FETCH c.patient p " +
                "LEFT JOIN FETCH p.personne " +
                "LEFT JOIN FETCH c.docteur d " +
                "LEFT JOIN FETCH d.personne " +
                "LEFT JOIN FETCH c.salle " +
                "WHERE c.patient.idPatient = :patientId " +
                "AND c.statut = :statut " +
                "ORDER BY c.dateConsultation DESC",
                Consultation.class
            );
            query.setParameter("patientId", patientId);
            query.setParameter("statut", StatutConsultation.TERMINEE);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
}
