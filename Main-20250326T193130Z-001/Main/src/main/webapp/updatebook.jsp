<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Update Book</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
    <div class="container mt-4">
        <h2 class="text-center">Update Book</h2>
        <form action="updatebook" method="post">
    <input type="hidden" name="id" value="${book.bookID}">

            <div class="mb-3">
                <label class="form-label">Title:</label>
              <input type="text" name="title" class="form-control" value="${book.title}" required>

            </div>

            <div class="mb-3">
                <label class="form-label">Author:</label>
                <input type="text" name="author" class="form-control"value="${book.author}" required>
            </div>

            <div class="mb-3">
                <label class="form-label">Publisher:</label>
                <input type="text" name="publisher" class="form-control"value="${book.publisher}"  required>
            </div>

            <div class="mb-3">
                <label class="form-label">Image URL:</label>
                <input type="text" name="image" class="form-control" value="${book.image}"  required>
            </div>

            <div class="mb-3 text-center">
                <button type="submit" class="btn btn-primary">Update</button>
                <a href="ManageBook" class="btn btn-secondary">Cancel</a>
            </div>
        </form>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
