package com.example.medisphere.service.interfaces;

import com.example.medisphere.model.entity.Personne;

public interface IAuthService {
	Personne authenticate(String email, String motDePasse) throws Exception;
}
