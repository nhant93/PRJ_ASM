/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nfs://.netbeans.org/projects/nbsp/Sources/NbModules/JSP_Servlet/Servlet.java to edit this template
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
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.ZoneId;
import java.time.temporal.ChronoUnit;

/**
 *
 * @author giaph
 */
@WebServlet(name = "SettingServlet", urlPatterns = {"/Setting"})
public class SettingServlet extends HttpServlet {

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
            out.println("<title>Servlet SettingServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet SettingServlet at " + request.getContextPath() + "</h1>");
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
        String section = request.getParameter("section");
        String action = request.getParameter("action");
        String title = request.getParameter("title");
        String image = request.getParameter("image");

        if ("general".equals(section) && "extend".equals(action)) {
            request.setAttribute("title", title);
            request.setAttribute("image", image);
            request.getRequestDispatcher("settings.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("settings.jsp").forward(request, response);
        }
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
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        if ("changePassword".equals(action)) {
            // Action đổi mật khẩu
            String rollNumber = request.getParameter("rollNumber");
            String currentPassword = request.getParameter("currentPassword");
            String newPassword = request.getParameter("newPassword");
            UserDAO userDAO = new UserDAO();

            // Log dữ liệu nhận được
            System.out.println("Received rollNumber: " + rollNumber);
            System.out.println("Received currentPassword: " + currentPassword);
            System.out.println("Received newPassword: " + newPassword);

            // Kiểm tra dữ liệu đầu vào
            if (rollNumber == null || rollNumber.trim().isEmpty()) {
                System.out.println("RollNumber is null or empty");
                response.getWriter().write("error: Missing rollNumber");
                return;
            }

            // Xử lý đổi mật khẩu
            if (currentPassword != null && newPassword != null) {
                boolean success = userDAO.changePassword(rollNumber, currentPassword, newPassword);
                System.out.println("Change password result: " + success);
                if (success) {
                    response.getWriter().write("success");
                } else {
                    response.getWriter().write("wrongCurrentPassword");
                }
                return;
            }
        } else if ("getDueDate".equals(action)) {
            String rollNumber = request.getParameter("rollNumber");
            UserDAO userDAO = new UserDAO();
            try {
                int userID = userDAO.getUserIdByRollNumber(rollNumber);
                java.sql.Date dueDate = userDAO.getLatestDueDate(userID);
                System.out.println("Due date from database: " + dueDate);
                if (dueDate != null) {
                    LocalDate dueLocalDate = dueDate.toLocalDate();
                    LocalDate today = LocalDate.now(ZoneId.systemDefault());
                    long diffInDays = ChronoUnit.DAYS.between(today, dueLocalDate);
                    diffInDays = Math.max(0, diffInDays);
                    System.out.println("Due days calculated: " + diffInDays + " (from " + today + " to " + dueLocalDate + ")");
                    response.getWriter().write(String.valueOf(diffInDays));
                } else {
                    System.out.println("No due date found for rollNumber: " + rollNumber);
                    int defaultLoanDays = userDAO.getDefaultLoanDays();
                    System.out.println("Default loan days from UserDAO: " + defaultLoanDays);
                    response.getWriter().write(String.valueOf(defaultLoanDays > 0 ? defaultLoanDays : 0));
                }
            } catch (SQLException e) {
                e.printStackTrace();
                System.out.println("SQLException in getDueDate: " + e.getMessage());
                response.getWriter().write("error: " + e.getMessage());
            }
            return;
        }

        // Trường hợp không xác định
        response.getWriter().write("error: Invalid request");
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Servlet to handle settings-related operations (change password and get due date)";
    }
    // </editor-fold>
}
