package com.dao;

import com.model.Cour;
import com.model.salle;
import com.util.Dbinteraction;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CourDAO {

    public List<Cour> getCoursWithEnseignants() throws SQLException {
        List<Cour> coursList = new ArrayList<>();
        Dbinteraction.connect();

        String sql = "SELECT c.id_cour, c.nom_cour, c.matiere, u.nom AS nom_enseignant, u.prenom AS prenom_enseignant " +
                "FROM cours c " +
                "JOIN users u ON c.enseignant_id = u.users_id";

        ResultSet rs = Dbinteraction.select(sql);

        try {
            while (rs.next()) {
                Cour cour = new Cour();
                cour.setId_cour(rs.getInt("id_cour"));
                cour.setNom_cour(rs.getString("nom_cour"));
                cour.setNom_matiere(rs.getString("matiere"));

                // Adding enseignant information to Cour object
                String nomEnseignant = rs.getString("nom_enseignant");
                String prenomEnseignant = rs.getString("prenom_enseignant");
                cour.setNom_enseignant(nomEnseignant);
                cour.setPrenom_enseignant(prenomEnseignant);

                coursList.add(cour);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        return coursList;
    }

    public List<Cour> getCoursbyEnseignantsid(int prof_id) throws SQLException {
        List<Cour> coursList = new ArrayList<>();
        Dbinteraction.connect();

        String sql = "SELECT c.id_cour, c.nom_cour, c.matiere, u.nom AS nom_enseignant, u.prenom AS prenom_enseignant " +
                "FROM cours c " +
                "JOIN users u ON c.enseignant_id = u.users_id " +
                "WHERE u.users_id = " + prof_id;


        ResultSet rs = Dbinteraction.select(sql);

        try {
            while (rs.next()) {
                Cour cour = new Cour();
                cour.setId_cour(rs.getInt("id_cour"));
                cour.setNom_cour(rs.getString("nom_cour"));
                cour.setNom_matiere(rs.getString("matiere"));

                // Adding enseignant information to Cour object
                String nomEnseignant = rs.getString("nom_enseignant");
                String prenomEnseignant = rs.getString("prenom_enseignant");
                cour.setNom_enseignant(nomEnseignant);
                cour.setPrenom_enseignant(prenomEnseignant);

                coursList.add(cour);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        return coursList;
    }

    public List<Cour> searchCours(String nomCours) throws SQLException {
        List<Cour> coursList = new ArrayList<>();
        Dbinteraction.connect();

        String sql = "SELECT c.id_cour, c.nom_cour, c.matiere, u.nom AS nom_enseignant, u.prenom AS prenom_enseignant " +
                "FROM cours c " +
                "JOIN users u ON c.enseignant_id = u.users_id " + // Added space before WHERE
                "WHERE c.nom_cour LIKE '%" + nomCours + "%'";



        ResultSet rs = Dbinteraction.select(sql);

        try {
            while (rs.next()) {
                Cour cour = new Cour();
                cour.setId_cour(rs.getInt("id_cour"));
                cour.setNom_cour(rs.getString("nom_cour"));
                cour.setNom_matiere(rs.getString("matiere"));
                String nomEnseignant = rs.getString("nom_enseignant");
                String prenomEnseignant = rs.getString("prenom_enseignant");
                cour.setNom_enseignant(nomEnseignant);
                cour.setPrenom_enseignant(prenomEnseignant);

                coursList.add(cour);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        return coursList;
    }

    public List<Cour> searchCoursbyprofid(String nomCours , int prof_id) throws SQLException {
        List<Cour> coursList = new ArrayList<>();
        Dbinteraction.connect();

        String sql = "SELECT c.id_cour, c.nom_cour, c.matiere, u.nom AS nom_enseignant, u.prenom AS prenom_enseignant " +
                "FROM cours c " +
                "JOIN users u ON c.enseignant_id = u.users_id " + // Added space before WHERE
                "WHERE c.nom_cour LIKE '%" + nomCours + "%'" +
                "AND u.users_id = " + prof_id;



        ResultSet rs = Dbinteraction.select(sql);

        try {
            while (rs.next()) {
                Cour cour = new Cour();
                cour.setId_cour(rs.getInt("id_cour"));
                cour.setNom_cour(rs.getString("nom_cour"));
                cour.setNom_matiere(rs.getString("matiere"));
                String nomEnseignant = rs.getString("nom_enseignant");
                String prenomEnseignant = rs.getString("prenom_enseignant");
                cour.setNom_enseignant(nomEnseignant);
                cour.setPrenom_enseignant(prenomEnseignant);

                coursList.add(cour);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        return coursList;
    }
    public void addCoursbyMAT(Cour cours) throws SQLException {
        Dbinteraction.connect();

        // Retrieve enseignant_id based on MAT
        int enseignantId = getEnseignantIdByMat(cours.getMat_enseignants());

        // Check if enseignantId is valid
        if (enseignantId != -1) {
            // Use enseignantId to insert the course
            Dbinteraction.Maj("INSERT INTO cours (nom_cour, matiere, enseignant_id) values ('" + cours.getNom_cour() + "', '" + cours.getNom_matiere() + "', " + enseignantId + ")");
        } else {
            // Handle the case where enseignantId is not valid
            System.out.println("Enseignant with MAT " + cours.getMat_enseignants() + " not found.");
        }

        Dbinteraction.disconnect();
    }


    private int getEnseignantIdByMat(int matEnseignant) throws SQLException {
        // Retrieve enseignant_id based on MAT
        int enseignantId = -1;

        String sql = "SELECT users_id FROM users WHERE mat = " + matEnseignant + " AND role = 'professeur'";
        ResultSet rs = Dbinteraction.select(sql);

        if (rs.next()) {
            enseignantId = rs.getInt("users_id");
        }

        return enseignantId;
    }

    public int deleteCoursbyID1(int id) throws SQLException {
        Dbinteraction.connect();
        try {
            String sql = "DELETE FROM cours WHERE id_cour = ? ";
            PreparedStatement statement = Dbinteraction.prepareStatement(sql);
            statement.setInt(1, id);
            return statement.executeUpdate();
        } finally {
            Dbinteraction.disconnect();
        }
    }
    public int deleteCoursbyID(int id) throws SQLException {
        Dbinteraction.connect();

        try {
            // Delete related records from Seance table
            String deleteSeanceSql = "DELETE FROM seance WHERE id_cour = ?";
            PreparedStatement deleteSeanceStatement = Dbinteraction.prepareStatement(deleteSeanceSql);
            deleteSeanceStatement.setInt(1, id);
            deleteSeanceStatement.executeUpdate();

            // Delete record from Cours table
            String deleteCoursSql = "DELETE FROM Cours WHERE id_cour = ?";
            PreparedStatement deleteCoursStatement = Dbinteraction.prepareStatement(deleteCoursSql);
            deleteCoursStatement.setInt(1, id);
            return deleteCoursStatement.executeUpdate();
        } finally {
            Dbinteraction.disconnect();
        }
    }

    public List<Cour> getCourProf(int prof_id) throws SQLException {
        List<Cour> courList = new ArrayList<>();
        Dbinteraction.connect();

        // Select courses for the specified professor ID
        ResultSet rs = Dbinteraction.select("SELECT id_cour, nom_cour, matiere FROM cours WHERE enseignant_id = " + prof_id);

        while (rs.next()) {
            Cour cour = new Cour();
            cour.setId_cour(rs.getInt("id_cour"));
            cour.setNom_cour(rs.getString("nom_cour"));
            cour.setNom_matiere(rs.getString("matiere"));
            courList.add(cour);
        }

        Dbinteraction.disconnect(); // Assuming you have a disconnect method in your Dbinteraction class
        return courList;
    }




}
