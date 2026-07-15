package com.example.projetjee22;

import com.model.User;
import com.util.Dbinteraction;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/AddAnnouncementServlet")
public class AddAnnouncementServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");

            int profId = user.getId();
            String seanceIdParam = request.getParameter("seanceId");
            int seanceId = (seanceIdParam != null && !seanceIdParam.isEmpty()) ? Integer.parseInt(seanceIdParam) : 0;

            if (seanceId > 0) {
                String announcementTitle = request.getParameter("announcementTitle");
                String announcementContent = request.getParameter("announcementContent");

                if (announcementTitle != null && announcementContent != null) {
                    try {
                        Dbinteraction.connect();
                        String sql = "INSERT INTO announcements (professor_id, seance_id, announcement_text, announcement_title)" +
                                " VALUES (?, ?, ?, ?)";

                        PreparedStatement preparedStatement = Dbinteraction.prepareStatement(sql);
                        preparedStatement.setInt(1, profId);
                        preparedStatement.setInt(2, seanceId);
                        preparedStatement.setString(3, announcementContent);
                        preparedStatement.setString(4, announcementTitle);

                        int rowsAffected = preparedStatement.executeUpdate();

                        if (rowsAffected > 0) {
                            response.sendRedirect("SeanceProf.jsp");
                        } else {
                            response.getWriter().write("error");
                        }

                        Dbinteraction.disconnect();
                    } catch (SQLException e) {
                        e.printStackTrace();
                        response.getWriter().write("error1");
                    }
                } else {
                    response.getWriter().write("error2");
                }
            } else {
                response.getWriter().write("error3");
            }
        } else {
            response.getWriter().write("error4");
        }
    }
}
