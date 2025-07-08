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
import java.util.ArrayList;
import java.util.List;
import model.Books;
import model.Users;

/**
 *
 * @author daigi
 */
public class ManageBook extends HttpServlet {

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
        try {
            BookDAO gDAO = new BookDAO();
            List<Books> list = gDAO.getAllBooks();
            request.setAttribute("list", list);
            getServletContext().getRequestDispatcher("/managebook.jsp").forward(request, response);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
