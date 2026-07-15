<%@ page import="com.model.User" %>
<%@ page import="com.model.salle" %>
<%@ page import="com.dao.SalleDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.sql.SQLException" %><%--
  Created by IntelliJ IDEA.
  User: DELL
  Date: 17/12/2023
  Time: 03:40
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
    HttpSession ses = request.getSession(false);
    User user = (User) ses.getAttribute("user");
    if (session.getAttribute("user") != null) {
        List<salle> salles;
        SalleDAO salleDAO = new SalleDAO();
        String searchByLocation = request.getParameter("searchByLocation");
        String searchByNomSalle = request.getParameter("searchByNomSalle");
        int searchByNumSalle = 0; // Default value or any other appropriate default

        // Check if searchByNumSalle parameter is provided and not empty
        String searchByNumSalleStr = request.getParameter("searchByNumSalle");
        if (searchByNumSalleStr != null && !searchByNumSalleStr.isEmpty()) {
            try {
                searchByNumSalle = Integer.parseInt(searchByNumSalleStr);
            } catch (NumberFormatException ex) {
                // Handle the case where the parameter is not a valid integer
                // You can log the error or take appropriate action
            }
        }

        if ((searchByLocation != null && !searchByLocation.isEmpty()) ||
                (searchByNomSalle != null && !searchByNomSalle.isEmpty()) ||
                searchByNumSalle > 0) {
            try {
                salles = salleDAO.searchSalles1(searchByLocation, searchByNomSalle, searchByNumSalle);
            } catch (SQLException e) {
                throw new RuntimeException(e);
            }
        } else {
            try {
                salles = salleDAO.getAllSalles1();
            } catch (SQLException e) {
                throw new RuntimeException(e);
            }
        }

%>

<%@ include file="Sidebar.jsp" %>
<div class="content" id="mainContent">
    <div class="page-title">
        <h1>Listes des Salles  </h1>
    </div>

    <div>
        <button class="add-button" id="addSallesButton" onclick="openAddSalleModal()">+ Ajouter une salle </button>
    </div>

    <div>
        <form action="Sallecp.jsp" method="get">
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
            <th>Status</th>
            <th>start_time</th>
            <th>End_time </th>
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
            <td><%= Salle.getStart_time() %></td>
            <td><%= Salle.getEnd_time() %></td>
            <td><button class="edit-button" onclick="openEditSalleModal(<%= Salle.getNum_salle() %>, '<%=  Salle.getNom_salle() %>', <%=  Salle.getCapacity()  %>, '<%= Salle.getLocalisation() %>', '<%= Salle.getDisponibilily() %>')">Edit</button></td>
            <td><button class="delete-button" onclick="deleteRow(<%= Salle.getNum_salle() %>);">Delete</button></td>
        </tr>
        <% } %>
        </tbody>
    </table>
        <%

    } else {
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

    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
    <script>
        $(document).ready(function () {
            console.log('Document ready');

            if ($('#SalleForm').length) {
                $('#SalleForm').submit(function (event) {
                    console.log('Form submitted');
                    event.preventDefault();

                    $.ajax({
                        type: 'POST',
                        url: 'addsalle1',
                        data: $(this).serialize(),
                        success: function (response) {
                            console.log('AJAX success');
                            console.log(response);

                            if (response.success) {
                                alert('Salle added successfully!');
                                $('#addSalleModal').modal('hide');
                            } else {
                                alert('Error: ' + response.message);
                            }
                        },
                        error: function (error) {
                            console.error('AJAX error');
                            console.error(error);
                        }
                    });
                });
            }
        });

    </script>

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

    <!-- ... Your HTML code ... -->

    <script>
        function deleteRow(num_salle2) {
            $.ajax({
                type: 'POST',
                url: 'Deletesalle1',
                data: { num_salle2: num_salle2 },
                success: function(response) {
                    if (response === 'success') {
                        // Delete the row from the table
                        var row = document.getElementById('row_' + num_salle2);
                        row.parentNode.removeChild(row);
                    } else {
                        // Handle the failure (e.g., display an error message)
                        console.error('Delete operation failed:', response);
                    }
                },
                error: function(error) {

                        console.error('Error during delete operation:', error);
                        alert('Error during delete operation: ' + error.statusText);

                }
            });
        }

    </script>

    <!-- ... Your HTML code ... -->

</body>
</html>
