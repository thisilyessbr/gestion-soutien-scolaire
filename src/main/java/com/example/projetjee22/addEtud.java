package com.example.projetjee22;

import com.dao.EtudiantDAO;
import com.model.Etudiant;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet(name = "addEtud", value = "/addEtud")
public class addEtud extends HttpServlet {
    EtudiantDAO etudiantDAO ;
    @Override
    public void init(ServletConfig config) throws ServletException {
        etudiantDAO = new EtudiantDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
            String nom = request.getParameter("nom");
            String login =  nom + generateRandomString(4);
            String password = generateRandomString(10);
            int mat = Integer.parseInt(request.getParameter("mat"));
            String prenom = request.getParameter("prenom");
            String adresse = request.getParameter("adresse");
            String email = request.getParameter("email");
            String matiere = request.getParameter("matiere");
            int tel = Integer.parseInt(request.getParameter("tel"));



            Etudiant newEtudiant = new Etudiant(mat, prenom, nom, adresse, email, matiere, tel ,login ,password);


        try {
            etudiantDAO.addEtudiant(newEtudiant);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }


        response.sendRedirect("Students.jsp");

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