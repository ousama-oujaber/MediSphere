package com.example.medisphere.repository.interfaces;

import com.example.medisphere.model.entity.Consultation;
import com.example.medisphere.model.entity.Docteur;
import com.example.medisphere.model.entity.Patient;
import com.example.medisphere.model.enums.StatutConsultation;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public interface IConsultationRepository {
    Consultation save(Consultation consultation);
    Optional<Consultation> findById(Long id);
    List<Consultation> findAll();
    List<Consultation> findByPatient(Patient patient);
    List<Consultation> findByPatientId(Long patientId);
    List<Consultation> findByDocteur(Docteur docteur);
    List<Consultation> findByDocteurId(Long docteurId);
    List<Consultation> findByStatut(StatutConsultation statut);
    List<Consultation> findByDateBetween(LocalDateTime dateDebut, LocalDateTime dateFin);
    List<Consultation> findByPatientIdAndStatut(Long patientId, StatutConsultation statut);
    List<Consultation> findByDocteurIdAndStatut(Long docteurId, StatutConsultation statut);
    List<Consultation> findByDocteurIdAndDateBetween(Long docteurId, LocalDate dateDebut, LocalDate dateFin);
    boolean existsByPatientIdAndDate(Long patientId, LocalDateTime dateConsultation);
    boolean existsByDocteurIdAndDate(Long docteurId, LocalDateTime dateConsultation);
    Consultation update(Consultation consultation);
    boolean delete(Long id);
    long count();
    long countByStatut(StatutConsultation statut);
    List<Consultation> getHistoriqueByPatientId(Long patientId);
}
