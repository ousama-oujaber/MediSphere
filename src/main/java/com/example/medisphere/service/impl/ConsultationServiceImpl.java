package com.example.medisphere.service.impl;

import com.example.medisphere.model.entity.Consultation;
import com.example.medisphere.model.entity.Docteur;
import com.example.medisphere.model.entity.Patient;
import com.example.medisphere.model.entity.Salle;
import com.example.medisphere.model.enums.StatutConsultation;
import com.example.medisphere.repository.interfaces.IConsultationRepository;
import com.example.medisphere.repository.interfaces.IDocteurRepository;
import com.example.medisphere.repository.interfaces.IPatientRepository;
import com.example.medisphere.repository.interfaces.ISalleRepository;
import com.example.medisphere.repository.impl.DocteurRepositoryImpl;
import com.example.medisphere.repository.impl.PatientRepositoryImpl;
import com.example.medisphere.repository.impl.SalleRepositoryImpl;
import com.example.medisphere.service.interfaces.IConsultationService;
import com.example.medisphere.util.JPAUtil;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

 
public class ConsultationServiceImpl implements IConsultationService {
    
    private final IConsultationRepository consultationRepository;
    private final ISalleRepository salleRepository;
    private final IDocteurRepository docteurRepository;
    private final IPatientRepository patientRepository;
    
    public ConsultationServiceImpl(IConsultationRepository consultationRepository) {
        this.consultationRepository = consultationRepository;
        this.salleRepository = new SalleRepositoryImpl(JPAUtil.getEntityManagerFactory());
        this.docteurRepository = new DocteurRepositoryImpl(JPAUtil.getEntityManagerFactory());
        this.patientRepository = new PatientRepositoryImpl(JPAUtil.getEntityManagerFactory());
    }
    
    @Override
    public List<Consultation> getConsultationsByDocteur(Long docteurId) {
        if (docteurId == null || docteurId <= 0) {
            throw new IllegalArgumentException("ID du docteur invalide");
        }
        return consultationRepository.findByDocteurId(docteurId);
    }
    
    @Override
    public List<Consultation> getConsultationsByDocteurAndStatut(Long docteurId, StatutConsultation statut) {
        if (docteurId == null || docteurId <= 0) {
            throw new IllegalArgumentException("ID du docteur invalide");
        }
        if (statut == null) {
            throw new IllegalArgumentException("Le statut ne peut pas être nul");
        }
        return consultationRepository.findByDocteurIdAndStatut(docteurId, statut);
    }
    
    @Override
    public List<Consultation> getConsultationsByDocteurAndDateRange(Long docteurId, LocalDate dateDebut, LocalDate dateFin) {
        if (docteurId == null || docteurId <= 0) {
            throw new IllegalArgumentException("ID du docteur invalide");
        }
        if (dateDebut == null || dateFin == null) {
            throw new IllegalArgumentException("Les dates ne peuvent pas être nulles");
        }
        if (dateDebut.isAfter(dateFin)) {
            throw new IllegalArgumentException("La date de début doit être antérieure à la date de fin");
        }
        return consultationRepository.findByDocteurIdAndDateBetween(docteurId, dateDebut, dateFin);
    }
    
    @Override
    public List<Consultation> getTodayConsultationsForDocteur(Long docteurId) {
        if (docteurId == null || docteurId <= 0) {
            throw new IllegalArgumentException("ID du docteur invalide");
        }
        LocalDate today = LocalDate.now();
        return consultationRepository.findByDocteurIdAndDateBetween(docteurId, today, today);
    }
    
    @Override
    public Consultation validerReservation(Long consultationId, Long docteurId) throws Exception {
        if (consultationId == null || consultationId <= 0) {
            throw new IllegalArgumentException("ID de la consultation invalide");
        }
        if (docteurId == null || docteurId <= 0) {
            throw new IllegalArgumentException("ID du docteur invalide");
        }
        
        Optional<Consultation> optConsultation = consultationRepository.findById(consultationId);
        if (optConsultation.isEmpty()) {
            throw new IllegalArgumentException("Consultation introuvable");
        }
        
        Consultation consultation = optConsultation.get();
        
        
        if (!consultation.getDocteur().getIdDocteur().equals(docteurId)) {
            throw new IllegalStateException("Cette consultation n'appartient pas à ce docteur");
        }
        
        
        if (consultation.getStatut() != StatutConsultation.RESERVEE) {
            throw new IllegalStateException("Seules les consultations réservées peuvent être validées");
        }
        
        
        consultation.setStatut(StatutConsultation.VALIDEE);
        consultation.setDateModification(LocalDateTime.now());
        
        return consultationRepository.update(consultation);
    }
    
    @Override
    public Consultation rejeterReservation(Long consultationId, Long docteurId, String motifAnnulation) throws Exception {
        if (consultationId == null || consultationId <= 0) {
            throw new IllegalArgumentException("ID de la consultation invalide");
        }
        if (docteurId == null || docteurId <= 0) {
            throw new IllegalArgumentException("ID du docteur invalide");
        }
        
        Optional<Consultation> optConsultation = consultationRepository.findById(consultationId);
        if (optConsultation.isEmpty()) {
            throw new IllegalArgumentException("Consultation introuvable");
        }
        
        Consultation consultation = optConsultation.get();
        
        
        if (!consultation.getDocteur().getIdDocteur().equals(docteurId)) {
            throw new IllegalStateException("Cette consultation n'appartient pas à ce docteur");
        }
        
        
        if (consultation.getStatut() != StatutConsultation.RESERVEE) {
            throw new IllegalStateException("Seules les consultations réservées peuvent être rejetées");
        }
        
        
        consultation.setStatut(StatutConsultation.ANNULEE);
        consultation.setDateModification(LocalDateTime.now());
        
        
        if (motifAnnulation != null && !motifAnnulation.trim().isEmpty()) {
            consultation.setCompteRendu("Annulée - Motif: " + motifAnnulation.trim());
        }
        
        return consultationRepository.update(consultation);
    }
    
    @Override
    public Consultation ajouterCompteRendu(Long consultationId, Long docteurId, String compteRendu) throws Exception {
        if (consultationId == null || consultationId <= 0) {
            throw new IllegalArgumentException("ID de la consultation invalide");
        }
        if (docteurId == null || docteurId <= 0) {
            throw new IllegalArgumentException("ID du docteur invalide");
        }
        if (compteRendu == null || compteRendu.trim().isEmpty()) {
            throw new IllegalArgumentException("Le compte rendu ne peut pas être vide");
        }
        
        Optional<Consultation> optConsultation = consultationRepository.findById(consultationId);
        if (optConsultation.isEmpty()) {
            throw new IllegalArgumentException("Consultation introuvable");
        }
        
        Consultation consultation = optConsultation.get();
        
        
        if (!consultation.getDocteur().getIdDocteur().equals(docteurId)) {
            throw new IllegalStateException("Cette consultation n'appartient pas à ce docteur");
        }
        
        
        if (consultation.getStatut() != StatutConsultation.VALIDEE) {
            throw new IllegalStateException("Seules les consultations validées peuvent recevoir un compte rendu");
        }
        
        
        if (consultation.getDateConsultation().isAfter(LocalDate.now())) {
            throw new IllegalStateException("Impossible d'ajouter un compte rendu pour une consultation future");
        }
        
        
        consultation.setCompteRendu(compteRendu.trim());
        consultation.setStatut(StatutConsultation.TERMINEE);
        consultation.setDateModification(LocalDateTime.now());
        
        return consultationRepository.update(consultation);
    }
    
    @Override
    public Optional<Consultation> getConsultationById(Long id) {
        if (id == null || id <= 0) {
            throw new IllegalArgumentException("ID de la consultation invalide");
        }
        return consultationRepository.findById(id);
    }
    
    @Override
    public List<Consultation> getHistoriquePatient(Long patientId) {
        if (patientId == null || patientId <= 0) {
            throw new IllegalArgumentException("ID du patient invalide");
        }
        return consultationRepository.getHistoriqueByPatientId(patientId);
    }
    
    @Override
    public long countConsultationsByDocteur(Long docteurId) {
        if (docteurId == null || docteurId <= 0) {
            throw new IllegalArgumentException("ID du docteur invalide");
        }
        return consultationRepository.findByDocteurId(docteurId).size();
    }
    
    @Override
    public long countConsultationsByDocteurAndStatut(Long docteurId, StatutConsultation statut) {
        if (docteurId == null || docteurId <= 0) {
            throw new IllegalArgumentException("ID du docteur invalide");
        }
        if (statut == null) {
            throw new IllegalArgumentException("Le statut ne peut pas être nul");
        }
        return consultationRepository.findByDocteurIdAndStatut(docteurId, statut).size();
    }
    
    @Override
    public Consultation updateStatut(Long consultationId, StatutConsultation nouveauStatut) throws Exception {
        if (consultationId == null || consultationId <= 0) {
            throw new IllegalArgumentException("ID de la consultation invalide");
        }
        if (nouveauStatut == null) {
            throw new IllegalArgumentException("Le nouveau statut ne peut pas être nul");
        }
        
        Optional<Consultation> optConsultation = consultationRepository.findById(consultationId);
        if (optConsultation.isEmpty()) {
            throw new IllegalArgumentException("Consultation introuvable");
        }
        
        Consultation consultation = optConsultation.get();
        consultation.setStatut(nouveauStatut);
        consultation.setDateModification(LocalDateTime.now());
        
        return consultationRepository.update(consultation);
    }
    
    @Override
    public Consultation createReservation(Long patientId, Long docteurId, LocalDate dateConsultation, 
                                         LocalTime heureConsultation, String motifConsultation) throws Exception {
        
        if (patientId == null || patientId <= 0) {
            throw new IllegalArgumentException("ID du patient invalide");
        }
        if (docteurId == null || docteurId <= 0) {
            throw new IllegalArgumentException("ID du docteur invalide");
        }
        if (dateConsultation == null) {
            throw new IllegalArgumentException("La date de consultation ne peut pas être nulle");
        }
        if (heureConsultation == null) {
            throw new IllegalArgumentException("L'heure de consultation ne peut pas être nulle");
        }
        if (dateConsultation.isBefore(LocalDate.now())) {
            throw new IllegalArgumentException("La date de consultation ne peut pas être dans le passé");
        }
        
        
        Optional<Patient> optPatient = patientRepository.findById(patientId);
        if (optPatient.isEmpty()) {
            throw new IllegalArgumentException("Patient introuvable");
        }
        
        
        Optional<Docteur> optDocteur = docteurRepository.findById(docteurId);
        if (optDocteur.isEmpty()) {
            throw new IllegalArgumentException("Docteur introuvable");
        }
        
        
        if (!isDoctorAvailable(docteurId, dateConsultation, heureConsultation)) {
            throw new IllegalStateException("Le docteur n'est pas disponible à cette date et heure");
        }
        
        
        if (!isPatientAvailable(patientId, dateConsultation, heureConsultation)) {
            throw new IllegalStateException("Vous avez déjà une consultation à cette date et heure");
        }
        
        
        List<Salle> availableRooms = getAvailableRooms(dateConsultation, heureConsultation);
        if (availableRooms.isEmpty()) {
            throw new IllegalStateException("Aucune salle disponible pour cette date et heure");
        }
        
        
        Consultation consultation = new Consultation();
        consultation.setPatient(optPatient.get());
        consultation.setDocteur(optDocteur.get());
        consultation.setDateConsultation(dateConsultation);
        consultation.setHeureConsultation(heureConsultation);
        consultation.setMotifConsultation(motifConsultation);
        consultation.setSalle(availableRooms.get(0)); // Assign first available room
        consultation.setStatut(StatutConsultation.RESERVEE);
        consultation.setDateCreation(LocalDateTime.now());
        consultation.setDateModification(LocalDateTime.now());
        
        return consultationRepository.save(consultation);
    }
    
    @Override
    public Consultation cancelReservation(Long consultationId, Long patientId) throws Exception {
        if (consultationId == null || consultationId <= 0) {
            throw new IllegalArgumentException("ID de la consultation invalide");
        }
        if (patientId == null || patientId <= 0) {
            throw new IllegalArgumentException("ID du patient invalide");
        }
        
        Optional<Consultation> optConsultation = consultationRepository.findById(consultationId);
        if (optConsultation.isEmpty()) {
            throw new IllegalArgumentException("Consultation introuvable");
        }
        
        Consultation consultation = optConsultation.get();
        
        
        if (!consultation.getPatient().getIdPatient().equals(patientId)) {
            throw new IllegalStateException("Cette consultation ne vous appartient pas");
        }
        
        
        if (consultation.getStatut() != StatutConsultation.RESERVEE) {
            throw new IllegalStateException("Seules les consultations réservées peuvent être annulées");
        }
        
        
        if (consultation.getDateConsultation().isBefore(LocalDate.now())) {
            throw new IllegalStateException("Impossible d'annuler une consultation passée");
        }
        
        
        consultation.setStatut(StatutConsultation.ANNULEE);
        consultation.setDateModification(LocalDateTime.now());
        
        return consultationRepository.update(consultation);
    }
    
    @Override
    public List<Salle> getAvailableRooms(LocalDate dateConsultation, LocalTime heureConsultation) {
        if (dateConsultation == null || heureConsultation == null) {
            throw new IllegalArgumentException("La date et l'heure ne peuvent pas être nulles");
        }
        
        LocalDateTime dateTime = LocalDateTime.of(dateConsultation, heureConsultation);
        
        
        List<Salle> allRooms = salleRepository.findAll();
        
        
        return allRooms.stream()
            .filter(salle -> salleRepository.isRoomAvailable(salle.getIdSalle(), dateTime))
            .collect(Collectors.toList());
    }
    
    @Override
    public boolean isDoctorAvailable(Long docteurId, LocalDate dateConsultation, LocalTime heureConsultation) {
        if (docteurId == null || dateConsultation == null || heureConsultation == null) {
            return false;
        }
        
        
        List<Consultation> consultations = consultationRepository.findByDocteurIdAndDateBetween(
            docteurId, dateConsultation, dateConsultation
        );
        
        
        for (Consultation consultation : consultations) {
            if (consultation.getStatut() != StatutConsultation.ANNULEE) {
                LocalTime consultTime = consultation.getHeureConsultation();
                
                if (Math.abs(heureConsultation.toSecondOfDay() - consultTime.toSecondOfDay()) < 1800) {
                    return false; // Less than 30 minutes apart
                }
            }
        }
        
        return true;
    }
    
    @Override
    public boolean isPatientAvailable(Long patientId, LocalDate dateConsultation, LocalTime heureConsultation) {
        if (patientId == null || dateConsultation == null || heureConsultation == null) {
            return false;
        }
        
        
        List<Consultation> consultations = consultationRepository.findByPatientId(patientId);
        
        
        for (Consultation consultation : consultations) {
            if (consultation.getDateConsultation().equals(dateConsultation) &&
                consultation.getStatut() != StatutConsultation.ANNULEE) {
                LocalTime consultTime = consultation.getHeureConsultation();
                
                if (Math.abs(heureConsultation.toSecondOfDay() - consultTime.toSecondOfDay()) < 1800) {
                    return false; // Less than 30 minutes apart
                }
            }
        }
        
        return true;
    }
    
    @Override
    public Consultation modifyReservation(Long consultationId, Long patientId, LocalDate newDate, 
                                         LocalTime newTime, String newMotif) throws Exception {
        
        if (consultationId == null || consultationId <= 0) {
            throw new IllegalArgumentException("ID de la consultation invalide");
        }
        if (patientId == null || patientId <= 0) {
            throw new IllegalArgumentException("ID du patient invalide");
        }
        if (newDate == null) {
            throw new IllegalArgumentException("La nouvelle date ne peut pas être nulle");
        }
        if (newTime == null) {
            throw new IllegalArgumentException("La nouvelle heure ne peut pas être nulle");
        }
        if (newDate.isBefore(LocalDate.now())) {
            throw new IllegalArgumentException("La nouvelle date ne peut pas être dans le passé");
        }
        
        
        Optional<Consultation> optConsultation = consultationRepository.findById(consultationId);
        if (optConsultation.isEmpty()) {
            throw new IllegalArgumentException("Consultation introuvable");
        }
        
        Consultation consultation = optConsultation.get();
        
        
        if (!consultation.getPatient().getIdPatient().equals(patientId)) {
            throw new IllegalStateException("Cette consultation ne vous appartient pas");
        }
        
        
        if (consultation.getStatut() != StatutConsultation.RESERVEE) {
            throw new IllegalStateException("Seules les consultations réservées peuvent être modifiées");
        }
        
        
        if (consultation.getDateConsultation().isBefore(LocalDate.now())) {
            throw new IllegalStateException("Impossible de modifier une consultation passée");
        }
        
        
        LocalDate oldDate = consultation.getDateConsultation();
        LocalTime oldTime = consultation.getHeureConsultation();
        Long docteurId = consultation.getDocteur().getIdDocteur();
        Long oldSalleId = consultation.getSalle() != null ? consultation.getSalle().getIdSalle() : null;
        
        
        boolean dateTimeChanged = !newDate.equals(oldDate) || !newTime.equals(oldTime);
        
        if (dateTimeChanged) {
            
            List<Consultation> docteurConsultations = consultationRepository.findByDocteurIdAndDateBetween(
                docteurId, newDate, newDate
            );
            for (Consultation dc : docteurConsultations) {
                if (!dc.getIdConsultation().equals(consultationId) && 
                    dc.getStatut() != StatutConsultation.ANNULEE) {
                    LocalTime consultTime = dc.getHeureConsultation();
                    if (Math.abs(newTime.toSecondOfDay() - consultTime.toSecondOfDay()) < 1800) {
                        throw new IllegalStateException("Le docteur n'est pas disponible à cette date et heure");
                    }
                }
            }
            
            
            List<Consultation> patientConsultations = consultationRepository.findByPatientId(patientId);
            for (Consultation pc : patientConsultations) {
                if (!pc.getIdConsultation().equals(consultationId) && 
                    pc.getDateConsultation().equals(newDate) &&
                    pc.getStatut() != StatutConsultation.ANNULEE) {
                    LocalTime consultTime = pc.getHeureConsultation();
                    if (Math.abs(newTime.toSecondOfDay() - consultTime.toSecondOfDay()) < 1800) {
                        throw new IllegalStateException("Vous avez déjà une consultation à cette date et heure");
                    }
                }
            }
            
            
            List<Salle> availableRooms = getAvailableRooms(newDate, newTime);
            
            
            boolean currentRoomAvailable = false;
            if (oldSalleId != null) {
                for (Salle room : availableRooms) {
                    if (room.getIdSalle().equals(oldSalleId)) {
                        currentRoomAvailable = true;
                        break;
                    }
                }
            }
            
            if (!currentRoomAvailable) {
                if (availableRooms.isEmpty()) {
                    throw new IllegalStateException("Aucune salle disponible pour cette date et heure");
                }
                
                consultation.setSalle(availableRooms.get(0));
            }
        }
        
        
        consultation.setDateConsultation(newDate);
        consultation.setHeureConsultation(newTime);
        if (newMotif != null && !newMotif.trim().isEmpty()) {
            consultation.setMotifConsultation(newMotif.trim());
        }
        consultation.setDateModification(LocalDateTime.now());
        
        return consultationRepository.update(consultation);
    }
}
