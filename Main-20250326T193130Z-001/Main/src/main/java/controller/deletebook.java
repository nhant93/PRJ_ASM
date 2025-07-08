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
public class deletebook extends HttpServlet {

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

        // Kiểm tra tham số id trước khi parse
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing book ID");
            return;
        }
        int id = Integer.parseInt(idStr);

        BookDAO gDao = new BookDAO();
        try {
            Books b = gDao.getBookById(id);
            request.setAttribute("book", b);
        } catch (SQLException ex) {
            Logger.getLogger(updatebook.class.getName()).log(Level.SEVERE, null, ex);
        }

        request.getRequestDispatcher("deletebook.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Kiểm tra tham số id trước khi parse
            String idStrPost = request.getParameter("id");
            if (idStrPost == null || idStrPost.trim().isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing book ID");
                return;
            }
            int id = Integer.parseInt(idStrPost);

            BookDAO bookDAO = new BookDAO();
            boolean isDeleted = bookDAO.deleteBook(id);
            if (isDeleted) {
                response.sendRedirect("ManageBook");
            } else {
                response.sendRedirect("deletebook");
            }
        } catch (Exception e) {
            System.out.println("ERR");
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}