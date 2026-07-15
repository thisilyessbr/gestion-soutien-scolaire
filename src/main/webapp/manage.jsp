<!-- managePresence.jsp -->
<%@ page import="com.model.Seance" %>
<%@ page import="com.dao.SeanceDAO" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.io.PrintWriter" %>
<%
    PrintWriter ou = response.getWriter();
    String seanceIdParam = request.getParameter("seanceId");
    if (seanceIdParam != null && !seanceIdParam.isEmpty()) {
        int seanceId = Integer.parseInt(seanceIdParam);
        SeanceDAO seanceDAO = new SeanceDAO();
        Seance seance = null; // Implement this method in SeanceDAO
        try {
            seance = seanceDAO.getSeanceById(seanceId);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        // Display details of the selected Seance on the page
        if (seance != null) {
            ou.println("<h2>Seance Details</h2>");
            ou.println("<p>Date: " + seance.getDateSeance() + "</p>");
            ou.println("<p>Start Time: " + seance.getHeureDebut() + "</p>");
            ou.println("<p>End Time: " + seance.getHeureFin() + "</p>");
            // Add more details as needed
        } else {
            ou.println("<p>Seance not found.</p>");
        }
    } else {
        ou.println("<p>Invalid seanceId parameter.</p>");
    }
%>

