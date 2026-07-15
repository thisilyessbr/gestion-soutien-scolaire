package com.example.projetjee22;

import com.dao.PaymentDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;

@WebServlet(name = "editScolarite", value = "/editScolarite")
public class editScolarite extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve data from the request
        int paymentId = Integer.parseInt(request.getParameter("editPaymentId"));
        BigDecimal montantPaye = new BigDecimal(request.getParameter("editMontantPaye"));
        BigDecimal montantReste = new BigDecimal(request.getParameter("editMontantReste"));
        String etat = request.getParameter("editEtat");

        // Add more fields as needed

        try {
            PaymentDAO paymentDAO = new PaymentDAO();

            // Update the scholarship using the DAO method
            int rowsUpdated = paymentDAO.updatePayment(paymentId, montantPaye, montantReste, etat);

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