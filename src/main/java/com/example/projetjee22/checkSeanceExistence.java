package com.example.projetjee22;

import com.dao.SeanceDAO;
import com.model.Seance;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet(name = "checkSeanceExistence", value = "/checkSeanceExistence")
public class checkSeanceExistence extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
            // Retrieve form data from the request
            int courseId = Integer.parseInt(request.getParameter("courId"));
            int roomId = Integer.parseInt(request.getParameter("room"));

            Seance seance = new Seance();
            seance.setIdCour(courseId);
            seance.setSalleId(roomId);

            SeanceDAO seanceDAO = new SeanceDAO();

            try {
                // Check if the seance already exists
                boolean seanceExists = seanceDAO.seanceExists(seance);

                // Send the response to the client
                response.setContentType("text/plain");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write(seanceExists ? "SeanceExists" : "SeanceDoesNotExist");
            } catch (SQLException e) {
                // Handle the exception appropriately (e.g., log or send an error response)
                e.printStackTrace();

            }
    }
}