<%@ page import="java.io.PrintWriter" %>
<%@ page import="com.model.User" %>
<%@ page import="com.dao.SalleDAO" %>
<%@ page import="com.model.salle" %>
<%@ page import="java.util.List" %>
<%@ page import="java.sql.SQLException" %><%--
  Created by IntelliJ IDEA.
  User: DELL
  Date: 11/12/2023
  Time: 14:29
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="resources/css/Style.css">


    <title>Salle</title>


</head>
<body>
<%
    PrintWriter o = response.getWriter();
    HttpSession ses= request.getSession(false);
    User user = (User) ses.getAttribute("user");
    if (session.getAttribute("user") != null) {
    List<salle> salles;
    SalleDAO salleDAO = new SalleDAO();
    String searchByLocation= request.getParameter("searchByLocation");
    String searchByNomSalle = request.getParameter("searchByNomSalle");
    String searchByNumSalle = request.getParameter("searchByNumSalle");


    if ((searchByLocation != null && !searchByLocation.isEmpty()) ||
            (searchByNomSalle != null && !searchByNomSalle.isEmpty()) ||
            (searchByNumSalle != null && !searchByNumSalle.isEmpty())) {
        try {
            // Perform a filtered search if any parameter is provided
            salles = salleDAO.searchSalles(searchByLocation, searchByNomSalle, searchByNumSalle);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    } else {
        try {
            salles = salleDAO.getAllSalles();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
%>
<%@ include file="Sidebar.jsp" %>

<div class="content" id="mainContent">
    <div class="page-title">
        <h1>Listes des Salles</h1>
    </div>

    <div>
        <button class="add-button" id="addSallesButton" onclick="openAddSalleModal()">+ Ajouter une salle </button>
    </div>

    <div>
        <form action="salle.jsp" method="get">
            <input type="text" class="filter-input" placeholder="Localisation" name="searchByLocation" id="filterByLocation">
            <input type="text" class="filter-input" placeholder="Nom de la salle" name="searchByNomSalle" id="filterByNomSalle">
            <input type="number" class="filter-input" placeholder="Numéro de la salle" name="searchByNumSalle" id="filterByNumSalle">
            <button class="add-button" type="submit" id="searchSalles">Chercher</button>
        </form>
    </div>


    <table class="table" id="SallesTable">
        <thead>
        <tr>
            <th>Num de salle</th>
            <th>Nom de Salle</th>
            <th>Capacité</th>
            <th>Localisation</th>
            <th>Disponibilité</th>
            <th>Edit</th>
            <th>Supprimer</th>
        </tr>
        </thead>
        <tbody id="sallesBody">
        <% for (salle Salle : salles) { %>
        <tr>
            <td><%= Salle.getNum_salle() %></td>
            <td><%= Salle.getNom_salle() %></td>
            <td><%= Salle.getCapacity() %></td>
            <td><%= Salle.getLocalisation() %></td>
            <td><%= Salle.getDisponibilily() %></td>
            <td><button class="edit-button" onclick="openEditSalleModal(<%= Salle.getNum_salle() %>, '<%=  Salle.getNom_salle() %>', <%=  Salle.getCapacity()  %>, '<%= Salle.getLocalisation() %>', '<%= Salle.getDisponibilily() %>')">Edit</button></td>
            <td><button class="delete-button" onclick="deleteRow(<%= Salle.getNum_salle() %>);">Delete</button></td>
        </tr>
        <% } %>
        </tbody>
    </table>
        <%

    } else {
        ses.invalidate();
    response.sendRedirect("login.jsp");
    }
   %>

    <div class="modal" id="addSalleModal">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Ajouter une salle</h5>
                    <button type="button" class="close close-button" data-dismiss="modal" onclick="closeAddSalleModal() " aria-label="Close">
                        <span aria-hidden="true">x</span>
                    </button>
                </div>
                <div class="modal-body">
                    <form id="SalleForm" method="post" action="addSalle">
                        <div class="form-group">
                            <div class="input-group">
                                <label for="capacite">Capacité</label>
                                <input type="number" class="form-control" name="capacite" id="capacite" placeholder="Entrez la capacité" required>
                            </div>
                            <span id="capacityLabel"></span>
                            <div class="input-group">
                                <label for="Localisation">Localisation</label>
                                <input type="text" class="form-control" name="Localisation" id="Localisation" placeholder="Entrez la localisation" required>
                            </div>
                            <span id="LocalisationLabel"></span>
                            <div class="input-group">
                                <label for="Nom_salle">Nom du salle</label>
                                <input type="text" class="form-control" name="Nom_salle" id="Nom_salle" placeholder="Entrez le nom de salle" required>
                            </div>
                            <span id="Nom_salleLabel"></span>
                            <div class="input-group">
                                <label for="Num_salle"> Num du salle</label>
                                <input type="number" class="form-control" name="Num_salle" id="Num_salle" placeholder="Entrez le numéro du salle" required>
                            </div>
                            <span id="Num_salleLabel"></span>

                            <!-- Add a checkbox for availability -->
                            <div class="form-check">
                                <input type="radio" class="form-check-input" name="disponibilite" id="disponible" value="Disponible">
                                <label class="form-check-label" for="disponible">Disponible</label>
                            </div>
                            <div class="form-check">
                                <input type="radio" class="form-check-input" name="disponibilite" id="occupé" value="Occupé">
                                <label class="form-check-label" for="occupé">Occupé</label>
                            </div>
                            <span id="occupéLabel"></span>

                        </div>
                        <div class="button-container">
                            <button type="button" class="btn-secondary" onclick="resetForm()">Réinitialiser</button>
                            <button type="submit" class="btn-primary">Enregistrer</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <div class="modal" id="editSalleModal">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Modifier une salle</h5>
                    <button type="button" class="close close-button" data-dismiss="modal" onclick="closeEditSalleModal()" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <form id="editSalleForm" method="post" action="EditSalle">
                        <!-- Input fields for Room Number, Capacity, Location, etc. -->
                        <div class="form-group">
                            <label for="editRoomNumber">Numéro de salle</label>
                            <input type="text" class="form-control" name="editRoomNumber" id="editRoomNumber" readonly>
                        </div>
                        <span id="editRoomNumberLabel"></span>
                        <div class="form-group">
                            <label for="editRoomName">Nom de salle</label>
                            <input type="text" class="form-control" name="editRoomName" id="editRoomName" readonly>
                        </div>
                        <span id="editRoomNameLabel"></span>
                        <div class="form-group">
                            <label for="editCapacity">Capacité</label>
                            <input type="number" class="form-control" name="editCapacity" id="editCapacity" required>
                        </div>
                        <span id="editCapacityLabel"></span>
                        <div class="form-group">
                            <label for="editLocation">Emplacement</label>
                            <input type="text" class="form-control" name="editLocation" id="editLocation" required>
                        </div>
                        <span id="editLocationLabel"></span>
                        <div class="form-check">
                            <input type="radio" class="form-check-input" name="editDisponible" id="editDisponible" value="Disponible">
                            <label class="form-check-label" for="disponible">Disponible</label>
                        </div>
                        <div class="form-check">
                            <input type="radio" class="form-check-input" name="editDisponible" id="editOccupé" value="Occupé">
                            <label class="form-check-label" for="occupé">Occupé</label>
                        </div>
                        <span id="editdisponibiliteLabel"></span>
                        <div class="button-container">
                            <button type="button" class="btn-secondary" onclick="resetEditSalleForm()">Réinitialiser</button>
                            <button type="submit" class="btn-primary">Enregistrer</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>


    <script>
        function resetForm() {
            document.getElementById('SalleForm').reset();
        }

        function openAddSalleModal() {
            // Show the modal
            document.getElementById('addSalleModal').style.display = 'block';
        }

        function closeAddSalleModal() {
            // Close the modal
            document.getElementById('addSalleModal').style.display = 'none';
        }

        // Add this part to handle the form submission
        document.getElementById('SalleForm').addEventListener('submit', function (event) {
            // Prevent the default form submission
            event.preventDefault();

            // Handle the form data as needed (e.g., send it to the server)

            // Close the modal after handling the form
            closeAddSalleModal();
        });
    </script>
    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
    <script>
        $(document).ready(function () {
            // Check if the form with ID 'SalleForm' exists before binding the submit event
            if ($('#SalleForm').length) {
                $('#SalleForm').submit(function (event) {
                    // Prevent the default form submission
                    event.preventDefault();

                    // Perform AJAX submission
                    $.ajax({
                        type: 'POST',
                        url: 'addsalle',
                        data: $(this).serialize(),
                        success: function (response) {
                            // Handle the success response
                            console.log(response);
                            // You can also update the UI or close the modal if needed
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
        function deleteRow(num_salle) {
            $.ajax({
                type: 'POST',
                url: 'Deletesalle',  // Update the URL if needed
                data: { num_salle: num_salle },  // Change 'mat' to 'num_salle'
                success: function(response) {
                    if (response === 'success') {
                        // Delete the row from the table
                        var row = document.getElementById('row_' + num_salle);
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
    <script>
        function openEditSalleModal(roomNumber, roomName, capacity, location, disponibility) {
            // Show the edit modal
            document.getElementById('editSalleModal').style.display = 'block';
            document.getElementById('editRoomNumber').value = roomNumber;
            document.getElementById('editCapacity').value = capacity;
            document.getElementById('editLocation').value = location;
            document.getElementById('editRoomName').value = roomName;
            document.getElementById('editDisponible').value = disponibility;
        }

        // Add this part to handle the form submission for editing


        document.getElementById('editSalleForm').addEventListener('submit', function (event) {
            // Prevent the default form submission
            event.preventDefault();

            // Perform AJAX submission
            $.ajax({
                type: 'POST',
                url: 'EditSalle', // Update the URL to match your servlet mapping
                data: $(this).serialize(), // Serialize the form data
                success: function (response) {
                    // Handle the success response
                    if (response === 'success') {
                        // Close the edit modal after a successful edit
                        closeEditSalleModal();
                    } else {
                        // Handle the failure (e.g., display an error message)
                        console.error('Edit operation failed:', response);
                    }
                },
                error: function (error) {
                    // Handle the error
                    console.error('Error during edit operation:', error);
                }
            });
        });

        function closeEditSalleModal() {
            // Close the edit modal
            document.getElementById('editSalleModal').style.display = 'none';
        }
    </script>

</body>
</html>
