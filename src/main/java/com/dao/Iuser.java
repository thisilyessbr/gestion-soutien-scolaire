package com.dao;
import com.model.User ;

public interface Iuser {
    public int addUser(User u);
    public int addUser( String nom , String prenom , String login , String Password , String role);

    public User authentification(String login , String Password);

}
