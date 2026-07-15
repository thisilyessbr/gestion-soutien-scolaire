package com.example.projetjee22;

import com.dao.CourDAO;
import com.dao.EtudiantDAO;
import com.model.Cour;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet(name = "addCours", value = "/addCours")
public class addCours extends HttpServlet {

    CourDAO courDAO;
    @Override
    public void init(ServletConfig config) throws ServletException {
        courDAO = new CourDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String nomCours= request.getParameter("nomCours");
        String matiere = request.getParameter("matiere");
        int enseignantMAT = Integer.parseInt(request.getParameter("enseignantMAT"));

        Cour newcour = new Cour(enseignantMAT,nomCours,matiere);

        try {
            courDAO.addCoursbyMAT(newcour);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}