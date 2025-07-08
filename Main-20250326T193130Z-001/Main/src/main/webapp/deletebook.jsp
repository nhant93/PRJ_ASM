<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="dao.BookDAO, model.Books" %>

<%
    int bookID = Integer.parseInt(request.getParameter("id"));
    BookDAO bookDAO = new BookDAO();
    Books book = bookDAO.getBookById(bookID);
    request.setAttribute("book", book);
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Confirm Delete</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    </head>
    <body>
        <div class="container mt-5">
            <div class="card text-center">
                <div class="card-header bg-danger text-white">
                    <h3>Confirm Delete</h3>
                </div>
                <div class="card-body">
                    <p>Are you sure you want to delete the book:</p>
                    <h5>${book.title}</h5>
                    <form action="deletebook" method="post">
                        <input type="hidden" name="id" value="${book.bookID}">
                        <div class="mt-3">
                            <button type="submit" class="btn btn-danger">Yes, Delete</button>
                            <a href="ManageBook" class="btn btn-secondary">No, Cancel</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </body>
</html>
