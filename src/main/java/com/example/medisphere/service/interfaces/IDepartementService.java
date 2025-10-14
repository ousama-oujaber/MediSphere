package com.example.medisphere.service.interfaces;

import com.example.medisphere.model.entity.Departement;
import java.util.List;
import java.util.Optional;

/**
 * Service interface for Departement management.
 * Defines business operations for department CRUD.
 */
public interface IDepartementService {
    
    /**
     * Create a new department
     * @param nom Department name (required, unique)
     * @param description Department description (optional)
     * @return Created department
     * @throws IllegalArgumentException if validation fails
     * @throws IllegalStateException if department already exists
     */
    Departement createDepartement(String nom, String description);
    
    /**
     * Get department by ID
     * @param id Department ID
     * @return Optional containing department if found
     */
    Optional<Departement> getDepartementById(Long id);
    
    /**
     * Get all departments
     * @return List of all departments ordered by name
     */
    List<Departement> getAllDepartements();
    
    /**
     * Get departments with their doctors loaded
     * @return List of departments with doctors
     */
    List<Departement> getDepartementsWithDocteurs();
    
    /**
     * Update existing department
     * @param id Department ID
     * @param nom New name (required, unique)
     * @param description New description (optional)
     * @return Updated department
     * @throws IllegalArgumentException if validation fails
     * @throws IllegalStateException if department not found or name already exists
     */
    Departement updateDepartement(Long id, String nom, String description);
    
    /**
     * Delete department by ID
     * @param id Department ID
     * @return true if deleted, false if not found
     * @throws IllegalStateException if department has associated doctors
     */
    boolean deleteDepartement(Long id);
    
    /**
     * Check if department name already exists
     * @param nom Department name
     * @return true if exists
     */
    boolean existsByNom(String nom);
    
    /**
     * Get total count of departments
     * @return Total number of departments
     */
    long countDepartements();
}
