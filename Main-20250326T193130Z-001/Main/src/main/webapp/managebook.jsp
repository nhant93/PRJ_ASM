<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.util.List" %>

<!DOCTYPE html>
<html>
    <head>
        <title>Manage Books</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <style>
            .back-btn {
                position: absolute;
                top: 10px;
                left: 10px;
            }
        </style>
    </head>
    <body class="container mt-4">
        <a href="admin" class="btn btn-secondary back-btn">Back</a>
        
        <h2 class="text-center">Manage Books</h2>
        <div class="mb-2"> 
        <a href="createbook" class="btn btn-primary">Create</a>
        </div>
        <table class="table table-bordered table-striped">
            <thead class="table-dark">
                <tr>
                    <th>Title</th>
                    <th>Author</th>
                    <th>Publisher</th>
                    
                    <th>Image</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty list}">
                        <c:forEach var="book" items="${list}">
                            <tr>
                                <td>${book.title}</td>
                                <td>${book.author}</td>
                                <td>${book.publisher}</td>
                                
                                <td><img src="book/BookImage/${book.getImage()}" width="100" height="100"></td>
                                <td>
                                    <a href="updatebook?id=${book.bookID}" class="btn btn-success">Update</a>
                                    <a href="deletebook?id=${book.bookID}" class="btn btn-danger">Delete</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="6" class="text-center text-danger">No books found.</td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>

    </body>
</html>