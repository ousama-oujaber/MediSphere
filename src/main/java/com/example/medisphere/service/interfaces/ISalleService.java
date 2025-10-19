package com.example.medisphere.service.interfaces;

import com.example.medisphere.model.entity.Salle;

import java.time.LocalDateTime;
import java.util.List;

 
public interface ISalleService {

    
    List<Salle> getAllSalles();

    
    Salle getSalleById(Long id);

    
    Salle createSalle(Salle salle);

    
    Salle updateSalle(Salle salle);

    
    boolean deleteSalle(Long id);

    
    List<Salle> getAvailableSalles();

    
    List<Salle> getSallesByEtage(Integer numeroEtage);

    
    List<Salle> getSallesByMinCapacite(Integer minCapacite);

    
    boolean isRoomAvailable(Long salleId, LocalDateTime dateHeure);

    
    double getOccupationRate(Long salleId, LocalDateTime dateDebut, LocalDateTime dateFin);

    
    String validateSalle(Salle salle);
}
