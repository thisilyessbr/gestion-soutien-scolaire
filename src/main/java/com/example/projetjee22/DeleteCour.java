package com.example.projetjee22;

import com.dao.CourDAO;
import com.dao.ProfesseurDAO;
import com.dao.SalleDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet(name = "DeleteCour", value = "/DeleteCour")
public class DeleteCour extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String matParam1 = request.getParameter("id_code");

        if (matParam1 != null && !matParam1.isEmpty()) {
            try {
                int id_code = Integer.parseInt(matParam1);
                CourDAO courDAO =new CourDAO() ;
                int rowsAffected = courDAO.deleteCoursbyID(id_code);

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