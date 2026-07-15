<%@ page import="com.model.User" %>
<%@ page import="com.util.Dbinteraction" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.PreparedStatement" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Sessions</title>
    <%@ include file="Sidebar2.jsp" %>
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

        .session-card {
            border: 1px solid #ccc;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
        }

        .session-title {
            font-size: 24px;
            font-weight: bold;
            margin-bottom: 10px;
        }

        .pdf-container {
            margin-top: 10px;
        }

        .pdf-link {
            display: block;
            margin-bottom: 10px;
        }

        .pdf-object {
            width: 100%;
            height: 500px; /* Set the desired height for the embedded PDF viewer */
        }
    </style>
</head>
<body>

<%
    HttpSession ses = request.getSession(false);
    User user = (User) ses.getAttribute("user");
    if (ses.getAttribute("user") != null) {
        Dbinteraction.connect();
        String sessionsSql = "SELECT  seance_schedule_id FROM StudentSeance  "+
                "Where student_id  = ?";
        PreparedStatement scheduleStatement = Dbinteraction.prepareStatement(sessionsSql);
        scheduleStatement.setInt(1, user.getId());
        ResultSet scheduleResultSet = scheduleStatement.executeQuery();
%>

<div class="content">
    <div class="page-title">
        <h1>Vos devoir ou Cour</h1>
    </div>

    <div class="session-container">
        <% while (scheduleResultSet.next()) {
            int seance_schedule_id= scheduleResultSet.getInt("seance_schedule_id");
            String  seance_schedule_idSql = "SELECT * FROM Sessions WHERE  seance_schedule_id  = ?";
            PreparedStatement sessionsStatement = Dbinteraction.prepareStatement(seance_schedule_idSql);
            sessionsStatement.setInt(1,  seance_schedule_id );
            ResultSet sessionsResultSet = sessionsStatement.executeQuery();
        %>

        <div class="session-card">
            <div class="session-title">Seance <%= seance_schedule_id %></div>

            <div class="pdf-container">
                <% while ( sessionsResultSet.next()) {
                    int sessionId =  sessionsResultSet.getInt("id_session");
                    String pdfFileName =sessionsResultSet.getString("pdf_file_name");

                  %>
                <div><%= pdfFileName %></div>
                <form action="Downloadpdf" method="get">
                    <input type="hidden" name="id" value="<%= sessionId %>">
                    <button type="submit">Download <%= pdfFileName %></button>
                </form>
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

</body>
</html>
