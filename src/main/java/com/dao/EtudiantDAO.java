package com.dao;

import com.model.Etudiant;
import com.util.Dbinteraction;
import jakarta.servlet.RequestDispatcher;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class EtudiantDAO implements IEtudiant {

    @Override
    public List<Etudiant> getAllEtudiants() throws SQLException {
        List<Etudiant> etudiants = new ArrayList<>();
        Dbinteraction.connect();
        ResultSet rs = Dbinteraction.select("select mat , nom , prenom ,email, adresse ,matiere , tel from users where role ='etudiant' ");
        while (rs.next()) {
            // Créer un objet Etudiant pour chaque enregistrement dans le résultat
            Etudiant etudiant = new Etudiant();
            etudiant.setMat(rs.getInt("mat"));
            etudiant.setNom(rs.getString("nom"));
            etudiant.setEmail(rs.getString("email"));
            etudiant.setPrenom(rs.getString("prenom"));
            etudiant.setAddress(rs.getString("adresse"));
            etudiant.setMatiere(rs.getString("matiere"));
            etudiant.setTel(rs.getInt("tel"));
            etudiants.add(etudiant);
        }
        return etudiants;
    }
    public List<Etudiant> gettenlastEtudiants() throws SQLException {
        List<Etudiant> etudiants = new ArrayList<>();
        Dbinteraction.connect();
        ResultSet rs = Dbinteraction.select("select mat , nom , prenom ,email, adresse ,matiere , tel from users  ORDER BY users_id DESC LIMIT 10");
        while (rs.next()) {

            Etudiant etudiant = new Etudiant();
            etudiant.setMat(rs.getInt("mat"));
            etudiant.setNom(rs.getString("nom"));
            etudiant.setEmail(rs.getString("email"));
            etudiant.setPrenom(rs.getString("prenom"));
            etudiant.setAddress(rs.getString("adresse"));
            etudiant.setMatiere(rs.getString("matiere"));
            etudiant.setTel(rs.getInt("tel"));
            etudiants.add(etudiant);
        }
        return etudiants;

    }

    public List<Etudiant> searchEtudiants(String nom, String prenom, String mat) throws SQLException {

        List<Etudiant> etudiants = new ArrayList<>();

        Dbinteraction.connect();

        String sql = "select * from users where role ='etudiant' AND 1=1";

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
                Etudiant etudiant = new Etudiant();
                etudiant.setMat(rs.getInt("mat"));
                etudiant.setNom(rs.getString("nom"));
                etudiant.setEmail(rs.getString("email"));
                etudiant.setPrenom(rs.getString("prenom"));
                etudiant.setAddress(rs.getString("adresse"));
                etudiant.setMatiere(rs.getString("matiere"));
                etudiant.setTel(rs.getInt("tel"));


                etudiants.add(etudiant);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        return etudiants;
    }

    public void addEtudiant(Etudiant etudiant) throws SQLException {
        Dbinteraction.connect();
        Dbinteraction.Maj("INSERT INTO users (nom, prenom, login, password, role, mat, adresse, matiere, tel, email) values ( '"+etudiant.getNom()+"', '"+etudiant.getPrenom()+"', '"+etudiant.getLogin()+"', '"+etudiant.getPassword()+"', 'etudiant', "+etudiant.getMat()+", '"+etudiant.getAddress()+"', '"+etudiant.getMatiere()+"', "+etudiant.getTel()+", '"+etudiant.getEmail()+"')");
        Dbinteraction.disconnect();
    }

    public int deleteEtudiantByMat(int mat) throws SQLException {
        Dbinteraction.connect();
        try {
            String sql = "DELETE FROM users WHERE mat = ? AND role ='etudiant'";
            PreparedStatement statement = Dbinteraction.prepareStatement(sql);
            statement.setInt(1, mat);
            return statement.executeUpdate();
        } finally {
            Dbinteraction.disconnect();
        }
    }

    public List<Etudiant> getStudentsByAcademicYear(String academicYear) throws SQLException {
        List<Etudiant> etudiants = new ArrayList<>();
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet rs = null;

        try {
            connection = Dbinteraction.connect1();
            String query = "SELECT * FROM users " +
                    "WHERE annee_scolaire = ? AND role = 'etudiant'";

            preparedStatement = connection.prepareStatement(query);
            preparedStatement.setString(1, academicYear);

            rs = preparedStatement.executeQuery();

            while (rs.next()) {
                // Populate Student object and add it to the list
                Etudiant etudiant = new Etudiant();
                etudiant.setMat(rs.getInt("mat"));
                etudiant.setNom(rs.getString("nom"));
                etudiant.setEmail(rs.getString("email"));
                etudiant.setPrenom(rs.getString("prenom"));
                etudiant.setAddress(rs.getString("adresse"));
                etudiant.setMatiere(rs.getString("matiere"));
                etudiant.setTel(rs.getInt("tel"));

                etudiants.add(etudiant);
            }
        } finally {
            // Close resources in the finally block
            Dbinteraction.disconnect();
        }

        return etudiants;
    }

    public int updateEtudiant(int mat, String prenom, String nom ,String adresse ,String email , String matiere , int tel) throws SQLException {
        Dbinteraction.connect();

        String sql = "UPDATE users SET nom = ?, prenom = ? , adresse = ? , matiere = ? , tel = ? , email = ? WHERE mat = ? AND role = 'etudiant'";
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

}
