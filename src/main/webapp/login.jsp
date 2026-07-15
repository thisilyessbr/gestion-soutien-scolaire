<%@ page import="com.model.User" %><%--
  Created by IntelliJ IDEA.
  User: DELL
  Date: 07/12/2023
  Time: 11:57
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login</title>

    <style>
    @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap');

    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
        font-family: 'Poppins', sans serif;
    }

    body {
        display: flex;
        justify-content: center;
        align-items: center;
        min-height: 100vh;
        background-size: cover;
        background: url('resources/img/bck2.png') no-repeat center;


    }

    header {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        padding: 20px 100px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        z-index: 99;

    }

    .logo {

        font-size: 2em;
        color: #fff;
        user-select: none;


    }

    .navigation a {
        position: relative;
        font-size: 1.1em;
        color: #fff;
        text-decoration: none;
        font-weight: 500;
        margin-left: 40px;


    }

    .navigation a::after {
        content: '';
        position: absolute;
        left: 0;
        bottom: -6px;
        width: 100%;
        height: 3px;
        background: #fff;
        border-radius: 5px;
        transform: scaleX(0);
        transition: transform .5s;
        transform-origin: right;

    }

    .navigation a:hover::after {
        transform-origin: left;
        transform: scaleX(1);


    }

    .navigation .btnlogin-popup {
        width: 130px;
        height: 50px;
        background: transparent;
        border: 2px solid #fff;
        outline: none;
        border-radius: 6px;
        cursor: pointer;
        font-size: 1.1em;
        color: #fff;
        font-weight: 500;
        margin-left: 40px;
        transition: .5s;

    }

    .navigation .btnlogin-popup:hover {
        background: #fff;
        color: #162938;

    }

    .wrapper {
        position: relative;
        width: 400px;
        height: 440px;
        background: transparent;
        border: 2px solid rgba(255, 255, 255, .5);
        backdrop-filter: blur(20px);
        box-shadow: 0 0 30px rgba(0, 0, 0, .5);
        display: flex;
        justify-content: center;
        align-items: center;
        border-radius: 5%;
        /*overflow: hidden;*/

    }

    .wrapper .form-box {
        width: 100%;
        padding: 40px;


    }

    .form-box h2 {
        font-size: 2em;
        color: #fff;
        text-align: center;


    }

    .input-box {
        position: relative;
        width: 100%;
        height: 50px;
        border-bottom: 2px solid #fff;
        margin: 30px 0;

    }

    .input-box label {
        position: absolute;
        top: 50%;
        left: 5px;
        transform: translateY(-50%);
        font-size: 1em;
        color: #fff;
        font-weight: 500;
        pointer-events: none;
        transition: .5s;
    }

    .input-box input:focus~label,
    .input-box input:valid~label {
        top: -5px;

    }

    .input-box input {
        width: 100%;
        height: 100%;
        background: transparent;
        border: none;
        outline: none;
        font-size: 1em;
        color: #fff;
        font-weight: 600;
        padding: 0 35px 0 5px;

    }

    .remember-forgot {
        font-size: .9em;
        color: #fff;
        font-weight: 500;
        margin: -15px 0 15px;
        display: flex;
        justify-content: space-between;



    }

    .remember-forgot label input {
        accent-color: #fff;
        margin-right: 3px;

    }

    .remember-forgot a {
        color: #fff;
        text-decoration: none;

    }

    .remember-forgot a:hover {
        text-decoration: underline;
    }

    .input-box .icon {
        position: absolute;
        right: 8px;
        font-size: 1.2em;
        color: #fff;
        line-height: 57px;

    }

    .btn {
        width: 100%;
        height: 45px;
        background: #fff;
        border: none;
        outline: none;
        border-radius: 6px;
        cursor: pointer;
        font-size: 1em;
        color: #000;
        font-weight: 500;
    }

    .login-register {
        font-size: .9em;
        color: #fff;
        text-align: center;
        font-weight: 500;
        margin: 25px 0 10px;


    }

    .login-register p a {
        color: #fff;
        text-decoration: none;
        font-weight: 600;


    }

    .login-register p a:hover {
        text-decoration: underline;
    }

    .wrapper .icon-close {
        position: absolute;
        top: 0;
        right: 0;
        width: 45px;
        height: 45px;
        font-size: 2em;
        color: #fff;
        display: flex;
        justify-content: center;
        align-items: center;
        cursor: pointer;
        z-index: 1;


    }</style>
</head>

<body>

<header>
    <h2 class="logo">Smart Schoolar</h2>
    <nav class="navigation">
        <a href="home.jsp">Home</a>
        <a href="#">About</a>
        <a href="#">Services</a>
        <a href="#">Contact</a>
        <button class="btnlogin-popup" onclick="location.href='login.jsp';">Login</button>
    </nav>

</header>

<div class="wrapper">
    <div class="form-box login">
        <h2>Login</h2>
        <form action="/login" method="post">
            <div class="input-box">
                <span class="icon"><ion-icon name="person-outline"></ion-icon></span>
                <input type="text"  name="txt" required>
                <label>Username</label>
            </div>
            <div class="input-box">
                <span class="icon"><ion-icon name="lock-closed-outline"></ion-icon></span>
                <input type="password" name="pwd" required>
                <label>Password</label>
            </div>
            <div class="remember-forgot">
                <label><input type="checkbox">Remember me</label>
                <a href="#">Forgot Password</a>
            </div>
            <button type="button" class="btn" onclick="submitForm()">Login</button>
            <div class="login-register">
                <p>Don't have an account ? <a href="#" class="register-link">Register</a></p>
            </div>
        </form>

    </div>


</div>

<script src="resources/js/scriptsidebar.js"></script>
<script type="module" src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.esm.js"></script>
<script nomodule src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.js"></script>
<script>
    function submitForm() {
        document.forms[0].submit();
    }
</script>
</body>

</html>
