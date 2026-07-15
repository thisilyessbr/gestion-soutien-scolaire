<%@ page import="java.util.List" %>
<%@ page import="com.model.User" %>
<%@ page import="com.dao.SalleDAO" %>
<%@ page import="com.dao.SeanceDAO" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="com.itextpdf.text.Document" %>
<%@ page import="com.itextpdf.text.DocumentException" %>
<%@ page import="com.itextpdf.text.Paragraph" %>
<%@ page import="com.itextpdf.text.pdf.PdfWriter" %>
<%@ page import="java.io.FileOutputStream" %>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
<head>
    <title>Manage Presence</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100vh;
            flex-direction: column;
        }

        h2 {
            font-size: 2em;
            text-align: center;
            color: #007bff; /* Blue color */
        }

        form {
            width: 300px;
            padding: 20px;
            background-color: #fff;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            border-radius: 10px;
        }

        label {
            display: block;
            margin-bottom: 10px;
        }

        input[type="radio"] {
            margin-right: 5px;
        }

        .edit-buttons {
            display: flex;
            justify-content: space-between;
        }

        button {
            background-color: #007bff;
            color: #fff;
            border: none;
            padding: 10px 15px;
            cursor: pointer;
            border-radius: 5px;
            margin-bottom: 10px;
        }

        button:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>

<h2>Manage Presence</h2>

<form action="UpdatePresence" method="post"  >


    <%
        String seanceId = request.getParameter("seanceId");
        System.out.println("seanceId: " + seanceId);
        if (seanceId != null && !seanceId.isEmpty()) {
            int id = Integer.parseInt(seanceId);
        }
        List<User> students;

        SeanceDAO seanceDAO = new SeanceDAO();
        try {
            students = seanceDAO.getStudentsInSeance(seanceId);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        for (User student : students) {
            String userId = String.valueOf(student.getId());
            String presenceStatus = null;
            try {
                presenceStatus = seanceDAO.getPresenceStatus(userId, seanceId);
            } catch (SQLException e) {
                throw new RuntimeException(e);
            }
    %>

    <div>
        <input type="hidden" name="seanceId" value="<%= seanceId %>">
        <input type="hidden" name="UserID_<%= student.getId()%>" value="<%= student.getId()%>">
        <p>Name: <%= student.getNom() + " " + student.getPrenom() %></p>
        <% if ("Present".equals(presenceStatus) || "Absent".equals(presenceStatus)) { %>
        <label>Present<input type="radio" name="presence_<%= student.getId()%>" value="Present" <%= presenceStatus.equals("Present") ? "checked" : "" %>></label>
        <label>Absent<input type="radio" name="presence_<%= student.getId()%>" value="Absent" <%= presenceStatus.equals("Absent") ? "checked" : "" %>></label>
        <div class="edit-buttons">
            <button type="button" name="edit_<%= student.getId()%>" onclick="enableEdit('<%= student.getId()%>')">Edit</button>
            <button type="submit" name="save_<%= student.getId()%>" style="display:none;">Save</button> <!-- Hidden Save button -->
            <button type="button" name="cancel_<%= student.getId()%>" style="display:none;" onclick="cancelEdit('<%= student.getId()%>')">Cancel</button> <!-- Hidden Cancel button -->
        </div>
        <% } else { %>
        <label>Present<input type="radio" name="presence_<%= student.getId()%>" value="Present" checked></label>
        <label>Absent<input type="radio" name="presence_<%= student.getId()%>" value="Absent"></label>
        <button type="submit" name="submit_<%= student.getId()%>">Submit</button> <!-- Submit button -->
        <% } %>
    </div>

    <%
        }
    %>

    <button type="button" name="downloadPdf" onclick="downloadPdf('<%= seanceId %>')">Download PDF</button>


</form>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        function enableEdit(studentId) {
            // Enable the radio buttons for editing
            var radioButtons = document.getElementsByName('presence_' + studentId);
            for (var i = 0; i < radioButtons.length; i++) {
                radioButtons[i].disabled = false;
            }

            // Show the Save and Cancel buttons for this student
            document.querySelector("button[name='save_" + studentId + "']").style.display = 'inline';
            document.querySelector("button[name='cancel_" + studentId + "']").style.display = 'inline';

            document.querySelector("button[name='edit_" + studentId + "']").style.display = 'none';
        }

        function cancelEdit(studentId) {

            document.forms[0].reset();
            document.querySelector("button[name='save_" + studentId + "']").style.display = 'none';
            document.querySelector("button[name='cancel_" + studentId + "']").style.display = 'none';
            document.querySelector("button[name='edit_" + studentId + "']").style.display = 'inline';
        }

        var editButtons = document.querySelectorAll('[name^="edit_"]');
        editButtons.forEach(function(button) {
            button.addEventListener('click', function() {
                var studentId = button.getAttribute('name').split('_')[1];
                enableEdit(studentId);
                var presenceValue = document.querySelector("input[name='presence_" + studentId + "']:checked").value;
                console.log('Edit clicked - Student ID:', studentId, 'Presence Value:', presenceValue);
            });
        });

        document.querySelector("button[name='downloadPdf']").addEventListener('click', function () {
            var seanceId = document.querySelector("input[name='seanceId']").value;

            console.log('Retrieved seanceId:', seanceId);

            var data = {
                seanceId: seanceId
            };
            console.log('About to make AJAX request with seanceId:', seanceId);
            // Make an AJAX request to the server to generate the PDF
            fetch('GeneratePDFServlet', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded' // or 'multipart/form-data'
                },
                body: 'seanceId=' + encodeURIComponent(seanceId)
            })

                    .then(response => {
                    console.log('Received AJAX response:', response);
                    if (!response.ok) {
                        throw new Error(`HTTP error! Status: ${response.status}`);
                    }

                    return response.blob().then(blob => ({ blob }));
                })
                .then(data => {
                    var link = document.createElement('a');
                    link.href = window.URL.createObjectURL(data.blob);
                    link.download = 'seance_' + seanceId + '.pdf';

                    document.body.appendChild(link);
                    link.click();
                    document.body.removeChild(link);
                })
                .catch(error => {
                    console.error('Error downloading PDF:', error);
                });
        });
    });

</script>








</body>
</html>
