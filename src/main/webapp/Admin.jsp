<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="com.model.User" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page import="com.dao.EtudiantDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="com.model.Etudiant" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.model.salle" %>
<%@ page import="com.dao.SalleDAO" %>


<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="resources/css/Admin.css">

    <title>Tableau De Bord</title>
</head>

<body>
<%
    response.getHeader("Cache-Control");
    User u = (User)session.getAttribute("user");
    if (u != null) {

%>

<%@ include file="Sidebar.jsp" %>
<div class="content" id="mainContent">
    <div class="page-heading">
        <h1 class="h3 text-gray-800">Tableau De Bord</h1>
    </div>

    <!-- Content Row -->
    <div class="row">

        <!-- Total Students Card -->
        <div class="col">
            <div class="col larger-card">
            <div class="card">
                <div class="card-body">
                    <div class="font-weight-bold text-primary text-uppercase">Total des élèves inscrits</div>
                        <%
                                try {
                                    // Your database connection details
                                    String url = "jdbc:mysql://localhost:3306/gestion_du_soutien";
                                    String username = "root";
                                    String password = "Usurma123@";

                                    Class.forName("com.mysql.cj.jdbc.Driver");
                                    Connection connection = DriverManager.getConnection(url, username, password);

                                    Statement statement = connection.createStatement();
                                    ResultSet resultSet = statement.executeQuery("SELECT COUNT(*) AS total_eleve FROM users WHERE role ='etudiant'");

                                    if (resultSet.next()) {
                                        int totalEleve = resultSet.getInt("total_eleve");
                            %>
                    <div class="h5 text-gray-800"><%= totalEleve %></div>
                    <%
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    %>
                </div>
            </div>
            </div>
        </div>

        <!-- Male Students Card -->
        <div class="col">
            <div class="col larger-card">
            <div class="card">
                <div class="card-body">
                    <div class="font-weight-bold text-success text-uppercase">Total des professeurd inscrits</div>
                    <%
                        try {
                            // Your database connection details
                            String url = "jdbc:mysql://localhost:3306/gestion_du_soutien";
                            String username = "root";
                            String password = "Usurma123@";

                            Class.forName("com.mysql.cj.jdbc.Driver");
                            Connection connection = DriverManager.getConnection(url, username, password);

                            Statement statement = connection.createStatement();
                            ResultSet resultSet = statement.executeQuery("SELECT COUNT(*) AS total_prof FROM users WHERE role ='professeur'");

                            if (resultSet.next()) {
                                int totalprof = resultSet.getInt("total_prof");
                    %>
                    <div class="h5 text-gray-800"><%= totalprof %></div>
                    <%
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    %>
                </div>
            </div>
            </div>
        </div>

        <!-- Female Students Card -->
        <div class="col">
            <div class="col larger-card">
            <div class="card">
                <div class="card-body">
                    <div class="font-weight-bold text-success text-uppercase">Fille inscrits</div>
                    <div class="h5 text-gray-800">3</div>
                </div>
            </div>
            </div>
        </div>

        <!-- Total Classes Card -->
        <div class="col">
            <div class="col larger-card">
            <div class="card">
                <div class="card-body">
                    <div class="font-weight-bold text-warning text-uppercase">Classes au Total</div>
                    <div class="h5 text-gray-800">10</div>
                </div>
            </div>
        </div>
        </div>
    </div>


<div class="container-fluid mb-4">
    <div class="row justify-content-center">
        <div class="col-auto">
            <button class="btn btn-primary" onclick="showLastTenStudents()">10 Derniers Élèves</button>
        </div>
        <div class="col-auto">
            <button class="btn btn-primary" onclick="showAvailableRooms()">Salles Disponibles</button>
        </div>
    </div>
</div>

<%
    List<Etudiant> etudiants1 ;
    EtudiantDAO etudiantDAO = new EtudiantDAO() ;
    try {
        etudiants1 = etudiantDAO.gettenlastEtudiants();
    } catch (SQLException e) {
        throw new RuntimeException(e);
    }

%>

<div id="lastTenStudents" class="container-fluid">
    <h1 class="h3 mb-2 text-gray-800">Derniers Étudiants</h1>
    <p class="mb-4">Liste des 10 derniers étudiants enregistrés.</p>

    <div class="card shadow mb-4">
        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary">Étudiants</h6>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-bordered" id="dataTable1">
                    <thead>
                    <tr>
                        <th>MAT</th>
                        <th>Prénom</th>
                        <th>Nom</th>
                        <th>Adresse</th>
                        <th>Email</th>
                        <th>Matière</th>
                        <th>Tel</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        // Display each student in the table
                        for (Etudiant etudiant : etudiants1) {
                    %>

                    <tr>
                        <td><%= etudiant.getMat() %></td>
                        <td><%= etudiant.getPrenom() %></td>
                        <td><%= etudiant.getNom() %></td>
                        <td><%= etudiant.getAddress() %></td>
                        <td><%= etudiant.getEmail() %></td>
                        <td><%= etudiant.getMatiere() %></td>
                        <td><%= etudiant.getTel() %></td>
                    </tr>

                    <%
                        }
                    %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<%
    List<salle> Salles ;
    SalleDAO salleDAO = new SalleDAO() ;
    try {
        Salles = salleDAO.getDisposalle();
    } catch (SQLException e) {
        throw new RuntimeException(e);
    }

%>
<!-- Section for Available Rooms -->
<div id="availableRooms" class="container-fluid">
    <h1 class="h3 mb-2 text-gray-800">Les Salles disponibles</h1>

    <div class="card shadow mb-4">
        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary">Salles</h6>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-bordered" id="dataTable2">
                    <thead>
                    <tr>
                        <th>Num Salle</th>
                        <th>Salle</th>
                        <th>Capacité</th>
                        <th>Emplacement</th>
                        <th>Disponibilité</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        // Display each student in the table
                        for (salle Salle: Salles) {
                    %>

                    <tr>
                        <td><%= Salle.getNum_salle() %></td>
                        <td><%= Salle.getNom_salle() %></td>
                        <td><%= Salle.getCapacity() %></td>
                        <td><%= Salle.getLocalisation() %></td>
                        <td><%= Salle.getDisponibilily() %></td>
                    </tr>

                    <%
                        }
                    %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

</div>


<%

    } else {
    response.sendRedirect("login.jsp");
    }
%>
<script>
    function showLastTenStudents() {
        document.getElementById('lastTenStudents').style.display = 'block';
        document.getElementById('availableRooms').style.display = 'none';
    }


    function showAvailableRooms() {
        document.getElementById('lastTenStudents').style.display = 'none';
        document.getElementById('availableRooms').style.display = 'block';
    }
    document.addEventListener('DOMContentLoaded', function() {
        showLastTenStudents();
    });
</script>
<script type="module" src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.esm.js"></script>
<script nomodule src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.js"></script>

</body>

</html>

