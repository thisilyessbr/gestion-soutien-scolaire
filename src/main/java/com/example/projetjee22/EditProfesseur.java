package com.example.projetjee22;

import com.dao.EtudiantDAO;
import com.dao.ProfesseurDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet(name = "EditProfesseur", value = "/EditProfesseur")
public class EditProfesseur extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve data from the request
        int mat = Integer.parseInt(request.getParameter("editMatProf"));
        String prenom = request.getParameter("editPrenomProf");
        String nom = request.getParameter("editNomProf");
        String adresse = request.getParameter("editAdresseProf");
        String email = request.getParameter("editEmailProf");
        String matiere = request.getParameter("editMatiereProf");
        int tel = Integer.parseInt(request.getParameter("editTelProf"));
        // Add more fields as needed

        try {
            ProfesseurDAO professeurDAO = new ProfesseurDAO();

            // Perform the update operation
            int rowsUpdated =professeurDAO.updateProfesseur(mat, prenom, nom , adresse , email , matiere ,tel );

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