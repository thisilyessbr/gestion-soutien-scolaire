package com.example.projetjee22;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.util.Dbinteraction;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "Downloadpdf", value = "/Downloadpdf")
public class Downloadpdf extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(Downloadpdf.class.getName());

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int sessionId;
        try {
            sessionId = Integer.parseInt(request.getParameter("id"));
            System.out.println(sessionId);
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
            connection = Dbinteraction.connect1();
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
                response.setContentType("application/pdf");

                // Copy PDF data to the response output stream
                try (OutputStream o = response.getOutputStream()) {
                    byte[] buffer = new byte[4096];
                    int bytesRead;
                    while ((bytesRead = pdfInputStream.read(buffer)) != -1) {
                        o.write(buffer, 0, bytesRead);
                    }
                }
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "PDF not found");
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error while processing the request", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error while processing the request");
        } finally {
            // Close resources
            if (pdfInputStream != null) {
                pdfInputStream.close();
            }
            if (connection != null) {
                Dbinteraction.disconnect();
            }
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Add doPost logic if needed
    }
}
