package com.example.projetjee22;

import com.dao.SalleDAO;
import com.model.salle;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;

@WebServlet(name = "addsalle", value = "/addsalle")
public class addsalle extends HttpServlet {

    SalleDAO salleDAO ;

    @Override
    public void init(ServletConfig config) throws ServletException {
        salleDAO = new SalleDAO() ;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        int capacity = Integer.parseInt(request.getParameter("capacite"));
        String Localisation = request.getParameter("Localisation");
        String Nom_salle = request.getParameter("Nom_salle");
        String disponibilite = request.getParameter("disponibilite");
        int Num_salle= Integer.parseInt(request.getParameter("Num_salle"));

        salle Salle = new salle(capacity,Localisation,Nom_salle,disponibilite,Num_salle);

        try {
           salleDAO.addSalle(Salle);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        response.setContentType("text/plain");
        PrintWriter out = response.getWriter();

        // Return a simple response (you can customize this based on your needs)
        out.write("Salle added successfully!");

        response.sendRedirect("salle.jsp");

    }
}