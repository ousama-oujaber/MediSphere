package com.example.medisphere.repository.interfaces;

import com.example.medisphere.model.entity.Departement;
import java.util.List;
import java.util.Optional;

public interface IDepartementRepository {
    Departement save(Departement departement);
    Optional<Departement> findById(Long id);
    Optional<Departement> findByNom(String nom);
    List<Departement> findAll();
    Departement update(Departement departement);
    boolean delete(Long id);
    boolean existsByNom(String nom);
    long count();
    List<Departement> findDepartementsWithDocteurs();
}
