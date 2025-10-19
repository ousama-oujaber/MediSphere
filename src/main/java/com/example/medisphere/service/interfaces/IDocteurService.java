package com.example.medisphere.service.interfaces;

import com.example.medisphere.model.entity.Docteur;

import java.util.List;
import java.util.Optional;

 
public interface IDocteurService {
    
    
    List<Docteur> getAllDocteurs();
    
    
    Optional<Docteur> getDocteurById(Long id);
    
    
    Docteur createDocteur(Docteur docteur);
    
    
    Docteur updateDocteur(Docteur docteur);
    
    
    boolean deleteDocteur(Long id);
    
    
    List<Docteur> getDocteursBySpecialite(String specialite);
    
    
    List<Docteur> getDocteursByDepartement(Long departementId);
    
    
    Optional<Docteur> getDocteurByEmail(String email);
    
    
    boolean emailExists(String email);
    
    
    long countDocteurs();
}
