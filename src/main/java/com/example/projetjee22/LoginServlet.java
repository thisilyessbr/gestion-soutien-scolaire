package com.example.projetjee22;

import com.dao.PasswordChangeStatusDAO;
import com.dao.UserDAO;
import com.model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet(name = "LoginServlet", value = "/login")
public class LoginServlet extends HttpServlet {

    UserDAO em;
   PasswordChangeStatusDAO passwordChangeStatusDAO ; // Assuming you have a DAO for PasswordChangeStatus

    @Override
    public void init(ServletConfig config) throws ServletException {
        em = new UserDAO();
        passwordChangeStatusDAO = new PasswordChangeStatusDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String log = req.getParameter("txt");
        String password = req.getParameter("pwd");
        User u = em.authentification(log, password);
        resp.setHeader("Cache-Control","no-cache, no-store ,must-revalidate");

        if (u != null) {
            HttpSession session = req.getSession();
            session.setAttribute("user", u);

            if (u.getRole().equals("admin")) {
                resp.sendRedirect("Admin.jsp");
            } else if (u.getRole().equals("professeur")) {
                Boolean passwordChanged = passwordChangeStatusDAO.hasPasswordChanged(u.getId());

                if (passwordChanged == null) {
                    // If the status is not set, it's the first login, redirect to change password page
                    session.setAttribute("userId", u.getId()); // Assuming userId is the unique identifier
                    req.getRequestDispatcher("changePassword.jsp").forward(req, resp);
                } else {
                    // Set the flag to true for subsequent requests in the same session
                    session.setAttribute("passwordChanged", true);
                    resp.sendRedirect("professeur.jsp");
                }

            } else if (u.getRole().equals("etudiant")) {
                // Check if the user has changed the password during the current session
                Boolean passwordChanged = passwordChangeStatusDAO.hasPasswordChanged(u.getId());

                if (passwordChanged == null) {
                    // If the status is not set, it's the first login, redirect to change password page
                    session.setAttribute("userId", u.getId()); // Assuming userId is the unique identifier
                    req.getRequestDispatcher("changePassword.jsp").forward(req, resp);
                } else {
                    // Set the flag to true for subsequent requests in the same session
                    session.setAttribute("passwordChanged", true);
                    resp.sendRedirect("etudiant.jsp");
                }
            } else {
                resp.sendRedirect("login.jsp");
            }
        } else {
            resp.sendRedirect("erreur.jsp");
        }
    }
}
