package com.dao;

import com.model.Presence;
import com.util.Dbinteraction;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class PresenceDAO {
    public List<Presence> getAllPresence() throws SQLException {
        List<Presence> presences = new ArrayList<>();
        Dbinteraction.connect();
        ResultSet rs = Dbinteraction.select("SELECT Users.mat , Users.nom, Users.prenom, " +
                "Cours.nom_cour, Cours.matiere, SeanceSchedule.date_seance, " +
                "Presence.status " +
                "FROM Presence " +
                "JOIN Users ON Presence.id_user = Users.users_id " +
                "JOIN Seance ON Presence.seance_id = Seance.id_seance " +
                "JOIN SeanceSchedule ON Seance.id_seance = SeanceSchedule.id_seance " +
                "JOIN Cours ON Seance.id_cour = Cours.id_cour " +
                "WHERE Users.role = 'etudiant';");



        while (rs.next()) {

            Presence presence = new Presence();
            presence.setId_etudiant(rs.getInt("mat"));
            presence.setNom_etudiant(rs.getString("nom"));
            presence.setPrenom_etud(rs.getString("prenom"));
            presence.setMatiere(rs.getString("matiere"));
            presence.setFormation(rs.getString("nom_cour"));
            presence.setSeance(rs.getDate("date_seance"));
            presence.setEtat(rs.getString("status"));
            presences.add(presence);
        }

        return presences;
    }
}
