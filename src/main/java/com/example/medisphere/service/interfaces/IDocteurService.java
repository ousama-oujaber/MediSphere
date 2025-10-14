package com.example.medisphere.service.interfaces;

import com.example.medisphere.model.entity.Docteur;

import java.util.List;
import java.util.Optional;

/**
 * Service interface for Docteur business logic
 * Handles doctor management operations
 */
public interface IDocteurService {
    
    /**
     * Get all doctors
     * @return List of all doctors
     */
    List<Docteur> getAllDocteurs();
    
    /**
     * Get doctor by ID
     * @param id Doctor ID
     * @return Optional containing the doctor if found
     */
    Optional<Docteur> getDocteurById(Long id);
    
    /**
     * Create a new doctor
     * @param docteur Doctor to create
     * @return Created doctor
     */
    Docteur createDocteur(Docteur docteur);
    
    /**
     * Update an existing doctor
     * @param docteur Doctor to update
     * @return Updated doctor
     */
    Docteur updateDocteur(Docteur docteur);
    
    /**
     * Delete a doctor by ID
     * @param id Doctor ID
     * @return true if deleted successfully
     */
    boolean deleteDocteur(Long id);
    
    /**
     * Get doctors by specialty
     * @param specialite Specialty name
     * @return List of doctors with the given specialty
     */
    List<Docteur> getDocteursBySpecialite(String specialite);
    
    /**
     * Get doctors by department ID
     * @param departementId Department ID
     * @return List of doctors in the department
     */
    List<Docteur> getDocteursByDepartement(Long departementId);
    
    /**
     * Check if email already exists
     * @param email Email to check
     * @return true if email exists
     */
    boolean emailExists(String email);
    
    /**
     * Get total count of doctors
     * @return Total number of doctors
     */
    long countDocteurs();
}
