
<%@ page import="java.util.List" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.dao.SeanceDAO" %>
<%@ page import="com.model.Seance" %>
<%@ page import="com.model.User" %>
<%@ page import="com.dao.EtudiantDAO" %>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <link rel="stylesheet" href="resources/css/Style.css">
    <title>Seance Etudiant</title>
</head>
<body>
<%@include file="Sidebar2.jsp"%>

<%
    HttpSession ses = request.getSession(false);
    User user = (User) ses.getAttribute("user");
    if (ses.getAttribute("user") != null) {
        List<Seance> seances = new ArrayList<>();
        int studentId = user.getId(); // Assuming the user is a student

        SeanceDAO seanceDAO = new SeanceDAO();
        String searchByCourNom = request.getParameter("searchByCourNom");
        String searchByDate = request.getParameter("searchByDate");

        if ((searchByCourNom != null && !searchByCourNom.isEmpty()) ||
                (searchByDate != null && !searchByDate.isEmpty())) {
            try {
                seances = seanceDAO.searchSeancesbyprof(searchByCourNom, searchByDate , studentId);
            } catch (SQLException e) {
                throw new RuntimeException(e);
            }
        } else {
            try {
                seances = seanceDAO.getAllSeancesOfStudent(studentId);
            } catch (SQLException e) {
                throw new RuntimeException(e);
            }
        }


%>

<!-- The rest of your HTML code remains unchanged -->

<div class="content" id="mainContent">
    <div class="page-title">
        <h1>Listes des Seances</h1>
    </div>

    <div>
        <form action="SeanceEtud.jsp" method="get">
            <input type="text" class="filter-input" placeholder="Cour Nom" name="searchByCourNom" id="filterByCourNom">
            <input type="date" class="filter-input" placeholder="Date" name="searchByDate" id="filterByDate">
            <!-- Add more input fields as needed for your search criteria -->
            <button class="add-button" type="submit" id="searchSeances">Search</button>
        </form>
    </div>

    <!-- Add your HTML code to display seances for the student -->
    <table class="table" id="SeancesTable">
        <thead>
        <tr>
            <th>Cour Nom</th>
            <th>Salle Nom</th>
            <th>Date</th>
            <th>Debut temps </th>
            <th>Fin temps </th>
        </tr>
        </thead>
        <tbody id="SeancesBody">
        <% for (Seance seance : seances) { %>
        <tr>
            <td><%= seance.getNom_cour() %></td>
            <td><%= seance.getNom_salle() %></td>
            <td><%= seance.getDateSeance() %></td>
            <td><%= seance.getHeureDebut() %></td>
            <td><%= seance.getHeureFin() %></td>
        </tr>
        <% } %>
        </tbody>
    </table>


</div>

<%
    } else {
        ses.invalidate();
        response.sendRedirect("login.jsp");
    }
%>



</body>
</html>
