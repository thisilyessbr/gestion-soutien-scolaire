package com.example.projetjee22;

import com.dao.SeanceDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet(name = "addStudentToSeance", value = "/addStudentToSeance")
public class addStudentToSeance extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
            // Retrieve the form parameters
            String studentMAT = request.getParameter("studentMAT");
            String seanceScheduleIdStr = request.getParameter("seanceScheduleId");

            if (studentMAT != null && !studentMAT.isEmpty() && seanceScheduleIdStr != null && !seanceScheduleIdStr.isEmpty()) {
                try {
                    // Convert seanceScheduleId to integer
                    int seanceScheduleId = Integer.parseInt(seanceScheduleIdStr);

                    // Call the DAO method to add the student to the seance
                    SeanceDAO studentSeanceDAO = new SeanceDAO();
                    int rowsAffected = studentSeanceDAO.addStudentToSeance(studentMAT, seanceScheduleId);

                    if (rowsAffected > 0) {
                        // Send a success response
                        response.getWriter().write("Student added to seance successfully");
                    } else {
                        // Send a failure response
                        response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error adding student to seance");
                    }
                } catch (NumberFormatException e) {
                    // Handle invalid seanceScheduleId (not a number)
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid seanceScheduleId");
                } catch (SQLException e) {
                    // Handle database-related errors
                    response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error adding student to seance");
                }
            } else {
                // Handle missing or empty parameters
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing or empty parameters");
            }
        }
    }
