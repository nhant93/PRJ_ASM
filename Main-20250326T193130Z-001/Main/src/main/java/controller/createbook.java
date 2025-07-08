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
import model.Books;
import model.Users;

/**
 *
 * @author daigi
 */
public class createbook extends HttpServlet {

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
        } else {
            request.getRequestDispatcher("createbook.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String title = request.getParameter("title");
            String author = request.getParameter("author");
            String publisher = request.getParameter("publisher");
            String genre = request.getParameter("genreid");
            String image = request.getParameter("image");

            Books newBook = new Books(0, title, author, publisher, image);

            BookDAO gDao = new BookDAO();
            int result = gDao.createBook(newBook);

            if (result == 1) {
                response.sendRedirect("ManageBook");
            } else {
                request.getRequestDispatcher("createbook.jsp").forward(request, response);
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
