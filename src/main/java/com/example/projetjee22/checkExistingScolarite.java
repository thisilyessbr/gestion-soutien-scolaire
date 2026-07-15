package com.example.projetjee22;

import com.dao.PaymentDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet(name = "checkExistingScolarite", value = "/checkExistingScolarite")
public class checkExistingScolarite extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    // Add this method to your servlet
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userMatString = request.getParameter("userMat");

        if (userMatString != null && !userMatString.isEmpty()) {
            try {

                int userMat = Integer.parseInt(userMatString);

                PaymentDAO paymentDAO = new PaymentDAO();
                boolean scholariteExists = paymentDAO.checkExistingScolarite(userMat);

                if (scholariteExists) {
                    response.getWriter().write("exists");
                } else {
                    response.getWriter().write("notExists");
                }
            } catch (NumberFormatException | SQLException e) {
                e.printStackTrace();
                response.getWriter().write("error");
            }
        } else {
            response.getWriter().write("error");
        }
    }


}