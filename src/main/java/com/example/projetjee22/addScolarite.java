package com.example.projetjee22;

import com.dao.PaymentDAO;
import com.dao.SalleDAO;
import com.model.Payment;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.sql.Date;
import java.sql.SQLException;

@WebServlet(name = "addScolarite", value = "/addScolarite")
public class addScolarite extends HttpServlet {

    PaymentDAO paymentDAO;

    @Override
    public void init(ServletConfig config) throws ServletException {
        paymentDAO = new PaymentDAO() ;
    }
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Extract parameters from the request
            int userMat = Integer.parseInt(request.getParameter("userMat"));
            BigDecimal paymentAmount = new BigDecimal(request.getParameter("paymentAmount"));
            String paymentMethod = request.getParameter("paymentMethod");
            Date paymentDate = Date.valueOf(request.getParameter("paymentDate"));
            BigDecimal montantPaye = new BigDecimal(request.getParameter("montantPaye"));
            BigDecimal montantReste = new BigDecimal(request.getParameter("montantReste"));
            String etat = request.getParameter("etat1");


            Payment payment = new Payment( paymentAmount, paymentMethod, paymentDate, montantPaye, montantReste, etat);
            paymentDAO.addPayment(payment ,userMat);
        } catch (NumberFormatException | SQLException e) {
            throw new RuntimeException(e);
        }

        response.setContentType("text/plain");
        PrintWriter out = response.getWriter();
        out.write("Payment added successfully!");

    }
}