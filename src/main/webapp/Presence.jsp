<%@ page import="com.model.User" %>
<%@ page import="com.model.Presence" %>
<%@ page import="com.dao.PresenceDAO" %>
<%@ page import="java.sql.ClientInfoStatus" %>
<%@ page import="java.util.List" %><%--
  Created by IntelliJ IDEA.
  User: DELL
  Date: 13/12/2023
  Time: 02:06
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@ include file="Sidebar.jsp" %>
    <link rel="stylesheet" href="resources/css/Style.css">
    <title>Presence</title>
</head>
<body>
<%
    HttpSession ses = request.getSession(false);
    List<Presence> presenceList;
    if (session.getAttribute("user") != null) {
        User user = (User) ses.getAttribute("user");
        PresenceDAO presenceDAO =new PresenceDAO() ;
       presenceList = presenceDAO.getAllPresence();
%>


<div class="content" id="mainContent">
    <div class="page-title">
        <h1>Listes des Présences</h1>
    </div>

    <div>
        <form action="" method="get">
            <input type="text" class="filter-input" placeholder="Nom" name="searchByNom" id="filterByNom">
            <input type="text" class="filter-input" placeholder="Prenom" name="searchByPrenom" id="filterByPrenom">
            <button class="add-button" type="submit" id="searchlists" >Chercher</button>
        </form>
    </div>

    <table class="table" id="GroupsPresence">
        <thead>
        <tr>
            <th>Mat Etudiant</th>
            <th>Etudiants(e)</th>
            <th>Date Séance</th>
            <th>Présence</th>
            <th>Matière</th>
            <th>Formation</th>
        </tr>
        </thead>
        <tbody id="classesBody">
        <%
            // Display each student in the table
            for ( Presence presence : presenceList) {
        %>

        <tr>

            <td ><%= presence.getId_etudiant() %></td>
            <td><%= presence.getNom_etudiant() %></td>
            <td ><%= presence.getSeance() %></td>
            <td><%= presence.getEtat() %></td>
            <td><%= presence.getMatiere()%></td>
            <td><%= presence.getFormation() %></td>
            </tr>
        <%
            }
        %>
        </tbody>
    </table>
        <%

    } else {
        ses.invalidate();
    response.sendRedirect("login.jsp");
    }
   %>

    <!-- Add this script section to the head of your HTML -->
    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>




</body>
</html>
