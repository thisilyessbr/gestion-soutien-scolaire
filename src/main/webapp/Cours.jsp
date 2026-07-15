<%--
  Created by IntelliJ IDEA.
  User: DELL
  Date: 13/12/2023
  Time: 17:59
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="com.model.User" %>
<%@ page import="com.model.Presence" %>
<%@ page import="com.dao.PresenceDAO" %>
<%@ page import="java.sql.ClientInfoStatus" %>
<%@ page import="java.util.List" %>
<%@ page import="com.dao.CourDAO" %>
<%@ page import="com.model.Cour" %>
<%@ page import="java.sql.SQLException" %><%--
  Created by IntelliJ IDEA.
  User: DELL
  Date: 13/12/2023
  Time: 02:06
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@ include file="Sidebar.jsp" %>
    <link rel="stylesheet" href="resources/css/Style.css">
    <title>Cours</title>

</head>
<body>
<%
    HttpSession ses = request.getSession(false);
    List<Cour> courList;
    if (session.getAttribute("user") != null) {
        User user = (User) ses.getAttribute("user");
        CourDAO courDAO = new CourDAO();
        String searchByName = request.getParameter("searchByNomCours");
        if (searchByName != null && !searchByName.isEmpty()) {
            try {
                // Perform a filtered search if any parameter is provided
                courList = courDAO.searchCours(searchByName);
            } catch (SQLException e) {
                throw new RuntimeException(e);
            }
        } else {
            try {
                courList = courDAO.getCoursWithEnseignants();
            } catch (SQLException e) {
                throw new RuntimeException(e);
            }
        }

%>


<div class="content" id="mainContent">
    <div class="page-title">
        <h1>Listes des cours</h1>
    </div>

    <div>
        <button class="add-button" id="addCoursButton" onclick="openAddCoursModal()">+ Ajouter un cour</button>
    </div>

    <div>
        <form action="Cours.jsp" method="get">
            <input type="text" class="filter-input" placeholder="Nom du Cour" name="searchByNomCours" id="filterByNom">
            <button class="add-button" type="submit" id="searchcours" >Chercher</button>
        </form>
    </div>

    <table class="table" id="GroupsPresence">
        <thead>
        <tr>
            <th>ID du cour</th>
            <th>Nom du cour</th>
            <th>Nom du matière</th>
            <th>Nom du enseignant</th>
            <th>Prenom du enseignant</th>
            <th>Supprimer</th>
        </tr>
        </thead>
        <tbody id="classesBody">
        <%
            // Display each student in the table
            for ( Cour cour : courList) {
        %>

        <tr>

            <td ><%= cour.getId_cour()%></td>
            <td><%= cour.getNom_cour() %></td>
            <td ><%= cour.getNom_matiere()%></td>
            <td><%= cour.getNom_enseignant()%></td>
            <td><%= cour.getPrenom_enseignant()%></td>
            <td><button class="delete-button" onclick="deleteRow(<%= cour.getId_cour()%>);">Delete</button></td>
        </tr>
        <%
            }
        %>
        </tbody>
    </table>
        <%

    } else {
        ses.invalidate();
    response.sendRedirect("login.jsp");
    }
   %>

    <div class="modal" id="addCoursModal">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Ajouter un cours</h5>
                    <button type="button" class="close close-button" data-dismiss="modal" onclick="closeAddCoursModal()" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <form id="CoursForm" method="post" action="addCours">
                        <div class="form-group">
                            <div class="input-group">
                                <label for="nomCours">Nom du cours</label>
                                <input type="text" class="form-control" name="nomCours" id="nomCours" placeholder="Entrez le nom du cours" required>
                            </div>
                            <span id="nomCoursLabel"></span>
                            <div class="input-group">
                                <label for="matiere">Matière</label>
                                <input type="text" class="form-control" name="matiere" id="matiere" placeholder="Entrez la matière" required>
                            </div>
                            <span id="matiereLabel"></span>
                            <div class="input-group">
                                <label for="enseignantMAT">MAT du Enseignant </label>
                                <input type="number" class="form-control" name="enseignantMAT" id="enseignantMAT" placeholder="Entrez le MAT de l'enseignant" required>
                            </div>
                            <span id="enseignantIDLabel"></span>

                        </div>
                        <div class="button-container">
                            <button type="button" class="btn-secondary" onclick="resetCoursForm()">Réinitialiser</button>
                            <button type="submit" class="btn-primary">Enregistrer</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>





    <!-- Add this script section to the head of your HTML -->
    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>

    <script>
        function resetCoursForm() {
            document.getElementById('CoursForm').reset();
        }

        function openAddCoursModal() {
            // Show the modal
            document.getElementById('addCoursModal').style.display = 'block';
        }

        function closeAddCoursModal() {
            // Close the modal
            document.getElementById('addCoursModal').style.display = 'none';
        }

        // Add this part to handle the form submission
        document.getElementById('CoursForm').addEventListener('submit', function (event) {
            // Prevent the default form submission
            event.preventDefault();

            // Handle the form data as needed (e.g., send it to the server)

            // Close the modal after handling the form
            closeAddCoursModal();
        });
    </script>
    <script>
        $(document).ready(function () {
            // Check if the form with ID 'CoursForm' exists before binding the submit event
            if ($('#CoursForm').length) {
                $('#CoursForm').submit(function (event) {
                    // Prevent the default form submission
                    event.preventDefault();

                    // Perform AJAX submission
                    $.ajax({
                        type: 'POST',
                        url: 'addCours',
                        data: $(this).serialize(), // Serialize the form data
                        success: function (response) {
                            // Handle the success response
                            console.log(response);
                            // You can also update the UI or close the modal if needed
                            closeAddCoursModal();
                        },
                        error: function (error) {
                            // Handle the error
                            console.error(error);
                        }
                    });
                });
            }
        });
    </script>
    <script>
        function deleteRow(id_code) {
            $.ajax({
                type: 'POST',
                url: 'DeleteCour',
                data: { id_code: id_code },
                success: function(response) {
                    if (response === 'success') {
                        // Delete the row from the table after successful delete operation
                        var row = document.getElementById('row_' + id_code);
                        row.parentNode.removeChild(row);
                    } else {
                        // Handle the failure (e.g., display an error message)
                        console.error('Delete operation failed:', response);
                    }
                },
                error: function(error) {
                    // Handle the error
                    console.error('Error during delete operation:', error);
                }
            });
        }

    </script>



</body>
</html>
