package com.dao;

import com.model.Etudiant;
import com.model.Professeur;
import com.model.salle;
import com.util.Dbinteraction;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SalleDAO {
    public List<salle> getDisposalle() throws SQLException {
        List<salle> salles = new ArrayList<>();
        Dbinteraction.connect();
        ResultSet rs = Dbinteraction.select("select capacité, localisation, Nom_salle, Disponibilité , Num_salle from salle where Disponibilité='Disponible'");
        while (rs.next()) {

            salle Salle = new salle();
            Salle.setCapacity(rs.getInt("capacité"));
            Salle.setLocalisation(rs.getString("localisation"));
            Salle.setNom_salle(rs.getString("Nom_salle"));
            Salle.setDisponibilily(rs.getString("Disponibilité"));
            Salle.setNum_salle(rs.getInt("Num_salle"));
            salles.add(Salle);
        }
        return salles;

    }

    public List<salle> getAllSalles() throws SQLException {
        List<salle> salles = new ArrayList<>();
        Dbinteraction.connect();
        ResultSet rs = Dbinteraction.select("SELECT  capacité, localisation, Nom_salle, Disponibilité, Num_salle FROM salle");
        while (rs.next()) {
            // Create a Salle object for each record in the result
            salle Salle = new salle();
            Salle.setCapacity(rs.getInt("capacité"));
            Salle.setLocalisation(rs.getString("localisation"));
            Salle.setNom_salle(rs.getString("Nom_salle"));
            Salle.setDisponibilily(rs.getString("Disponibilité"));
            Salle.setNum_salle(rs.getInt("Num_salle"));
            salles.add(Salle);
        }
        return salles;
    }

    public List<salle> getAllSalles1() throws SQLException {
        List<salle> salles = new ArrayList<>();
        Dbinteraction.connect();
        // Use a LEFT JOIN to include all records from Sallecp and matching records from SalleAvailability
        ResultSet rs = Dbinteraction.select("SELECT s.capacité, s.localisation, s.Nom_salle, s.Num_salle, sa.status , sa.start_time , sa.end_time " +
                "FROM Sallecp s " +
                "LEFT JOIN SalleAvailability sa ON s.id_salle = sa.salle_id");
        while (rs.next()) {
            // Create a Salle object for each record in the result
            salle Salle = new salle();
            Salle.setCapacity(rs.getInt("capacité"));
            Salle.setLocalisation(rs.getString("localisation"));
            Salle.setNom_salle(rs.getString("Nom_salle"));
            Salle.setNum_salle(rs.getInt("Num_salle"));
            Salle.setDisponibilily(rs.getString("status"));
            Salle.setEnd_time(rs.getTime("end_time"));
            Salle.setStart_time(rs.getTime("start_time"));
            salles.add(Salle);
        }
        return salles;
    }

    public List<salle> searchSalles(String location, String nomSalle, String numSalle) throws SQLException {
        List<salle> salles = new ArrayList<>();
        Dbinteraction.connect();

        String sql = "SELECT * FROM salle WHERE 1=1";


        if (location != null && !location.isEmpty()) {
            sql += " AND localisation LIKE '%" + location + "%'";
        }

        if (nomSalle != null && !nomSalle.isEmpty()) {
            sql += " AND Nom_salle LIKE '%" + nomSalle + "%'";
        }

        if (numSalle != null && !numSalle.isEmpty()) {
            sql += " AND Num_salle LIKE '%" + numSalle + "%'";
        }

        ResultSet rs = Dbinteraction.select(sql);

        try {
            while (rs.next()) {
                salle Salle = new salle();
                Salle.setCapacity(rs.getInt("capacité"));
                Salle.setLocalisation(rs.getString("localisation"));
                Salle.setNom_salle(rs.getString("Nom_salle"));
                Salle.setNum_salle(rs.getInt("Num_salle"));

                salles.add(Salle);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        return salles;
    }
    public List<salle> searchSalles1(String location1, String nomSalle1, int numSalle1) throws SQLException {
        List<salle> salles = new ArrayList<>();
        Dbinteraction.connect();

        String sql = "SELECT s.capacité, s.localisation, s.Nom_salle, s.Num_salle, sa.status, sa.start_time, sa.end_time " +
                "FROM Sallecp s " +
                "INNER JOIN SalleAvailability sa ON s.id_salle = sa.salle_id " +
                "WHERE 1=1";

        if (location1 != null && !location1.isEmpty()) {
            sql += " AND s.localisation LIKE ?";
        }

        if (nomSalle1 != null && !nomSalle1.isEmpty()) {
            sql += " AND s.Nom_salle LIKE ?";
        }

        if (numSalle1 > 0) {
            sql += " AND s.Num_salle = ?";
        }

        try (PreparedStatement pstmt = Dbinteraction.prepareStatement(sql)) {
            int parameterIndex = 1;

            if (location1 != null && !location1.isEmpty()) {
                pstmt.setString(parameterIndex++, "%" + location1 + "%");
            }

            if (nomSalle1 != null && !nomSalle1.isEmpty()) {
                pstmt.setString(parameterIndex++, "%" + nomSalle1 + "%");
            }

            if (numSalle1 > 0) {
                pstmt.setInt(parameterIndex++, numSalle1);
            }

            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                salle Salle = new salle();
                Salle.setCapacity(rs.getInt("capacité"));
                Salle.setLocalisation(rs.getString("localisation"));
                Salle.setNom_salle(rs.getString("Nom_salle"));
                Salle.setNum_salle(rs.getInt("Num_salle"));
                Salle.setDisponibilily(rs.getString("status"));
                Salle.setEnd_time(rs.getTime("end_time"));
                Salle.setStart_time(rs.getTime("start_time"));
                salles.add(Salle);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        return salles;
    }


    public void addSalle(salle Salle) throws SQLException {
        Dbinteraction.connect();
        Dbinteraction.Maj("INSERT INTO salle ( capacité , localisation, Nom_salle , Disponibilité, Num_salle) values ( "+Salle.getCapacity()+", '"+Salle.getLocalisation()+"', '"+Salle.getNom_salle()+"', '"+Salle.getDisponibilily()+"', "+Salle.getNum_salle()+")");

        Dbinteraction.disconnect();
    }

    public void addSalle1(salle Salle) throws SQLException {
        Dbinteraction.connect();

        try (Connection connection = Dbinteraction.connect1()) {
            // Insert into sallecp table and retrieve generated key
            String insertSalleQuery = "INSERT INTO sallecp (capacité, localisation, Nom_salle, Num_salle) VALUES (?, ?, ?, ?)";
            try (PreparedStatement preparedStatement = connection.prepareStatement(insertSalleQuery, PreparedStatement.RETURN_GENERATED_KEYS)) {
                preparedStatement.setInt(1, Salle.getCapacity());
                preparedStatement.setString(2, Salle.getLocalisation());
                preparedStatement.setString(3, Salle.getNom_salle());
                preparedStatement.setInt(4, Salle.getNum_salle());

                int affectedRows = preparedStatement.executeUpdate();

                if (affectedRows == 0) {
                    throw new SQLException("Creating salle failed, no rows affected.");
                }

                // Retrieve the generated key (id_salle)
                try (ResultSet generatedKeys = preparedStatement.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        int salleId = generatedKeys.getInt(1);

                        // Insert into SalleAvailability table
                        String insertAvailabilityQuery = "INSERT INTO SalleAvailability (salle_id, start_time, end_time, status) VALUES (?, '00:00:00', '23:59:59', 'disponible')";
                        try (PreparedStatement availabilityStatement = connection.prepareStatement(insertAvailabilityQuery)) {
                            availabilityStatement.setInt(1, salleId);
                            availabilityStatement.executeUpdate();
                        } catch (SQLException e) {
                            throw new SQLException("Failed to insert into SalleAvailability table.", e);
                        }
                    } else {
                        throw new SQLException("Creating salle failed, no ID obtained.");
                    }
                }
            } catch (SQLException e) {
                throw new SQLException("Failed to insert into sallecp table.", e);
            }
        } finally {
            Dbinteraction.disconnect();
        }
    }

    public int deleteSalleBYnum(int num) throws SQLException {
        Dbinteraction.connect();
        try {
            String sql = "DELETE FROM salle WHERE  Num_salle = ? ";
            PreparedStatement statement = Dbinteraction.prepareStatement(sql);
            statement.setInt(1, num);
            return statement.executeUpdate();
        } finally {
            Dbinteraction.disconnect();
        }
    }

    public int deleteSalleByNum1(int num) throws SQLException {
        Dbinteraction.connect();

        try {
            // Start a transaction
            Dbinteraction.setAutoCommit(false);

            // Retrieve the salle_id from salle table
            int salleId = getSalleIdByNum(num);

            // Delete from SalleAvailability table
            String deleteAvailabilityQuery = "DELETE FROM SalleAvailability WHERE salle_id = ?";
            try (PreparedStatement availabilityStatement = Dbinteraction.prepareStatement(deleteAvailabilityQuery)) {
                availabilityStatement.setInt(1, salleId);
                availabilityStatement.executeUpdate();
            } catch (SQLException e) {
                // Rollback the transaction if an error occurs
                Dbinteraction.rollback();
                throw new SQLException("Failed to delete from SalleAvailability table.", e);
            }

            // Delete from salle table
            String deleteSalleQuery = "DELETE FROM Sallecp WHERE Num_salle = ?";
            try (PreparedStatement statement = Dbinteraction.prepareStatement(deleteSalleQuery)) {
                statement.setInt(1, num);
                int rowsAffected = statement.executeUpdate();

                // Commit the transaction if both deletions were successful
                Dbinteraction.commit();

                return rowsAffected;
            } catch (SQLException e) {
                // Rollback the transaction if an error occurs
                Dbinteraction.rollback();
                throw new SQLException("Failed to delete from salle table.", e);
            }
        } finally {
            // Ensure autocommit is restored to its default state
            Dbinteraction.setAutoCommit(true);
            Dbinteraction.disconnect();
        }
    }

    private int getSalleIdByNum(int num) throws SQLException {
        String selectQuery = "SELECT id_salle FROM Sallecp WHERE Num_salle = ?";
        try (PreparedStatement preparedStatement = Dbinteraction.prepareStatement(selectQuery)) {
            preparedStatement.setInt(1, num);
            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                if (resultSet.next()) {
                    return resultSet.getInt("id_salle");
                } else {
                    throw new SQLException("No salle found with Num_salle = " + num);
                }
            }
        }
    }


    public int updateSalle(int number, String name, String Location, String diponibility , int capacity) throws SQLException {
        Dbinteraction.connect();

        String sql = "UPDATE salle SET  capacité = ? , localisation = ? , Disponibilité = ? , Nom_salle = ?  WHERE Num_salle = ? ";
        PreparedStatement statement = Dbinteraction.prepareStatement(sql);

        statement.setInt(1, capacity);
        statement.setString(2, Location);
        statement.setString(3, diponibility );
        statement.setString(4, name);
        statement.setInt(5, number);


        int rowsUpdated = statement.executeUpdate();

        Dbinteraction.disconnect();

        return rowsUpdated;
    }


}
