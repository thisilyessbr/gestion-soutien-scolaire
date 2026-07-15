<%@ page import="java.sql.SQLException" %>
<%@ page import="com.model.User" %>
<%@ page import="com.dao.PaymentDAO" %>
<%@ page import="com.model.Payment" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %><%--
  Created by IntelliJ IDEA.
  User: DELL
  Date: 16/12/2023
  Time: 15:01
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>

    <%@ include file="Sidebar.jsp" %>
    <title>Scolarité</title>
  <style>body {
      font-family: 'Arial', sans-serif;
      background-color: #f4f4f4;
      margin: 0;
      padding: 0;
  }

  .content {
      width: 84%;
      padding: 20px;
      background-color: #fff;
      box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
  }

  .page-title {
      border-bottom: 2px solid #007bff;
      padding-bottom: 10px;
      margin-bottom: 20px;
  }

  .add-button,
  .search-button {
      background-color: #007bff;
      color: #fff;
      border: none;
      padding: 10px 15px;
      cursor: pointer;
      border-radius: 5px;
      margin-right: 10px;
      margin-bottom: 10px;
  }

  .filter-input {
      padding: 8px;
      margin-right: 10px;
      border: 1px solid #ccc;
      border-radius: 5px;
  }

  .table {
      width: 100%;
      border-collapse: collapse;
      margin-top: 20px;
  }

  .table th,
  .table td {
      padding: 15px;
      text-align: left;
      border-bottom: 1px solid #ddd;
  }

  .add-button:hover,
  .search-button:hover {
      background-color: #0056b3;
  }

  .edit-button,
  .delete-button {
      background-color: #17a2b8;
      color: #fff;
      border: none;
      padding: 8px 12px;
      cursor: pointer;
      border-radius: 5px;
      margin-right: 5px;
  }

  .edit-button:hover,
  .delete-button:hover {
      background-color: #117a8b;
  }

  /* Modal styles */
  .modal {
      display: none;
      position: fixed;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background: rgba(0, 0, 0, 0.5);
  }

  .modal-dialog {
      max-width: 400px;
      margin: 30px auto;
      background: #fff;
      border-radius: 8px;
  }

  .modal-header {
      background: #007bff;
      color: #fff;
      padding: 30px;
      border-top-left-radius: 8px;
      border-top-right-radius: 8px;
      position: relative;
  }

  .modal-title {
      margin: 0;
  }

  .close-button {
      position: absolute;
      background-color: #007bff;
      cursor: pointer;
      right: 10px;
      width: 10px;
      height: 10px;
      margin-top: -45px;
      border: 0;
  }

  .modal-body {
      padding: 20px;
  }

  .form-group {
      margin-bottom: 20px;
  }

  label {
      display: block;
      margin-bottom: 5px;
      font-weight: bold;
  }

  .input-group {
      margin-bottom: 15px;
  }

  .form-check {
      margin-bottom: 15px;
  }

  .button-container {
      text-align: right;
  }

  .btn-secondary {
      background-color: #6c757d;
      color: #fff;
      border: none;
      padding: 8px 15px;
      margin-right: 10px;
      cursor: pointer;
      border-radius: 10px;
  }

  .button-container {
      text-align: center;
  }

  .btn-primary {
      background-color: #007bff;
      color: #fff;
      border: none;
      padding: 8px 15px;
      cursor: pointer;
      border-radius: 10px;
  }
  </style>
</head>
<body>
<%
    HttpSession ses = request.getSession(false);
    List<Payment> payments = new ArrayList<>();

    if (session.getAttribute("user") != null) {
        User user = (User) ses.getAttribute("user");
        PaymentDAO paymentDAO = new PaymentDAO();

        String searchByNomEtudiant = request.getParameter("searchByNomEtudiant");
        String searchByPrenomEtudiant = request.getParameter("searchByPrenomEtudiant");
        String etat = request.getParameter("etat");
        String academicYear = request.getParameter("selectedAcademicYear");

        if (academicYear != null && !academicYear.isEmpty()) {
            // Fetch payments for the selected academic year
            try {
                payments = paymentDAO.getPaymentsByAcademicYear(academicYear);
            } catch (SQLException e) {
                throw new RuntimeException(e);
            }
        } else if ((searchByNomEtudiant != null && !searchByNomEtudiant.isEmpty()) ||
                (searchByPrenomEtudiant != null && !searchByPrenomEtudiant.isEmpty()) ||
                (etat != null && !etat.isEmpty())) {

            try {
                payments = paymentDAO.searchPayments(searchByNomEtudiant, searchByPrenomEtudiant, etat);
            } catch (SQLException e) {
                throw new RuntimeException(e);
            }
        } else {
            // Fetch all payments
            try {
                payments = paymentDAO.getAllPayments();
            } catch (SQLException e) {
                throw new RuntimeException(e);
            }
        }

%>



<!-- Your HTML/JS/Bootstrap code here -->

<div class="content" id="mainContent">
    <%@ include file="NavBar.jsp" %>
    <div class="page-title">
        <h1>Gestion de la Scolarité</h1>
    </div>

    <div>
        <button class="add-button" id="addPaymentButton" onclick=" openAddScolariteModal()">+ Ajouter un paiement</button>
    </div>

    <div>
        <form action="Scolarité.jsp" method="get">
            <input type="text" class="filter-input" placeholder="Nom de l'étudiant" name="searchByNomEtudiant" id="filterByNom">
            <input type="text" class="filter-input" placeholder="Prénom de l'étudiant" name="searchByPrenomEtudiant" id="filterByPrenom">
            <select name="etat" id="etat">
                <option value="Tous">Tous</option>
                <option value="A compléter">À compléter</option>
                <option value="Réglé">Réglé</option>
            </select>

            <button class="add-button" type="submit" id="searchScolarite">Chercher</button>
        </form>
    </div>


    <table class="table" id="ScolariteTable">
        <thead>
        <tr>
            <th>ID du paiement</th>
            <th>Nom de l'étudiant</th>
            <th>Prenom de l'étudiant</th>
            <th>Montant du paiement</th>
            <th>Méthode de paiement</th>
            <th>Date du paiement</th>
            <th>Montant payé</th>
            <th>Montant restant</th>
            <th>État</th>
            <th>Edit</th>
            <th>Supprimer</th>
        </tr>
        </thead>

            <%
            // Display each student in the table
            for (Payment payment : payments) {
        %>

        <tr>
            <td><%= payment.getPaymentId() %></td>
            <td><%= payment.getNom_etudiant() %></td>
            <td><%= payment.getPrenom_etudiant() %></td>
            <td><%= payment.getPaymentAmount() %></td>
            <td><%= payment.getPaymentMethod() %></td>
            <td><%= payment.getPaymentDate() %></td>
            <td><%= payment.getMontantPaye()%></td>
            <td><%= payment.getMontantReste() %></td>
            <td><%= payment.getEtat()%></td>
            <td>
                <button class="edit-button" onclick="openEditScolariteModal(<%= payment.getPaymentId() %>,<%= payment.getMontantPaye() %>, <%=  payment.getMontantReste() %>, '<%= payment.getEtat() %>')">Edit</button>
            </td>
            <td><button class="delete-button" onclick="deleteScolarite(<%= payment.getPaymentId()%>);">Delete</button></td>
        </tr>

            <%
            }
        %>
    </table>
        <%

    } else {
        ses.invalidate();
    response.sendRedirect("login.jsp");
    }
   %>

    <div class="modal" id="addScolariteModal">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Ajouter une scolarité</h5>
                    <button type="button" class="close close-button" onclick="closeAddScolariteModal()" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span>
                    </button>
                </div>
                <div class="modal-body">
                    <!-- Scolarite Form -->
                    <form id="ScolariteForm" method="post" action="addScolarite">
                        <!-- Dynamically populated fields -->
                        <div class="form-group">
                            <label for="userMat">Mat de l'etudiant</label>
                            <input type="number" class="form-control" name="userMat" id="userMat" placeholder="Entrez le matricule de l'etudiant" required>
                        </div>

                        <div class="form-group">
                            <label for="paymentAmount">Montant du paiement</label>
                            <input type="number" step="0.01" class="form-control" name="paymentAmount" id="paymentAmount" placeholder="Entrez le montant du paiement" required>
                        </div>

                        <div class="form-group">
                            <label for="paymentMethod">Méthode de paiement</label>
                            <select name="paymentMethod" id="paymentMethod" required>
                                <option value="Trimestre">Trimestre</option>
                                <option value="Mensuelle">Mensuelle</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="paymentDate">Date de paiement</label>
                            <input type="date" class="form-control" name="paymentDate" id="paymentDate" required>
                        </div>

                        <div class="form-group">
                            <label for="montantPaye">Montant payé</label>
                            <input type="number" step="0.01" class="form-control" name="montantPaye" id="montantPaye" placeholder="Entrez le montant payé" required>
                        </div>

                        <div class="form-group">
                            <label for="montantReste">Montant restant</label>
                            <input type="number" step="0.01" class="form-control" name="montantReste" id="montantReste" placeholder="Entrez le montant restant" required>
                        </div>

                        <div class="form-group">
                            <label for="etat1">Etat</label>
                            <select name="etat1" id="etat1" required>
                                <option value="A compléter">À compléter</option>
                                <option value="Réglé">Réglé</option>
                            </select>
                        </div>

                        <div class="button-container">
                            <button type="button" class="btn-secondary" onclick="resetScolariteForm()">Réinitialiser</button>
                            <button type="submit" class="btn-primary">Enregistrer la scolarité</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <div class="modal" id="editscholariteModal">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Modifier une scolarité</h5>
                    <button type="button" class="close close-button" onclick="closeEditScolariteModal()" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span>
                    </button>
                </div>
                <div class="modal-body">
                    <!-- Scolarite Edit Form -->
                    <form id="editscolariteForm" method="post" action="editScolarite">

                        <div class="form-group">
                        <input type="hidden" name="editPaymentId" id="editPaymentId">
                        </div>

                        <div class="form-group">
                            <label for="editMontantPaye">Montant payé</label>
                            <input type="number" step="0.01" class="form-control" name="editMontantPaye" id="editMontantPaye" placeholder="Entrez le montant payé" required>
                        </div>

                        <div class="form-group">
                            <label for="editMontantReste">Montant restant</label>
                            <input type="number" step="0.01" class="form-control" name="editMontantReste" id="editMontantReste" placeholder="Entrez le montant restant" required>
                        </div>

                        <div class="form-group">
                            <label for="editEtat">Etat</label>
                            <select name="editEtat" id="editEtat" required>
                                <option value="A compléter">À compléter</option>
                                <option value="Réglé">Réglé</option>
                            </select>
                        </div>

                        <div class="button-container">
                            <button type="button" class="btn-secondary" onclick="resetEditScolariteForm()">Réinitialiser</button>
                            <button type="submit" class="btn-primary">Enregistrer la modification</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>




    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
    <script>
        function resetScolariteForm() {
            document.getElementById('ScolariteForm').reset();
        }

        function openAddScolariteModal() {
            var userMat = document.getElementById('userMat').value;
            checkExistingScolarite(userMat, function (response) {
                if (response === 'exists') {
                    alert('Scolarite already exists for this student!');
                    resetScolariteForm();
                } else {
                    document.getElementById('addScolariteModal').style.display = 'block';
                }
            });
        }

        function closeAddScolariteModal() {

            document.getElementById('addScolariteModal').style.display = 'none';
        }

        // Capture the form and submit it without nested conditions
        document.getElementById('ScolariteForm').addEventListener('submit', function (event) {
            // Prevent the default form submission
            event.preventDefault();

            // Perform AJAX check before submitting the form
            var userMat = document.getElementById('userMat').value;
            checkExistingScolarite(userMat, function (response) {
                if (response === 'exists') {
                    alert('Scolarite already exists for this student!');
                    // Reset the form and open the modal again
                    resetScolariteForm();
                    document.getElementById('addScolariteModal').style.display = 'block';
                } else {
                    // Submit the form using AJAX
                    $.ajax({
                        type: 'POST',
                        url: 'addScolarite',
                        data: $('#ScolariteForm').serialize(), // Correctly target the form
                        success: function (response) {
                            console.log(response); // Log the entire response
                            if (response.trim() === 'Payment added successfully!') {
                                // Handle the success response
                                closeAddScolariteModal();
                            } else {
                                // Handle the failure (e.g., display an error message)
                                console.error('Unexpected server response:', response);
                            }
                        },


                        error: function (error) {
                            // Handle the error
                            console.error(error);
                        }
                    });
                }
            });
        });
    </script>



    <script>
        function openEditScolariteModal(paymentId, montantPaye, montantReste, etat) {
            // Show the edit modal
            document.getElementById('editscholariteModal').style.display = 'block';
            document.getElementById('editPaymentId').value = paymentId;
            document.getElementById('editMontantPaye').value = montantPaye;
            document.getElementById('editMontantReste').value = montantReste;
            document.getElementById('editEtat').value = etat;
        }

        // Add this part to handle the form submission for editing
        document.getElementById('editscolariteForm').addEventListener('submit', function (event) {
            // Prevent the default form submission
            event.preventDefault();

            // Perform AJAX submission
            $.ajax({
                type: 'POST',
                url: 'editScolarite', // Update the URL to match your servlet mapping
                data: $(this).serialize(), // Serialize the form data
                success: function (response) {
                    // Handle the success response
                    if (response === 'success') {
                        // Close the edit modal after a successful edit
                        closeEditScolariteModal();
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

        function closeEditScolariteModal() {
            // Close the edit modal
            document.getElementById('editscholariteModal').style.display = 'none';
        }
    </script>

    <script>
        function resetEditScolariteForm() {
        document.getElementById('editscolariteForm').reset();
    }
    </script>
    <script>
        function deleteScolarite(paymentId) {
            $.ajax({
                type: 'POST',
                url: 'deleteScolarite',  // Update the URL to match your servlet mapping
                data: { paymentId: paymentId },
                success: function(response) {
                    if (response === 'success') {
                        // Delete the row from the table
                        var row = document.getElementById('row_' + paymentId);
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
        function checkExistingScolarite(userMat, callback) {
            $.ajax({
                type: 'POST',
                url: 'checkExistingScolarite',
                data: { userMat: userMat },
                success: function(response) {
                    callback(response);
                },
                error: function(error) {
                    console.error('Error during checkExistingScolarite operation:', error);
                }
            });
        }
    </script>



</body>
</html>
