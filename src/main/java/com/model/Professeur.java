package com.model;

public class Professeur {
    private int mat;
    private String nom;
    private String prenom;
    private String address;
    private String email;
    private String matiere;
    private int tel ;

    private String login ;

    private String password ;


    public Professeur() {
    }

    public Professeur(int mat, String nom, String prenom, String address, String email,
                    String matiere, int tel) {
        this.mat = mat;
        this.nom = nom;
        this.prenom = prenom;
        this.address = address;
        this.email = email;
        this.matiere = matiere;
        this.tel = tel;

    }

    public Professeur(int mat, String nom, String prenom, String address, String email,
                    String matiere, int tel ,String login ,String password) {
        this.mat = mat;
        this.nom = nom;
        this.prenom = prenom;
        this.address = address;
        this.email = email;
        this.matiere = matiere;
        this.tel = tel;
        this.login=login;
        this.password=password;

    }

    public Professeur(int mat, String nom, String prenom) {
        this.mat = mat;
        this.nom = nom;
        this.prenom = prenom;


    }
    // Getters and setters for other attributes


    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getLogin() {
        return login;
    }

    public void setLogin(String login) {
        this.login = login;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public int getMat() {
        return mat;
    }

    public void setMat(int mat) {
        this.mat = mat;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public int getTel() {
        return tel;
    }

    public void setTel(int tel) {
        this.tel = tel;
    }

    public String getPrenom() {
        return prenom;
    }

    public void setPrenom(String prenom) {
        this.prenom = prenom;
    }

    public String getMatiere() {
        return matiere;
    }

    public void setMatiere(String matière) {
        this.matiere = matière;
    }


}
