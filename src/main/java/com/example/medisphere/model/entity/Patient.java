package com.example.medisphere.model.entity;

import com.example.medisphere.model.enums.RoleUtilisateur;
import jakarta.persistence.*;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

 
@Entity
@Table(name = "patient")
public class Patient {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_patient")
    private Long idPatient;

    @OneToOne(cascade = {CascadeType.PERSIST, CascadeType.MERGE}, fetch = FetchType.EAGER)
    @JoinColumn(name = "id_personne", nullable = false, unique = true)
    private Personne personne;

    @Column(name = "numero_dossier", unique = true, length = 50)
    private String numeroDossier;

    @Column(name = "poids", precision = 5, scale = 2)
    private BigDecimal poids;

    @Column(name = "taille", precision = 5, scale = 2)
    private BigDecimal taille;

    @Column(name = "groupe_sanguin", length = 5)
    private String groupeSanguin;

    @Lob
    @Column(name = "allergies", columnDefinition = "TEXT")
    private String allergies;

    @Lob
    @Column(name = "antecedents_medicaux", columnDefinition = "TEXT")
    private String antecedentsMedicaux;

    @OneToMany(mappedBy = "patient", cascade = {CascadeType.PERSIST, CascadeType.MERGE}, fetch = FetchType.LAZY)
    private List<Consultation> consultations = new ArrayList<>();

    
    public Patient() {
    }

    public Patient(Personne personne) {
        this.personne = personne;
        if (personne != null) {
            personne.setTypePersonne(RoleUtilisateur.PATIENT);
        }
    }

    public Patient(String nom, String prenom, String email, String motDePasse) {
        this.personne = new Personne(RoleUtilisateur.PATIENT, nom, prenom, email, motDePasse);
    }

    
    public void addConsultation(Consultation consultation) {
        consultations.add(consultation);
        consultation.setPatient(this);
    }

    public void removeConsultation(Consultation consultation) {
        consultations.remove(consultation);
        consultation.setPatient(null);
    }

    
    public BigDecimal calculerIMC() {
        if (poids != null && taille != null && taille.compareTo(BigDecimal.ZERO) > 0) {
            BigDecimal tailleEnMetres = taille.divide(new BigDecimal("100"), 2, java.math.RoundingMode.HALF_UP);
            return poids.divide(tailleEnMetres.multiply(tailleEnMetres), 2, java.math.RoundingMode.HALF_UP);
        }
        return null;
    }

    
    public Long getIdPatient() {
        return idPatient;
    }

    public void setIdPatient(Long idPatient) {
        this.idPatient = idPatient;
    }

    public Personne getPersonne() {
        return personne;
    }

    public void setPersonne(Personne personne) {
        this.personne = personne;
    }

    
    public String getNom() {
        return personne != null ? personne.getNom() : null;
    }

    public String getPrenom() {
        return personne != null ? personne.getPrenom() : null;
    }

    public String getEmail() {
        return personne != null ? personne.getEmail() : null;
    }

    public String getNomComplet() {
        return personne != null ? personne.getNomComplet() : null;
    }

    public String getNumeroDossier() {
        return numeroDossier;
    }

    public void setNumeroDossier(String numeroDossier) {
        this.numeroDossier = numeroDossier;
    }

    public BigDecimal getPoids() {
        return poids;
    }

    public void setPoids(BigDecimal poids) {
        this.poids = poids;
    }

    public BigDecimal getTaille() {
        return taille;
    }

    public void setTaille(BigDecimal taille) {
        this.taille = taille;
    }

    public String getGroupeSanguin() {
        return groupeSanguin;
    }

    public void setGroupeSanguin(String groupeSanguin) {
        this.groupeSanguin = groupeSanguin;
    }

    public String getAllergies() {
        return allergies;
    }

    public void setAllergies(String allergies) {
        this.allergies = allergies;
    }

    public String getAntecedentsMedicaux() {
        return antecedentsMedicaux;
    }

    public void setAntecedentsMedicaux(String antecedentsMedicaux) {
        this.antecedentsMedicaux = antecedentsMedicaux;
    }

    public List<Consultation> getConsultations() {
        return consultations;
    }

    public void setConsultations(List<Consultation> consultations) {
        this.consultations = consultations;
    }

    @Override
    public String toString() {
        return "Patient{" +
                "idPatient=" + idPatient +
                ", numeroDossier='" + numeroDossier + '\'' +
                ", nom='" + getNom() + '\'' +
                ", prenom='" + getPrenom() + '\'' +
                ", email='" + getEmail() + '\'' +
                '}';
    }
}
