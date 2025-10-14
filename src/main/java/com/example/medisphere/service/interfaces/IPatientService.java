package com.example.medisphere.service.interfaces;

import com.example.medisphere.model.entity.Patient;
import java.util.List;
import java.util.Optional;

/**
 * Interface du service pour la gestion des patients
 */
public interface IPatientService {
    
    // Méthodes existantes pour l'enregistrement
    Patient registerPatient(String nom, String prenom, String email, String motDePasse, String telephone);
    Patient findByEmail(String email);
    Patient findById(Long id);
    boolean emailExists(String email);
    long getTotalPatients();
    
    // Nouvelles méthodes pour l'admin
    /**
     * Récupère tous les patients
     */
    List<Patient> getAllPatients();
    
    /**
     * Recherche un patient par son ID
     */
    Optional<Patient> getPatientById(Long id);
    
    /**
     * Recherche un patient par son numéro de dossier
     */
    Optional<Patient> getPatientByNumeroDossier(String numeroDossier);
    
    /**
     * Recherche des patients par mot-clé (nom, prénom, email, numéro de dossier)
     */
    List<Patient> searchPatients(String keyword);
    
    /**
     * Recherche des patients par groupe sanguin
     */
    List<Patient> getPatientsByGroupeSanguin(String groupeSanguin);
    
    /**
     * Crée un nouveau patient
     */
    Patient createPatient(Patient patient);
    
    /**
     * Met à jour un patient existant
     */
    Patient updatePatient(Patient patient);
    
    /**
     * Supprime un patient par son ID
     */
    boolean deletePatient(Long id);
    
    /**
     * Valide les données d'un patient
     */
    void validatePatient(Patient patient);
    
    /**
     * Génère un numéro de dossier unique
     */
    String generateNumeroDossier();
}

