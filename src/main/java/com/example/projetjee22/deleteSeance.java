package com.example.projetjee22;

import com.dao.SeanceDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet(name = "deleteSeance", value = "/deleteSeance")
public class deleteSeance extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        // Retrieve the seanceId from the request parameters
        String seanceId = request.getParameter("seanceId");

        if (seanceId != null && !seanceId.isEmpty()) {
            try {
                // Call the DAO method to delete the seance
                SeanceDAO seanceDAO = new SeanceDAO();
                seanceDAO.deleteSeanceById(Integer.parseInt(seanceId));

                // Send a success response
                response.getWriter().write("Seance deleted successfully");
            } catch (SQLException e) {
                // Handle database-related errors
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error deleting seance");
            } catch (NumberFormatException e) {
                // Handle invalid seanceId (not a number)
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid seanceId");
            }
        } else {
            // Handle missing or empty seanceId parameter
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing or empty seanceId parameter");
        }
    }
}