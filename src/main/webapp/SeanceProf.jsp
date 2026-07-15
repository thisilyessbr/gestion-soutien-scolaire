<%@ page import="com.model.Seance" %>
<%@ page import="com.model.User" %>
<%@ page import="java.util.List" %>
<%@ page import="com.dao.SeanceDAO" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.dao.SalleDAO" %>
<%@ page import="com.model.salle" %>
<%@ page import="com.model.Cour" %>
<%@ page import="com.dao.CourDAO" %><%--
  Created by IntelliJ IDEA.
  User: DELL
  Date: 14/12/2023
  Time: 16:47
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <link rel="stylesheet" href="resources/css/Style.css">
    <title>Seance</title>

</head>
<body>

<%

    HttpSession ses = request.getSession(false);
    User user = (User) ses.getAttribute("user");
    if (ses.getAttribute("user") != null) {
        List<Seance> seances = new ArrayList<>();
        int prof_id = user.getId();
        SeanceDAO seanceDAO = new SeanceDAO();
        String searchByCourNom = request.getParameter("searchByCourNom");
        String searchByDate = request.getParameter("searchByDate");

        if ((searchByCourNom != null && !searchByCourNom.isEmpty()) ||
                (searchByDate != null && !searchByDate.isEmpty())) {
            try {
                seances = seanceDAO.searchSeancesbyprof(searchByCourNom, searchByDate , prof_id);
            } catch (SQLException e) {
                throw new RuntimeException(e);
            }
        } else {
            try {
                seances = seanceDAO.getAllSeancesofaprof(prof_id);
            } catch (SQLException e) {
                throw new RuntimeException(e);
            }
        }

        // Now you can use the 'seances' list to display or process the data as needed

%>
<%@ include file="Sidebar1.jsp" %>

<div class="content" id="mainContent">
    <div class="page-title">
        <h1>Listes des Seances</h1>
    </div>

    <div>
        <button class="add-button" id="addSeanceButton" onclick="openAddSeanceModal()">+ Ajouter une séance </button>
        <button class="add-button" id="addStudentToSeanceButton" onclick="openAddStudentToSeanceModal()">+ Ajouter un étudiant à une séance</button>
    </div>


    <div>
        <form action="SeanceProf.jsp" method="get">
            <input type="text" class="filter-input" placeholder="Cour Nom" name="searchByCourNom" id="filterByCourNom">
            <input type="date" class="filter-input" placeholder="Date" name="searchByDate" id="filterByDate">
            <!-- Add more input fields as needed for your search criteria -->
            <button class="add-button" type="submit" id="searchSeances">Search</button>
        </form>
    </div>



    <table class="table" id="SeancesTable">
        <thead>
        <tr>
            <th>ID Seance</th>
            <th>Cour Nom</th>
            <th>Salle Nom</th>
            <th>Date</th>
            <th>Debut temps </th>
            <th>Fin temps </th>
            <th>Marquer Presence</th>
            <th>Etudiant Dans la séance</th>
            <th>Créer une Annonce</th>
        </tr>
        </thead>
        <tbody id="SeancesBody">
        <% for (Seance seance : seances) { %>
        <tr>
            <td><%= seance.getIdSeance() %></td>
            <td><%= seance.getNom_cour() %></td>
            <td><%= seance.getNom_salle() %></td>
            <td><%= seance.getDateSeance() %></td>
            <td><%= seance.getHeureDebut() %></td>
            <td><%= seance.getHeureFin() %></td>
            <td>
                <button class="edit-button" onclick="managePresence('<%= seance.getIdSeance() %>')">Manage Presence</button>
            </td>

            <td>
                <button class="edit-button"  onclick="getStudentsInSeance('<%= seance.getIdSeance() %>')">View Students</button>
            </td>
            <td>
                <form action="Annouceprof.jsp" method="post">
                    <input type="hidden" name="seanceId" value="<%= seance.getIdSeance() %>">
                    <button class="edit-button" type="submit">Create Announcement</button>
                </form>
            </td>
        </tr>
        <% } %>
        </tbody>
    </table>



    <%
        SalleDAO salleDAO = new SalleDAO();
        CourDAO courDAO = new CourDAO();
        List<Cour> Courprof = null ;
        List<salle> disponibleSalles = null;

        try {
            disponibleSalles = salleDAO.getDisposalle();
            Courprof = courDAO.getCourProf(prof_id);
        } catch (SQLException e) {
            e.printStackTrace(); // Handle the exception appropriately in your application
        }
    %>
    <!-- Add Seance Schedule Modal -->
    <div class="modal" id="addSeanceModal">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Ajouter une séance</h5>
                    <button type="button" class="close close-button" onclick="closeAddSeanceModal()" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span>
                    </button>
                </div>
                <div class="modal-body">
                    <!-- Seance Schedule Form -->
                    <form id="SeanceScheduleForm" method="post" action="addSeanceSchedule">
                        <!-- Dynamically populated fields -->
                        <div class="form-group">
                            <label for="room">Salle Disponible</label>
                            <select class="form-control" name="room" id="room" required>
                                <% for (salle salle : disponibleSalles) { %>
                                <option value="<%= salle.getNum_salle() %>"><%= salle.getNom_salle() %></option>
                                <% } %>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="courId">Nom du cours</label>

                            <select class="form-control" name="courId" id="courId" required>
                                <% for (Cour cour : Courprof) { %>
                                <option value="<%= cour.getId_cour() %>"><%= cour.getNom_cour() %></option>
                                <% } %>
                            </select>

                        </div>

                        <div class="form-group">
                            <label for="heureDebut">Heure de début</label>
                            <input type="time" class="form-control" name="heureDebut" id="heureDebut" required>
                        </div>

                        <div class="form-group">
                            <label for="heureFin">Heure de fin</label>
                            <input type="time" class="form-control" name="heureFin" id="heureFin" required>
                        </div>
                        <div class="form-group">
                            <label for="dateSchedule">Date de seance</label>
                            <input type="date" class="form-control" name="dateSeance" id="dateSchedule" required>
                        </div>


                        <div class="button-container">
                            <button type="button" class="btn-secondary" onclick="resetSeanceScheduleForm()">Réinitialiser</button>
                            <button type="submit" class="btn-primary">Enregistrer la séance</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <div class="modal" id="addStudentToSeanceModal">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Ajouter un étudiant à une séance</h5>
                    <button type="button" class="close close-button" onclick="closeAddStudentToSeanceModal()" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span>
                    </button>
                </div>
                <div class="modal-body">
                    <!-- Add Student to Seance Form -->
                    <form id="AddStudentToSeanceForm" method="post" action="addStudentToSeance">
                        <div class="form-group">
                            <label for="studentId">MAT de l'étudiant</label>
                            <input type="text" class="form-control" name="studentMAT" id="studentId" placeholder="Entrez le matricule de l'étudiant" required>
                        </div>

                        <div class="form-group">
                            <label for="seanceScheduleId">ID de séance</label>
                            <input type="number" class="form-control" name="seanceScheduleId" id="seanceScheduleId" placeholder="Entrez l'ID de l'horaire de séance" required>
                        </div>

                        <div class="button-container">
                            <button type="button" class="btn-secondary" onclick="resetAddStudentToSeanceForm()">Réinitialiser</button>
                            <button type="submit" class="btn-primary">Ajouter l'étudiant à la séance</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

</div>

<%

    } else {
        ses.invalidate();
        response.sendRedirect("login.jsp");
    }
%>

<script>
    function resetSeanceScheduleForm() {
        document.getElementById('SeanceScheduleForm').reset();
    }

    function openAddSeanceModal() {
        // Show the modal for adding a seance
        document.getElementById('addSeanceModal').style.display = 'block';
    }

    function closeAddSeanceModal() {
        // Close the modal for adding a seance
        document.getElementById('addSeanceModal').style.display = 'none';
    }

    // Add this part to handle the form submission for adding a seance
    document.getElementById('SeanceScheduleForm').addEventListener('submit', function (event) {
        // Prevent the default form submission
        event.preventDefault();

        // Handle the form data as needed (e.g., send it to the server)

        // Close the modal after handling the form
        closeAddSeanceModal();
    });

</script>

<script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
<!-- Add this part to handle the form submission for adding a seance -->
<script>

/*


                // Perform AJAX submission
                $.ajax({
                    type: 'POST',
                    url: 'checkSeanceExistence', // Update the URL for the check
                    data: $(this).serialize(),
                    success: function (response) {
                        // Check the response from the server
                        if (response === 'SeanceExists') {
                            // Seance already exists, handle accordingly (e.g., show a message)
                            alert('Seance already exists.');
                        } else {
                            // Seance does not exist, proceed to add it
                            addSeance();
                        }
                    },
                    error: function (xhr, status, error) {
                        console.error(xhr.responseText);
                        // Optionally, display the error to the user or log it
                    }
                });
            });
        }
    });
 */
$(document).ready(function () {
    // Check if the form with ID 'SeanceScheduleForm' exists before binding the submit event
    if ($('#SeanceScheduleForm').length) {
        $('#SeanceScheduleForm').submit(function (event) {
            // Prevent the default form submission
            event.preventDefault();
        // Continue with the AJAX request to add the seance
        $.ajax({
            type: 'POST',
            url: 'addSeanceSchedule', // Update the URL as needed
            data: $('#SeanceScheduleForm').serialize(),
            success: function (response) {
                // Handle the success response
                console.log(response);
                // You can also update the UI or close the modal if needed
                closeAddSeanceModal(); // Assuming you have a function to close the modal
            },
            error: function (xhr, status, error) {
                console.error(xhr.responseText);
                // Optionally, display the error to the user or log it
            }
        });
    });

    }

});
</script>

<script>
    $(document).ready(function () {
        // Check if the form with ID 'AddStudentToSeanceForm' exists before binding the submit event
        if ($('#AddStudentToSeanceForm').length) {
            $('#AddStudentToSeanceForm').submit(function (event) {
                // Prevent the default form submission
                event.preventDefault();

                // Perform AJAX submission
                $.ajax({
                    type: 'POST',
                    url: 'addStudentToSeance', // Update the URL as needed
                    data: $(this).serialize(),
                    success: function (response) {
                        // Handle the success response
                        console.log(response);
                        // You can also update the UI or close the modal if needed
                        closeAddStudentToSeanceModal(); // Assuming you have a function to close the modal
                    },
                    error: function (xhr, status, error) {
                        console.error(xhr.responseText);
                        // Optionally, display the error to the user or log it
                    }
                });
            });
        }
    });

    function openAddStudentToSeanceModal() {
        // Show the modal for adding a student to a seance
        document.getElementById('addStudentToSeanceModal').style.display = 'block';
    }

    function closeAddStudentToSeanceModal() {
        // Close the modal for adding a student to a seance
        document.getElementById('addStudentToSeanceModal').style.display = 'none';
    }
</script>

<script>
    function getStudentsInSeance(seanceId) {
        // Perform AJAX request to fetch students for the given seance
        $.ajax({
            type: 'GET',
            url: 'getStudentsInSeance', // Update the URL as needed
            data: { seanceId: seanceId },
            success: function (response) {
                // Display the students in a modal or any other UI element
                alert('Students in Seance ' + seanceId + ': ' + response);
            },
            error: function (xhr, status, error) {
                console.error(xhr.responseText);
                // Optionally, display the error to the user or log it
            }
        });
    }
</script>

<script>
    function managePresence(seanceId) {
        window.location.href = "managePresence.jsp?seanceId=" + seanceId;
    }
</script>

</body>
</html>
