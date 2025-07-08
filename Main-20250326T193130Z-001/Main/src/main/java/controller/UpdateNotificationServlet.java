/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dao.UserDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/UpdateNotificationServlet")
public class UpdateNotificationServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String rollNumber = request.getParameter("rollNumber");
        String interval = request.getParameter("interval");

        UserDAO userDAO = new UserDAO();
        boolean success = userDAO.updateNotificationSettings(rollNumber, interval, true);

        if (success) {
            response.getWriter().write("success");
        } else {
            response.getWriter().write("error");
        }
    }
}