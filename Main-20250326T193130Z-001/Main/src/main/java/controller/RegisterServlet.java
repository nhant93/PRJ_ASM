/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.logging.Logger;
import model.Users;

/**
 *
 * @author giaph
 */
@WebServlet(name = "RegisterServlet", urlPatterns = {"/Register"})
public class RegisterServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(RegisterServlet.class.getName());

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try ( PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet RegisterServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet RegisterServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("showSignup", true);
        request.getRequestDispatcher("auth.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String rollNumber = request.getParameter("rollNumber");
        String password = request.getParameter("password");
        String fullName = request.getParameter("fullName");
        String phonenumber = request.getParameter("phoneNumber") != null ? request.getParameter("phoneNumber").trim() : "";
        String address = request.getParameter("address") != null ? request.getParameter("address").trim() : "";
        String email = request.getParameter("email");

        if (rollNumber == null || password == null || fullName == null || email == null
                || rollNumber.isEmpty() || password.isEmpty() || fullName.isEmpty() || email.isEmpty()) {
            LOGGER.warning("Registration failed: Missing required fields");
            request.setAttribute("error", "All fields are required!");
            request.getRequestDispatcher("auth.jsp").forward(request, response);
            return;
        }

        // Hash mật khẩu trước khi lưu vào database
        UserDAO userDAO = new UserDAO();
        String hashedPassword = userDAO.hashMD5(password);

        // Kiểm tra trùng FullName và Email
        if (userDAO.isFullNameExists(fullName)) {
            request.setAttribute("error", "❌ Name existed. Please choose another one.");
            request.getRequestDispatcher("auth.jsp").forward(request, response);
            return;
        } else if (userDAO.isEmailExists(email)) {
            request.setAttribute("error", "❌ Email existed. Please choose another one.");
            request.getRequestDispatcher("auth.jsp").forward(request, response);
            return;
        }

        // Nếu không trùng, tiếp tục đăng ký
        boolean isRegistered = userDAO.registerUser(new Users(rollNumber, hashedPassword, fullName, phonenumber, address, email, 1));
        if (isRegistered) {
            request.setAttribute("message", "✅ Successful registration! Redirecting...");
        } else {
            request.setAttribute("error", "❌ Failed registration! Please try again.");
        }
        request.getRequestDispatcher("auth.jsp").forward(request, response);
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
