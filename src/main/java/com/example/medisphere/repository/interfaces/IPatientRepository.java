package com.example.medisphere.repository.interfaces;

import com.example.medisphere.model.entity.Patient;
import java.util.List;
import java.util.Optional;

public interface IPatientRepository {
    Patient save(Patient patient);
    Optional<Patient> findById(Long id);
    Optional<Patient> findByEmail(String email);
    Optional<Patient> findByNumeroDossier(String numeroDossier);
    List<Patient> findAll();
    List<Patient> searchByKeyword(String keyword);
    List<Patient> findByGroupeSanguin(String groupeSanguin);
    boolean delete(Long id);
    boolean existsByEmail(String email);
    boolean existsByEmail(String email, Long excludeId);
    boolean existsByNumeroDossier(String numeroDossier, Long excludeId);
    long count();
    Patient update(Patient patient);
}
