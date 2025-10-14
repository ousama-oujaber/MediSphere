package com.example.medisphere.service.impl;

import com.example.medisphere.model.entity.Salle;
import com.example.medisphere.repository.impl.SalleRepositoryImpl;
import com.example.medisphere.repository.interfaces.ISalleRepository;
import com.example.medisphere.service.interfaces.ISalleService;
import com.example.medisphere.util.JPAUtil;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public class SalleServiceImpl implements ISalleService {

    private final ISalleRepository salleRepository;

    public SalleServiceImpl() {
        this.salleRepository = new SalleRepositoryImpl(JPAUtil.getEntityManagerFactory());
    }

    public SalleServiceImpl(ISalleRepository salleRepository) {
        this.salleRepository = salleRepository;
    }

    @Override
    public List<Salle> getAllSalles() {
        return salleRepository.findAll();
    }

    @Override
    public Salle getSalleById(Long id) {
        Optional<Salle> salle = salleRepository.findById(id);
        return salle.orElse(null);
    }

    @Override
    public Salle createSalle(Salle salle) {
        String validationError = validateSalle(salle);
        if (validationError != null) {
            throw new IllegalArgumentException(validationError);
        }

        if (salleRepository.existsByNomSalle(salle.getNomSalle())) {
            throw new IllegalArgumentException("Une salle avec ce nom existe déjà");
        }

        if (salle.getDisponible() == null) {
            salle.setDisponible(true);
        }

        return salleRepository.save(salle);
    }

    @Override
    public Salle updateSalle(Salle salle) {
        Optional<Salle> existing = salleRepository.findById(salle.getIdSalle());
        if (existing.isEmpty()) {
            throw new IllegalArgumentException("Salle non trouvée");
        }

        String validationError = validateSalle(salle);
        if (validationError != null) {
            throw new IllegalArgumentException(validationError);
        }

        Optional<Salle> salleWithSameName = salleRepository.findByNomSalle(salle.getNomSalle());
        if (salleWithSameName.isPresent() && !salleWithSameName.get().getIdSalle().equals(salle.getIdSalle())) {
            throw new IllegalArgumentException("Une autre salle avec ce nom existe déjà");
        }

        return salleRepository.update(salle);
    }

    @Override
    public boolean deleteSalle(Long id) {
        Optional<Salle> salle = salleRepository.findById(id);
        if (salle.isEmpty()) {
            throw new IllegalArgumentException("Salle non trouvée");
        }

        if (!salle.get().getConsultations().isEmpty()) {
            throw new IllegalArgumentException("Impossible de supprimer une salle avec des consultations");
        }

        return salleRepository.delete(id);
    }

    @Override
    public List<Salle> getAvailableSalles() {
        return salleRepository.findAll().stream()
                .filter(Salle::getDisponible)
                .toList();
    }

    @Override
    public List<Salle> getSallesByEtage(Integer numeroEtage) {
        return salleRepository.findAll().stream()
                .filter(s -> s.getNumeroEtage() != null && s.getNumeroEtage().equals(numeroEtage))
                .toList();
    }

    @Override
    public List<Salle> getSallesByMinCapacite(Integer minCapacite) {
        return salleRepository.findByCapaciteGreaterThanEqual(minCapacite);
    }

    @Override
    public boolean isRoomAvailable(Long salleId, LocalDateTime dateHeure) {
        return salleRepository.isRoomAvailable(salleId, dateHeure);
    }

    @Override
    public double getOccupationRate(Long salleId, LocalDateTime dateDebut, LocalDateTime dateFin) {
        return salleRepository.getOccupationRate(salleId, dateDebut, dateFin);
    }

    @Override
    public String validateSalle(Salle salle) {
        if (salle == null) {
            return "La salle ne peut pas être nulle";
        }

        if (salle.getNomSalle() == null || salle.getNomSalle().trim().isEmpty()) {
            return "Le nom de la salle est obligatoire";
        }

        if (salle.getNomSalle().length() > 50) {
            return "Le nom de la salle ne peut pas dépasser 50 caractères";
        }

        if (salle.getNumeroEtage() != null && salle.getNumeroEtage() < 0) {
            return "Le numéro d'étage ne peut pas être négatif";
        }

        if (salle.getCapacite() != null && salle.getCapacite() < 1) {
            return "La capacité doit être au moins 1";
        }

        return null;
    }
}

