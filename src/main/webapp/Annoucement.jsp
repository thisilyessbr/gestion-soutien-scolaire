<%@ page import="com.model.User" %>
<%@ page import="com.util.Dbinteraction" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.PreparedStatement" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Professor Announcements</title>
    <%@ include file="Sidebar1.jsp" %>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
        }

        .content {
            width: 84%;
            height: 100vh;
            padding: 20px;
            background-color: #fff;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }

        .page-title {
            border-bottom: 2px solid #007bff;
            margin-bottom: 20px;
            padding: 10px;
        }

        .seance-card {
            border: 1px solid #ccc;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
        }

        .seance-title {
            font-size: 24px;
            font-weight: bold;
            margin-bottom: 10px;
        }

        .announcements-container {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
        }

        .announcement-card {
            border: 1px solid #ddd;
            border-radius: 10px;
            padding: 15px;
            flex: 1 0 calc(30% - 20px);
            background-color: #f9f9f9;
        }

        .announcement-title {
            font-size: 18px;
            font-weight: bold;
            margin-bottom: 10px;
        }

        .announcement-content {
            font-size: 14px;
        }

        .button-container {
            text-align: left;
            display: flex;
            gap: 15px ;
        }

        .return-button, .btn-primary {
            background-color: #007bff;
            color: #fff;
            border: none;
            padding: 8px 15px;
            cursor: pointer;
            border-radius: 10px;
            text-decoration: none;
        }

        .return-button:hover, .btn-primary:hover {
            background-color: #0056b3;
        }

        .return-button {
            background-color: #ff0000;
        }

        .return-button:hover {
            background-color:  #cc0000;
        }

        .announcement-content {
            font-size: 14px;
            display: none; /* Hide the announcement content by default */
        }
    </style>
</head>
<body>

<%
    HttpSession ses = request.getSession(false);
    User user = (User) ses.getAttribute("user");
    if (ses.getAttribute("user") != null) {
        Dbinteraction.connect();
        String seancesSql = "SELECT * FROM Seance " +
                "JOIN Cours ON Seance.id_cour = Cours.id_cour " +
                "WHERE Cours.enseignant_id = ?";
        PreparedStatement seancesStatement = Dbinteraction.prepareStatement(seancesSql);
        seancesStatement.setInt(1, user.getId());
        ResultSet seancesResultSet = seancesStatement.executeQuery();
%>

<div class="content">
    <div class="page-title">
        <h1>Announcements for Seances</h1>
    </div>

    <div class="announcements-container">
        <% while (seancesResultSet.next()) {
            int seanceId = seancesResultSet.getInt("id_seance");
            String announcementsSql = "SELECT * FROM announcements WHERE seance_id = ?";
            PreparedStatement announcementsStatement = Dbinteraction.prepareStatement(announcementsSql);
            announcementsStatement.setInt(1, seanceId);
            ResultSet announcementsResultSet = announcementsStatement.executeQuery();
        %>

        <div class="seance-card">
            <div class="seance-title">Seance <%= seanceId %></div>

            <div class="announcements-container">
                <% while (announcementsResultSet.next()) {
                    int announcementId = announcementsResultSet.getInt("announcement_id");%>
                <div class="announcement-card">
                    <div class="announcement-title"><%= announcementsResultSet.getString("announcement_title") %></div>
                    <div class="announcement-content" id="announcementContent_<%= seanceId %>_<%= announcementId %>">
                        <%= announcementsResultSet.getString("announcement_text") %>
                    </div>
                    <button onclick="toggleAnnouncementContent(<%= seanceId %>, <%= announcementId %>)">
                        Toggle Content
                    </button>
                </div>
                <% } %>
            </div>
        </div>

        <% } %>
    </div>

</div>

<%
        Dbinteraction.disconnect();
    } else {
        ses.invalidate();
        response.sendRedirect("login.jsp");
    }
%>

<script>
    function toggleAnnouncementContent(seanceId, announcementId) {
        var contentElement = document.getElementById('announcementContent_' + seanceId + '_' + announcementId);
        contentElement.style.display = (contentElement.style.display === 'none' || contentElement.style.display === '') ? 'block' : 'none';
    }
</script>
</body>
</html>
