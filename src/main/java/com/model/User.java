package com.model;

public class User {


    private int id;
    private String nom;
    private String prenom;

    private String login ;

    private String Password ;

    private int mat ;

    private boolean passwordChanged;

    // Constructor, getters, setters, and other methods...

    public boolean isPasswordChanged() {
        return passwordChanged;
    }

    public void setPasswordChanged(boolean passwordChanged) {
        this.passwordChanged = passwordChanged;
    }
    private String role ;
    public User( String nom , String prenom , String login , String Password ,String role) {
        this.nom=nom;
        this.prenom=prenom ;
        this.login=login;
        this.Password=Password ;
        this.role=role ;

   }

    public User( String nom , String prenom , String login , String Password ,String role , int mat) {
        this.nom=nom;
        this.prenom=prenom ;
        this.login=login;
        this.Password=Password ;
        this.role=role ;
        this.mat=mat ;

    }
    public User( int id , String nom , String prenom , String login , String Password ,String role ) {
        this.id=id ;
        this.nom=nom;
        this.prenom=prenom ;
        this.login=login;
        this.Password=Password ;
        this.role=role ;

    }
    public User( int id , String nom , String prenom , String login , String Password ,String role , int mat ) {
        this.id=id ;
        this.nom=nom;
        this.prenom=prenom ;
        this.login=login;
        this.Password=Password ;
        this.role=role ;
        this.mat=mat;

    }

    public int getMat() {
        return mat;
    }

    public void setMat(int mat) {
        this.mat = mat;
    }

    public User() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public String getLogin() {
        return login;
    }

    public void setLogin(String login) {
        this.login = login;
    }

    public String getPassword() {
        return Password;
    }

    public void setPassword(String password) {
        Password = password;
    }

    public String getPrenom() {
        return prenom;
    }

    public void setPrenom(String prenom) {
        this.prenom = prenom;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }
}
