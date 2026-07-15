<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*" %>
<%@ page import="jakarta.servlet.*" %>
<%@ page import="jakarta.servlet.http.*" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Logout</title>
</head>
<body>

<%
    HttpSession ses= request.getSession(false);
    if (ses != null) {
        ses.invalidate();
    }

    response.sendRedirect("login.jsp");
%>

</body>
</html>
