/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.BookDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Books;
import model.Users;

/**
 *
 * @author daigi
 */
public class updatebook extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

// Nguyên kiểm tra quyền 
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("Login");
            return;
        }
        Users user = (Users) session.getAttribute("user");
        if (user.getRoleID() != 0) {
            response.sendRedirect("mainPage");
            return;
        }
        int id = Integer.parseInt(request.getParameter("id"));
        BookDAO gDao = new BookDAO();
        try {
            Books b = gDao.getBookById(id);
            request.setAttribute("book", b);

        } catch (SQLException ex) {
            Logger.getLogger(updatebook.class.getName()).log(Level.SEVERE, null, ex);
        }

        request.getRequestDispatcher("updatebook.jsp").forward(request, response);

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String title = request.getParameter("title");
            String author = request.getParameter("author");
            String publisher = request.getParameter("publisher");
            String genre = request.getParameter("genreid");
            String image = request.getParameter("image");

            BookDAO book = new BookDAO();
            Books updatedBook = new Books(id, title, author, publisher,image);

            int success = book.updateBook(updatedBook);
            if (success > 0) {
                response.sendRedirect("ManageBook");
            } else {
                response.sendRedirect("/ManageBook/updatebook?id=" + id);

            }
        } catch (Exception e) {
            throw new ServletException("Error processing book creation: " + e.getMessage());
        }

    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
