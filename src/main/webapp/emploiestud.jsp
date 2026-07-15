<%@ page import="com.model.Seance" %>
<%@ page import="java.util.List" %>
<%@ page import="com.dao.SeanceDAO" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.time.LocalTime" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.ZoneId" %>
<%@ page import="com.model.User" %>

<html>
<head>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <title>Emploi du Temps</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
        }

        .content {
            width: 84%;
            padding: 20px;
            background-color: #fff;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            margin: auto; /* Center the content */
        }

        .page-title {
            border-bottom: 2px solid #007bff;
            padding-bottom: 10px;
            margin-bottom: 20px;
        }

        /* Center the calendar */
        #calendar-container {
            text-align: center;
            margin-left: 550px;
        }

        #calendar {
            display: inline-block;
            margin-top: 20px;

        }
    </style>
    <!-- Include jQuery from CDN -->
    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>

    <!-- Include flatpickr JavaScript from CDN -->
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
</head>
<body>

<%
    HttpSession ses = request.getSession(false);
    User user = (User) ses.getAttribute("user");
    if (ses.getAttribute("user") != null) {
        int stud_id =user.getId();
        List<Seance> seances = new ArrayList<>();
        SeanceDAO seanceDAO = new SeanceDAO();

        try {
            seances = seanceDAO.getAllSeancesOfStudent1(stud_id);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
%>

<%@ include file="Sidebar2.jsp" %>

<div class="content" id="mainContent">
    <div class="page-title">
        <h1>Emploi du Temps</h1>
    </div>

    <div id="calendar-container">
        <div id="calendar"></div>
    </div>
    <div id="seanceDetails"></div> <!-- Add a div to display seance details -->

    <script>
        document.addEventListener('DOMContentLoaded', function () {
            // JavaScript object to organize events by date
            var groupedEvents = {};

            // Group events by date
            <% for (Seance seance : seances) { %>
            <%
                Date dateSeance = seance.getDateSeance();
                LocalTime heureDebut = seance.getHeureDebut();
                Date heureFin = seance.getHeureFin();
                String nomCour = seance.getNom_cour();
                String nom =seance.getEnseignantNom();
                String prenom =seance.getEnseignantPrenom();

                if (dateSeance != null && heureDebut != null && heureFin != null) {
                    try {
                        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
                        SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm:ss");

                        String formattedStartDate = dateFormat.format(dateSeance);
                        String formattedStartTime = timeFormat.format(Date.from(heureDebut.atDate(LocalDate.now()).atZone(ZoneId.systemDefault()).toInstant()));
                        String formattedEndTime = timeFormat.format(heureFin);
            %>

            // Create an array for each date if it doesn't exist
            if (!groupedEvents['<%= formattedStartDate %>']) {
                groupedEvents['<%= formattedStartDate %>'] = [];
            }

            // Add the event to the corresponding date
            groupedEvents['<%= formattedStartDate %>'].push({
                title: '<%= seance.getIdSeance() %>', // Display seance number as the title
                start: '<%= formattedStartDate %>T<%= formattedStartTime %>',
                end: '<%= formattedStartDate %>T<%= formattedEndTime %>',
                description: 'Seance ID: <%= seance.getIdSeance() %> - Commence a <%= formattedStartTime %>, se termine a <%= formattedEndTime %> , dans <%=nomCour%> cour , avec professeur <%=nom%> <%=prenom%>',
                url: 'manage.jsp?seanceId=<%= seance.getIdSeance() %>'
            });
            <%
                    } catch (IllegalArgumentException e) {
                        // Handle the case when date or time is not in the expected format
                    }
                } else {
                    // Handle the case when date, heureDebut, or heureFin is null
                    // You may want to provide a default value or take appropriate action
                }
            %>
            <% } %>

            // Initialize flatpickr with the calendar
            var calendar = flatpickr("#calendar", {
                mode: "range",
                dateFormat: "Y-m-d",
                defaultDate: ["today"],
                inline: true,
                events: groupedEvents,
                eventRender: function (event, element) {
                    element.find('.fc-title').append("<br/>" + event.description);
                },
                onChange: function (selectedDates, dateStr, instance) {
                    // Display seances for the clicked date
                    displaySeancesForDate(dateStr);
                }
            });

            // Function to display seances for the clicked date
            function displaySeancesForDate(dateStr) {
                // Retrieve seances for the clicked date
                var seancesForDate = groupedEvents[dateStr] || [];

                // Display seances in the UI
                var seanceDetails = document.getElementById('seanceDetails');
                seanceDetails.innerHTML = '<h2>Seances for ' + dateStr + '</h2>';
                seanceDetails.innerHTML += '<ul>';
                seancesForDate.forEach(function (seance) {
                    seanceDetails.innerHTML += '<li>' + seance.description + '</li>';
                });
                seanceDetails.innerHTML += '</ul>';
            }
        });
    </script>
</div>

<%
    } else {
        ses.invalidate();
        response.sendRedirect("login.jsp");
    }
%>
</body>
</html>

