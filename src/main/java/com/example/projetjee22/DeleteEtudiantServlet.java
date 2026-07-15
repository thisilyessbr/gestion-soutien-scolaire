package com.example.projetjee22;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.SQLException;

import com.dao.EtudiantDAO ;

@WebServlet(name = "DeleteEtudiantServlet", value = "/DeleteEtudiantServlet")
public class DeleteEtudiantServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String matParam = request.getParameter("mat");

        if (matParam != null && !matParam.isEmpty()) {
            try {
                int mat = Integer.parseInt(matParam);
                EtudiantDAO etudiantDAO = new EtudiantDAO();
                int rowsAffected = etudiantDAO.deleteEtudiantByMat(mat);

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