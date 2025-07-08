<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Your Shopping Cart</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 0;
                padding: 20px;
                background-color: #f5f5f5;
            }
            .container {
                max-width: 800px;
                margin: 0 auto;
                background-color: white;
                padding: 20px;
                border-radius: 8px;
                box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            }
            .header {
                position: relative;
                text-align: center;
                border-bottom: 2px solid #ff0000;
                padding-bottom: 10px;
                margin-bottom: 20px;
            }
            .header h2 {
                margin: 0;
                font-size: 24px;
                font-weight: bold;
                color: black;
                display: inline-block;
            }
            .cart-icon {
                position: absolute;
                right: 0;
                top: 50%;
                transform: translateY(-50%);
            }
            .cart-icon img {
                width: 30px;
            }
            .cart-count {
                position: absolute;
                top: -10px;
                right: -10px;
                background-color: red;
                color: white;
                border-radius: 50%;
                padding: 2px 6px;
                font-size: 12px;
                font-weight: bold;
            }
            .book-item {
                display: flex;
                align-items: center;
                margin-bottom: 20px;
                padding-bottom: 20px;
                border-bottom: 1px solid #ddd;
            }
            .book-title {
                width: 150px;
                font-style: italic;
                font-weight: bold;
                color: black;
                text-align: center;
                word-wrap: break-word;
            }
            .book-image {
                width: 100px;
                text-align: center;
            }
            .book-image img {
                width: 100px;
                height: 150px;
                object-fit: cover;
            }
            .book-details {
                flex: 1;
                display: flex;
                flex-direction: column;
                align-items: center;
            }
            .progress-bar {
                width: 80%;
                height: 20px;
                background-color: #ddd;
                border-radius: 10px;
                overflow: hidden;
                margin: 10px 0;
                position: relative;
            }
            .progress-fill {
                height: 100%;
                position: absolute;
                top: 0;
                left: 0;
            }
            .progress-fill.green {
                background-color: #4CAF50 !important;
            }
            .progress-fill.yellow {
                background-color: #FFC107 !important;
            }
            .progress-fill.red {
                background-color: #F44336 !important;
            }
            .progress-text {
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                display: flex;
                align-items: center;
                justify-content: center;
                text-align: center;
                color: black;
                font-weight: bold;
                font-size: 14px;
                z-index: 1; /* Đảm bảo văn bản hiển thị phía trên progress-fill */
            }
            .buttons {
                display: flex;
                justify-content: space-between;
                width: 80%;
                margin-top: 10px;
            }
            .buttons button {
                padding: 8px 16px;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                font-size: 14px;
                font-weight: bold;
                color: black;
                background-color: transparent;
                transition: color 0.3s;
            }
            .buttons button:hover {
                color: red;
            }
            .buttons a.extend-btn {
                padding: 8px 16px;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                font-size: 14px;
                font-weight: bold;
                color: black;
                background-color: transparent;
                text-decoration: none;
                transition: color 0.3s;
            }
            .buttons a.extend-btn:hover {
                color: red;
            }
            .back-btn {
                display: flex;
                align-items: center;
                text-decoration: none;
                color: black;
                font-size: 16px;
                font-weight: bold;
                margin-bottom: 20px;
                text-align: center;
            }
            .back-btn img {
                width: 20px;
                margin-right: 5px;
            }
        </style>
        <script>
            function returnBook(bookId) {
                if (confirm('Do you want to return this book?')) {
                    window.location.href = '<%=request.getContextPath()%>/Borrow?action=return&bookId=' + bookId;
                }
            }
        </script>
    </head>
    <body>
        <div class="container">
            <a href="<%=request.getContextPath()%>/mainPage" class="back-btn">
                <img src="https://img.icons8.com/material-rounded/24/000000/back.png" alt="Back">
                Back
            </a>

            <div class="header">
                <h2>Your Shopping Cart</h2>
                <div class="cart-icon">
                    <img src="https://img.icons8.com/ios-filled/50/000000/shopping-cart.png" alt="Cart">
                    <span class="cart-count">${sessionScope.borrowedBooks != null ? sessionScope.borrowedBooks.size() : 0}</span>
                </div>
            </div>

            <c:choose>
                <c:when test="${not empty sessionScope.borrowedBooks}">
                    <c:forEach var="book" items="${sessionScope.borrowedBooks}" varStatus="loop">
                        <c:set var="isDuplicate" value="false" />
                        <c:if test="${loop.index > 0}">
                            <c:forEach var="prevBook" items="${sessionScope.borrowedBooks}" end="${loop.index - 1}">
                                <c:if test="${prevBook.title == book.title}">
                                    <c:set var="isDuplicate" value="true" />
                                </c:if>
                            </c:forEach>
                        </c:if>

                        <c:if test="${not isDuplicate}">
                            <div class="book-item">
                                <div class="book-title">${book.title}</div>
                                <div class="book-image">
                                    <img src="<%=request.getContextPath()%>/book/BookImage/${book.image}" alt="${book.title}">
                                </div>
                                <div class="book-details">
                                    <div class="progress-bar">
                                        <c:choose>
                                            <c:when test="${book.daysLeftDisplay == 'Late'}">
                                                <div class="progress-fill red" style="width: 100%;"></div>
                                            </c:when>
                                            <c:when test="${book.daysLeft > 10}">
                                                <div class="progress-fill green" style="width: ${book.daysLeft * 7.14}%;"></div>
                                            </c:when>
                                            <c:when test="${book.daysLeft > 5}">
                                                <div class="progress-fill yellow" style="width: ${book.daysLeft * 7.14}%;"></div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="progress-fill red" style="width: ${book.daysLeft * 7.14}%;"></div>
                                            </c:otherwise>
                                        </c:choose>
                                        <div class="progress-text">${book.daysLeftDisplay}</div>
                                    </div>
                                    <div class="buttons">
                                        <button class="return-btn" onclick="returnBook(${book.bookID})">Return Book</button>
                                        <a href="<%=request.getContextPath()%>/Setting?section=general&action=extend&title=${book.title}&image=${book.image}" class="extend-btn">Extend</a>
                                    </div>
                                </div>
                            </div>
                        </c:if>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <p class="text-center">You have not borrowed any books yet..</p>
                </c:otherwise>
            </c:choose>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>