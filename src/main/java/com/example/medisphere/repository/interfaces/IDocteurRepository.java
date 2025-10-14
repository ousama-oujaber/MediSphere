package com.example.medisphere.repository.interfaces;

import com.example.medisphere.model.entity.Docteur;
import com.example.medisphere.model.entity.Departement;
import java.util.List;
import java.util.Optional;

public interface IDocteurRepository {
    Docteur save(Docteur docteur);
    Optional<Docteur> findById(Long id);
    Optional<Docteur> findByEmail(String email);
    List<Docteur> findAll();
    List<Docteur> findByDepartement(Departement departement);
    List<Docteur> findByDepartementId(Long departementId);
    List<Docteur> findBySpecialite(String specialite);
    boolean delete(Long id);
    boolean existsByEmail(String email);
    long count();
    Docteur update(Docteur docteur);
}
