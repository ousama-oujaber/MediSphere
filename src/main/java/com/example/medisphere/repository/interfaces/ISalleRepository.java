package com.example.medisphere.repository.interfaces;

import com.example.medisphere.model.entity.Salle;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public interface ISalleRepository {
    Salle save(Salle salle);
    Optional<Salle> findById(Long id);
    Optional<Salle> findByNomSalle(String nomSalle);
    List<Salle> findAll();
    List<Salle> findAvailableRooms(LocalDateTime dateHeure);
    boolean isRoomAvailable(Long salleId, LocalDateTime dateHeure);
    List<Salle> findByCapaciteGreaterThanEqual(Integer capacite);
    double getOccupationRate(Long salleId, LocalDateTime dateDebut, LocalDateTime dateFin);
    double getGlobalOccupationRate(LocalDateTime dateDebut, LocalDateTime dateFin);
    List<LocalDateTime> getOccupiedSlots(Long salleId);
    List<LocalDateTime> getOccupiedSlotsBetween(Long salleId, LocalDateTime dateDebut, LocalDateTime dateFin);
    Salle update(Salle salle);
    boolean delete(Long id);
    boolean existsByNomSalle(String nomSalle);
    long count();
}
