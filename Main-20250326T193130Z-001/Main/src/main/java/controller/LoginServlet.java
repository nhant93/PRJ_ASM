/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.BookDAO;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Books;
import model.Users;

/**
 *
 * @author giaph
 */
@WebServlet(name = "LoginServlet", urlPatterns = {"/Login"})
public class LoginServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(LoginServlet.class.getName());

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet BookManagement</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet BookManagement at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("auth.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        UserDAO userDAO = new UserDAO();
        BookDAO bookDAO = new BookDAO();
        String rollNumber = request.getParameter("rollNumber");
        String password = request.getParameter("password");
        Users user = userDAO.verifyMD5(rollNumber, password);
        
        if (user != null) {
            LOGGER.info("LoginServlet successful for Roll Number: " + rollNumber);
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            List<Books> borrowedBooks = null;
            try {
                borrowedBooks = bookDAO.getBorrowedBooksByUserId(user.getUserID());
            } catch (SQLException ex) {
                Logger.getLogger(LoginServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
            session.setAttribute("borrowedBooks", borrowedBooks);
            request.setAttribute("message", "Login successful!");
            if (user.getRoleID() == 0) {
                response.sendRedirect("admin");
            } else {
                response.sendRedirect("mainPage");
            }
        } else {
            LOGGER.warning("LoginServlet failed for Roll Number: " + rollNumber);
            request.setAttribute("error", "Invalid Roll Number or Password! Please try again.");
            request.getRequestDispatcher("auth.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}