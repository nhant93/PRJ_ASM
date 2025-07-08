<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Create Book</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body>

        <div class="container mt-5">
            <h2 class="text-center">Add New Book</h2>
            <form action="createbook" method="post">
                <div class="mb-3">
                    <label class="form-label">Title</label>
                    <input type="text" name="title" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Author</label>
                    <input type="text" name="author" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Publisher</label>
                    <input type="text" name="publisher" class="form-control">
                </div>                
                <div class="mb-3">
                    <label class="form-label">Image URL</label>
                    <input type="text" name="image" class="form-control" placeholder="Enter image">
                </div>
                <button type="submit" class="btn btn-primary">Create</button>
                <a href="ManageBook" class="btn btn-secondary">Cancel</a>
            </form>
        </div>

    </body>
</html>

