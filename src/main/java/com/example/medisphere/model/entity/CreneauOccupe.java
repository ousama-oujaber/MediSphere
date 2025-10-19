package com.example.medisphere.model.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.Objects;


@Entity
@Table(
    name = "creneau_occupe",
    uniqueConstraints = @UniqueConstraint(
        name = "unique_salle_creneau",
        columnNames = {"id_salle", "date_heure_debut"}
    )
)
public class CreneauOccupe {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_creneau")
    private Long idCreneau;

    @Column(name = "date_heure_debut", nullable = false)
    private LocalDateTime dateHeureDebut;

    @Column(name = "date_heure_fin", nullable = false)
    private LocalDateTime dateHeureFin;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_salle", nullable = false)
    private Salle salle;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_consultation", nullable = false)
    private Consultation consultation;

    
    public CreneauOccupe() {
    }

    public CreneauOccupe(LocalDateTime dateHeureDebut, LocalDateTime dateHeureFin, Salle salle, Consultation consultation) {
        this.dateHeureDebut = dateHeureDebut;
        this.dateHeureFin = dateHeureFin;
        this.salle = salle;
        this.consultation = consultation;
    }

    
    public boolean chevauche(LocalDateTime debut, LocalDateTime fin) {
        return (debut.isBefore(dateHeureFin) && fin.isAfter(dateHeureDebut));
    }

    
    public Long getIdCreneau() {
        return idCreneau;
    }

    public void setIdCreneau(Long idCreneau) {
        this.idCreneau = idCreneau;
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

    public Salle getSalle() {
        return salle;
    }

    public void setSalle(Salle salle) {
        this.salle = salle;
    }

    public Consultation getConsultation() {
        return consultation;
    }

    public void setConsultation(Consultation consultation) {
        this.consultation = consultation;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        CreneauOccupe that = (CreneauOccupe) o;
        return Objects.equals(salle, that.salle) &&
               Objects.equals(dateHeureDebut, that.dateHeureDebut);
    }

    @Override
    public int hashCode() {
        return Objects.hash(salle, dateHeureDebut);
    }

    @Override
    public String toString() {
        return "CreneauOccupe{" +
                "idCreneau=" + idCreneau +
                ", dateHeureDebut=" + dateHeureDebut +
                ", dateHeureFin=" + dateHeureFin +
                ", salle=" + (salle != null ? salle.getNomSalle() : "null") +
                '}';
    }
}
