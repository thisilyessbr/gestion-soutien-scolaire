package com.example.projetjee22;

import com.dao.SalleDAO;
import com.model.Announcement;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet(name = "ProcessAnnouncement", value = "/ProcessAnnouncement")
public class ProcessAnnouncement extends HttpServlet {

    Announcement announcement;

    @Override
    public void init(ServletConfig config) throws ServletException {
        announcement = new Announcement() ;
    }
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String announcementTitle = request.getParameter("announcementTitle");
        String announcementContent = request.getParameter("announcementContent");




    }
}