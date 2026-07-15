package com.example.projetjee22;

import com.dao.EtudiantDAO;
import com.dao.ProfesseurDAO;
import com.model.Etudiant;
import com.model.Professeur;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet(name = "addProf", value = "/addProf")
public class addProf extends HttpServlet {
    ProfesseurDAO professeurDAO ;
    @Override
    public void init(ServletConfig config) throws ServletException {
        professeurDAO = new ProfesseurDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String nom = request.getParameter("nom1");
        String login =  nom + generateRandomString(4);
        String password = generateRandomString(10);
        int mat = Integer.parseInt(request.getParameter("mat1"));
        String prenom = request.getParameter("prenom1");
        String adresse = request.getParameter("adresse1");
        String email = request.getParameter("email1");
        String matiere = request.getParameter("matiere1");
        int tel = Integer.parseInt(request.getParameter("tel1"));



        Professeur newProfesseur = new Professeur(mat, prenom, nom, adresse, email, matiere, tel ,login ,password);


        try {
            professeurDAO.addProfesseur(newProfesseur);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }


        response.sendRedirect("Profs.jsp");

    }
    private String generateRandomString(int length) {
        // Define the characters allowed in the random string
        String allowedChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

        // Create a StringBuilder to build the random string
        StringBuilder randomStringBuilder = new StringBuilder(length);

        // Generate a random string by appending random characters
        for (int i = 0; i < length; i++) {
            int index = (int) (Math.random() * allowedChars.length());
            randomStringBuilder.append(allowedChars.charAt(index));
        }

        return randomStringBuilder.toString();
    }
}