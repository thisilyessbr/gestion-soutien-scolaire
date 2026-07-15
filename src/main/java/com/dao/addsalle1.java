package com.dao;

import com.model.salle;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;

@WebServlet(name = "addsalle1", value = "/addsalle1")
public class addsalle1 extends HttpServlet {


    SalleDAO salleDAO ;

    @Override
    public void init(ServletConfig config) throws ServletException {
        salleDAO = new SalleDAO() ;
    }
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        int capacity1 = Integer.parseInt(request.getParameter("capacite"));
        String Localisation1 = request.getParameter("Localisation");
        String Nom_salle1 = request.getParameter("Nom_salle");
        int Num_salle1 = Integer.parseInt(request.getParameter("Num_salle"));

        salle Salle = new salle(capacity1,Localisation1,Nom_salle1,Num_salle1);

        try {
            salleDAO.addSalle1(Salle);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        response.sendRedirect("salle.jsp");

    }
}