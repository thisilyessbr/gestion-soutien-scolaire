<%@ page import="com.model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Devoir</title>
</head>
<style>
    .ct {
        font-family: 'Arial', sans-serif;
        background-color: #f4f4f4;
        margin: 0;
        padding: 0;
        display: flex;
        align-items: center;
        justify-content: center;
        height: 100vh;
    }

    form {
        width: 300px; /* Set the desired width of your form */
        padding: 20px;
        background-color: #fff;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        border-radius: 10px;
    }

    label {
        display: block;
        margin-bottom: 10px;
    }

    input {
        width: 100%;
        padding: 10px;
        margin-bottom: 15px;
        box-sizing: border-box;
        border: 1px solid #ccc;
        border-radius: 5px;
    }

    button {
        background-color: #007bff;
        color: #fff;
        border: none;
        padding: 10px;
        border-radius: 5px;
        cursor: pointer;
    }

    button:hover {
        background-color: #0056b3;
    }
</style>
<body>

<%
    HttpSession ses = request.getSession(false);
    User user = (User) ses.getAttribute("user");
    if (ses.getAttribute("user") != null) {



%>
<%@include file="Sidebar1.jsp"%>

<div class="ct">
    <form action="SendDevoir" method="post" enctype="multipart/form-data">
        <input type="hidden" name="professorId" value="<%= user.getId() %>">
        <label for="seanceId">Numero du seance :</label>
        <input type="number" name="seanceId" id="seanceId" required>
        <label for="devoirFile">Envoyer le devoir (PDF): </label>
        <input type="file" name="devoirFile" id="devoirFile" accept=".pdf" required>
        <button type="submit">Envoyer Devoir</button>
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
