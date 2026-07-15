<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.util.Dbinteraction" %>
<style>
    /* Add any custom styles for your navigation bar here */
    body, html {
        margin: 0;
        padding: 0;
    }


    .navbar {
        background-color: #fff;
        padding: 10px;
        text-align: right;
        color: #fff;
        position: relative; /* Ensure relative positioning for absolute child */
    }

    .navbar button {
        background-color: #fff;
        color: #007bff;
        border: none;
        padding: 5px 10px;
        cursor: pointer;
        border-radius: 5px;
        margin-right: 10px;
    }

    #academicYearDropdown {
        display: none;
        position: relative;
        box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
        z-index: 1;
        width: 150px;
        color: #000000;
        top: 10px;
        left: 1250px ;
    }

    #academicYearDropdown div {
        padding: 10px;
        cursor: pointer;
    }
</style>
<script>
    function toggleDropdown() {
        var dropdown = document.getElementById("academicYearDropdown");
        dropdown.style.display = (dropdown.style.display === "none" || dropdown.style.display === "") ? "block" : "none";
    }

    function selectAcademicYear(academicYear) {
        var selectedYearElement = document.getElementById("selectedYear");
        if (selectedYearElement) {
            selectedYearElement.innerText = academicYear;
            // Create a form dynamically
            var form = document.createElement("form");
            form.action = "Seance.jsp";
            form.method = "get";

            // Create a hidden input to store the selected academic year
            var input = document.createElement("input");
            input.type = "hidden";
            input.name = "selectedAcademicYear";
            input.value = academicYear;

            // Append the input to the form
            form.appendChild(input);

            // Append the form to the body and submit it
            document.body.appendChild(form);
            form.submit();
        } else {
            console.error("Element with ID 'selectedYear' not found.");
        }
    }
</script>

<div class="navbar">
    <button onclick="toggleDropdown()">  <i class="fa fa-cog" aria-hidden="true" style="font-size: 20px;"></i></button>

    <div id="academicYearDropdown">
        <%
            try {
                Connection connection = Dbinteraction.connect1();
                String query = "SELECT DISTINCT annee_scolaire FROM users";

                Statement statement = connection.createStatement();
                ResultSet resultSet = statement.executeQuery(query);

                while (resultSet.next()) {
                    String academicYearDropdown = resultSet.getString("annee_scolaire");
        %>
        <div onclick="selectAcademicYear('<%= academicYearDropdown %>')"><%= academicYearDropdown %></div>
        <%
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        %>

        <div hidden="hidden" id="selectedYear"></div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/js/all.min.js"></script>
</div>
