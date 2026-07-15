package com.example.projetjee22;

import com.dao.PaymentDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet(name = "deleteScolarite", value = "/deleteScolarite")
public class deleteScolarite extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String paymentIdParam = request.getParameter("paymentId");

        if (paymentIdParam != null && !paymentIdParam.isEmpty()) {
            try {
                int paymentId = Integer.parseInt(paymentIdParam);
                PaymentDAO paymentDAO = new PaymentDAO();
                int rowsAffected = paymentDAO.deletePaymentById(paymentId);

                if (rowsAffected > 0) {
                    // Deletion was successful
                    response.getWriter().write("success");
                } else {
                    // No rows were deleted (scholarite not found or other issues)
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