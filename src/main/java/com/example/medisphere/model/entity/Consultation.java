package com.example.medisphere.model.entity;

import com.example.medisphere.model.enums.StatutConsultation;
import jakarta.persistence.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

@Entity
@Table(
    name = "consultation",
    uniqueConstraints = @UniqueConstraint(
        name = "unique_patient_datetime",
        columnNames = {"id_patient", "date_heure_debut"}
    )
)
public class Consultation {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_consultation")
    private Long idConsultation;

    @Column(name = "date_consultation", nullable = false)
    private LocalDate dateConsultation;

    @Column(name = "heure_consultation", nullable = false)
    private LocalTime heureConsultation;

    @Column(name = "date_heure_debut", nullable = false)
    private LocalDateTime dateHeureDebut;

    @Column(name = "date_heure_fin", nullable = false)
    private LocalDateTime dateHeureFin;

    @Enumerated(EnumType.STRING)
    @Column(name = "statut", nullable = false, length = 20)
    private StatutConsultation statut = StatutConsultation.RESERVEE;

    @Lob
    @Column(name = "motif_consultation", nullable = false, columnDefinition = "TEXT")
    private String motifConsultation;

    @Lob
    @Column(name = "compte_rendu", columnDefinition = "TEXT")
    private String compteRendu;

    @Lob
    @Column(name = "diagnostic", columnDefinition = "TEXT")
    private String diagnostic;

    @Lob
    @Column(name = "traitement_prescrit", columnDefinition = "TEXT")
    private String traitementPrescrit;

    @Lob
    @Column(name = "observations", columnDefinition = "TEXT")
    private String observations;

    @Column(name = "date_creation", updatable = false)
    private LocalDateTime dateCreation;

    @Column(name = "date_modification")
    private LocalDateTime dateModification;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_patient", nullable = false)
    private Patient patient;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_docteur", nullable = false)
    private Docteur docteur;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_salle", nullable = false)
    private Salle salle;

    public Consultation() {
    }

    public Consultation(LocalDate dateConsultation, LocalTime heureConsultation, String motifConsultation) {
        this.dateConsultation = dateConsultation;
        this.heureConsultation = heureConsultation;
        this.motifConsultation = motifConsultation;
        this.statut = StatutConsultation.RESERVEE;
        
        this.dateHeureDebut = LocalDateTime.of(dateConsultation, heureConsultation);
        this.dateHeureFin = this.dateHeureDebut.plusMinutes(30);
    }

    public Long getIdConsultation() {
        return idConsultation;
    }

    public void setIdConsultation(Long idConsultation) {
        this.idConsultation = idConsultation;
    }

    public LocalDate getDateConsultation() {
        return dateConsultation;
    }

    public void setDateConsultation(LocalDate dateConsultation) {
        this.dateConsultation = dateConsultation;
    }

    public LocalTime getHeureConsultation() {
        return heureConsultation;
    }

    public void setHeureConsultation(LocalTime heureConsultation) {
        this.heureConsultation = heureConsultation;
    }

    public LocalDateTime getDateHeureDebut() {
        return dateHeureDebut;
    }

    public void setDateHeureDebut(LocalDateTime dateHeureDebut) {
        this.dateHeureDebut = dateHeureDebut;
    }

    public LocalDateTime getDateHeureFin() {
        return dateHeureFin;
    }

    public void setDateHeureFin(LocalDateTime dateHeureFin) {
        this.dateHeureFin = dateHeureFin;
    }

    public StatutConsultation getStatut() {
        return statut;
    }

    public void setStatut(StatutConsultation statut) {
        this.statut = statut;
    }

    public String getMotifConsultation() {
        return motifConsultation;
    }

    public void setMotifConsultation(String motifConsultation) {
        this.motifConsultation = motifConsultation;
    }

    public String getCompteRendu() {
        return compteRendu;
    }

    public void setCompteRendu(String compteRendu) {
        this.compteRendu = compteRendu;
    }

    public String getDiagnostic() {
        return diagnostic;
    }

    public void setDiagnostic(String diagnostic) {
        this.diagnostic = diagnostic;
    }

    public String getTraitementPrescrit() {
        return traitementPrescrit;
    }

    public void setTraitementPrescrit(String traitementPrescrit) {
        this.traitementPrescrit = traitementPrescrit;
    }

    public String getObservations() {
        return observations;
    }

    public void setObservations(String observations) {
        this.observations = observations;
    }

    public LocalDateTime getDateCreation() {
        return dateCreation;
    }

    public void setDateCreation(LocalDateTime dateCreation) {
        this.dateCreation = dateCreation;
    }

    public LocalDateTime getDateModification() {
        return dateModification;
    }

    public void setDateModification(LocalDateTime dateModification) {
        this.dateModification = dateModification;
    }

    public Patient getPatient() {
        return patient;
    }

    public void setPatient(Patient patient) {
        this.patient = patient;
    }

    public Docteur getDocteur() {
        return docteur;
    }

    public void setDocteur(Docteur docteur) {
        this.docteur = docteur;
    }

    public Salle getSalle() {
        return salle;
    }

    public void setSalle(Salle salle) {
        this.salle = salle;
    }

    @Override
    public String toString() {
        return "Consultation{" +
                "idConsultation=" + idConsultation +
                ", dateConsultation=" + dateConsultation +
                ", heureConsultation=" + heureConsultation +
                ", statut=" + statut +
                ", patient=" + (patient != null ? patient.getNomComplet() : "null") +
                ", docteur=" + (docteur != null ? docteur.getNomComplet() : "null") +
                '}';
    }
}
