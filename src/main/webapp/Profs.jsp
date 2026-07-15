<%@ page import="java.io.PrintWriter" %>
<%@ page import="com.model.Professeur" %>
<%@ page import="java.util.List" %>
<%@ page import="com.model.User" %>
<%@ page import="com.dao.ProfesseurDAO" %>
<%@ page import="java.sql.SQLException" %><%--
  Created by IntelliJ IDEA.
  User: DELL
  Date: 10/12/2023
  Time: 14:55
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="resources/css/Style.css">
    <title>Profs</title>

</head>
<body>
<%
        PrintWriter o = response.getWriter();
        HttpSession ses = request.getSession(false);
        List<Professeur> profs;
        if (session.getAttribute("user") != null) {
            User user = (User) ses.getAttribute("user");
            ProfesseurDAO profDAO = new ProfesseurDAO();
            String searchByName = request.getParameter("searchByName");
            String searchByPrenom = request.getParameter("searchByPrenom");
            String searchByMat = request.getParameter("searchByMat");
            String academicYear = request.getParameter("selectedAcademicYear");
            if (academicYear != null && !academicYear.isEmpty()) {
                // Fetch payments for the selected academic year
                try {
                    profs = profDAO.getprofsByAcademicYear(academicYear);
                } catch (SQLException e) {
                    throw new RuntimeException(e);
                }
        }else if (searchByName != null && !searchByName.isEmpty()
                    || searchByPrenom != null && !searchByPrenom.isEmpty()
                    || searchByMat != null && !searchByMat.isEmpty()) {
                try {
                    // Perform a filtered search if any parameter is provided
                    profs = profDAO.searchProfesseurs(searchByName, searchByPrenom, searchByMat);
                } catch (SQLException e) {
                    throw new RuntimeException(e);
                }
            } else {
                try {
                    profs = profDAO.getAllProfesseur();
                } catch (SQLException e) {
                    throw new RuntimeException(e);
                }
            }


%>
<%@ include file="Sidebar.jsp" %>

<div class="content" id="mainContent">
    <%@ include file="NavBarProf.jsp" %>
    <div class="page-title">
        <h1>Listes des Professeurs</h1>
    </div>

    <div>
        <button class="add-button" id="addProfsButton" onclick="openAddProfModal()">+ Ajouter un prof</button>
    </div>

    <div>
        <form action="Profs.jsp" method="get">
            <input type="text" class="filter-input" placeholder="Nom" name="searchByName" id="filterByName">
            <input type="text" class="filter-input" placeholder="Prenom" name="searchByPrenom" id="filterByPrenom">
            <input type="text" class="filter-input" placeholder="MAT" name="searchByMat" id="filterByMat">
            <button class="add-button" type="submit" id="searchProfs" >Chercher</button>
        </form>
    </div>

    <table class="table" id="ProfsTable">
        <thead>
        <tr>
            <th>MAT Du prof</th>
            <th>Prénom</th>
            <th>Nom</th>
            <th>Adresse</th>
            <th>Email</th>
            <th>Matière enseigné</th>
            <th>Tel</th>
            <th>Edit</th>
            <th>Supprimer</th>
        </tr>
        </thead>
        <tbody id="classesBody">
        <%
            // Display each student in the table
            for (Professeur professeur : profs) {
        %>

        <tr>
            <td><%= professeur.getMat() %></td>
            <td><%= professeur.getPrenom() %></td>
            <td><%= professeur.getNom() %></td>
            <td><%= professeur.getAddress() %></td>
            <td><%= professeur.getEmail() %></td>
            <td><%= professeur.getMatiere() %></td>
            <td><%= professeur.getTel() %></td>
            <td><button class="edit-button" onclick="openEditProfModal(<%= professeur.getMat() %>, '<%= professeur.getPrenom() %>', '<%= professeur.getNom() %>' , '<%= professeur.getAddress() %>' , '<%= professeur.getEmail() %>' , '<%= professeur.getMatiere() %>' ,<%= professeur.getTel() %>   )">Edit</button></td>
            <td><button class="delete-button" onclick="deleteRow1(<%= professeur.getMat() %>);">Delete</button></td>
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
    <div class="modal" id="addProfModal">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Ajouter un professeur</h5>
                    <button type="button" class="close close-button" data-dismiss="modal" onclick="closeAddProfModal()" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <form id="ProfForm" method="post" action="addProf">
                        <div class="form-group">
                            <div class="input-group">
                                <label for="mat">MAT</label>
                                <input type="number" class="form-control" name="mat1" id="mat" placeholder="Entrez le matricule " required>
                            </div>
                            <span id="matLabel"></span>
                            <div class="input-group">
                                <label for="prénom">PrénomProf</label>
                                <input type="text" class="form-control" name="prenom1" id="prénom" placeholder="Entrez le prénom " required>
                            </div>
                            <span id="prenomLabel"></span>
                            <div class="input-group">
                                <label for="nom">NomProf</label>
                                <input type="text" class="form-control" name="nom1" id="nom" placeholder="Entrez le nom " required>
                            </div>
                            <span id="nomLabel"></span>
                            <div class="input-group">
                                <label for="adresse">Adresse</label>
                                <input type="text" class="form-control" name="adresse1" id="adresse" placeholder="Entrez l'adresse " required>
                            </div>
                            <span id="adresseLabel"></span>
                            <div class="input-group">
                                <label for="email">Email</label>
                                <input type="email" class="form-control" name="email1" id="email" placeholder="Entrez l'email" required>
                            </div>
                            <span id="emailLabel"></span>
                            <div class="input-group">
                                <label for="matiere">Matière enseigné</label>
                                <input type="text" class="form-control" name="matiere1" id="matiere" placeholder="Entrez la matière" required>
                            </div>
                            <span id="matièreLabel"></span>
                            <div class="input-group">
                                <label for="tel">Tel</label>
                                <input type="number" class="form-control" name="tel1" id="tel" placeholder="Entrez le telephone "required>
                            </div>
                            <span id="telLabel"></span>
                        </div>
                        <div class="button-container">
                            <button type="button"  class="btn-secondary " onclick="resetForm()">Réinitialiser</button>
                            <button type="submit" class="btn-primary">Enregistrer</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <div class="modal" id="editProfModal">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Modifier un professeur</h5>
                    <button type="button" class="close close-button" data-dismiss="modal" onclick="closeEditProfModal()" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <form id="editProfForm" method="post" action="EditProfesseur">
                        <!-- Input fields for Mat, Prenom, Nom, etc. -->
                        <div class="form-group">
                            <label for="editMatProf">MAT</label>
                            <input type="number" class="form-control" name="editMatProf" id="editMatProf" readonly>
                        </div>
                        <span id="editmatLabelProf"></span>
                        <div class="form-group">
                            <label for="editPrenomProf">Prénom</label>
                            <input type="text" class="form-control" name="editPrenomProf" id="editPrenomProf" required>
                        </div>
                        <span id="editprenomLabelProf"></span>
                        <div class="form-group">
                            <label for="editNomProf">Nom</label>
                            <input type="text" class="form-control" name="editNomProf" id="editNomProf" required>
                        </div>
                        <span id="editnomLabelProf"></span>
                        <div class="form-group">
                            <label for="editAdresseProf">Adresse</label>
                            <input type="text" class="form-control" name="editAdresseProf" id="editAdresseProf" required>
                        </div>
                        <span id="editAdresseLabelProf"></span>
                        <div class="form-group">
                            <label for="editEmailProf">Email</label>
                            <input type="email" class="form-control" name="editEmailProf" id="editEmailProf" required>
                        </div>
                        <span id="editemailLabelProf"></span>
                        <div class="form-group">
                            <label for="editMatiereProf">Matière</label>
                            <input type="text" class="form-control" name="editMatiereProf" id="editMatiereProf" required>
                        </div>
                        <span id="editmatiereLabelProf"></span>
                        <div class="form-group">
                            <label for="editTelProf">Tel</label>
                            <input type="tel" class="form-control" name="editTelProf" id="editTelProf" required>
                        </div>
                        <span id="edittelLabelProf"></span>
                        <div class="button-container">
                            <button type="button" class="btn-secondary" onclick="resetEditProfForm()">Réinitialiser</button>
                            <button type="submit" class="btn-primary">Enregistrer</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>



    <script type="module" src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.esm.js"></script>
    <script nomodule src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>


    <script>
        function resetForm() {
            document.getElementById('ProfForm').reset();
        }
        function openAddProfModal() {
            // Show the modal
            document.getElementById('addProfModal').style.display = 'block';
        }

        function closeAddProfModal() {
            // Close the modal
            document.getElementById('addProfModal').style.display = 'none';
        }

        // Add this part to handle the form submission
        document.getElementById('ProfForm').addEventListener('submit', function (event) {
            // Prevent the default form submission
            event.preventDefault();

            // Handle the form data as needed (e.g., send it to the server)

            // Close the modal after handling the form
            closeAddProfModal();
        });
    </script>
    <script>
        $(document).ready(function () {
            // Check if the form with ID 'ProfForm' exists before binding the submit event
            if ($('#ProfForm').length) {
                $('#ProfForm').submit(function (event) {
                    // Prevent the default form submission
                    event.preventDefault();

                    $.ajax({
                        type: 'POST',
                        url: 'addProf',
                        data: $(this).serialize(), // Serialize the form data
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
    function openEditProfModal(mat, prenom, nom, adresse, email, matiere, tel) {
        // Show the edit modal
        document.getElementById('editProfModal').style.display = 'block';
        // Populate the edit form with the existing data
        document.getElementById('editMatProf').value = mat;
        document.getElementById('editPrenomProf').value = prenom;
        document.getElementById('editNomProf').value = nom;
        document.getElementById('editAdresseProf').value = adresse;
        document.getElementById('editEmailProf').value = email;
        document.getElementById('editMatiereProf').value = matiere;
        document.getElementById('editTelProf').value = tel;
        // Add more lines to populate other fields if needed
    }

    // Add this part to handle the form submission for editing
    document.getElementById('editProfForm').addEventListener('submit', function (event) {
        // Prevent the default form submission
        event.preventDefault();

        // Perform AJAX submission
        $.ajax({
            type: 'POST',
            url: 'EditProfesseur', // Update the URL to match your servlet mapping
            data: $(this).serialize(), // Serialize the form data
            success: function (response) {
                // Handle the success response
                if (response === 'success') {
                    // Close the edit modal after a successful edit
                    closeEditProfModal();
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

    function closeEditProfModal() {
        document.getElementById('editProfModal').style.display = 'none';
    }
</script>


<script>
    function deleteRow1(mat) {
        $.ajax({
            type: 'POST',
            url: 'DeleteProf',
            data: { mat: mat },
            success: function(response) {
                console.log('Server Response:', response);
                if (response === 'success') {
                    // Delete the row from the table
                    var row = document.getElementById('row_' + mat);
                    row.parentNode.removeChild(row);
                } else {
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




