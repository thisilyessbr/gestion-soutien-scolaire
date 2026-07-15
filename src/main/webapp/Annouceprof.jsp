<%@ page import="com.model.User" %>
<%@ page import="com.util.Dbinteraction" %>
<!DOCTYPE html>
<html lang="en">
<head>
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
            padding-bottom: 10px;
            margin-bottom: 20px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }

        input,
        textarea {
            width: 50%;
            padding: 10px;
            margin-bottom: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }

        .button-container {
            text-align: left;
            display: flex;
            gap: 15px ;
        }

        .btn-primary {
            background-color: #007bff;
            color: #fff;
            border: none;
            padding: 8px 15px;
            cursor: pointer;
            border-radius: 10px;
        }

        .btn-primary:hover {
            background-color: #0056b3;
        }
        .return-button {
            background-color: #ff0000;;
            color: #fff;
            border: none;
            padding: 8px 15px;
            cursor: pointer;
            border-radius: 10px;
        }

        .return-button:hover {
            background-color:  #cc0000;
        }

        .page-title {
            border-bottom: 2px solid #007bff;
            margin-bottom: 20px;
            padding: 10px;
        }

    </style>
</head>
<body>

<%
    HttpSession ses = request.getSession(false);
    User user = (User) ses.getAttribute("user");
    if (ses.getAttribute("user") != null) {

        String seanceIdParam = request.getParameter("seanceId");
        int seanceId = (seanceIdParam != null && !seanceIdParam.isEmpty()) ? Integer.parseInt(seanceIdParam) : 0;



%>




<div class="content">
    <div class="page-title">
        <h1>Annoucement for Seance <%= seanceId %> </h1>
    </div>
    <form action="AddAnnouncementServlet" method="post">
        <div class="form-group">
            <label for="announcementTitle">Announcement Title:</label>
            <input type="text" name="announcementTitle" id="announcementTitle" required>
        </div>
        <input type="hidden" name="seanceId" value="<%= seanceId %>">
        <div class="form-group">
            <label for="announcementContent">Announcement Content:</label>
            <textarea name="announcementContent" id="announcementContent" rows="10" required></textarea>
        </div>

        <div class="button-container">
            <a href="SeanceProf.jsp" class="return-button">Return to Seance</a>
            <button type="submit" class="btn-primary">Send Announcement</button>
        </div>
    </form>

</div>

<%

    } else {
        ses.invalidate();
        response.sendRedirect("login.jsp");
    }
%>

</body>
</html>
