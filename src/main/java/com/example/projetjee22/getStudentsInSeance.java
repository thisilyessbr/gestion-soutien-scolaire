package com.example.projetjee22;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import com.model.User; // Assuming you have a User class in this package or import it accordingly
import com.dao.SeanceDAO; // Adjust the import based on your actual package structure and class names

@WebServlet(name = "getStudentsInSeance", value = "/getStudentsInSeance")
public class getStudentsInSeance extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Assuming you have a parameter indicating the seanceId
        String seanceId = request.getParameter("seanceId");

        if (seanceId != null && !seanceId.isEmpty()) {
            try {
                // Call the DAO method to get students in the seance
                SeanceDAO seanceDAO = new SeanceDAO();
                List<User> students = seanceDAO.getStudentsInSeance(seanceId);

                // Set the students list as an attribute in the request
                request.setAttribute("students", students);

                // Forward the request to a JSP page to display the students
                RequestDispatcher dispatcher = request.getRequestDispatcher("displayStudents.jsp");
                dispatcher.forward(request, response);

            } catch (SQLException e) {
                // Handle database-related errors
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error getting students in seance");
            }
        } else {
            // Handle missing or empty seanceId parameter
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing or empty seanceId parameter");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // You can handle POST requests if needed
        // For example, you might use POST for submitting a form
    }
}
