package com.model;

import java.sql.Time;

public class salle {
    int capacity , num_salle ;
    String localisation , nom_salle , Disponibilily ;

    Time start_time ;

    Time End_time ;

    public salle() {
    }

    public salle(int capacity , String localisation , String nom_salle ,String disponibilily ,int num_salle) {

        this.capacity = capacity ;
        this.localisation = localisation ;
        this.nom_salle = nom_salle ;
        this.Disponibilily = disponibilily;
        this.num_salle = num_salle ;

    }
    public salle(int capacity , String localisation , String nom_salle  ,int num_salle) {

        this.capacity = capacity ;
        this.localisation = localisation ;
        this.nom_salle = nom_salle ;
        this.num_salle = num_salle ;

    }

    public Time getStart_time() {
        return start_time;
    }

    public void setStart_time(Time start_time) {
        this.start_time = start_time;
    }

    public Time getEnd_time() {
        return End_time;
    }

    public void setEnd_time(Time end_time) {
        End_time = end_time;
    }

    public int getCapacity() {
        return capacity;
    }

    public void setCapacity(int capacity) {
        this.capacity = capacity;
    }

    public String getDisponibilily() {
        return Disponibilily;
    }

    public void setDisponibilily(String disponibilily) {
        Disponibilily = disponibilily;
    }

    public String getLocalisation() {
        return localisation;
    }

    public void setLocalisation(String localisation) {
        this.localisation = localisation;
    }

    public String getNom_salle() {
        return nom_salle;
    }

    public void setNom_salle(String nom_salle) {
        this.nom_salle = nom_salle;
    }

    public int getNum_salle() {
        return num_salle;
    }

    public void setNum_salle(int num_salle) {
        this.num_salle = num_salle;
    }
}
