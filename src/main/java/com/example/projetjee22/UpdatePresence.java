package com.example.projetjee22;

import com.util.Dbinteraction;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.*;
import java.util.Enumeration;

@WebServlet(name = "UpdatePresence", value = "/UpdatePresence")
public class UpdatePresence extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve presence data from the form
        String seanceId = request.getParameter("seanceId");

        // Retrieve the user IDs and presence statuses
        Enumeration<String> parameterNames = request.getParameterNames();
        while (parameterNames.hasMoreElements()) {
            String paramName = parameterNames.nextElement();
            if (paramName.startsWith("UserID")) {
                String userId = request.getParameter(paramName);
                String status = request.getParameter("presence_" + userId);
                System.out.println("Parameter: " + paramName);
                System.out.println("Parameter: " + status);
                System.out.println("Updating presence: User=" + userId + ", Seance=" + seanceId + ", Status=" + status);
                if (status != null && !status.isEmpty()) {
                    if (!checkPresence(userId, seanceId)) {
                        // If the presence does not exist, update the presence
                        updatePresence(userId, seanceId, status);
                    } else {
                        // Presence already exists, update the presence status
                        updatePresenceStatus(userId, seanceId, status);
                    }
                }
            }
        }

        response.sendRedirect("Seance.jsp?seanceId=" + seanceId);
    }

    // Method to update the presence status in the database
    private void updatePresence(String userId, String seanceId, String status) {
        try {
            Connection connection = Dbinteraction.connect1();
            String updateQuery = "INSERT INTO presence (id_user, seance_id, status) VALUES (?, ?, ?)";
            try (PreparedStatement preparedStatement = connection.prepareStatement(updateQuery)) {
                preparedStatement.setInt(1, Integer.parseInt(userId));
                preparedStatement.setInt(2, Integer.parseInt(seanceId));
                preparedStatement.setString(3, status);
                preparedStatement.executeUpdate();
            }
        } catch (SQLException e) {
            // Handle database-related errors
            e.printStackTrace(); // You might want to log the error instead
        }
    }

    private void updatePresenceStatus(String userId, String seanceId, String status) {
        try {
            Connection connection = Dbinteraction.connect1();

            String updateQuery = "UPDATE presence SET status = ? WHERE id_user = ? AND seance_id = ?";
            try (PreparedStatement preparedStatement = connection.prepareStatement(updateQuery)) {
                preparedStatement.setString(1, status);
                preparedStatement.setInt(2, Integer.parseInt(userId));
                preparedStatement.setInt(3, Integer.parseInt(seanceId));
                preparedStatement.executeUpdate();

            }
        } catch (SQLException e) {

            e.printStackTrace();
        }
    }

    private boolean checkPresence(String userId, String seanceId) {
        try {
            Connection connection = Dbinteraction.connect1();
            String checkQuery = "SELECT * FROM presence WHERE id_user = ? AND seance_id = ?";
            try (PreparedStatement preparedStatement = connection.prepareStatement(checkQuery)) {
                preparedStatement.setInt(1, Integer.parseInt(userId));
                preparedStatement.setInt(2, Integer.parseInt(seanceId));
                ResultSet resultSet = preparedStatement.executeQuery();
                return resultSet.next(); // If there is a result, presence already exists
            }
        } catch (SQLException e) {
            // Handle database-related errors
            e.printStackTrace(); // You might want to log the error instead
            return false; // Assume presence does not exist in case of an error
        }
    }
}
