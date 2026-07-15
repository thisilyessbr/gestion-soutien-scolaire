<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="com.model.User" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page import="com.dao.EtudiantDAO" %>
<%@ page import="com.model.Etudiant" %>
<%@ page import="java.util.List" %>
<%@ page import="java.sql.SQLException" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="resources/css/Style.css">
    <title>Student</title>

</head>

<body>
<%
    PrintWriter o = response.getWriter();
    HttpSession ses = request.getSession(false);
    List<Etudiant> etudiants;
    if (ses.getAttribute("user") != null) {
        User user = (User) ses.getAttribute("user");
        EtudiantDAO etudiantDAO = new EtudiantDAO();
        String searchByName = request.getParameter("searchByName");
        String searchByPrenom = request.getParameter("searchByPrenom");
        String searchByMat = request.getParameter("searchByMat");
        String academicYear = request.getParameter("selectedAcademicYear");
        if (academicYear != null && !academicYear.isEmpty()) {
            // Fetch payments for the selected academic year
            try {
               etudiants = etudiantDAO.getStudentsByAcademicYear(academicYear);
            } catch (SQLException e) {
                throw new RuntimeException(e);
            }
        }else if (searchByName != null && !searchByName.isEmpty()
                || searchByPrenom != null && !searchByPrenom.isEmpty()
                || searchByMat != null && !searchByMat.isEmpty()) {
            try {
                // Perform a filtered search if any parameter is provided
                etudiants = etudiantDAO.searchEtudiants(searchByName, searchByPrenom, searchByMat);
            } catch (SQLException e) {
                throw new RuntimeException(e);
            }
        } else {
            try {
                etudiants = etudiantDAO.getAllEtudiants();
            } catch (SQLException e) {
                throw new RuntimeException(e);
            }
        }


%>
<%@ include file="Sidebar.jsp" %>

<div class="content" id="mainContent">
    <%@ include file="NavBarEtud.jsp" %>
    <div class="page-title">
        <h1>Listes des élèves</h1>
    </div>

    <div>
        <button class="add-button" id="addEleveButton" onclick="openAddEleveModal()">+ Ajouter un élève</button>
    </div>

    <div>
        <form action="Students.jsp" method="get">
        <input type="text" class="filter-input" placeholder="Nom" name="searchByName" id="filterByName">
        <input type="text" class="filter-input" placeholder="Prenom" name="searchByPrenom" id="filterByPrenom">
        <input type="text" class="filter-input" placeholder="MAT" name="searchByMat" id="filterByMat">
        <button class="add-button" type="submit" id="searchEtudiants" >Chercher</button>
        </form>
    </div>

    <table class="table" id="etudiantsTable">
        <thead>
        <tr>
            <th>MAT</th>
            <th>Prénom</th>
            <th>Nom</th>
            <th>Adresse</th>
            <th>Email</th>
            <th>Matière</th>
            <th>Tel</th>
            <th>Edit</th>
            <th>Supprimer</th>
        </tr>
        </thead>
        <tbody id="classesBody">
        <%
            // Display each student in the table
            for (Etudiant etudiant : etudiants) {
        %>

        <tr>
            <td><%= etudiant.getMat() %></td>
            <td><%= etudiant.getPrenom() %></td>
            <td><%= etudiant.getNom() %></td>
            <td><%= etudiant.getAddress() %></td>
            <td><%= etudiant.getEmail() %></td>
            <td><%= etudiant.getMatiere() %></td>
            <td><%= etudiant.getTel() %></td>
            <td><button class="edit-button" onclick="openEditEleveModal(<%= etudiant.getMat() %>, '<%= etudiant.getPrenom() %>', '<%= etudiant.getNom() %>' , '<%= etudiant.getAddress() %>' , '<%= etudiant.getEmail() %>' , '<%= etudiant.getMatiere() %>' ,<%= etudiant.getTel() %>   )">Edit</button></td>
            <td><button class="delete-button" onclick="deleteRow(<%= etudiant.getMat() %>);">Delete</button></td>
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

    <div class="modal" id="addEleveModal">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Ajouter un élève</h5>
                    <button type="button" class="close close-button" data-dismiss="modal" onclick="closeAddEleveModal()" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <form id="EleveForm" method="post" action="addEtud">
                        <div class="form-group">
                            <div class="input-group">
                            <label for="mat">MAT</label>
                            <input type="number" class="form-control" name="mat" id="mat" placeholder="Entrez le matricule " required>
                            </div>
                            <span id="matLabel"></span>
                            <div class="input-group">
                            <label for="prénom">Prénom</label>
                            <input type="text" class="form-control" name="prenom" id="prénom" placeholder="Entrez le prénom " required>
                            </div>
                            <span id="prenomLabel"></span>
                            <div class="input-group">
                            <label for="nom">Nom</label>
                            <input type="text" class="form-control" name="nom" id="nom" placeholder="Entrez le nom " required>
                            </div>
                            <span id="nomLabel"></span>
                            <div class="input-group">
                            <label for="adresse">Adresse</label>
                            <input type="text" class="form-control" name="adresse" id="adresse" placeholder="Entrez l'adresse " required>
                            </div>
                            <span id="adresseLabel"></span>
                            <div class="input-group">
                            <label for="email">Email</label>
                            <input type="email" class="form-control" name="email" id="email" placeholder="Entrez l'email" required>
                            </div>
                            <span id="emailLabel"></span>
                            <div class="input-group">
                            <label for="matiere">Matière</label>
                            <input type="text" class="form-control" name="matiere" id="matiere" placeholder="Entrez la matière" required>
                            </div>
                            <span id="matièreLabel"></span>
                            <div class="input-group">
                            <label for="tel">Tel</label>
                            <input type="number" class="form-control" name="tel" id="tel" placeholder="Entrez le telephone "required>
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

    <!-- Edit Modal -->
    <div class="modal" id="editEleveModal">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Modifier un élève</h5>
                    <button type="button" class="close close-button" data-dismiss="modal" onclick="closeEditEleveModal()" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <form id="editForm" method="post" action="EditEtudiantServlet">
                        <!-- Input fields for Mat, Prenom, Nom, etc. -->
                        <div class="form-group">
                            <label for="editMat">MAT</label>
                            <input type="number" class="form-control" name="editMat" id="editMat" readonly>
                        </div>
                        <span id="editmatLabel"></span>
                        <div class="form-group">
                            <label for="editPrenom">Prénom</label>
                            <input type="text" class="form-control" name="editPrenom" id="editPrenom" required>
                        </div>
                        <span id="editprenomLabel"></span>
                        <div class="form-group">
                            <label for="editNom">Nom</label>
                            <input type="text" class="form-control" name="editNom" id="editNom" required>
                        </div>
                        <span id="editnomLabel"></span>
                        <div class="form-group">
                            <label for="editAdresse">Adresse</label>
                            <input type="text" class="form-control" name="editAdresse" id="editAdresse" required>
                        </div>
                        <span id="editAdresseLabel"></span>
                        <div class="form-group">
                            <label for="editEmail">Email</label>
                            <input type="email" class="form-control" name="editEmail" id="editEmail" required>
                        </div>
                        <span id="editemailLabel"></span>
                        <div class="form-group">
                            <label for="editMatiere">Matière</label>
                            <input type="text" class="form-control" name="editMatiere" id="editMatiere" required>
                        </div>
                        <span id="editmatiereLabel"></span>
                        <div class="form-group">
                            <label for="editTel">Tel</label>
                            <input type="tel" class="form-control" name="editTel" id="editTel" required>
                        </div>
                        <span id="edittelLabel"></span>
                        <div class="button-container">
                            <button type="button" class="btn-secondary" onclick="resetEditForm()">Réinitialiser</button>
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
<script>
    function resetForm() {
        document.getElementById('EleveForm').reset();
    }
    function openAddEleveModal() {
        // Show the modal
        document.getElementById('addEleveModal').style.display = 'block';
    }

    function closeAddEleveModal() {
        // Close the modal
        document.getElementById('addEleveModal').style.display = 'none';
    }

    // Add this part to handle the form submission
    document.getElementById('EleveForm').addEventListener('submit', function (event) {
        // Prevent the default form submission
        event.preventDefault();

        // Handle the form data as needed (e.g., send it to the server)

        // Close the modal after handling the form
        closeAddEleveModal();
    });
</script>
<script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
<script>
    $(document).ready(function () {
        $('#EleveForm').submit(function (event) {
            // Prevent the default form submission
            event.preventDefault();

            // Perform AJAX submission
            $.ajax({
                type: 'POST',
                url: 'addEtud',
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
    });
</script>
<!-- ... Other HTML code ... -->

<script>
    function deleteRow(mat) {
        $.ajax({
            type: 'POST',
            url: 'DeleteEtudiantServlet',
            data: { mat: mat },
            success: function(response) {
                if (response === 'success') {
                    // Delete the row from the table
                    var row = document.getElementById('row_' + mat);
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
    function openEditEleveModal(mat, prenom, nom , adresse , email ,matiere ,tel ) {
        // Show the edit modal
        document.getElementById('editEleveModal').style.display = 'block';

        // Populate the edit form with the existing data
        document.getElementById('editMat').value = mat;
        document.getElementById('editPrenom').value = prenom;
        document.getElementById('editNom').value = nom;
        document.getElementById('editAdresse').value = adresse;
        document.getElementById('editEmail').value = email;
        document.getElementById('editMatiere').value = matiere;
        document.getElementById('editTel').value = tel;
        // Add more lines to populate other fields if needed
    }


    // Add this part to handle the form submission for editing
    document.getElementById('editForm').addEventListener('submit', function (event) {
        // Prevent the default form submission
        event.preventDefault();

        // Perform AJAX submission
        $.ajax({
            type: 'POST',
            url: 'EditEtudiantServlet', // Update the URL to match your servlet mapping
            data: $(this).serialize(), // Serialize the form data
            success: function (response) {
                // Handle the success response
                if (response === 'success') {
                    // Close the edit modal after a successful edit
                    closeEditEleveModal();
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


    function closeEditEleveModal() {
        // Close the edit modal
        document.getElementById('editEleveModal').style.display = 'none';
    }
</script>





</body>

</html>
