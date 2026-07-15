package com.model;
import java.sql.Date;
 // Assuming you use java.util.Date for date fields
import java.sql.Time;  // Assuming you use java.sql.Time for time fields
import java.time.LocalTime;

public class Seance {


    String EnseignantNom ,EnseignantPrenom ;
    private String nom_cour ;

    private String nom_salle ;
    private int idSeance;
    private int idCour;
    private int salleId;
    private Date dateSeance;
    private Time heureDebut;
    private Time heureFin;

    public Seance() {
    }

    public String getEnseignantNom() {
        return EnseignantNom;
    }

    public void setEnseignantNom(String enseignantNom) {
        EnseignantNom = enseignantNom;
    }

    public String getEnseignantPrenom() {
        return EnseignantPrenom;
    }

    public void setEnseignantPrenom(String enseignantPrenom) {
        EnseignantPrenom = enseignantPrenom;
    }

    public String getNom_salle() {
        return nom_salle;
    }


    public void setNom_salle(String nom_salle) {
        this.nom_salle = nom_salle;
    }

    public String getNom_cour() {
        return nom_cour;
    }

    public void setNom_cour(String nom_cour) {
        this.nom_cour = nom_cour;
    }

    // Constructor
    public Seance(int idSeance, int idCour, int salleId, Date dateSeance, Time heureDebut, Time heureFin) {
        this.idSeance = idSeance;
        this.idCour = idCour;
        this.salleId = salleId;
        this.dateSeance = dateSeance;
        this.heureDebut = heureDebut;
        this.heureFin = heureFin;
    }

    public Seance( int idCour, int salleId, Date dateSeance, Time heureDebut, Time heureFin) {
        this.idCour = idCour;
        this.salleId = salleId;
        this.dateSeance = dateSeance;
        this.heureDebut = heureDebut;
        this.heureFin = heureFin;
    }



    public Seance(int idSeance , int idCour, int salleId) {
        this.idCour = idCour;
        this.salleId = salleId;
        this.idSeance = idSeance;
    }


    // Getters and Setters
    public int getIdSeance() {
        return idSeance;
    }

    public void setIdSeance(int idSeance) {
        this.idSeance = idSeance;
    }

    public int getIdCour() {
        return idCour;
    }

    public void setIdCour(int idCour) {
        this.idCour = idCour;
    }

    public int getSalleId() {
        return salleId;
    }

    public void setSalleId(int salleId) {
        this.salleId = salleId;
    }

    public Date getDateSeance() {
        return dateSeance;
    }

    public void setDateSeance(Date dateSeance) {
        this.dateSeance = dateSeance;
    }

    public LocalTime getHeureDebut() {
        return heureDebut.toLocalTime();
    }

    public void setHeureDebut(Time heureDebut) {
        this.heureDebut = heureDebut;
    }

    public Time getHeureFin() {
        return heureFin;
    }

    public void setHeureFin(Time heureFin) {
        this.heureFin = heureFin;
    }
}

