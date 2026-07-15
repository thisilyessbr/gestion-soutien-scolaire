package com.example.projetjee22;

import com.dao.EtudiantDAO;
import com.dao.ProfesseurDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet(name = "DeleteProf", value = "/DeleteProf")
public class DeleteProf extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String matParam1 = request.getParameter("mat");

        if (matParam1 != null && !matParam1.isEmpty()) {
            try {
                int mat = Integer.parseInt(matParam1);
                ProfesseurDAO professeurDAO = new ProfesseurDAO();
                int rowsAffected = professeurDAO.deleteProfesseurByMat(mat);

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