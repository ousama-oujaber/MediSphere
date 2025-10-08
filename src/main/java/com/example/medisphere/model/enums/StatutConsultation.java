package com.example.medisphere.model.enums;

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

    public static StatutConsultation fromString(String text) {
        for (StatutConsultation statut : StatutConsultation.values()) {
            if (statut.name().equalsIgnoreCase(text)) {
                return statut;
            }
        }
        throw new IllegalArgumentException("Statut de consultation invalide: " + text);
    }
}
