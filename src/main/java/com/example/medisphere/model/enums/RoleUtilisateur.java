package com.example.medisphere.model.enums;

/**
 * Enum représentant les différents rôles d'utilisateur dans le système
 */
public enum RoleUtilisateur {
    PATIENT("Patient"),
    DOCTEUR("Docteur"),
    ADMIN("Administrateur");

    private final String label;

    RoleUtilisateur(String label) {
        this.label = label;
    }

    public String getLabel() {
        return label;
    }

    /**
     * Retourne l'enum à partir d'une chaîne
     */
    public static RoleUtilisateur fromString(String text) {
        for (RoleUtilisateur role : RoleUtilisateur.values()) {
            if (role.name().equalsIgnoreCase(text)) {
                return role;
            }
        }
        throw new IllegalArgumentException("Rôle utilisateur invalide: " + text);
    }
}
