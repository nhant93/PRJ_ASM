<%@page import="model.Users"%>
<%@page import="java.sql.*, java.util.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Main Page - Library</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@700&family=Dancing+Script:wght@700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" integrity="sha512-DTOQO9RWCH3ppGqcWaEA1BIZOC6xxalwEsw9c2QQeAIftl+Vegovlnee1c9QX4TctnWMn13TZye+giMm8e2LwA==" crossorigin="anonymous" referrerpolicy="no-referrer" />
        <link rel="stylesheet" href="css/main-page.css" />

        <style>
            .book-container {
                display: flex;
                background-color: #fff;
                flex-wrap: wrap;
            }
            .book {
                display: flex;
                flex-direction: column;
                align-items: center;
                text-align: center;
                width: calc((100% - 20px) / 5);
                margin: 5px auto;
                padding: 10px;
                border-radius: 5px;
                box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            }
            .book-title {
                font-size: 14px;
                margin: 8px 0;
                color: #333;
                word-wrap: break-word;
                max-width: 100%;
                height: 40px;
            }
            .book img {
                width: 150px;
                height: 220px;
                object-fit: cover;
                border: 1px solid #ddd;
            }
            .highlight {
                background-color: yellow;
            }

            body {
                padding-top: 130px;
                margin: 0;
                font-family: 'Roboto', sans-serif;
            }
            .container:not(#introduction3), .feature-section, #faqSection, .footer {
                opacity: 0;
                transition: opacity 0.5s ease;
            }
            .container:not(#introduction3).visible, .feature-section.visible, #faqSection.visible, .footer.visible {
                opacity: 1;
            }
            .content {
                max-width: 45%;
                transform: translateX(0);
                animation: slideInLeft 1.2s ease-in-out forwards;
            }
            .book-image {
                transform: translateX(0);
                animation: slideInRight 1.2s ease-in-out forwards;
            }
            @keyframes slideInLeft {
                from {
                    opacity: 0;
                    transform: translateX(-100%);
                }
                to {
                    opacity: 1;
                    transform: translateX(0);
                }
            }
            @keyframes slideInRight {
                from {
                    opacity: 0;
                    transform: translateX(100%);
                }
                to {
                    opacity: 1;
                    transform: translateX(0);
                }
            }

            .nav-link {
                opacity: 0;
                transform: translateY(-20px);
                animation: slideDown 0.5s ease-in-out forwards;
            }
            .nav-link:nth-child(1) {
                animation-delay: 0.1s;
            }
            .nav-link:nth-child(2) {
                animation-delay: 0.2s;
            }
            .nav-link:nth-child(3) {
                animation-delay: 0.3s;
            }
            @keyframes slideDown {
                from {
                    opacity: 0;
                    transform: translateY(-20px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }
            .nav-item {
                display: flex;
                align-items: center;
            }
            .cart-icon-header {
                margin-left: 5px;
                font-size: 18px;
                color: #000000;
                transition: color 0.3s ease;
            }
            .cart-icon-header:hover {
                color: #0066cc;
            }
        </style>
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

                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav"
                        aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                    <span class="navbar-toggler-icon"></span>
                </button>

                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav mx-auto">
                        <li class="nav-item">
                            <a class="nav-link" href="#introduction1">Introduction</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#list">My Books</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#faqSection">FAQs</a>
                            <a href="<%=request.getContextPath()%>/Borrow" class="cart-icon-header" title="Go to Borrowed Books">
                                <i class="fas fa-shopping-cart"></i>
                            </a>
                        </li>
                    </ul>
                    <div class="search-container">
                        <span class="search-icon"><i class="fas fa-search" style="color: #000000;"></i></span>
                        <form class="search-form" id="searchForm">
                            <input type="hidden" name="currentPage" value="${requestScope.currentPage}">
                            <label for="searchInput"></label>
                            <input type="text" class="search-input" placeholder="Search" name="search" value="${requestScope.search}" id="searchInput">
                        </form>
                    </div>
                </div>

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
                            <a href="Setting" class="dropdown-item">Settings</a>
                            <a href="#" class="dropdown-item" onclick="showHelpPopup()">Help</a>
                            <a href="#" class="dropdown-item" onclick="showFeedbackPopup()">Feedback</a>
                            <a href="Logout" class="dropdown-item logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
                        </div>
                    </div>
                    <%
                    } else {
                    %>
                    <a class="login-btn" href="Login">Log in</a>
                    <a class="signup-btn" href="<%=request.getContextPath()%>/Register">Sign up</a>
                    <%
                        }
                    %>
                </div>
            </nav>

            <div class="container" id="introduction1">
                <div class="content">
                    <button class="btn-custom">We provide</button>
                    <h1>Your community's knowledge information is ready</h1>
                    <p>FPT Library is the largest online book library in Vietnam with millions of e-books in every field</p>
                    <a href="#" class="btn-join">JOIN</a>
                </div>
                <img src="https://cdn.cmsfly.com/67d30eecb99cf4001f539e60/images/photo1585521549926ca6526bda09e-Rkp7h.jpeg" alt="Book Stack" class="book-image">
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

            <div class="container" style="display: block" id="introduction3">
                <h3 class="text-center mb-4" id="list">Book List</h3>
                <p>Total books: <c:out value="${requestScope.books.size()}"/></p>
                <div class="book-container" id="bookContainer">
                    <c:if test="${not empty requestScope.books}">
                        <c:forEach var="b" items="${requestScope.books}" varStatus="loop">
                            <div class="book" data-index="${loop.count}" style="${loop.count > 20 ? 'display: none;' : 'display: flex;'}">
                                <img src="./book/BookImage/${b.getImage()}" alt="book image">
                                <div class="book-title">
                                    <c:choose>
                                        <c:when test="${not empty requestScope.search and b.getTitle().toLowerCase().contains(requestScope.search.toLowerCase())}">
                                            <span style="background-color: yellow">${b.getTitle()}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span>${b.getTitle()}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <a class="btn btn-primary mt-3 w-100" href="./detail?id=${b.getBookID()}">Borrow</a>
                            </div>
                        </c:forEach>
                    </c:if>
                    <c:if test="${empty requestScope.books}">
                        <p>No books available.</p>
                    </c:if>
                </div>
                <div class="text-center" id="toggleButtonContainer">
                    <c:if test="${not empty requestScope.books and requestScope.books.size() >= 20}">
                        <a class="btn btn-secondary" href="javascript:void(0)" onclick="toggleBooks()" id="toggleButton">Read more</a>
                    </c:if>
                </div>
            </div>

            <div id="faqSection" class="container-sm">
                <div class="faq-container">
                    <h2 class="faq-title">FAQs - Frequently Asked Questions</h2>
                    <p class="faq-subtitle">If you can't find an answer, please contact us for support.</p>
                    <div class="faq-list">
                        <div class="faq-item">
                            <p class="faq-question">How to borrow a book?</p>
                            <p class="faq-answer">You need to log in to the system, select a book, and click the "Borrow book" button.</p>
                        </div>
                        <div class="faq-item">
                            <p class="faq-question">How long can I borrow a book?</p>
                            <p class="faq-answer">You can borrow a book for a maximum of 14 days. You can renew it if you want to borrow longer.</p>
                        </div>
                        <div class="faq-item">
                            <p class="faq-question">How to renew a book?</p>
                            <p class="faq-answer">Go to the "My Books" section, select the book to renew, and click the "Renew" button.</p>
                        </div>
                        <div class="faq-item">
                            <p class="faq-question">Is there a fee for borrowing books?</p>
                            <p class="faq-answer">Borrowing books is completely free, but you may be fined if you return a book late.</p>
                        </div>
                        <div class="faq-item">
                            <p class="faq-question">What should I do if I lose a book?</p>
                            <p class="faq-answer">You need to contact the library to learn about the compensation or replacement process.</p>
                        </div>
                        <div class="faq-item">
                            <p class="faq-question">How to find a book quickly?</p>
                            <p class="faq-answer">Use the search bar on the homepage and enter keywords related to the book you need.</p>
                        </div>
                    </div>
                </div>
            </div>

            <div class="overlay" id="overlay"></div>

            <div class="popup" id="helpPopup">
                <ul>
                    <li><a href="#faqSection" onclick="closeHelpPopup(); scrollToFAQs();">FAQs</a></li>
                    <li>
                        <strong style="color: #000000;">Contact Support:</strong>
                        <p><span style="color: #1E90FF; font-weight: 600;">Email:</span> hongtuannguyencm@gmail.com</p>
                        <p><span style="color: #FF6200; font-weight: 600;">Phone Number:</span> 0818578616</p>
                        <p><span style="color: #28A745; font-weight: 600;">Messenger:</span> FPTLibrary.the</p>
                    </li>
                </ul>
                <button class="popup-back-btn" onclick="closeHelpPopup()">Back</button>
            </div>

            <div class="popup feedback-popup" id="feedbackPopup">
                <h4>Feedback</h4>
                <textarea placeholder="Enter your feedback..." id="feedbackInput"></textarea>
                <div class="feedback-buttons">
                    <button class="popup-back-btn" onclick="closeFeedbackPopup()">Back</button>
                    <button class="send-btn" onclick="sendFeedback()">Send</button>
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
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            document.getElementById("searchForm").addEventListener("submit", function (event) {
                event.preventDefault();
                searchAndScroll();
            });

            document.getElementById("searchInput").addEventListener("keydown", function (event) {
                if (event.key === "Enter") {
                    event.preventDefault();
                    searchAndScroll();
                }
            });

            function searchAndScroll() {
                const searchValue = document.getElementById("searchInput").value.trim().toLowerCase();
                const books = document.querySelectorAll('.book');

                books.forEach(book => {
                    const titleSpan = book.querySelector('.book-title span');
                    if (titleSpan) {
                        titleSpan.classList.remove('highlight');
                    }
                });

                if (searchValue) {
                    let foundBook = null;
                    books.forEach(book => {
                        const title = book.querySelector('.book-title span').textContent.toLowerCase();
                        if (title.includes(searchValue)) {
                            foundBook = book;
                            book.style.display = 'flex';
                            const titleSpan = book.querySelector('.book-title span');
                            if (titleSpan) {
                                titleSpan.classList.add('highlight');
                            }
                            return;
                        }
                    });

                    if (foundBook) {
                        const navbarHeight = document.querySelector('.navbar').offsetHeight;
                        const bookPosition = foundBook.getBoundingClientRect().top + window.pageYOffset - navbarHeight;
                        window.scrollTo({
                            top: bookPosition,
                            behavior: 'smooth'
                        });
                    } else {
                        alert("Không tìm thấy sách với từ khóa: " + searchValue);
                    }
                }
            }

            document.addEventListener('DOMContentLoaded', function () {
                const navLinks = document.querySelectorAll('.nav-link');
                const navbarNav = document.querySelector('.navbar-nav');
                const underline = document.createElement('div');
                underline.classList.add('underline');
                navbarNav.appendChild(underline);

                let activeLink = navLinks[0];
                activeLink.classList.add('active');
                updateUnderline();

                navLinks.forEach(link => {
                    link.addEventListener('click', function (e) {
                        e.preventDefault();
                        if (activeLink !== this) {
                            activeLink.classList.remove('active');
                            activeLink.style.color = '#000000';
                            this.classList.add('active');
                            this.style.color = '#0066cc';
                            activeLink = this;
                            updateUnderline();
                        }
                        const targetId = this.getAttribute('href').substring(1);
                        const targetElement = document.getElementById(targetId);
                        if (targetElement) {
                            const navbarHeight = document.querySelector('.navbar').offsetHeight;
                            const targetPosition = targetElement.getBoundingClientRect().top + window.pageYOffset - navbarHeight;
                            window.scrollTo({
                                top: targetPosition,
                                behavior: 'smooth'
                            });
                        }
                    });
                });

                function updateUnderline() {
                    const rect = activeLink.getBoundingClientRect();
                    const navRect = navbarNav.getBoundingClientRect();
                    underline.style.width = rect.width + 'px';
                    underline.style.left = (rect.left - navRect.left) + 'px';
                }

                window.addEventListener('resize', updateUnderline);

                const observer = new IntersectionObserver((entries) => {
                    entries.forEach(entry => {
                        if (entry.isIntersecting) {
                            entry.target.classList.add('visible');
                        } else {
                            entry.target.classList.remove('visible');
                        }
                    });
                }, {threshold: 0.3});

                document.querySelectorAll('.container:not(#introduction3), .feature-section, #faqSection, .footer').forEach(section => {
                    observer.observe(section);
                });

                console.log("Total books loaded:", document.querySelectorAll('.book').length);
            });

            let displayedBooks = 20;
            const booksPerLoad = 20;
            const totalBooks = document.querySelectorAll('.book').length;

            function toggleBooks() {
                const books = document.querySelectorAll('.book');
                const toggleButton = document.getElementById('toggleButton');
                console.log("Toggle button clicked, current text:", toggleButton.textContent);

                if (toggleButton.textContent === 'Read more') {
                    displayedBooks += booksPerLoad;
                    if (displayedBooks >= totalBooks) {
                        displayedBooks = totalBooks;
                        toggleButton.textContent = 'Collapse';
                    }
                    books.forEach((book, index) => {
                        if (index < displayedBooks) {
                            book.style.display = 'flex';
                        }
                    });
                } else {
                    displayedBooks = 20;
                    books.forEach((book, index) => {
                        if (index >= displayedBooks) {
                            book.style.display = 'none';
                        } else {
                            book.style.display = 'flex';
                        }
                    });
                    toggleButton.textContent = 'Read more';
                    window.scrollTo({
                        top: document.getElementById('list').offsetTop - document.querySelector('.navbar').offsetHeight,
                        behavior: 'smooth'
                    });
                }
                console.log("Displayed books:", displayedBooks);
            }

            function showOverlay() {
                document.getElementById('overlay').classList.add('active');
            }
            function hideOverlay() {
                document.getElementById('overlay').classList.remove('active');
            }
            function showHelpPopup() {
                document.getElementById('helpPopup').classList.add('active');
                showOverlay();
            }
            function closeHelpPopup() {
                document.getElementById('helpPopup').classList.remove('active');
                hideOverlay();
            }
            function scrollToFAQs() {
                const faqSection = document.getElementById('faqSection');
                const navbarHeight = document.querySelector('.navbar').offsetHeight;
                const targetPosition = faqSection.getBoundingClientRect().top + window.pageYOffset - navbarHeight;
                window.scrollTo({top: targetPosition, behavior: 'smooth'});
            }
            function showFeedbackPopup() {
                document.getElementById('feedbackPopup').classList.add('active');
                showOverlay();
            }
            function closeFeedbackPopup() {
                document.getElementById('feedbackPopup').classList.remove('active');
                hideOverlay();
            }
            function sendFeedback() {
                const feedback = document.getElementById('feedbackInput').value.trim();
                if (feedback) {
                    alert("Feedback has been sent, thank you for your contribution!");
                    closeFeedbackPopup();
                } else {
                    alert("Please enter feedback before sending!");
                }
            }
            function handleSubscribe(event) {
                event.preventDefault();
                const email = document.getElementById('subscribeEmail').value.trim();
                if (email) {
                    alert("We will notify you of offers at the earliest time. Thank you for your interest in our service!");
                    document.getElementById('subscribeEmail').value = '';
                }
            }
        </script>
    </body>
</html>