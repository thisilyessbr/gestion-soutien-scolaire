package com.example.projetjee22;

import com.dao.ProfesseurDAO;
import com.dao.SalleDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet(name = "EditSalle", value = "/EditSalle")
public class EditSalle extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve data from the request
        int number = Integer.parseInt(request.getParameter("editRoomNumber"));
        String Location = request.getParameter("editLocation");
        String name = request.getParameter("editRoomName");
        String diponibility = request.getParameter("editDisponible");
        int capacity = Integer.parseInt(request.getParameter("editCapacity"));

        // Add more fields as needed

        try {
            SalleDAO salleDAO = new SalleDAO() ;

            int rowsUpdated =salleDAO.updateSalle(number, name, Location, diponibility , capacity );

            if (rowsUpdated > 0) {
                response.getWriter().write("success");
            } else {
                response.getWriter().write("failure");
            }
        } catch (NumberFormatException | SQLException e) {
            e.printStackTrace();
            response.getWriter().write("failure");
        }
    }
}