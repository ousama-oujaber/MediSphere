package com.example.medisphere.model.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

 
@Entity
@Table(name = "salle")
public class Salle {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_salle")
    private Long idSalle;

    @Column(name = "nom_salle", nullable = false, unique = true, length = 50)
    private String nomSalle;

    @Column(name = "numero_etage")
    private Integer numeroEtage;

    @Column(name = "capacite")
    private Integer capacite;

    @Lob
    @Column(name = "equipements", columnDefinition = "TEXT")
    private String equipements;

    @Column(name = "disponible")
    private Boolean disponible = true;

    @Column(name = "date_creation", updatable = false)
    private LocalDateTime dateCreation;

    @OneToMany(mappedBy = "salle", cascade = {CascadeType.PERSIST, CascadeType.MERGE})
    private List<Consultation> consultations = new ArrayList<>();

    
    public Salle() {
    }

    public Salle(String nomSalle, Integer numeroEtage, Integer capacite) {
        this.nomSalle = nomSalle;
        this.numeroEtage = numeroEtage;
        this.capacite = capacite;
        this.disponible = true;
    }

    
    @PrePersist
    protected void onCreate() {
        dateCreation = LocalDateTime.now();
    }

    
    public void addConsultation(Consultation consultation) {
        consultations.add(consultation);
        consultation.setSalle(this);
    }

    public void removeConsultation(Consultation consultation) {
        consultations.remove(consultation);
        consultation.setSalle(null);
    }

    
    public Long getIdSalle() {
        return idSalle;
    }

    public void setIdSalle(Long idSalle) {
        this.idSalle = idSalle;
    }

    public String getNomSalle() {
        return nomSalle;
    }

    public void setNomSalle(String nomSalle) {
        this.nomSalle = nomSalle;
    }

    public Integer getNumeroEtage() {
        return numeroEtage;
    }

    public void setNumeroEtage(Integer numeroEtage) {
        this.numeroEtage = numeroEtage;
    }

    public Integer getCapacite() {
        return capacite;
    }

    public void setCapacite(Integer capacite) {
        this.capacite = capacite;
    }

    public String getEquipements() {
        return equipements;
    }

    public void setEquipements(String equipements) {
        this.equipements = equipements;
    }

    public Boolean getDisponible() {
        return disponible;
    }

    public void setDisponible(Boolean disponible) {
        this.disponible = disponible;
    }

    public LocalDateTime getDateCreation() {
        return dateCreation;
    }

    public void setDateCreation(LocalDateTime dateCreation) {
        this.dateCreation = dateCreation;
    }

    public List<Consultation> getConsultations() {
        return consultations;
    }

    public void setConsultations(List<Consultation> consultations) {
        this.consultations = consultations;
    }

    
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Salle salle = (Salle) o;
        return Objects.equals(nomSalle, salle.nomSalle);
    }

    @Override
    public int hashCode() {
        return Objects.hash(nomSalle);
    }

    @Override
    public String toString() {
        return "Salle{" +
                "idSalle=" + idSalle +
                ", nomSalle='" + nomSalle + '\'' +
                ", numeroEtage=" + numeroEtage +
                ", capacite=" + capacite +
                ", disponible=" + disponible +
                '}';
    }
}
