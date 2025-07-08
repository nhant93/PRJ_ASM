<%@page import="model.Users"%>
<%@page import="java.sql.*, java.util.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
    <head>
        <title>Book Detail</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@700&family=Dancing+Script:wght@700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" integrity="sha512-DTOQO9RWCH3ppGqcWaEA1BIZOC6xxalwEsw9c2QQeAIftl+Vegovlnee1c9QX4TctnWMn13TZye+giMm8e2LwA==" crossorigin="anonymous" referrerpolicy="no-referrer" />
        <link rel="stylesheet" href="css/main-page.css" />
    </head>
    <body>
        <div class="container-fluid">
            <nav class="navbar navbar-expand-lg navbar-dark">
                <a class="navbar-brand" href="mainPage">
                    <span class="fpt-logo">
                        <span class="fpt-letter fpt-f">F</span>
                        <span class="fpt-letter fpt-p">P</span>
                        <span class="fpt-letter fpt-t">T</span>
                        <span class="library-text">Library</span>
                    </span>
                </a>

                <div class="ms-auto">
                    <%
                        if (session != null && session.getAttribute("user") != null) {
                            Users user = (Users) session.getAttribute("user");
                            String fullName = user.getFullname() != null ? user.getFullname() : user.getRollNumber();
                            String[] nameParts = fullName.split("\\s+");
                            String lastName = nameParts[nameParts.length - 1];
                    %>
                    <div class="user-container">
                        <span class="user-icon"></span>
                        <a class="user-greeting">Hi, <%= lastName%></a>
                        <div class="dropdown-menu">
                            <a href="settings.jsp" class="dropdown-item">Settings</a>
                            <a href="#" class="dropdown-item" onclick="showHelpPopup()">Help</a>
                            <a href="#" class="dropdown-item" onclick="showFeedbackPopup()">Feedback</a>
                            <a href="Logout" class="dropdown-item logout"><i class="fas fa-sign-out-alt"></i> Log out</a>
                        </div>
                    </div>
                    <%
                    } else {
                    %>
                    <a class="login-btn" href="auth.jsp">Log in</a>
                    <a class="signup-btn" href="auth.jsp?panel=signup">Sign up</a>
                    <%
                        }
                    %>
                </div>
            </nav>

            <div class="container" style="display: block">
                <h2 class="text-center mb-4">Book Detail</h2>
                <div class="card shadow-sm">
                    <div class="d-flex">
                        <div class="card-body w-50">
                            <img src="./book/BookImage/${requestScope.book.getImage()}" alt="${requestScope.book.getTitle()} cover" class="card-img-top img-fluid rounded-top">
                        </div>
                        <div class="card-body w-50">
                            <div>
                                <ul class="nav nav-tabs" id="bookDetailTab" role="tablist">
                                    <li class="nav-item" role="presentation">
                                        <button class="nav-link active" id="overview-tab" data-bs-toggle="tab" data-bs-target="#overview" type="button" role="tab" aria-controls="overview" aria-selected="true">Overview</button>
                                    </li>
                                    <li class="nav-item" role="presentation">
                                        <button class="nav-link" id="details-tab" data-bs-toggle="tab" data-bs-target="#details" type="button" role="tab" aria-controls="details" aria-selected="false">Additional Details</button>
                                    </li>
                                </ul>
                                <div class="tab-content p-3">
                                    <div class="tab-pane fade show active" id="overview" role="tabpanel" aria-labelledby="overview-tab">
                                        <h4 class="card-title">${requestScope.book.getTitle()}</h4>
                                        <p class="card-text"><strong>Author:</strong> ${requestScope.book.getAuthor()}</p>
                                        <div class="card-text"><strong>Description:</strong>
                                            <p>This is ${requestScope.book.getTitle()}. The front features an evocative illustration: a solitary river twisting through a misty landscape, framed by bare trees under a sky heavy with gray clouds.
                                                The title is written in elegant, silver lettering, while the author’s name, Sarah Lin, appears in smaller print below. It’s the sort of cover that catches
                                                your eye in a bookstore, promising mystery and quiet intrigue.</p>
                                            <p>From there, the novel unfolds across 18 chapters, each averaging about 15 pages. ${requestScope.book.getAuthor()} writing style is clear and descriptive,
                                                balancing dialogue with vivid imagery of the natural surroundings—the rustle of leaves, the damp chill of the air,
                                                the constant murmur of the river. Clara becomes obsessed with uncovering Edith’s fate, piecing together clues from the
                                                journal while digging into the town’s history through dusty records and reluctant conversations with the older residents.</p>
                                        </div>
                                    </div>
                                    <div class="tab-pane fade" id="details" role="tabpanel" aria-labelledby="details-tab">
                                        <p class="card-text"><strong>Name of Publisher:</strong> ${requestScope.book.getPublisher()}</p>
                                    </div>
                                </div>
                            </div>
                            <div>
                                <button class="btn btn-primary" onclick="borrowBook(${requestScope.book.getBookID()})">Borrow</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="feature-section" id="introduction2">
            <h3>The library offers the following features:</h3>
            <div class="feature-items">
                <div class="feature-item">
                    <i class="fas fa-book feature-icon" style="color: #000000;"></i>
                    <h5 class="fw-bold">Efficient Book Management</h5>
                    <p>Streamline your book collection with advanced tools for easy categorization, tracking, and updates.</p>
                </div>
                <div class="feature-item">
                    <i class="fas fa-clock feature-icon" style="color: #000000;"></i>
                    <h5 class="fw-bold">Save Time, Better Book Control</h5>
                    <p>Automate repetitive tasks and gain full control over your inventory with real-time updates.</p>
                </div>
                <div class="feature-item">
                    <i class="fas fa-user-check feature-icon" style="color: #000000;"></i>
                    <h5 class="fw-bold">Enhanced User Experience</h5>
                    <p>Enjoy a seamless, intuitive interface designed for quick access and smooth navigation.</p>
                </div>
            </div>
        </div>

        <footer class="footer">
            <div class="container">
                <div class="row">
                    <div class="col-md-4">
                        <h5 class="footer-logo">FPT Library</h5>
                        <p>We want to bring customers an exciting experience with great books from publishers worldwide with zero cost.</p>
                    </div>
                    <div class="col-md-4">
                        <h5>CONTACT</h5>
                        <div class="contact-info">
                            <p><i class="fas fa-map-marker-alt"></i> <strong>Address:</strong> An Binh, Ninh Kieu, Can Tho</p>
                            <p><i class="fab fa-facebook-messenger"></i> <strong>Messenger:</strong> FPTLibrary.the</p>
                            <p><i class="fas fa-envelope"></i> <strong>Email:</strong> hongtuannguyencm@gmail.com</p>
                            <p><i class="fas fa-phone-alt"></i> <strong>Phone:</strong> 0818578616</p>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <h5 class="subscribe-title">SUBSCRIBE FOR OFFERS</h5>
                        <form class="subscribe-form" id="subscribeForm" onsubmit="handleSubscribe(event)">
                            <input type="email" id="subscribeEmail" placeholder="Your email" required>
                            <button type="submit">Subscribe</button>
                        </form>
                        <p style="font-size: 0.9rem; margin-top: 10px;">Subscribe to receive the latest offers</p>
                    </div>
                </div>
            </div>
        </footer>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                            function borrowBook(bookId) {
                                var xhr = new XMLHttpRequest();
                                xhr.open("GET", "<%=request.getContextPath()%>/Borrow?action=borrow&bookId=" + bookId, true);
                                xhr.onreadystatechange = function () {
                                    if (xhr.readyState === 4) {
                                        if (xhr.status === 200) {
                                            if (xhr.responseText === "duplicate") {
                                                alert("❌ You've already borrowed this book. Please choose another one.");
                                            } else if (xhr.responseText === "success") {
                                                alert("✅ Borrow book successfully!");
                                                window.location.href = "<%=request.getContextPath()%>/Borrow";
                                            } else {
                                                alert("❌ Error while borrowing book. Please try again.");
                                            }
                                        } else {
                                            alert("❌ Error while borrowing book. Please try again.");
                                        }
                                    }
                                };
                                xhr.send();
                            }

                            function handleSubscribe(event) {
                                event.preventDefault();
                                const email = document.getElementById('subscribeEmail').value.trim();
                                if (email) {
                                    alert("We will notify you of offers at the earliest time. Thank you for your interest in our service!");
                                    document.getElementById('subscribeEmail').value = '';
                                }
                            }

                            // Phần không liên quan - giữ nguyên
                            function showHelpPopup() {
                                alert("This is the help section.");
                            }

                            function showFeedbackPopup() {
                                alert("Please provide your feedback.");
                            }
        </script>
    </body>
</html>