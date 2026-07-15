<%@ page import="com.util.Dbinteraction" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.io.OutputStream" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page contentType="application/pdf" pageEncoding="UTF-8"%>

<%
    // Get the session ID from the request parameter
    int sessionId;
    try {
        sessionId = Integer.parseInt(request.getParameter("id"));
    } catch (NumberFormatException e) {
        response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid session ID");
        return;
    }

    // Fetch PDF data from the database based on the session ID
    Connection connection = null;
    PreparedStatement statement = null;
    ResultSet resultSet = null;
    InputStream pdfInputStream = null;

    try {
        connection = Dbinteraction.connect();
        String query = "SELECT pdf_data, pdf_file_name FROM Sessions WHERE id_session = ?";
        statement = connection.prepareStatement(query);
        statement.setInt(1, sessionId);
        resultSet = statement.executeQuery();

        if (resultSet.next()) {
            // Get the PDF data and file name
            pdfInputStream = resultSet.getBinaryStream("pdf_data");
            String pdfFileName = resultSet.getString("pdf_file_name");

            // Set response headers for file download
            response.setHeader("Content-Disposition", "attachment; filename=\"" +
                    URLEncoder.encode(pdfFileName, StandardCharsets.UTF_8.toString()) + "\"");

            // Copy PDF data to the response output stream
            OutputStream o = response.getOutputStream();
            byte[] buffer = new byte[4096];
            int bytesRead;
            while ((bytesRead = pdfInputStream.read(buffer)) != -1) {
                o.write(buffer, 0, bytesRead);
            }
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "PDF not found");
        }
    } catch (Exception e) {
        e.printStackTrace();
        response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error while processing the request");
    } finally {
        // Close resources
        if (pdfInputStream != null) {
            pdfInputStream.close();
        }
        if (resultSet != null) {
            resultSet.close();
        }
        if (statement != null) {
            statement.close();
        }
        if (connection != null) {
            Dbinteraction.disconnect();
        }
    }
%>
