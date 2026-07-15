package com.example.projetjee22;

import com.dao.SalleDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet(name = "Deletesalle1", value = "/Deletesalle1")
public class Deletesalle1 extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    @Override

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String numParam2 = request.getParameter("num_salle2");

        if (numParam2 != null && !numParam2.isEmpty()) {
            try {
                int num = Integer.parseInt(numParam2);
                SalleDAO salleDAO = new SalleDAO() ;
                int rowsAffected = salleDAO.deleteSalleByNum1(num);
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