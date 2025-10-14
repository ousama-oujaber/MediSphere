package com.example.medisphere.service.interfaces;

import com.example.medisphere.model.entity.Personne;

public interface IAuthService {
	/**
	 * Authenticate a user by email and password.
	 * @param email user email
	 * @param motDePasse raw password (TODO: use hashed password in production)
	 * @return the authenticated Personne or null if credentials are invalid
	 */
	Personne authenticate(String email, String motDePasse) throws Exception;
}
