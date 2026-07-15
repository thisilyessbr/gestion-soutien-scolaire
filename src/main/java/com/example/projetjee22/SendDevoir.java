
package com.example.projetjee22;

import com.dao.SessionDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.io.InputStream;
import java.sql.SQLException;
@WebServlet("/SendDevoir")
@MultipartConfig
public class SendDevoir extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);

        if (session != null && session.getAttribute("user") != null) {
            String professorIdStr = request.getParameter("professorId");
            String seanceIdStr = request.getParameter("seanceId");

            if (professorIdStr != null && !professorIdStr.isEmpty() && seanceIdStr != null && !seanceIdStr.isEmpty()) {
                try {
                    int professorId = Integer.parseInt(professorIdStr);
                    int seanceId = Integer.parseInt(seanceIdStr);

                    Part filePart = request.getPart("devoirFile");
                    String fileName = extractFileName(filePart);
                    InputStream fileInputStream = filePart.getInputStream();

                    SessionDAO sessionDAO = new SessionDAO();

                    try {
                        sessionDAO.uploadDevoir(professorId, seanceId, fileInputStream, fileName);
                    } catch (SQLException e) {
                        throw new ServletException("Error uploading devoir", e);
                    }

                    response.sendRedirect("Devoir.jsp");
                } catch (NumberFormatException e) {
                    e.printStackTrace(); // Log or handle the exception appropriately
                    response.sendRedirect("error.jsp");
                }
            } else {
                // Handle the case where professorIdStr or seanceIdStr is null or empty
                // You might want to redirect the user to an error page or show an error message
                response.sendRedirect("error.jsp");
            }
        } else {
            response.sendRedirect("login.jsp");
        }
    }

    private String extractFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        String[] items = contentDisposition.split(";");

        for (String item : items) {
            if (item.trim().startsWith("filename")) {
                return item.substring(item.indexOf("=") + 2, item.length() - 1);
            }
        }

        return "unknown";
    }
}
