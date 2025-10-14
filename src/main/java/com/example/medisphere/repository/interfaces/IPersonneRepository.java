package com.example.medisphere.repository.interfaces;

import com.example.medisphere.model.entity.Personne;
import com.example.medisphere.model.enums.RoleUtilisateur;

import java.util.Optional;

public interface IPersonneRepository {
    Optional<Personne> findByEmail(String email);
    Optional<Personne> findById(Long id);
    Personne save(Personne personne);
    boolean existsByEmail(String email);
    Optional<Personne> findByEmailAndType(String email, RoleUtilisateur type);
}
