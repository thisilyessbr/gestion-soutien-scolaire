package com.dao;

import com.model.Payment;
import com.model.Presence;
import com.util.Dbinteraction;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class PaymentDAO {
    public List<Payment> getAllPayments() throws SQLException {
        List<Payment> paymentList = new ArrayList<>();
        Dbinteraction.connect();

        String query = "SELECT s.payment_id, s.user_id, s.payment_amount, s.payment_method, s.payment_date," +
                "       s.Montant_paye, s.Montant_reste, s.Etat, u.nom, u.prenom " +
                "FROM scolarite1 s " +
                "JOIN users u ON s.user_id = u.users_id " +
                "WHERE u.role = 'etudiant';";

        ResultSet rs = Dbinteraction.select(query);

        while (rs.next()) {
            Payment payment = new Payment();
            payment.setPaymentId(rs.getInt("payment_id"));
            payment.setUserId(rs.getInt("user_id"));
            payment.setPaymentAmount(rs.getBigDecimal("payment_amount"));
            payment.setPaymentMethod(rs.getString("payment_method"));
            payment.setPaymentDate(rs.getDate("payment_date"));
            payment.setMontantPaye(rs.getBigDecimal("Montant_paye"));
            payment.setMontantReste(rs.getBigDecimal("Montant_reste"));
            payment.setEtat(rs.getString("Etat"));
            payment.setNom_etudiant(rs.getString("nom"));
            payment.setPrenom_etudiant(rs.getString("prenom"));

            paymentList.add(payment);
        }

        Dbinteraction.disconnect();

        return paymentList;
    }
    public List<Payment> searchPayments(String searchByNomEtudiant, String searchByPrenomEtudiant, String etat) throws SQLException {
        List<Payment> payments = new ArrayList<>();

        Dbinteraction.connect();


        String sql = "SELECT s.payment_id, s.user_id, s.payment_amount, s.payment_method, s.payment_date," +
                "       s.Montant_paye, s.Montant_reste, s.Etat, u.nom, u.prenom " +
                "FROM scolarite1 s " +
                "JOIN users u ON s.user_id = u.users_id " +
                "WHERE 1=1";

        // Add conditions based on the provided parameters
        if (searchByNomEtudiant != null && !searchByNomEtudiant.isEmpty()) {
            sql += " AND u.nom LIKE '%" + searchByNomEtudiant + "%'";
        }

        if (searchByPrenomEtudiant != null && !searchByPrenomEtudiant.isEmpty()) {
            sql += " AND u.prenom LIKE '%" + searchByPrenomEtudiant + "%'";
        }

        if (etat != null && !etat.isEmpty() && !etat.equals("Tous")) {
            sql += " AND s.Etat = '" + etat + "'";
        }

        ResultSet rs = Dbinteraction.select(sql);

        try {
            while (rs.next()) {
                Payment payment = new Payment();
                payment.setPaymentId(rs.getInt("payment_id"));
                payment.setUserId(rs.getInt("user_id"));
                payment.setPaymentAmount(rs.getBigDecimal("payment_amount"));
                payment.setPaymentMethod(rs.getString("payment_method"));
                payment.setPaymentDate(rs.getDate("payment_date"));
                payment.setMontantPaye(rs.getBigDecimal("Montant_paye"));
                payment.setMontantReste(rs.getBigDecimal("Montant_reste"));
                payment.setEtat(rs.getString("Etat"));
                payment.setNom_etudiant(rs.getString("nom"));
                payment.setPrenom_etudiant(rs.getString("prenom"));
                // Add other setters accordingly

                payments.add(payment);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        return payments;
    }
    public int getUserIdByMat(int mat) throws SQLException {
            Connection connection = null;
            PreparedStatement statement = null;
            ResultSet resultSet = null;
            int userId = -1;

            try {
                connection = Dbinteraction.connect1();


                String query = "SELECT users_id FROM users WHERE mat = ?";
                statement = connection.prepareStatement(query);
                statement.setInt(1, mat);

                resultSet = statement.executeQuery();

                if (resultSet.next()) {
                    userId = resultSet.getInt("users_id");
                }
            } finally {
                Dbinteraction.disconnect();
            }

            return userId;
        }


        public void addPayment(Payment payment, int mat) throws SQLException {
            Connection connection = null;
            PreparedStatement statement = null;

            try {
                connection = Dbinteraction.connect1();  // Replace this with your database connection method


                int userId = getUserIdByMat(mat);
                String insertQuery = "INSERT INTO scolarite1 (user_id, payment_amount, payment_method, payment_date, Montant_paye, Montant_reste, Etat) " +
                        "VALUES (?, ?, ?, ?, ?, ?, ?)";
                statement = connection.prepareStatement(insertQuery);
                statement.setInt(1, userId);
                statement.setBigDecimal(2, payment.getPaymentAmount());
                statement.setString(3, payment.getPaymentMethod());
                statement.setDate(4, new java.sql.Date(payment.getPaymentDate().getTime()));
                statement.setBigDecimal(5, payment.getMontantPaye());
                statement.setBigDecimal(6, payment.getMontantReste());
                statement.setString(7, payment.getEtat());

                statement.executeUpdate();
            } finally {
                Dbinteraction.disconnect();
            }
        }


    public int updatePayment(int paymentId, BigDecimal montantPaye, BigDecimal montantReste, String etat) throws SQLException {
        Connection connection = null;
        PreparedStatement statement = null;
        int rowsUpdated = 0;

        try {
            connection = Dbinteraction.connect1();

            String updateQuery = "UPDATE scolarite1 SET Montant_paye = ?, Montant_reste = ?, Etat = ? WHERE payment_id = ?";
            statement = connection.prepareStatement(updateQuery);
            statement.setBigDecimal(1, montantPaye);
            statement.setBigDecimal(2, montantReste);
            statement.setString(3, etat);
            statement.setInt(4, paymentId);

            rowsUpdated = statement.executeUpdate();
        } finally {
            Dbinteraction.disconnect();
        }

        return rowsUpdated;
    }

    public int deletePaymentById(int paymentId) throws SQLException {
        Dbinteraction.connect();
        try {
            String sql = "DELETE FROM scolarite1 WHERE payment_id = ?";
            PreparedStatement statement = Dbinteraction.prepareStatement(sql);
            statement.setInt(1, paymentId);
            return statement.executeUpdate();
        } finally {
            Dbinteraction.disconnect();
        }
    }

    public boolean checkExistingScolarite(int userMat) throws SQLException {
        boolean scholariteExists = false;
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;

        try {
            connection = Dbinteraction.connect1();
            String sql = "SELECT COUNT(*) " +
                    "FROM scolarite1 s " +
                    "JOIN users u ON s.user_id = u.users_id " +
                    "WHERE u.mat = ?";

            preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setInt(1, userMat);

            resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                int count = resultSet.getInt(1);
                scholariteExists = count > 0;

            }
        } finally {
            Dbinteraction.disconnect();
        }

        return scholariteExists;
    }

    public List<Payment> getPaymentsByAcademicYear(String academicYear) throws SQLException {
        List<Payment> payments = new ArrayList<>();
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet rs = null;

        try {
            connection = Dbinteraction.connect1();
            String query = "SELECT * FROM scolarite1 p " +
                    "JOIN users u ON p.user_id = u.users_id " +
                    "WHERE u.annee_scolaire = ?";

            preparedStatement = connection.prepareStatement(query);
            preparedStatement.setString(1, academicYear);

            rs = preparedStatement.executeQuery();

            while (rs.next()) {
                // Populate Payment object and add it to the list
                Payment payment = new Payment();
                payment.setPaymentId(rs.getInt("payment_id"));
                payment.setUserId(rs.getInt("user_id"));
                payment.setPaymentAmount(rs.getBigDecimal("payment_amount"));
                payment.setPaymentMethod(rs.getString("payment_method"));
                payment.setPaymentDate(rs.getDate("payment_date"));
                payment.setMontantPaye(rs.getBigDecimal("Montant_paye"));
                payment.setMontantReste(rs.getBigDecimal("Montant_reste"));
                payment.setEtat(rs.getString("Etat"));
                payment.setNom_etudiant(rs.getString("nom"));
                payment.setPrenom_etudiant(rs.getString("prenom"));

                payments.add(payment);
            }
        } finally {
            // Close resources in the finally block
            Dbinteraction.disconnect();
        }

        return payments;
    }





}
