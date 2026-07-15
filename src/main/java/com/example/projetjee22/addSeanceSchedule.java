package com.example.projetjee22;

import com.dao.SalleDAO;
import com.dao.SeanceDAO;
import com.model.Seance;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.sql.Time;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;

@WebServlet(name = "addSeanceSchedule", value = "/addSeanceSchedule")
public class addSeanceSchedule extends HttpServlet {

    SeanceDAO seanceDAO;

    @Override
    public void init(ServletConfig config) throws ServletException {
        seanceDAO = new SeanceDAO() ;
    }
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String room = request.getParameter("room");

        // Split the selected value into num_salle and nom_salle
        String[] roomValues = room.split(":");
        int numSalle = Integer.parseInt(roomValues[0]);

        // Parse courId to int
        int courId = Integer.parseInt(request.getParameter("courId"));

        String heureDebutString = request.getParameter("heureDebut");
        String heureFinString = request.getParameter("heureFin");
        String dateSeanceString = request.getParameter("dateSeance");

        // Parse dateSeance to LocalDate
        LocalDate dateSeance = LocalDate.parse(dateSeanceString);

        // Parse heureDebut and heureFin to LocalTime
        LocalTime heureDebut = LocalTime.parse(heureDebutString, DateTimeFormatter.ofPattern("HH:mm"));
        LocalTime heureFin = LocalTime.parse(heureFinString, DateTimeFormatter.ofPattern("HH:mm"));

        Time sqlHeureDebut = Time.valueOf(heureDebut);
        Time sqlHeureFin = Time.valueOf(heureFin);
        Date sqlDateSeance = Date.valueOf(dateSeance);

        Seance seance = new Seance(courId ,numSalle ,sqlDateSeance ,sqlHeureDebut ,sqlHeureFin );

        try {
            seanceDAO.addSeance(seance);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        try {
            // Existing code for processing the request

        } catch (Exception e) {
            e.printStackTrace();  // Log the exception to the console
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Internal Server Error");
        }

    }
}