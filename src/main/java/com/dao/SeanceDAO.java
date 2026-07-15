package com.dao;

import com.model.Seance;
import com.model.User;
import com.util.Dbinteraction;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SeanceDAO { // Assuming this class handles database interactions

    // ... (other methods and attributes)
    public Seance getSeanceById(int seanceId) throws SQLException {
        Seance seance = null;
        Dbinteraction.connect(); // Assuming this method connects to the database

        String sql = "SELECT s.id_seance, s.id_cour, s.salle_id, ss.date_seance, ss.heure_debut, ss.heure_fin " +
                "FROM Seance s " +
                "JOIN SeanceSchedule ss ON s.id_seance = ss.id_seance " +
                "WHERE s.id_seance = ?";

        try (PreparedStatement preparedStatement = Dbinteraction.prepareStatement(sql)) {
            preparedStatement.setInt(1, seanceId);

            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                if (resultSet.next()) {
                    seance = new Seance();
                    seance.setIdSeance(resultSet.getInt("id_seance"));
                    seance.setIdCour(resultSet.getInt("id_cour"));
                    seance.setSalleId(resultSet.getInt("salle_id"));
                    seance.setDateSeance(resultSet.getDate("date_seance"));
                    seance.setHeureDebut(resultSet.getTime("heure_debut"));
                    seance.setHeureFin(resultSet.getTime("heure_fin"));
                }
            }
        } catch (SQLException e) {
            // Handle the exception as needed
            throw new RuntimeException("Error retrieving Seance by id_seance", e);
        } finally {
            Dbinteraction.disconnect(); // Assuming this method disconnects from the database
        }

        return seance;
    }

    public List<Seance> getAllSeancesWithSchedules() throws SQLException {
        List<Seance> seances = new ArrayList<>();
        Dbinteraction.connect();
        ResultSet rs = Dbinteraction.select("SELECT s.id_seance, s.id_cour, s.salle_id, ss.date_seance, ss.heure_debut, ss.heure_fin FROM Seance s JOIN SeanceSchedule ss ON s.id_seance = ss.id_seance");
        while (rs.next()) {
            // Create a Seance object for each record in the result
            Seance seance = new Seance();
            seance.setIdSeance(rs.getInt("id_seance"));
            seance.setIdCour(rs.getInt("id_cour"));
            seance.setSalleId(rs.getInt("salle_id"));
            seance.setDateSeance(rs.getDate("date_seance"));
            seance.setHeureDebut(rs.getTime("heure_debut"));
            seance.setHeureFin(rs.getTime("heure_fin"));
            seances.add(seance);
        }
        return seances;
    }

    public List<Seance> getAllSeancesofaprof(int prof_id) throws SQLException {
        List<Seance> seances = new ArrayList<>();
        Dbinteraction.connect();
        ResultSet rs = Dbinteraction.select("SELECT s.id_seance, s.id_cour , c.nom_cour, s.salle_id, salle.Nom_salle, ss.date_seance, ss.heure_debut, ss.heure_fin " +
                "FROM Seance s " +
                "JOIN SeanceSchedule ss ON s.id_seance = ss.id_seance " +
                "JOIN Cours c ON s.id_cour = c.id_cour " +
                "JOIN Salle salle ON s.salle_id = salle.id_salle " +
                "WHERE c.enseignant_id = " + prof_id);



        while (rs.next()) {
            Seance seance = new Seance();
            seance.setIdSeance(rs.getInt("id_seance"));
            seance.setIdCour(rs.getInt("id_cour"));
            seance.setSalleId(rs.getInt("salle_id"));
            seance.setDateSeance(rs.getDate("date_seance"));
            seance.setHeureDebut(rs.getTime("heure_debut"));
            seance.setHeureFin(rs.getTime("heure_fin"));
            seance.setNom_cour(rs.getString("nom_cour"));
            seance.setNom_salle(rs.getString("Nom_salle"));

            seances.add(seance);
        }
        return seances;
    }

    public List<Seance> getAllSeancesOfStudent(int studentId) throws SQLException {
        List<Seance> seances = new ArrayList<>();
        Dbinteraction.connect();
        ResultSet rs = Dbinteraction.select("SELECT s.id_seance, c.nom_cour, salle.Nom_salle, ss.date_seance, ss.heure_debut, ss.heure_fin " +
                "FROM Seance s " +
                "JOIN SeanceSchedule ss ON s.id_seance = ss.id_seance " +
                "JOIN Cours c ON s.id_cour = c.id_cour " +
                "JOIN Salle salle ON s.salle_id = salle.id_salle " +
                "JOIN StudentSeance st ON s.id_seance = st.seance_schedule_id " +
                "WHERE st.student_id = " + studentId);

        while (rs.next()) {
            Seance seance = new Seance();
            seance.setIdSeance(rs.getInt("id_seance"));
            seance.setDateSeance(rs.getDate("date_seance"));
            seance.setHeureDebut(rs.getTime("heure_debut"));
            seance.setHeureFin(rs.getTime("heure_fin"));
            seance.setNom_cour(rs.getString("nom_cour"));
            seance.setNom_salle(rs.getString("Nom_salle"));

            seances.add(seance);
        }
        return seances;
    }

    public List<Seance> getAllSeancesOfStudent1(int studentId) throws SQLException {
        List<Seance> seances = new ArrayList<>();
        Dbinteraction.connect();
        ResultSet rs = Dbinteraction.select("SELECT s.id_seance, c.nom_cour, salle.Nom_salle, ss.date_seance, ss.heure_debut, ss.heure_fin, u.nom AS enseignant_nom, u.prenom AS enseignant_prenom " +
                "FROM Seance s " +
                "JOIN SeanceSchedule ss ON s.id_seance = ss.id_seance " +
                "JOIN Cours c ON s.id_cour = c.id_cour " +
                "JOIN Salle salle ON s.salle_id = salle.id_salle " +
                "JOIN StudentSeance st ON s.id_seance = st.seance_schedule_id " +
                "JOIN Users u ON c.enseignant_id = u.users_id " + // Added JOIN with Users table
                "WHERE st.student_id = " + studentId);

        while (rs.next()) {
            Seance seance = new Seance();
            seance.setIdSeance(rs.getInt("id_seance"));
            seance.setDateSeance(rs.getDate("date_seance"));
            seance.setHeureDebut(rs.getTime("heure_debut"));
            seance.setHeureFin(rs.getTime("heure_fin"));
            seance.setNom_cour(rs.getString("nom_cour"));
            seance.setNom_salle(rs.getString("Nom_salle"));
            seance.setEnseignantNom(rs.getString("enseignant_nom")); // Set enseignant's name
            seance.setEnseignantPrenom(rs.getString("enseignant_prenom")); // Set enseignant's prenom

            seances.add(seance);
        }
        return seances;
    }

    public List<Seance> getSeancesByAcademicYear(String academicYear) throws SQLException {
        List<Seance> seances = new ArrayList<>();
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet rs = null;

        try {
            connection = Dbinteraction.connect1();
            String query = "SELECT s.id_seance, c.nom_cour, salle.Nom_salle, ss.date_seance, ss.heure_debut, ss.heure_fin, u.nom AS enseignant_nom, u.prenom AS enseignant_prenom " +
                    "FROM Seance s " +
                    "JOIN SeanceSchedule ss ON s.id_seance = ss.id_seance " +
                    "JOIN Cours c ON s.id_cour = c.id_cour " +
                    "JOIN Salle salle ON s.salle_id = salle.id_salle " +
                    "JOIN Users u ON c.enseignant_id = u.users_id " + // Added JOIN with Users table
                    "JOIN StudentSeance st ON s.id_seance = st.seance_schedule_id " +
                    "JOIN Users student ON st.student_id = student.users_id " + // Added JOIN with Users table for student
                    "WHERE student.annee_scolaire = ?";

            preparedStatement = connection.prepareStatement(query);
            preparedStatement.setString(1, academicYear);

            rs = preparedStatement.executeQuery();

            while (rs.next()) {
                Seance seance = new Seance();
                seance.setIdSeance(rs.getInt("id_seance"));
                seance.setDateSeance(rs.getDate("date_seance"));
                seance.setHeureDebut(rs.getTime("heure_debut"));
                seance.setHeureFin(rs.getTime("heure_fin"));
                seance.setNom_cour(rs.getString("nom_cour"));
                seance.setNom_salle(rs.getString("Nom_salle"));
                seance.setEnseignantNom(rs.getString("enseignant_nom")); // Set enseignant's name
                seance.setEnseignantPrenom(rs.getString("enseignant_prenom")); // Set enseignant's prenom

                seances.add(seance);
            }
        } finally {
            // Close resources in the finally block
            Dbinteraction.disconnect();
        }

        return seances;
    }

    public List<Seance> searchSeancesByStudent(String searchByCourNom, String searchByDate, int studentId) throws SQLException {
        List<Seance> seances = new ArrayList<>();
        Dbinteraction.connect();

        String sql = "SELECT s.id_seance, c.nom_cour, salle.Nom_salle, ss.date_seance, ss.heure_debut, ss.heure_fin " +
                "FROM Seance s " +
                "JOIN SeanceSchedule ss ON s.id_seance = ss.id_seance " +
                "JOIN Cours c ON s.id_cour = c.id_cour " +
                "JOIN Salle salle ON s.salle_id = salle.id_salle " +
                "JOIN StudentSeance st ON s.id_seance = st.seance_schedule_id " +
                "WHERE st.student_id = " + studentId;

        if (searchByCourNom != null && !searchByCourNom.isEmpty()) {
            sql += " AND c.nom_cour LIKE '%" + searchByCourNom + "%'";
        }
        if (searchByDate != null && !searchByDate.isEmpty()) {
            sql += " AND ss.date_seance LIKE '%" + searchByDate + "%'";
        }

        ResultSet rs = Dbinteraction.select(sql);

        try {
            while (rs.next()) {
                Seance seance = new Seance();
                seance.setIdSeance(rs.getInt("id_seance"));
                seance.setNom_cour(rs.getString("nom_cour"));
                seance.setNom_salle(rs.getString("Nom_salle"));
                seance.setDateSeance(rs.getDate("date_seance"));
                seance.setHeureDebut(rs.getTime("heure_debut"));
                seance.setHeureFin(rs.getTime("heure_fin"));
                seances.add(seance);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        return seances;
    }

    public List<Seance> searchSeancesbyprof(String searchByCourNom, String searchByDate, int prof_id) throws SQLException {
        List<Seance> seances = new ArrayList<>();
        Dbinteraction.connect();

        String sql = "SELECT s.id_seance, s.id_cour , c.nom_cour, s.salle_id, salle.Nom_salle, ss.date_seance, ss.heure_debut, ss.heure_fin " +
                "FROM Seance s " +
                "JOIN SeanceSchedule ss ON s.id_seance = ss.id_seance " +
                "JOIN Cours c ON s.id_cour = c.id_cour " +
                "JOIN salle ON s.salle_id = salle.id_salle " +
                "WHERE c.enseignant_id = " + prof_id;

        if (searchByCourNom != null && !searchByCourNom.isEmpty()) {
            sql += " AND c.nom_cour LIKE '%" + searchByCourNom + "%'";
        }
        if (searchByDate != null && !searchByDate.isEmpty()) {
            sql += " AND ss.date_seance LIKE '%" + searchByDate + "%'";
        }

        ResultSet rs = Dbinteraction.select(sql);

        try {
            while (rs.next()) {
                Seance seance = new Seance();
                seance.setIdSeance(rs.getInt("id_seance"));
                seance.setNom_cour(rs.getString("nom_cour"));
                seance.setIdCour(rs.getInt("id_cour"));
                seance.setSalleId(rs.getInt("salle_id"));
                seance.setNom_salle(rs.getString("Nom_salle"));
                seance.setDateSeance(rs.getDate("date_seance"));
                seance.setHeureDebut(rs.getTime("heure_debut"));
                seance.setHeureFin(rs.getTime("heure_fin"));
                seances.add(seance);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        return seances;
    }

    public List<Seance> searchSeances(String searchByCourseId, String searchByRoomId, String searchByDate) throws SQLException {
            List<Seance> seances = new ArrayList<>();
            Dbinteraction.connect();

        String sql = "SELECT s.id_seance, s.id_cour, s.salle_id, ss.date_seance, ss.heure_debut, ss.heure_fin " +
                    "FROM Seance s " +
                    "JOIN SeanceSchedule ss ON s.id_seance = ss.id_seance " +
                    "WHERE 1=1";

            // Append conditions based on provided parameters
            if (searchByCourseId != null && !searchByCourseId.isEmpty()) {
                sql += " AND s.id_cour LIKE '%" + searchByCourseId + "%'";
            }
            if (searchByRoomId != null && !searchByRoomId.isEmpty()) {
                sql += " AND s.salle_id  LIKE '%" + searchByRoomId+ "%'";
            }
            if (searchByDate != null && !searchByDate.isEmpty()) {
                sql += " AND ss.date_seance LIKE '%" + searchByDate + "%'";
            }

             ResultSet rs = Dbinteraction.select(sql);


                try {
                    while (rs.next()) {
                        Seance seance = new Seance();
                        seance.setIdSeance(rs.getInt("id_seance"));
                        seance.setIdCour(rs.getInt("id_cour"));
                        seance.setSalleId(rs.getInt("salle_id"));
                        seance.setDateSeance(rs.getDate("date_seance"));
                        seance.setHeureDebut(rs.getTime("heure_debut"));
                        seance.setHeureFin(rs.getTime("heure_fin"));
                        seances.add(seance);
                    } } catch (SQLException e) {
                    throw new RuntimeException(e);
                }



            return seances;
        }


    public String getPresenceStatus(String userId, String seanceId) throws SQLException {
        String presenceStatus = null;
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;

        try {
            connection = Dbinteraction.connect1();
            String query = "SELECT status FROM Presence WHERE id_user = ? AND seance_id = ?";
            preparedStatement = connection.prepareStatement(query);
            preparedStatement.setInt(1, Integer.parseInt(userId));
            preparedStatement.setInt(2, Integer.parseInt(seanceId));
            resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                presenceStatus = resultSet.getString("status");
            }
        } finally {
            // Close resources in a finally block to ensure they are closed even if an exception occurs
            if (resultSet != null) {
                resultSet.close();
            }
            if (preparedStatement != null) {
                preparedStatement.close();
            }
            if (connection != null) {
                connection.close();
            }
        }

        return presenceStatus;
    }

    public void addSeance(Seance seance) throws SQLException {
        Connection connection = Dbinteraction.connect1();

        String seanceSql = "INSERT INTO Seance (id_cour, salle_id) VALUES (?, ?)";
        try (PreparedStatement seanceStatement = connection.prepareStatement(seanceSql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            seanceStatement.setInt(1, seance.getIdCour());
            seanceStatement.setInt(2, seance.getSalleId());

            // Execute the insert statement
            seanceStatement.executeUpdate();

            // Retrieve the auto-generated id_seance
            try (ResultSet generatedKeys = seanceStatement.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    seance.setIdSeance(generatedKeys.getInt(1));
                } else {
                    throw new SQLException("Failed to retrieve id_seance after insertion");
                }
            }
        }

        // Insert SeanceSchedule information
        String scheduleSql = "INSERT INTO SeanceSchedule (id_seance, date_seance, heure_debut, heure_fin) VALUES (?, ?, ?, ?)";
        try (PreparedStatement scheduleStatement = connection.prepareStatement(scheduleSql)) {
            scheduleStatement.setInt(1, seance.getIdSeance());
            scheduleStatement.setDate(2, seance.getDateSeance());
            scheduleStatement.setTime(3, Time.valueOf(seance.getHeureDebut()));
            scheduleStatement.setTime(4, seance.getHeureFin());

            // Execute the insert statement for SeanceSchedule
            scheduleStatement.executeUpdate();
        }

        // Close the connection after use
        connection.close();
    }
    public boolean seanceExists(Seance seance) throws SQLException {
        try (Connection connection = Dbinteraction.connect1()) {
            String query = "SELECT COUNT(*) FROM Seance WHERE id_cour = ? AND salle_id = ?";
            try (PreparedStatement preparedStatement = connection.prepareStatement(query)) {
                preparedStatement.setInt(1, seance.getIdCour());
                preparedStatement.setInt(2, seance.getSalleId());

                try (ResultSet resultSet = preparedStatement.executeQuery()) {
                    if (resultSet.next()) {
                        // If count is greater than 0, the seance exists
                        return resultSet.getInt(1) > 0;
                    }
                }
            }
        }
        return false; // Default to false if an exception occurs or no result is obtained
    }


    public int deleteSeanceById(int seanceId) throws SQLException {
        Dbinteraction.connect();

        try {
            // Start a transaction
            Dbinteraction.setAutoCommit(false);

            // Delete from Presence table
            String deletePresenceQuery = "DELETE FROM Presence WHERE seance_id = ?";
            try (PreparedStatement presenceStatement = Dbinteraction.prepareStatement(deletePresenceQuery)) {
                presenceStatement.setInt(1, seanceId);
                presenceStatement.executeUpdate();
            } catch (SQLException e) {
                // Rollback the transaction if an error occurs
                Dbinteraction.rollback();
                throw new SQLException("Failed to delete from Presence table.", e);
            }

            // Delete from StudentSeance table
            String deleteStudentSeanceQuery = "DELETE FROM StudentSeance WHERE seance_schedule_id IN (SELECT id_schedule FROM SeanceSchedule WHERE id_seance = ?)";
            try (PreparedStatement studentSeanceStatement = Dbinteraction.prepareStatement(deleteStudentSeanceQuery)) {
                studentSeanceStatement.setInt(1, seanceId);
                studentSeanceStatement.executeUpdate();
            } catch (SQLException e) {
                // Rollback the transaction if an error occurs
                Dbinteraction.rollback();
                throw new SQLException("Failed to delete from StudentSeance table.", e);
            }

            // Delete from SeanceSchedule table
            String deleteSeanceScheduleQuery = "DELETE FROM SeanceSchedule WHERE id_seance = ?";
            try (PreparedStatement seanceScheduleStatement = Dbinteraction.prepareStatement(deleteSeanceScheduleQuery)) {
                seanceScheduleStatement.setInt(1, seanceId);
                seanceScheduleStatement.executeUpdate();
            } catch (SQLException e) {
                // Rollback the transaction if an error occurs
                Dbinteraction.rollback();
                throw new SQLException("Failed to delete from SeanceSchedule table.", e);
            }

            // Delete from Seance table
            String deleteSeanceQuery = "DELETE FROM Seance WHERE id_seance = ?";
            try (PreparedStatement seanceStatement = Dbinteraction.prepareStatement(deleteSeanceQuery)) {
                seanceStatement.setInt(1, seanceId);
                int rowsAffected = seanceStatement.executeUpdate();

                // Commit the transaction if all deletions were successful
                Dbinteraction.commit();

                return rowsAffected;
            } catch (SQLException e) {
                // Rollback the transaction if an error occurs
                Dbinteraction.rollback();
                throw new SQLException("Failed to delete from Seance table.", e);
            }
        } finally {
            // Ensure autocommit is restored to its default state
            Dbinteraction.setAutoCommit(true);
            Dbinteraction.disconnect();
        }
    }

    public int addStudentToSeance(String studentMAT, int seanceScheduleId) throws SQLException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;

        try {
            connection = Dbinteraction.connect1();
            String sql = "INSERT INTO StudentSeance (student_id, seance_schedule_id) VALUES (?, ?)";
            preparedStatement = connection.prepareStatement(sql);

            // Retrieve the user_id based on studentMAT from the users table
            int studentId = getUserIdByMAT(studentMAT);

            // Set parameters
            preparedStatement.setInt(1, studentId);
            preparedStatement.setInt(2, seanceScheduleId);

            // Execute the query
            return preparedStatement.executeUpdate();
        } finally {
            Dbinteraction.disconnect();
        }
    }

    private int getUserIdByMAT(String studentMAT) throws SQLException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;

        try {
            connection = Dbinteraction.connect1();
            String sql = "SELECT users_id FROM users WHERE mat = ?";
            preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setString(1, studentMAT);
            resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                return resultSet.getInt("users_id");
            } else {
                // Handle the case where the user with the given MAT is not found
                throw new SQLException("User with MAT " + studentMAT + " not found");
            }
        } finally {
            Dbinteraction.disconnect();
        }
    }

    public List<User> getStudentsInSeance(String seanceId) throws SQLException {
        List<User> students = new ArrayList<>();

        // Assuming there is a method in your DAO to retrieve students based on seanceId
        // Adjust the SQL query and database schema based on your actual implementation
        String sql = "SELECT u.nom, u.prenom ,u.users_id FROM StudentSeance ss " +
                "JOIN users u ON ss.student_id = u.users_id " +
                "WHERE ss.seance_schedule_id = ?";

        try (Connection connection = Dbinteraction.connect1();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, Integer.parseInt(seanceId));
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    String nom = resultSet.getString("nom");
                    String prenom = resultSet.getString("prenom");
                    int id =resultSet.getInt("users_id");

                    // Create a User object and add it to the list
                    User student = new User();
                    student.setNom(nom);
                    student.setPrenom(prenom);
                    student.setId(id);
                    students.add(student);
                }
            }
        }

        return students;
    }



}





