package com.example.projetjee22;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.itextpdf.text.pdf.PdfPTable;
import com.util.Dbinteraction;
import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.pdf.PdfWriter;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


@WebServlet("/GeneratePDFServlet")
public class GeneratePDFServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String seanceId = request.getParameter("seanceId");
        System.out.println("Retrieved seanceId 1: " + seanceId);

        try {
            Dbinteraction.connect();

            // Fetch students with role 'etudiant' from the users table
            String query = "SELECT  u.nom, u.prenom, p.status FROM users u "
                    + "JOIN Presence p ON u.users_id = p.id_user "
                    + "WHERE u.role = 'etudiant' AND p.seance_id = ?";
            PreparedStatement preparedStatement = Dbinteraction.prepareStatement(query);
            preparedStatement.setString(1, seanceId);

            ResultSet resultSet = preparedStatement.executeQuery();

            // Create a ByteArrayOutputStream to store the PDF content
            ByteArrayOutputStream baos = new ByteArrayOutputStream();

            // Create the PDF document
            Document pdf = new Document();
            PdfWriter.getInstance(pdf, baos);
            pdf.open();
            pdf.add(new Paragraph("Seance ID: " + seanceId)); // Add relevant information
            pdf.add(new Paragraph(" "));

            float[] columnWidths = {2, 2, 2}; // Adjust the widths based on your preference
            PdfPTable table = new PdfPTable(columnWidths);

// Add table headers
            table.addCell("Nom");
            table.addCell("Prenom");
            table.addCell("Status");

            while (resultSet.next()) {
                // Add data to the table
                table.addCell(resultSet.getString("nom"));
                table.addCell(resultSet.getString("prenom"));
                table.addCell(resultSet.getString("status"));
            }

// Add the table to the PDF document
            pdf.add(table);

            pdf.close();
            resultSet.close();
            preparedStatement.close();
            Dbinteraction.disconnect();

            // Set the response headers
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "attachment; filename=\"student_list.pdf\"");

            // Write the PDF content to the response output stream
            response.getOutputStream().write(baos.toByteArray());
            response.getOutputStream().flush();
            response.getOutputStream().close();
        } catch (DocumentException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

