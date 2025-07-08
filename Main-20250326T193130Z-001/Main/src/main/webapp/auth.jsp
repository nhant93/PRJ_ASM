<%--
    Document   : auth
    Created on : Mar 13, 2025
    Author     : nguyenht (modified by Grok)
--%>

<%@page import="model.Users"%>
<%@page import="dao.UserDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Authentication</title>
        <link href="https://cdn.lineicons.com/4.0/lineicons.css" rel="stylesheet">
        <style>
            @import url("https://fonts.googleapis.com/css2?family=Poppins");

            * {
                box-sizing: border-box;
            }

            body {
                display: flex;
                background-color: #f6f5f7;
                justify-content: center;
                align-items: center;
                flex-direction: column;
                font-family: "Poppins", sans-serif;
                overflow: hidden;
                height: 100vh;
            }

            h1 {
                font-weight: 700;
                letter-spacing: -1.5px;
                margin: 0;
                margin-bottom: 15px;
            }

            h1.title {
                font-size: 45px;
                line-height: 45px;
                margin: 0;
                text-shadow: 0 0 10px rgba(16, 64, 74, 0.5);
            }

            p {
                font-size: 14px;
                font-weight: 100;
                line-height: 20px;
                letter-spacing: 0.5px;
                margin: 20px 0 30px;
                text-shadow: 0 0 10px rgba(16, 64, 74, 0.5);
            }

            span {
                font-size: 14px;
                margin-top: 25px;
            }

            a {
                color: #333;
                font-size: 14px;
                text-decoration: none;
                margin: 15px 0;
                transition: 0.3s ease-in-out;
            }

            a:hover {
                color: #4bb6b7;
            }

            .content {
                display: flex;
                width: 100%;
                height: 50px;
                align-items: center;
                justify-content: center;
            }

            .content .checkbox {
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .content input {
                accent-color: #333;
                width: 12px;
                height: 12px;
            }

            .content label {
                font-size: 14px;
                user-select: none;
                padding-left: 5px;
            }

            button {
                position: relative;
                border-radius: 20px;
                border: 1px solid #4bb6b7;
                background-color: #4bb6b7;
                color: #fff;
                font-size: 15px;
                font-weight: 700;
                margin: 10px;
                padding: 12px 80px;
                letter-spacing: 1px;
                text-transform: capitalize;
                transition: 0.3s ease-in-out;
            }

            button:hover {
                letter-spacing: 3px;
            }

            button:active {
                transform: scale(0.95);
            }

            button:focus {
                outline: none;
            }

            button.ghost {
                background-color: rgba(225, 225, 225, 0.2);
                border: 2px solid #fff;
                color: #fff;
            }

            button.ghost i {
                position: absolute;
                opacity: 0;
                transition: 0.3s ease-in-out;
            }

            button.ghost i.signup {
                right: 70px;
            }

            button.ghost i.login {
                left: 70px;
            }

            button.ghost:hover i.signup {
                right: 40px;
                opacity: 1;
            }

            button.ghost:hover i.login {
                left: 40px;
                opacity: 1;
            }

            @keyframes show {
                0%, 49.99% {
                    opacity: 0;
                    z-index: 1;
                }
                50%, 100% {
                    opacity: 1;
                    z-index: 5;
                }
            }

            .container {
                background-color: #fff;
                border-radius: 25px;
                box-shadow: 0 14px 28px rgba(0, 0, 0, 0.25), 0 10px 10px rgba(0, 0, 0, 0.22);
                position: relative;
                overflow: hidden;
                width: 768px;
                max-width: 100%;
                min-height: 650px;
            }

            .form-container {
                position: absolute;
                top: 0;
                height: 100%;
                transition: all 0.6s ease-in-out;
            }

            .login-container {
                left: 0;
                width: 50%;
                z-index: 2;
            }

            .container.right-panel-active .login-container {
                transform: translateX(100%);
            }

            .signup-container {
                left: 0;
                width: 50%;
                opacity: 0;
                z-index: 1;
            }

            .container.right-panel-active .signup-container {
                transform: translateX(100%);
                opacity: 1;
                z-index: 5;
                animation: show 0.6s;
            }

            form {
                background-color: #fff;
                display: flex;
                align-items: center;
                justify-content: center;
                flex-direction: column;
                padding: 0 50px;
                height: 100%;
                text-align: center;
            }

            input {
                background-color: #eee;
                border-radius: 10px;
                border: none;
                padding: 12px 15px;
                margin: 8px 0;
                width: 100%;
            }

            .overlay-container {
                position: absolute;
                top: 0;
                left: 50%;
                width: 50%;
                height: 100%;
                overflow: hidden;
                transition: transform 0.6s ease-in-out;
                z-index: 100;
            }

            .container.right-panel-active .overlay-container {
                transform: translateX(-100%);
            }

            .overlay {
                background-image: url('image/image.gif');
                background-repeat: no-repeat;
                background-size: cover;
                background-position: 0 0;
                color: #fff;
                position: relative;
                left: -100%;
                height: 100%;
                width: 200%;
                transform: translateX(0);
                transition: transform 0.6s ease-in-out;
            }

            .overlay::before {
                content: "";
                position: absolute;
                left: 0;
                right: 0;
                top: 0;
                bottom: 0;
                background: linear-gradient(
                    to top,
                    rgba(46, 94, 109, 0.4) 40%,
                    rgba(46, 94, 109, 0)
                    );
            }

            .container.right-panel-active .overlay {
                transform: translateX(50%);
            }

            .overlay-panel {
                position: absolute;
                display: flex;
                align-items: center;
                justify-content: center;
                flex-direction: column;
                padding: 0 40px;
                text-align: center;
                top: 0;
                height: 100%;
                width: 50%;
                transform: translateX(0);
                transition: transform 0.6s ease-in-out;
            }

            .overlay-left {
                transform: translateX(-20%);
            }

            .container.right-panel-active .overlay-left {
                transform: translateX(0);
            }

            .overlay-right {
                right: 0;
                transform: translateX(0);
            }

            .container.right-panel-active .overlay-right {
                transform: translateX(20%);
            }

            .overlay-panel h1,
            .overlay-panel p,
            .overlay-panel button {
                color: #2c3e50;
            }

            .social-container {
                display: none;
            }
        </style>
    </head>
    <body>
        <div class="container" id="container">
            <div class="form-container login-container">
                <form method="post" action="Login" id="loginForm">
                    <h1>Login</h1>
                    <input type="text" name="rollNumber" placeholder="Enter Roll Number" required>
                    <input type="password" name="password" placeholder="Enter your password" required>
                    <button type="submit">Login</button>
                </form>
            </div>

            <div class="form-container signup-container">
                <form method="post" action="Register">
                    <h1>Sign Up</h1>
                    <input type="text" name="rollNumber" placeholder="Enter Roll Number" required>
                    <input type="password" name="password" placeholder="Enter your password" required>
                    <input type="text" name="fullName" placeholder="Enter Fullname" required>
                    <input type="text" name="phoneNumber" placeholder="PhoneNumber">
                    <input type="text" name="address" placeholder="Address">
                    <input type="email" name="email" placeholder="Enter your Email" required>
                    <button type="submit">Sign Up</button>
                </form>
            </div>

            <div class="overlay-container">
                <div class="overlay">
                    <div class="overlay-panel overlay-left">
                        <h1 class="title">Hello <br> friends</h1>
                        <p>If you have an account, login here and have fun</p>
                        <button class="ghost" id="login">Login
                            <i class="lni lni-arrow-left login"></i>
                        </button>
                    </div>
                    <div class="overlay-panel overlay-right">
                        <h1 class="title">Start<br> reading now</h1>
                        <p>If you don’t have an account yet, join us and start reading.</p>
                        <button class="ghost" id="signup">Sign Up
                            <i class="lni lni-arrow-right signup"></i>
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            const signupButton = document.getElementById("signup");
            const loginButton = document.getElementById("login");
            const container = document.getElementById("container");

            <% if (request.getAttribute("showSignup") != null && (boolean) request.getAttribute("showSignup")) { %>
            container.classList.add("right-panel-active");
            <% }%>

            signupButton.addEventListener("click", () => {
                container.classList.add("right-panel-active");
            });

            loginButton.addEventListener("click", () => {
                container.classList.remove("right-panel-active");
            });

            document.addEventListener("DOMContentLoaded", function () {
                let signupForm = document.querySelector(".signup-container form");

                signupForm.onsubmit = function (event) {
                    event.preventDefault();

                    let rollNumber = signupForm.querySelector("input[name='rollNumber']").value.trim();
                    let password = signupForm.querySelector("input[name='password']").value.trim();
                    let fullName = signupForm.querySelector("input[name='fullName']").value.trim();
                    let email = signupForm.querySelector("input[name='email']").value.trim();

                    let errorMessage = "";

                    let rollNumberPattern = /^[A-Za-z]{2}\d{6}$/;
                    if (!rollNumberPattern.test(rollNumber)) {
                        errorMessage += "❌ RollNumber must have 8 letters, 2 first are characters and last 6 are digits.\n";
                    }

                    if (password.length < 8) {
                        errorMessage += "❌ Password must have at least 8 letters.\n";
                    }

                    if (!/^[^\s@]+@fpt\.edu\.vn$/.test(email) && !/^[^\s@]+@gmail\.com\$/.test(email)) {
                        errors += "❌ Email: Must be in format <name>@fpt.edu.vn or <name>@gmail.com\n";
                    }

                    if (fullName.split(" ").length < 2) {
                        errorMessage += "❌ Invalid fullname.\n";
                    }

                    if (errorMessage !== "") {
                        alert(errorMessage);
                    } else {
                        signupForm.submit();
                    }
                };

                let message = "<%= request.getAttribute("message") != null ? request.getAttribute("message") : ""%>";
                let error = "<%= request.getAttribute("error") != null ? request.getAttribute("error") : ""%>";

                if (message !== "") {
                    alert(message);
                    setTimeout(() => {
                        container.classList.remove("right-panel-active");
                    }, 2000);
                }

                if (error !== "") {
                    alert(error);
                }
            });
        </script>
    </body>
</html>