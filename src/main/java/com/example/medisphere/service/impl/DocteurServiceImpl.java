package com.example.medisphere.service.impl;

import com.example.medisphere.model.entity.Docteur;
import com.example.medisphere.repository.impl.DocteurRepositoryImpl;
import com.example.medisphere.repository.interfaces.IDocteurRepository;
import com.example.medisphere.service.interfaces.IDocteurService;
import com.example.medisphere.util.JPAUtil;

import java.util.List;
import java.util.Optional;

public class DocteurServiceImpl implements IDocteurService {
    
    private final IDocteurRepository docteurRepository;
    
    public DocteurServiceImpl() {
        this.docteurRepository = new DocteurRepositoryImpl(JPAUtil.getEntityManagerFactory());
    }
    
    public DocteurServiceImpl(IDocteurRepository docteurRepository) {
        this.docteurRepository = docteurRepository;
    }

    @Override
    public List<Docteur> getAllDocteurs() {
        return docteurRepository.findAll();
    }

    @Override
    public Optional<Docteur> getDocteurById(Long id) {
        if (id == null || id <= 0) {
            throw new IllegalArgumentException("Doctor ID must be positive");
        }
        return docteurRepository.findById(id);
    }

    @Override
    public Docteur createDocteur(Docteur docteur) {
        validateDocteur(docteur);
        
        if (docteurRepository.existsByEmail(docteur.getEmail())) {
            throw new IllegalArgumentException("Email already exists: " + docteur.getEmail());
        }
        
        return docteurRepository.save(docteur);
    }

    @Override
    public Docteur updateDocteur(Docteur docteur) {
        if (docteur.getIdDocteur() == null) {
            throw new IllegalArgumentException("Doctor ID is required for update");
        }
        
        validateDocteur(docteur);
        
        Optional<Docteur> existing = docteurRepository.findById(docteur.getIdDocteur());
        if (existing.isEmpty()) {
            throw new IllegalArgumentException("Doctor not found with ID: " + docteur.getIdDocteur());
        }
        
        return docteurRepository.update(docteur);
    }

    @Override
    public boolean deleteDocteur(Long id) {
        if (id == null || id <= 0) {
            throw new IllegalArgumentException("Doctor ID must be positive");
        }
        
        Optional<Docteur> existing = docteurRepository.findById(id);
        if (existing.isEmpty()) {
            throw new IllegalArgumentException("Doctor not found with ID: " + id);
        }
        
        return docteurRepository.delete(id);
    }

    @Override
    public List<Docteur> getDocteursBySpecialite(String specialite) {
        if (specialite == null || specialite.trim().isEmpty()) {
            throw new IllegalArgumentException("Specialty cannot be empty");
        }
        return docteurRepository.findBySpecialite(specialite);
    }

    @Override
    public List<Docteur> getDocteursByDepartement(Long departementId) {
        if (departementId == null || departementId <= 0) {
            throw new IllegalArgumentException("Department ID must be positive");
        }
        return docteurRepository.findByDepartementId(departementId);
    }

    @Override
    public boolean emailExists(String email) {
        if (email == null || email.trim().isEmpty()) {
            return false;
        }
        return docteurRepository.existsByEmail(email);
    }

    @Override
    public long countDocteurs() {
        return docteurRepository.count();
    }

    private void validateDocteur(Docteur docteur) {
        if (docteur == null) {
            throw new IllegalArgumentException("Doctor cannot be null");
        }
        
        if (docteur.getPersonne() == null) {
            throw new IllegalArgumentException("Doctor must have a person associated");
        }
        
        if (docteur.getSpecialite() == null || docteur.getSpecialite().trim().isEmpty()) {
            throw new IllegalArgumentException("Specialty is required");
        }
        
        if (docteur.getDepartement() == null) {
            throw new IllegalArgumentException("Department is required");
        }
        
        if (docteur.getNom() == null || docteur.getNom().trim().isEmpty()) {
            throw new IllegalArgumentException("Last name is required");
        }
        
        if (docteur.getPrenom() == null || docteur.getPrenom().trim().isEmpty()) {
            throw new IllegalArgumentException("First name is required");
        }
        
        if (docteur.getEmail() == null || docteur.getEmail().trim().isEmpty()) {
            throw new IllegalArgumentException("Email is required");
        }
        
        if (!docteur.getEmail().matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            throw new IllegalArgumentException("Invalid email format");
        }
    }
}
