package com.example.medisphere.service.interfaces;

import com.example.medisphere.model.entity.Departement;
import java.util.List;
import java.util.Optional;

 
public interface IDepartementService {
    
    
    Departement createDepartement(String nom, String description);
    
    
    Optional<Departement> getDepartementById(Long id);
    
    
    List<Departement> getAllDepartements();
    
    
    List<Departement> getDepartementsWithDocteurs();
    
    
    Departement updateDepartement(Long id, String nom, String description);
    
    
    boolean deleteDepartement(Long id);
    
    
    boolean existsByNom(String nom);
    
    
    long countDepartements();
}
