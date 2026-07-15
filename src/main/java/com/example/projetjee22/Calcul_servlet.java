package com.example.projetjee22;

import com.util.Dbinteraction;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet(name = "Calcul_servlet", value = "/Calcul_servlet")
public class Calcul_servlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Assuming your Dbinteraction class has methods like connect, select, and disconnect
            Dbinteraction.connect();

            // Assuming select method returns a ResultSet
            ResultSet resultSet = Dbinteraction.select("SELECT count(*) AS total_eleve FROM users WHERE role ='etudiant'");

            if (resultSet.next()) {
                // Retrieve the total number of students from the ResultSet
                int totalEleve = resultSet.getInt("total_eleve");
                request.setAttribute("totalEleve", totalEleve);
                request.setAttribute("totalEleve", totalEleve);
                request.getRequestDispatcher("/Admin.jsp").forward(request, response);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            // Handle the exception, log it, or send an error response
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error retrieving total students");
        } finally {
            // Make sure to disconnect from the database in a finally block to ensure it happens even if an exception occurs
            Dbinteraction.disconnect();
        }

    }
}