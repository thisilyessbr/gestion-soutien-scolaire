package com.dao;

import com.model.Etudiant;
import com.model.Professeur;
import com.util.Dbinteraction;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ProfesseurDAO {

    public List<Professeur> getprofsByAcademicYear(String academicYear) throws SQLException {
        List<Professeur> professeurs = new ArrayList<>();
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet rs = null;

        try {
            connection = Dbinteraction.connect1();
            String query = "SELECT * FROM users " +
                    "WHERE annee_scolaire = ? AND role = 'professeur'";

            preparedStatement = connection.prepareStatement(query);
            preparedStatement.setString(1, academicYear);

            rs = preparedStatement.executeQuery();

            while (rs.next()) {

                Professeur professeur = new Professeur();
                professeur.setMat(rs.getInt("mat"));
                professeur.setNom(rs.getString("nom"));
                professeur.setEmail(rs.getString("email"));
                professeur.setPrenom(rs.getString("prenom"));
                professeur.setAddress(rs.getString("adresse"));
                professeur.setMatiere(rs.getString("matiere"));
                professeur.setTel(rs.getInt("tel"));
                professeurs.add(professeur);
                professeurs.add(professeur);
            }
        } finally {
            // Close resources in the finally block
            Dbinteraction.disconnect();
        }

        return professeurs;
    }

    public List<Professeur> getAllProfesseur() throws SQLException {
        List<Professeur> professeurs = new ArrayList<>();
        Dbinteraction.connect();
        ResultSet rs = Dbinteraction.select("select mat , nom , prenom ,email, adresse ,matiere , tel from users where role ='professeur' ");
        while (rs.next()) {
            // Créer un objet Etudiant pour chaque enregistrement dans le résultat
            Professeur professeur = new Professeur();
            professeur.setMat(rs.getInt("mat"));
            professeur.setNom(rs.getString("nom"));
            professeur.setEmail(rs.getString("email"));
            professeur.setPrenom(rs.getString("prenom"));
            professeur.setAddress(rs.getString("adresse"));
            professeur.setMatiere(rs.getString("matiere"));
            professeur.setTel(rs.getInt("tel"));
            professeurs.add(professeur);
        }
        return professeurs;
    }
    public List<Professeur> searchProfesseurs(String nom, String prenom, String mat) throws SQLException {

        List<Professeur> profs = new ArrayList<>();

        Dbinteraction.connect();

        String sql = "select * from users where role='professeur' AND 1=1";

        if (nom != null && !nom.isEmpty()) {
            sql += " AND nom LIKE '%" + nom + "%'";
        }
        if (prenom != null && !prenom.isEmpty()) {
            sql += " AND prenom LIKE '%" + prenom + "%'";
        }
        if (mat != null && !mat.isEmpty()) {
            sql += " AND mat LIKE '%" + mat + "%'";
        }

        ResultSet rs = Dbinteraction.select(sql);


        try {
            while (rs.next()) {
                Professeur professeur = new Professeur();
                professeur.setMat(rs.getInt("mat"));
                professeur.setNom(rs.getString("nom"));
                professeur.setEmail(rs.getString("email"));
                professeur.setPrenom(rs.getString("prenom"));
                professeur.setAddress(rs.getString("adresse"));
                professeur.setMatiere(rs.getString("matiere"));
                professeur.setTel(rs.getInt("tel"));


                profs.add(professeur);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        return profs;
    }

    public void addProfesseur(Professeur professeur) throws SQLException {
        Dbinteraction.connect();
        Dbinteraction.Maj("INSERT INTO users (nom, prenom, login, password, role, mat, adresse, matiere, tel, email) values ( '"+professeur.getNom()+"', '"+professeur.getPrenom()+"', '"+professeur.getLogin()+"', '"+professeur.getPassword()+"', 'professeur', "+professeur.getMat()+", '"+professeur.getAddress()+"', '"+professeur.getMatiere()+"', "+professeur.getTel()+", '"+professeur.getEmail()+"')");
        Dbinteraction.disconnect();
    }
    public int updateProfesseur(int mat, String prenom, String nom ,String adresse ,String email , String matiere , int tel) throws SQLException {
        Dbinteraction.connect();

        String sql = "UPDATE users SET nom = ?, prenom = ? , adresse = ? , matiere = ? , tel = ? , email = ? WHERE mat = ? AND role='professeur' ";
        PreparedStatement statement = Dbinteraction.prepareStatement(sql);

        statement.setString(2, prenom);
        statement.setString(1, nom);
        statement.setString(3, adresse);
        statement.setString(4, matiere);
        statement.setInt(5, tel);
        statement.setString(6, email);
        statement.setInt(7, mat);

        int rowsUpdated = statement.executeUpdate();

        Dbinteraction.disconnect();

        return rowsUpdated;
    }

    public int deleteProfesseurByMat(int mat) throws SQLException {
        Dbinteraction.connect1();
        try {
            String sql = "DELETE FROM users WHERE mat = ? AND role='professeur'";
            PreparedStatement statement = Dbinteraction.prepareStatement(sql);
            statement.setInt(1, mat);
            return statement.executeUpdate();
        } finally {
            Dbinteraction.disconnect();
        }
    }

}