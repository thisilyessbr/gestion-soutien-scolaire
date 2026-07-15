package com.model;

public class Cour {
    private int id_cour;
    private int id_enseignants;
    private String nom_cour;
    private String nom_matiere;

    private int Mat_enseignants ;

    String nom_enseignant ;
    String prenom_enseignant ;

    public String getPrenom_enseignant() {
        return prenom_enseignant;
    }

    public void setPrenom_enseignant(String prenom_enseignant) {
        this.prenom_enseignant = prenom_enseignant;
    }

    // Constructors
    public Cour() {
        // Default constructor
    }

    public int getMat_enseignants() {
        return Mat_enseignants;
    }

    public void setMat_enseignants(int mat_enseignants) {
        Mat_enseignants = mat_enseignants;
    }

    public String getNom_enseignant() {
        return nom_enseignant;
    }

    public void setNom_enseignant(String nom_enseignant) {
        this.nom_enseignant = nom_enseignant;
    }

    public Cour(int id_cour, int id_enseignants, String nom_cour, String nom_matiere) {
        this.id_cour = id_cour;
        this.id_enseignants = id_enseignants;
        this.nom_cour = nom_cour;
        this.nom_matiere = nom_matiere;
    }
    public Cour( int Mat_enseignants , String nom_cour, String nom_matiere) {
        this.Mat_enseignants = Mat_enseignants;
        this.nom_cour = nom_cour;
        this.nom_matiere = nom_matiere;
    }

    // Getter methods
    public int getId_cour() {
        return id_cour;
    }

    public int getId_enseignants() {
        return id_enseignants;
    }

    public String getNom_cour() {
        return nom_cour;
    }

    public String getNom_matiere() {
        return nom_matiere;
    }

    // Setter methods
    public void setId_cour(int id_cour) {
        this.id_cour = id_cour;
    }

    public void setId_enseignants(int id_enseignants) {
        this.id_enseignants = id_enseignants;
    }

    public void setNom_cour(String nom_cour) {
        this.nom_cour = nom_cour;
    }

    public void setNom_matiere(String nom_matiere) {
        this.nom_matiere = nom_matiere;
    }

}

