package com.example.medisphere.model.entity;

import com.example.medisphere.model.enums.RoleUtilisateur;
import jakarta.persistence.*;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;


@Entity
@Table(name = "docteur")
public class Docteur {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_docteur")
    private Long idDocteur;

    @OneToOne(cascade = {CascadeType.PERSIST, CascadeType.MERGE}, fetch = FetchType.EAGER)
    @JoinColumn(name = "id_personne", nullable = false, unique = true)
    private Personne personne;

    @Column(name = "specialite", nullable = false, length = 100)
    private String specialite;

    @Column(name = "numero_ordre", unique = true, length = 50)
    private String numeroOrdre;

    @Column(name = "annees_experience")
    private Integer anneesExperience;

    @Lob
    @Column(name = "biographie", columnDefinition = "TEXT")
    private String biographie;

    @Column(name = "tarif_consultation", precision = 10, scale = 2)
    private BigDecimal tarifConsultation;

    @Column(name = "disponible")
    private Boolean disponible = true;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "id_departement", nullable = false)
    private Departement departement;

    @OneToMany(mappedBy = "docteur", cascade = {CascadeType.PERSIST, CascadeType.MERGE}, fetch = FetchType.LAZY)
    private List<Consultation> consultations = new ArrayList<>();

    // Constructeurs
    public Docteur() {
    }

    public Docteur(Personne personne, String specialite) {
        this.personne = personne;
        this.specialite = specialite;
        this.disponible = true;
        if (personne != null) {
            personne.setTypePersonne(RoleUtilisateur.DOCTEUR);
        }
    }

    public Docteur(String nom, String prenom, String email, String motDePasse, String specialite) {
        this.personne = new Personne(RoleUtilisateur.DOCTEUR, nom, prenom, email, motDePasse);
        this.specialite = specialite;
        this.disponible = true;
    }

    // Méthodes utilitaires pour les relations bidirectionnelles
    public void addConsultation(Consultation consultation) {
        consultations.add(consultation);
        consultation.setDocteur(this);
    }

    public void removeConsultation(Consultation consultation) {
        consultations.remove(consultation);
        consultation.setDocteur(null);
    }

    // Getters et Setters
    public Long getIdDocteur() {
        return idDocteur;
    }

    public void setIdDocteur(Long idDocteur) {
        this.idDocteur = idDocteur;
    }

    public Personne getPersonne() {
        return personne;
    }

    public void setPersonne(Personne personne) {
        this.personne = personne;
    }

    // Méthodes de délégation pour accéder facilement aux données de Personne
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

    public String getSpecialite() {
        return specialite;
    }

    public void setSpecialite(String specialite) {
        this.specialite = specialite;
    }

    public String getNumeroOrdre() {
        return numeroOrdre;
    }

    public void setNumeroOrdre(String numeroOrdre) {
        this.numeroOrdre = numeroOrdre;
    }

    public Integer getAnneesExperience() {
        return anneesExperience;
    }

    public void setAnneesExperience(Integer anneesExperience) {
        this.anneesExperience = anneesExperience;
    }

    public String getBiographie() {
        return biographie;
    }

    public void setBiographie(String biographie) {
        this.biographie = biographie;
    }

    public BigDecimal getTarifConsultation() {
        return tarifConsultation;
    }

    public void setTarifConsultation(BigDecimal tarifConsultation) {
        this.tarifConsultation = tarifConsultation;
    }

    public Boolean getDisponible() {
        return disponible;
    }

    public void setDisponible(Boolean disponible) {
        this.disponible = disponible;
    }

    public Departement getDepartement() {
        return departement;
    }

    public void setDepartement(Departement departement) {
        this.departement = departement;
    }

    public List<Consultation> getConsultations() {
        return consultations;
    }

    public void setConsultations(List<Consultation> consultations) {
        this.consultations = consultations;
    }

    @Override
    public String toString() {
        return "Docteur{" +
                "idDocteur=" + idDocteur +
                ", specialite='" + specialite + '\'' +
                ", nom='" + getNom() + '\'' +
                ", prenom='" + getPrenom() + '\'' +
                ", email='" + getEmail() + '\'' +
                ", disponible=" + disponible +
                '}';
    }
}
