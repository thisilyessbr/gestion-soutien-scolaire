package com.example.projetjee22;

import com.dao.ProfesseurDAO;
import com.dao.SalleDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet(name = "Deletesalle", value = "/Deletesalle")
public class Deletesalle extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String numParam1 = request.getParameter("num_salle");

        if (numParam1 != null && !numParam1.isEmpty()) {
            try {
                int num = Integer.parseInt(numParam1);
                SalleDAO salleDAO = new SalleDAO() ;
                int rowsAffected = salleDAO.deleteSalleBYnum(num);

                if (rowsAffected > 0) {
                    // Deletion was successful
                    response.getWriter().write("success");
                } else {
                    // No rows were deleted (student not found or other issues)
                    response.getWriter().write("failure");
                }
            } catch (NumberFormatException | SQLException e) {
                e.printStackTrace();
                response.getWriter().write("failure");
            }
        } else {
            response.getWriter().write("failure");
        }
    }


}