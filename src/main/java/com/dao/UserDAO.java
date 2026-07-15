package com.dao;

import com.model.User;
import com.util.Dbinteraction ;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserDAO implements Iuser {
    @Override
    public int addUser(User u) {
        Dbinteraction.connect();
        int nb = Dbinteraction.Maj("insert into users values (null,'"+u.getNom()+"','"+u.getPrenom()+"','"+u.getLogin()+"','"+u.getPassword()+"','"+u.getRole()+"')");
        Dbinteraction.disconnect();
        return nb ;

    }


    public User getUserById(int userId) {
        String sql = "SELECT * FROM users WHERE users_id = ?";
        try (PreparedStatement preparedStatement = Dbinteraction.connect1().prepareStatement(sql)) {
            preparedStatement.setInt(1, userId);

            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                if (resultSet != null && resultSet.next()) {
                    User user = new User();
                    user.setId(resultSet.getInt("users_id"));
                    user.setLogin(resultSet.getString("username"));
                    user.setPassword(resultSet.getString("password"));
                    user.setRole(resultSet.getString("role"));
                    user.setPasswordChanged(resultSet.getBoolean("password_changed"));

                    return user;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();  // Handle the exception (logging or other actions)
        } finally {
            Dbinteraction.disconnect();
        }

        return null;
    }


    public boolean updateUserPassword(int userId, String newPassword) {


        String updatePasswordSql = "UPDATE users SET password = ? WHERE users_id = ?";
        String updateStatusSql = "INSERT INTO PasswordChangeStatus (user_id, password_changed) VALUES (?, TRUE) " +
                "ON DUPLICATE KEY UPDATE password_changed = TRUE";

        try (Connection connection = Dbinteraction.connect1();
             PreparedStatement updatePasswordStatement = connection.prepareStatement(updatePasswordSql);
             PreparedStatement updateStatusStatement = connection.prepareStatement(updateStatusSql)) {

            connection.setAutoCommit(false);

            // Update the user's password
            updatePasswordStatement.setString(1, newPassword);
            updatePasswordStatement.setInt(2, userId);
            int rowsUpdated = Dbinteraction.executeUpdate(updatePasswordStatement);

            // Update the password change status
            updateStatusStatement.setInt(1, userId);
            Dbinteraction.executeUpdate(updateStatusStatement);

            connection.commit();

            return rowsUpdated > 0;
        } catch (SQLException e) {
            // Handle the exception (logging or other actions)
            Dbinteraction.rollback();
        } finally {
            Dbinteraction.setAutoCommit(true);
            Dbinteraction.disconnect();
        }

        return false;  // Return false if the update fails
    }


    @Override
    public int addUser(String nom, String prenom, String login, String Password , String role) {
        Dbinteraction.connect();
        int nb = Dbinteraction.Maj("insert into users values (null,'"+nom+"','"+prenom+"','"+login+"','"+Password+"','"+role+"')");
        Dbinteraction.disconnect();
        return nb ;
    }

    @Override
    public User authentification(String login, String Password) {
        User u = null ;
        Dbinteraction.connect();
        ResultSet rs = Dbinteraction.select("select * from users where login='"+login+"' and password='"+Password+"'");
        try {
            if(rs.next())
            {
                u = new User(rs.getInt(1),rs.getString(2),rs.getString(3),rs.getString(4),rs.getString(5),rs.getString(6),rs.getInt(7));

            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        return u ;

    }
}
