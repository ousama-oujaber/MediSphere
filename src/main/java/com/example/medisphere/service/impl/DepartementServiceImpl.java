package com.example.medisphere.service.impl;

import com.example.medisphere.model.entity.Departement;
import com.example.medisphere.repository.interfaces.IDepartementRepository;
import com.example.medisphere.service.interfaces.IDepartementService;

import java.util.List;
import java.util.Optional;

public class DepartementServiceImpl implements IDepartementService {

    private final IDepartementRepository departementRepository;

    public DepartementServiceImpl(IDepartementRepository departementRepository) {
        this.departementRepository = departementRepository;
    }

    @Override
    public Departement createDepartement(String nom, String description) {
        validateNom(nom);
        
        if (departementRepository.existsByNom(nom.trim())) {
            throw new IllegalStateException("Un département avec ce nom existe déjà");
        }

        Departement departement = new Departement(nom.trim(), description != null ? description.trim() : null);
        
        return departementRepository.save(departement);
    }

    @Override
    public Optional<Departement> getDepartementById(Long id) {
        if (id == null || id <= 0) {
            throw new IllegalArgumentException("ID du département invalide");
        }
        return departementRepository.findById(id);
    }

    @Override
    public List<Departement> getAllDepartements() {
        return departementRepository.findAll();
    }

    @Override
    public List<Departement> getDepartementsWithDocteurs() {
        return departementRepository.findDepartementsWithDocteurs();
    }

    @Override
    public Departement updateDepartement(Long id, String nom, String description) {

        if (id == null || id <= 0) {
            throw new IllegalArgumentException("ID du département invalide");
        }
        validateNom(nom);

        Departement departement = departementRepository.findById(id)
            .orElseThrow(() -> new IllegalStateException("Département introuvable"));

        String trimmedNom = nom.trim();
        if (!departement.getNom().equals(trimmedNom) && departementRepository.existsByNom(trimmedNom)) {
            throw new IllegalStateException("Un département avec ce nom existe déjà");
        }

        departement.setNom(trimmedNom);
        departement.setDescription(description != null ? description.trim() : null);

        return departementRepository.update(departement);
    }

    @Override
    public boolean deleteDepartement(Long id) {
        if (id == null || id <= 0) {
            throw new IllegalArgumentException("ID du département invalide");
        }

        Optional<Departement> optDepartement = departementRepository.findById(id);
        if (optDepartement.isPresent()) {
            Departement departement = optDepartement.get();
            if (departement.getDocteurs() != null && !departement.getDocteurs().isEmpty()) {
                throw new IllegalStateException(
                    "Impossible de supprimer un département ayant des docteurs associés"
                );
            }
        }

        return departementRepository.delete(id);
    }

    @Override
    public boolean existsByNom(String nom) {
        if (nom == null || nom.trim().isEmpty()) {
            return false;
        }
        return departementRepository.existsByNom(nom.trim());
    }

    @Override
    public long countDepartements() {
        return departementRepository.count();
    }

    private void validateNom(String nom) {
        if (nom == null || nom.trim().isEmpty()) {
            throw new IllegalArgumentException("Le nom du département est requis");
        }
        if (nom.trim().length() < 2) {
            throw new IllegalArgumentException("Le nom du département doit contenir au moins 2 caractères");
        }
        if (nom.trim().length() > 100) {
            throw new IllegalArgumentException("Le nom du département ne peut pas dépasser 100 caractères");
        }
    }
}
