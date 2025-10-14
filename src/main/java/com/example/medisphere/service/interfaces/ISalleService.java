package com.example.medisphere.service.interfaces;

import com.example.medisphere.model.entity.Salle;

import java.time.LocalDateTime;
import java.util.List;

/**
 * Service interface for Salle management
 * Provides business logic for room operations
 */
public interface ISalleService {

    /**
     * Get all rooms
     * @return List of all rooms
     */
    List<Salle> getAllSalles();

    /**
     * Get a room by its ID
     * @param id Room ID
     * @return Room if found, null otherwise
     */
    Salle getSalleById(Long id);

    /**
     * Create a new room
     * @param salle Room to create
     * @return Created room
     */
    Salle createSalle(Salle salle);

    /**
     * Update an existing room
     * @param salle Room to update
     * @return Updated room
     */
    Salle updateSalle(Salle salle);

    /**
     * Delete a room
     * @param id Room ID
     * @return true if deleted, false otherwise
     */
    boolean deleteSalle(Long id);

    /**
     * Get all available rooms
     * @return List of available rooms
     */
    List<Salle> getAvailableSalles();

    /**
     * Get rooms by floor number
     * @param numeroEtage Floor number
     * @return List of rooms on the specified floor
     */
    List<Salle> getSallesByEtage(Integer numeroEtage);

    /**
     * Get rooms with minimum capacity
     * @param minCapacite Minimum capacity
     * @return List of rooms with at least the specified capacity
     */
    List<Salle> getSallesByMinCapacite(Integer minCapacite);

    /**
     * Check if room is available at specific time
     * @param salleId Room ID
     * @param dateHeure Date and time
     * @return true if available, false otherwise
     */
    boolean isRoomAvailable(Long salleId, LocalDateTime dateHeure);

    /**
     * Get room occupation rate
     * @param salleId Room ID
     * @param dateDebut Start date
     * @param dateFin End date
     * @return Occupation rate percentage
     */
    double getOccupationRate(Long salleId, LocalDateTime dateDebut, LocalDateTime dateFin);

    /**
     * Validate room data before save/update
     * @param salle Room to validate
     * @return Validation message, null if valid
     */
    String validateSalle(Salle salle);
}
