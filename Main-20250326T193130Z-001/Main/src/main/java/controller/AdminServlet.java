/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.BookDAO;
import dao.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import java.util.List;
import model.Books;
import model.Users;

/**
 *
 * @author Admin
 */
@WebServlet(name = "AdminServlet", urlPatterns = {"/admin"})
public class AdminServlet extends HttpServlet {

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
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet AdminServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AdminServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

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

        UserDAO userDAO = new UserDAO();
        BookDAO bookDAO = new BookDAO();
        List<Users> userList = userDAO.getAllUsers();
        request.setAttribute("userList", userList);

        // Lấy cài đặt mượn sách
        int defaultLoanDays = userDAO.getDefaultLoanDays();
        int maxBooksAllowed = userDAO.getMaxBooksAllowed();
        int lateFeePerDay = userDAO.getLateFeePerDay();
        //int extendFee = bookDAO.getExtendFee(); 
        int extendFee = 0;
        try {
            extendFee = bookDAO.getExtendFee();
        } catch (SQLException e) {
            e.printStackTrace(); // hoặc log ra file
            extendFee = 5000; // hoặc giá trị mặc định bạn muốn
        }

        request.setAttribute("defaultLoanDays", defaultLoanDays);
        request.setAttribute("maxBooksAllowed", maxBooksAllowed);
        request.setAttribute("lateFeePerDay", lateFeePerDay);
        request.setAttribute("extendFee", extendFee);

        // Lấy danh sách sách
        try {
            List<Books> bookList = bookDAO.getAllBooks();
            request.setAttribute("bookList", bookList);
        } catch (Exception e) {
        }

        request.getRequestDispatcher("admin.jsp").forward(request, response);
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
        response.setContentType("text/plain;charset=UTF-8");

        String action = request.getParameter("action");
        UserDAO userDAO = new UserDAO();
        BookDAO bookDAO = new BookDAO();

        if (null == action) {
            response.getWriter().write("error: Invalid action!");
        } else {
            switch (action) {
                case "add": {
                    String rollNumber = request.getParameter("rollNumber");
                    String password = request.getParameter("password");
                    String fullName = request.getParameter("fullName");
                    String phoneNumber = request.getParameter("phoneNumber") != null ? request.getParameter("phoneNumber").trim() : "";
                    String address = request.getParameter("address") != null ? request.getParameter("address").trim() : "";
                    String email = request.getParameter("email");

                    if (rollNumber == null || password == null || fullName == null || email == null
                            || rollNumber.isEmpty() || password.isEmpty() || fullName.isEmpty() || email.isEmpty()) {
                        response.getWriter().write("error: All required fields must be filled!");
                        return;
                    }

                    Users user = new Users();
                    user.setRollNumber(rollNumber);
                    user.setPassword(userDAO.hashMD5(password));
                    user.setFullname(fullName);
                    user.setPhonenumber(phoneNumber);
                    user.setAddress(address);
                    user.setEmail(email);

                    try {
                        boolean success = userDAO.registerUser(user);
                        response.getWriter().write(success ? "success: Add new user successfully!" : "error: Failed to add new user!");
                    } catch (Exception e) {
                        response.getWriter().write("error: Error while adding user: " + e.getMessage());
                    }
                    break;
                }
                case "update": {
                    String userIDStr = request.getParameter("userID");
                    String rollNumber = request.getParameter("rollNumber");
                    String fullName = request.getParameter("fullName");
                    String phoneNumber = request.getParameter("phoneNumber") != null ? request.getParameter("phoneNumber").trim() : "";
                    String address = request.getParameter("address") != null ? request.getParameter("address").trim() : "";
                    String email = request.getParameter("email");

                    if (userIDStr == null || rollNumber == null || fullName == null || email == null
                            || userIDStr.isEmpty() || rollNumber.isEmpty() || fullName.isEmpty() || email.isEmpty()) {
                        response.getWriter().write("error: All required fields must be filled!");
                        return;
                    }

                    try {
                        int userID = Integer.parseInt(userIDStr);
                        boolean success = userDAO.updateUser(userID, rollNumber, fullName, phoneNumber, address, email);
                        response.getWriter().write(success ? "success: Update user's information successfully!" : "error: Failed to update user's information!");
                    } catch (NumberFormatException e) {
                        response.getWriter().write("error: Invalid ID!");
                    } catch (Exception e) {
                        response.getWriter().write("error: Error while updating: " + e.getMessage());
                    }
                    break;
                }
                case "delete": {
                    String userIDStr = request.getParameter("userID");
                    if (userIDStr == null || userIDStr.trim().isEmpty()) {
                        response.getWriter().write("error: Invalid ID!");
                        return;
                    }

                    try {
                        int userID = Integer.parseInt(userIDStr);
                        boolean success = userDAO.deleteUser(userID);
                        response.getWriter().write(success ? "success: Delete user successfully!" : "error: Failed to delete user!");
                    } catch (NumberFormatException e) {
                        response.getWriter().write("error: ID must be a number!");
                    } catch (Exception e) {
                        response.getWriter().write("error: Error while deleting: " + e.getMessage());
                    }
                    break;
                }
                case "updateSettings": {
                    String defaultLoanDaysStr = request.getParameter("defaultLoanDays");
                    String maxBooksAllowedStr = request.getParameter("maxBooksAllowed");
                    String lateFeePerDayStr = request.getParameter("lateFeePerDay");
                    String extendFeeStr = request.getParameter("extendFee");

                    try {
                        boolean success = userDAO.updateLoanSettings(defaultLoanDaysStr, maxBooksAllowedStr, lateFeePerDayStr, extendFeeStr);
                        response.getWriter().write(success ? "success: Update settings successfully!" : "error: Failed to update settings!");
                    } catch (NumberFormatException e) {
                        response.getWriter().write("error: Invalid value format!");
                    } catch (Exception e) {
                        response.getWriter().write("error: Error while updating settings: " + e.getMessage());
                    }
                    break;
                }
                case "updateNotificationSettings": {
                    String rollNumber = request.getParameter("rollNumber");
                    String notificationInterval = request.getParameter("notificationInterval");
                    String enabledStr = request.getParameter("enabled");

                    try {
                        boolean enabled = Boolean.parseBoolean(enabledStr);
                        boolean success = userDAO.updateNotificationSettings(rollNumber, notificationInterval, enabled);
                        response.getWriter().write(success ? "success: Update notification successfully!" : "error: Failed to update notification!");
                    } catch (NumberFormatException e) {
                        response.getWriter().write("error: Invalid ID!");
                    } catch (Exception e) {
                        response.getWriter().write("error: Error while update notification: " + e.getMessage());
                    }
                    break;
                }
                case "addBook": {
                    String title = request.getParameter("bookTitle");
                    String author = request.getParameter("bookAuthor");
                    String publisher = request.getParameter("bookPublisher");

                    if (title == null || author == null || title.isEmpty() || author.isEmpty()) {
                        response.getWriter().write("error: Title and Author are required!");
                        return;
                    }

                    try {
                        boolean success = bookDAO.addBook(title, author, publisher);
                        response.getWriter().write(success ? "success: Add new book successfully!" : "error: Failed to add new book!");
                    } catch (Exception e) {
                        response.getWriter().write("error: Error while adding new book: " + e.getMessage());
                    }
                    break;
                }
                case "deleteBook": {
                    String bookIDStr = request.getParameter("bookID");
                    if (bookIDStr == null || bookIDStr.trim().isEmpty()) {
                        response.getWriter().write("error: Invalid Book ID!");
                        return;
                    }

                    try {
                        int bookID = Integer.parseInt(bookIDStr);
                        boolean success = bookDAO.deleteBook(bookID);
                        response.getWriter().write(success ? "success: Delete book successfully!" : "error: Failed to delete book!");
                    } catch (NumberFormatException e) {
                        response.getWriter().write("error: Book ID must be a number!");
                    } catch (Exception e) {
                        response.getWriter().write("error: Error while deleting book: " + e.getMessage());
                    }
                    break;
                }
                default: {
                    response.getWriter().write("error: Invalid action!");
                    break;
                }
            }
        }
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
