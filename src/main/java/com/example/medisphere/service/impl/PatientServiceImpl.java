package com.example.medisphere.service.impl;

import com.example.medisphere.model.entity.Patient;
import com.example.medisphere.model.entity.Personne;
import com.example.medisphere.model.enums.RoleUtilisateur;
import com.example.medisphere.repository.interfaces.IPatientRepository;
import com.example.medisphere.service.interfaces.IPatientService;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;


public class PatientServiceImpl implements IPatientService {
    
    private final IPatientRepository patientRepository;
    
    public PatientServiceImpl(IPatientRepository patientRepository) {
        this.patientRepository = patientRepository;
    }
    
    

    @Override
    public Patient registerPatient(String nom, String prenom, String email, String motDePasse, String telephone) {
        validateRegistrationData(nom, prenom, email, motDePasse);
        
        if (patientRepository.existsByEmail(email)) {
            throw new IllegalStateException("Un compte avec cet email existe déjà");
        }
        
        Personne personne = new Personne();
        personne.setTypePersonne(RoleUtilisateur.PATIENT);
        personne.setNom(nom);
        personne.setPrenom(prenom);
        personne.setEmail(email);
        personne.setMotDePasse(motDePasse); // TODO: hash passwords
        personne.setTelephone(telephone);
        personne.setActif(true);
        personne.setDateCreation(LocalDateTime.now());
        
        Patient patient = new Patient();
        patient.setPersonne(personne);
        patient.setNumeroDossier(generateNumeroDossier());
        
        return patientRepository.save(patient);
    }
    
    @Override
    public Patient findByEmail(String email) {
        return patientRepository.findByEmail(email).orElse(null);
    }
    
    @Override
    public Patient findById(Long id) {
        return patientRepository.findById(id).orElse(null);
    }
    
    @Override
    public boolean emailExists(String email) {
        return patientRepository.existsByEmail(email);
    }
    
    @Override
    public long getTotalPatients() {
        return patientRepository.count();
    }
    
    
    
    @Override
    public List<Patient> getAllPatients() {
        return patientRepository.findAll();
    }
    
    @Override
    public Optional<Patient> getPatientById(Long id) {
        if (id == null || id <= 0) {
            throw new IllegalArgumentException("L'ID du patient est invalide");
        }
        return patientRepository.findById(id);
    }
    
    @Override
    public Optional<Patient> getPatientByNumeroDossier(String numeroDossier) {
        if (numeroDossier == null || numeroDossier.trim().isEmpty()) {
            throw new IllegalArgumentException("Le numéro de dossier est invalide");
        }
        return patientRepository.findByNumeroDossier(numeroDossier);
    }
    
    @Override
    public List<Patient> searchPatients(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return getAllPatients();
        }
        return patientRepository.searchByKeyword(keyword.trim());
    }
    
    @Override
    public List<Patient> getPatientsByGroupeSanguin(String groupeSanguin) {
        if (groupeSanguin == null || groupeSanguin.trim().isEmpty()) {
            throw new IllegalArgumentException("Le groupe sanguin est invalide");
        }
        return patientRepository.findByGroupeSanguin(groupeSanguin);
    }
    
    @Override
    public Patient createPatient(Patient patient) {
        validatePatient(patient);
        
        if (patientRepository.existsByEmail(patient.getPersonne().getEmail(), null)) {
            throw new IllegalArgumentException("Un patient avec cet email existe déjà");
        }
        
        if (patient.getNumeroDossier() == null || patient.getNumeroDossier().trim().isEmpty()) {
            patient.setNumeroDossier(generateNumeroDossier());
        } else {
            if (patientRepository.existsByNumeroDossier(patient.getNumeroDossier(), null)) {
                throw new IllegalArgumentException("Ce numéro de dossier existe déjà");
            }
        }
        
        if (patient.getPersonne() != null) {
            patient.getPersonne().setTypePersonne(RoleUtilisateur.PATIENT);
            patient.getPersonne().setActif(true);
            patient.getPersonne().setDateCreation(LocalDateTime.now());
        }
        
        return patientRepository.save(patient);
    }
    
    @Override
    public Patient updatePatient(Patient patient) {
        if (patient.getIdPatient() == null) {
            throw new IllegalArgumentException("L'ID du patient est requis pour la mise à jour");
        }
        
        validatePatient(patient);
        
        Optional<Patient> existing = patientRepository.findById(patient.getIdPatient());
        if (existing.isEmpty()) {
            throw new IllegalArgumentException("Le patient avec l'ID " + patient.getIdPatient() + " n'existe pas");
        }
        
        if (patientRepository.existsByEmail(patient.getPersonne().getEmail(), patient.getIdPatient())) {
            throw new IllegalArgumentException("Un autre patient avec cet email existe déjà");
        }
        
        if (patient.getNumeroDossier() != null &&
            patientRepository.existsByNumeroDossier(patient.getNumeroDossier(), patient.getIdPatient())) {
            throw new IllegalArgumentException("Un autre patient avec ce numéro de dossier existe déjà");
        }
        
        return patientRepository.update(patient);
    }
    
    @Override
    public boolean deletePatient(Long id) {
        if (id == null || id <= 0) {
            throw new IllegalArgumentException("L'ID du patient est invalide");
        }
        
        Optional<Patient> patient = patientRepository.findById(id);
        if (patient.isEmpty()) {
            throw new IllegalArgumentException("Le patient avec l'ID " + id + " n'existe pas");
        }
        
        if (patient.get().getConsultations() != null && !patient.get().getConsultations().isEmpty()) {
            throw new IllegalStateException("Impossible de supprimer un patient ayant des consultations. " +
                    "Le patient a " + patient.get().getConsultations().size() + " consultation(s).");
        }
        
        return patientRepository.delete(id);
    }
    
    @Override
    public void validatePatient(Patient patient) {
        if (patient == null) {
            throw new IllegalArgumentException("Le patient ne peut pas être null");
        }
        
        if (patient.getPersonne() == null) {
            throw new IllegalArgumentException("Les informations personnelles du patient sont requises");
        }
        
        Personne personne = patient.getPersonne();
        
        if (personne.getNom() == null || personne.getNom().trim().isEmpty()) {
            throw new IllegalArgumentException("Le nom est obligatoire");
        }
        if (personne.getNom().length() > 100) {
            throw new IllegalArgumentException("Le nom ne doit pas dépasser 100 caractères");
        }
        
        if (personne.getPrenom() == null || personne.getPrenom().trim().isEmpty()) {
            throw new IllegalArgumentException("Le prénom est obligatoire");
        }
        if (personne.getPrenom().length() > 100) {
            throw new IllegalArgumentException("Le prénom ne doit pas dépasser 100 caractères");
        }
        
        if (personne.getEmail() == null || personne.getEmail().trim().isEmpty()) {
            throw new IllegalArgumentException("L'email est obligatoire");
        }
        if (!personne.getEmail().matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            throw new IllegalArgumentException("Format d'email invalide");
        }
        if (personne.getEmail().length() > 255) {
            throw new IllegalArgumentException("L'email ne doit pas dépasser 255 caractères");
        }
        
        if (patient.getNumeroDossier() != null && patient.getNumeroDossier().length() > 50) {
            throw new IllegalArgumentException("Le numéro de dossier ne doit pas dépasser 50 caractères");
        }
        
        if (patient.getGroupeSanguin() != null && !patient.getGroupeSanguin().trim().isEmpty()) {
            String groupeSanguin = patient.getGroupeSanguin().toUpperCase();
            if (!groupeSanguin.matches("^(A|B|AB|O)[+-]$")) {
                throw new IllegalArgumentException("Format de groupe sanguin invalide. " +
                        "Formats acceptés: A+, A-, B+, B-, AB+, AB-, O+, O-");
            }
        }
    }
    
    @Override
    public String generateNumeroDossier() {
        return "PAT-" + System.currentTimeMillis() + "-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
    }
    
    

    private void validateRegistrationData(String nom, String prenom, String email, String motDePasse) {
        if (nom == null || nom.trim().isEmpty()) {
            throw new IllegalArgumentException("Le nom est obligatoire");
        }
        if (prenom == null || prenom.trim().isEmpty()) {
            throw new IllegalArgumentException("Le prénom est obligatoire");
        }
        if (email == null || email.trim().isEmpty()) {
            throw new IllegalArgumentException("L'email est obligatoire");
        }
        if (!email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            throw new IllegalArgumentException("Format d'email invalide");
        }
        if (motDePasse == null || motDePasse.length() < 6) {
            throw new IllegalArgumentException("Le mot de passe doit contenir au moins 6 caractères");
        }
    }
}

