package com.example.medisphere.model.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "departement")
public class Departement {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_departement")
    private Long idDepartement;

    @Column(name = "nom", nullable = false, unique = true, length = 100)
    private String nom;

    @Lob
    @Column(name = "description", columnDefinition = "TEXT")
    private String description;

    @Column(name = "date_creation", updatable = false)
    private LocalDateTime dateCreation;

    @OneToMany(mappedBy = "departement", cascade = {CascadeType.PERSIST, CascadeType.MERGE})
    private List<Docteur> docteurs = new ArrayList<>();

    public Departement() {
    }

    public Departement(String nom, String description) {
        this.nom = nom;
        this.description = description;
    }

    public Long getIdDepartement() {
        return idDepartement;
    }

    public void setIdDepartement(Long idDepartement) {
        this.idDepartement = idDepartement;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public LocalDateTime getDateCreation() {
        return dateCreation;
    }

    public void setDateCreation(LocalDateTime dateCreation) {
        this.dateCreation = dateCreation;
    }

    public List<Docteur> getDocteurs() {
        return docteurs;
    }

    public void setDocteurs(List<Docteur> docteurs) {
        this.docteurs = docteurs;
    }

    @Override
    public String toString() {
        return "Departement{" +
                "idDepartement=" + idDepartement +
                ", nom='" + nom + '\'' +
                ", description='" + description + '\'' +
                ", dateCreation=" + dateCreation +
                '}';
    }
}
