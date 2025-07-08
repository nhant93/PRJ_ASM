package controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import dao.BookDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Books;

@WebServlet(name = "MainPage", urlPatterns = {"/mainPage"})
public class MainPageServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        BookDAO bookDAO = new BookDAO();
        String search = request.getParameter("search");
        try {
            if (search == null) search = "";
            // Lấy ít nhất 95 sách hoặc toàn bộ danh sách
            List<Books> books = bookDAO.getAllBooks(); // Hoặc getAllBooks() nếu muốn lấy hết

            request.setAttribute("search", search);
            request.setAttribute("currentPage", 1); // Giữ mặc định là 1
            request.setAttribute("books", books);
            request.getRequestDispatcher("mainPage.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}