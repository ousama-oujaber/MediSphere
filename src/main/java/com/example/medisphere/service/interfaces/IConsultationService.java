package com.example.medisphere.service.interfaces;

import com.example.medisphere.model.entity.Consultation;
import com.example.medisphere.model.entity.Salle;
import com.example.medisphere.model.enums.StatutConsultation;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;
import java.util.Optional;

 
public interface IConsultationService {
    
    
    List<Consultation> getConsultationsByDocteur(Long docteurId);
    
    
    List<Consultation> getConsultationsByDocteurAndStatut(Long docteurId, StatutConsultation statut);
    
    
    List<Consultation> getConsultationsByDocteurAndDateRange(Long docteurId, LocalDate dateDebut, LocalDate dateFin);
    
    
    List<Consultation> getTodayConsultationsForDocteur(Long docteurId);
    
    
    Consultation validerReservation(Long consultationId, Long docteurId) throws Exception;
    
    
    Consultation rejeterReservation(Long consultationId, Long docteurId, String motifAnnulation) throws Exception;
    
    
    Consultation ajouterCompteRendu(Long consultationId, Long docteurId, String compteRendu) throws Exception;
    
    
    Optional<Consultation> getConsultationById(Long id);
    
    
    List<Consultation> getHistoriquePatient(Long patientId);
    
    
    long countConsultationsByDocteur(Long docteurId);
    long countConsultationsByDocteurAndStatut(Long docteurId, StatutConsultation statut);
    
    
    Consultation updateStatut(Long consultationId, StatutConsultation nouveauStatut) throws Exception;
    
    
    Consultation createReservation(Long patientId, Long docteurId, LocalDate dateConsultation, 
                                  LocalTime heureConsultation, String motifConsultation) throws Exception;
    
    
    Consultation cancelReservation(Long consultationId, Long patientId) throws Exception;
    
    
    List<Salle> getAvailableRooms(LocalDate dateConsultation, LocalTime heureConsultation);
    
    
    boolean isDoctorAvailable(Long docteurId, LocalDate dateConsultation, LocalTime heureConsultation);
    
    
    boolean isPatientAvailable(Long patientId, LocalDate dateConsultation, LocalTime heureConsultation);
    
    
    Consultation modifyReservation(Long consultationId, Long patientId, LocalDate newDate, 
                                  LocalTime newTime, String newMotif) throws Exception;
}
