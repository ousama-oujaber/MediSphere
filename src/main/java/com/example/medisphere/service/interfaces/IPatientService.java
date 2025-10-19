package com.example.medisphere.service.interfaces;

import com.example.medisphere.model.entity.Patient;
import java.util.List;
import java.util.Optional;

 
public interface IPatientService {
    
    
    Patient registerPatient(String nom, String prenom, String email, String motDePasse, String telephone);
    Patient findByEmail(String email);
    Patient findById(Long id);
    boolean emailExists(String email);
    long getTotalPatients();
    
    
    
    List<Patient> getAllPatients();
    
    
    Optional<Patient> getPatientById(Long id);
    
    
    Optional<Patient> getPatientByNumeroDossier(String numeroDossier);
    
    
    List<Patient> searchPatients(String keyword);
    
    
    List<Patient> getPatientsByGroupeSanguin(String groupeSanguin);
    
    
    Patient createPatient(Patient patient);
    
    
    Patient updatePatient(Patient patient);
    
    
    boolean deletePatient(Long id);
    
    
    void validatePatient(Patient patient);
    
    
    String generateNumeroDossier();
}

