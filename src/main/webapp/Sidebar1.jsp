<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <title>SideBar</title>
    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f9f9f9;
            overflow-x: hidden;
        }

        .sidebar {
            height: 100%;
            width: 250px;
            position: fixed;
            background-color: #007bff;
            color: #fff;
            transition: 0.3s;
            overflow-y: auto;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }

        .sidebar a {
            display: block;
            padding: 15px;
            text-decoration: none;
            font-size: 1em;
            color: #fff;
            transition: 0.3s;
        }

        .sidebar a .icon {
            margin-right: 10px;
        }

        .sidebar a:hover {
            background-color: #0056b3;
        }

        .content {
            margin-left: 250px;
            padding: 16px;
        }

        .header {
            background-color: #007bff;
            color: #fff;
            padding: 15px;
            text-align: center;
        }

        .content-inner {
            background-color: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }

        h2 {
            color: #333;
        }
    </style>
</head>
<body>

<div class="sidebar" id="mySidebar">
    <div class="header">
        <h1>Smart Scholar</h1>
    </div>
    <a href="Annoucement.jsp" onclick="loadContent('Annoucement.jsp')">
        <i class="fas fa-clipboard"></i> Annonce
    </a>
    <a href="Courprof.jsp" onclick="loadContent('Courprof.jsp')">
        <i class="fas fa-clipboard"></i> Cours
    </a>

    <a href="Devoir.jsp" onclick="loadContent('Devoir.jsp')">
        <i class="fas fa-clipboard"></i> Devoir

   <a href="SeanceProf.jsp" onclick="loadContent('SeanceProf.jsp')">
        <i class="fas fa-clipboard"></i> Seance
    </a>
   <a href="emploieprof.jsp" onclick="loadContent('emploieprof.jsp')">
                <i class="fas fa-clipboard"></i> Emploie du temps
   </a>

        <a href="#" onclick="logout()">
        <i class="fas fa-sign-out-alt"></i> Logout
    </a>
</div>


<script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/js/all.min.js"></script>
<script>
    function openSidebar() {
        document.getElementById("mySidebar").style.width = "250px";
    }

    function closeSidebar() {
        document.getElementById("mySidebar").style.width = "0";
    }
</script>
<script>
    function logout() {

        window.location.href = "logout.jsp"; // Replace with your actual logout page
    }
</script>

</body>
</html>
