package com.example.projetjee22;

import com.dao.UserDAO;
import com.model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet(name = "updatePassword", value = "/updatePassword")
public class updatePassword extends HttpServlet {

    private UserDAO em;

    @Override
    public void init(ServletConfig config) throws ServletException {
        em = new UserDAO(); // Assuming UserDAO handles database operations
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // You might want to add some logic for handling GET requests if needed
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int userId = Integer.parseInt(req.getParameter("userId"));
        String newPassword = req.getParameter("newPassword");
        String confirmPassword = req.getParameter("confirmPassword");

        if (newPassword.equals(confirmPassword)) {
            // Passwords match, update the password in the database
            boolean passwordChanged = em.updateUserPassword(userId, newPassword);

            if (passwordChanged) {
                // Redirect to a success page based on the user's role
                resp.sendRedirect("login.jsp");
            } else {
                resp.sendRedirect("changePassword.jsp");
            }
        } else {
            // Passwords don't match, handle accordingly (redirect to an error page, etc.)
            resp.sendRedirect("error.jsp");
        }
    }
}
