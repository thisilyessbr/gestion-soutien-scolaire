package com.model;

import java.util.Date;

public class Presence {
    int id_etudiant;
    String nom_etudiant;

    String prenom_etud ;
    Date seance;
    String matiere, formation;

    String etat ;

    public String getPrenom_etud() {
        return prenom_etud;
    }

    public void setPrenom_etud(String prenom_etud) {
        this.prenom_etud = prenom_etud;
    }

    public Presence() {
    }

    public Presence(int id_etudiant , String etat , String prenom_etud, String nom_etudiant, Date seance, String matiere, String formation) {
        this.id_etudiant = id_etudiant;
        this.nom_etudiant = nom_etudiant;
        this.seance = seance;
        this.matiere = matiere;
        this.formation = formation;
        this.prenom_etud = prenom_etud ;
        this.etat=etat ;
    }

    public String getEtat() {
        return etat;
    }

    public void setEtat(String etat) {
        this.etat = etat;
    }

    // Getter methods
    public int getId_etudiant() {
        return id_etudiant;
    }

    public String getNom_etudiant() {
        return nom_etudiant;
    }

    public Date getSeance() {
        return seance;
    }

    public String getMatiere() {
        return matiere;
    }

    public String getFormation() {
        return formation;
    }

    // Setter methods
    public void setId_etudiant(int id_etudiant) {
        this.id_etudiant = id_etudiant;
    }

    public void setNom_etudiant(String nom_etudiant) {
        this.nom_etudiant = nom_etudiant;
    }

    public void setSeance(Date seance) {
        this.seance = seance;
    }

    public void setMatiere(String matiere) {
        this.matiere = matiere;
    }

    public void setFormation(String formation) {
        this.formation = formation;
    }
}

