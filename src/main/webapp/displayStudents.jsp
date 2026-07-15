<%@ page import="java.util.List" %>
<%@ page import="com.model.User" %>
<%@ page import="java.io.PrintWriter" %>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    PrintWriter o = response.getWriter();
    List<User> students = (List<User>) request.getAttribute("students");

    // Check if the list is not null or empty
    if (students != null && !students.isEmpty()) {
        for (User student : students) {
            o.println( " Name: " + student.getNom() + " " + student.getPrenom() + " .");
        }
    }
%>

