package com.dao;


import com.util.Dbinteraction;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class PasswordChangeStatusDAO {
    private static final String CHECK_PASSWORD_CHANGED_QUERY =
            "SELECT password_changed FROM PasswordChangeStatus WHERE user_id = ?";

    public Boolean hasPasswordChanged(int userId) {
        try (Connection connection = Dbinteraction.connect1();
             PreparedStatement preparedStatement = connection.prepareStatement(CHECK_PASSWORD_CHANGED_QUERY)) {
            preparedStatement.setInt(1, userId);

            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                if (resultSet.next()) {
                    return resultSet.getBoolean("password_changed");
                } else {

                    return null;
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error checking password change status", e);
        }
    }
}
