package com.example.medisphere.model.enums;

/**
 * Enum représentant les différents statuts d'une consultation
 */
public enum StatutConsultation {
    RESERVEE("Réservée"),
    VALIDEE("Validée"),
    ANNULEE("Annulée"),
    TERMINEE("Terminée");

    private final String label;

    StatutConsultation(String label) {
        this.label = label;
    }

    public String getLabel() {
        return label;
    }

    /**
     * Retourne l'enum à partir d'une chaîne
     */
    public static StatutConsultation fromString(String text) {
        for (StatutConsultation statut : StatutConsultation.values()) {
            if (statut.name().equalsIgnoreCase(text)) {
                return statut;
            }
        }
        throw new IllegalArgumentException("Statut de consultation invalide: " + text);
    }
}
