package com.example.projetjee22;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.SQLException;

import com.dao.EtudiantDAO;

@WebServlet(name = "EditEtudiantServlet", value = "/editEtud")
public class EditEtudiantServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve data from the request
        int mat = Integer.parseInt(request.getParameter("editMat"));
        String prenom = request.getParameter("editPrenom");
        String nom = request.getParameter("editNom");
        String adresse = request.getParameter("editAdresse");
        String email = request.getParameter("editEmail");
        String matiere = request.getParameter("editMatiere");
        int tel = Integer.parseInt(request.getParameter("editTel"));
        // Add more fields as needed

        try {
            EtudiantDAO etudiantDAO = new EtudiantDAO();

            // Perform the update operation
            int rowsUpdated = etudiantDAO.updateEtudiant(mat, prenom, nom , adresse , email , matiere ,tel );

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
