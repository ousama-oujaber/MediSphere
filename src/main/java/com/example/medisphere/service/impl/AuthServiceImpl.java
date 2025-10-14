package com.example.medisphere.service.impl;

import com.example.medisphere.model.entity.Personne;
import com.example.medisphere.repository.impl.PersonneRepositoryImpl;
import com.example.medisphere.repository.interfaces.IPersonneRepository;
import com.example.medisphere.service.interfaces.IAuthService;
import com.example.medisphere.util.JPAUtil;

import jakarta.persistence.EntityManagerFactory;

public class AuthServiceImpl implements IAuthService {

    private final IPersonneRepository personneRepository;

    public AuthServiceImpl() {
        EntityManagerFactory emf = JPAUtil.getEntityManagerFactory();
        this.personneRepository = new PersonneRepositoryImpl(emf);
    }

    @Override
    public Personne authenticate(String email, String motDePasse) throws Exception {
        if (email == null || email.trim().isEmpty() || motDePasse == null || motDePasse.trim().isEmpty()) {
            return null;
        }

        var opt = personneRepository.findByEmail(email);
        if (opt.isEmpty()) {
            return null;
        }

        Personne personne = opt.get();
        if (motDePasse.equals(personne.getMotDePasse())) {
            return personne;
        }

        return null;
    }
}