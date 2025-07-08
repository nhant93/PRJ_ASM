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
import java.sql.Date;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import model.Books;
import model.Users;

@WebServlet(name = "BorrowServlet", urlPatterns = {"/Borrow"})
public class BorrowServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try ( PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet BorrowServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet BorrowServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String action = request.getParameter("action");
        Users user = (Users) session.getAttribute("user");
        BookDAO bookDAO = new BookDAO();
        UserDAO userDAO = new UserDAO();
        String bookIdStr = "";
        List<Books> borrowedBooks = (List<Books>) session.getAttribute("borrowedBooks");

        // Load borrowed books if not already in session
        if (user != null) {
            try {
                borrowedBooks = bookDAO.getBorrowedBooksByUserId(user.getUserID());
                session.setAttribute("borrowedBooks", borrowedBooks);
            } catch (SQLException e) {
                throw new ServletException("Error loading borrowed books: " + e.getMessage());
            }
        }

        // Calculate daysLeft and daysLeftDisplay for each book
        if (borrowedBooks != null && user != null) {
            for (Books book : borrowedBooks) {
                Date dueDate = userDAO.getDueDateForBook(user.getUserID(), book.getTitle());
                int daysLeft = 0;
                String daysLeftDisplay = "Late";
                if (dueDate != null) {
                    LocalDate dueLocalDate = dueDate.toLocalDate();
                    LocalDate today = LocalDate.now();
                    daysLeft = (int) ChronoUnit.DAYS.between(today, dueLocalDate);
                    daysLeft = Math.max(0, daysLeft);
                    if (daysLeft > 0) {
                        daysLeftDisplay = daysLeft + " days";
                    }
                }
                book.setDaysLeft(daysLeft);
                book.setDaysLeftDisplay(daysLeftDisplay);
                System.out.println("Book: " + book.getTitle() + ", DueDate: " + dueDate + ", DaysLeft: " + daysLeft);
            }
            session.setAttribute("borrowedBooks", borrowedBooks);
        }

        if (action == null || action.equals("view")) {
            request.getRequestDispatcher("/borrow.jsp").forward(request, response);
        } else {
            switch (action) {
                case "return": {
                    bookIdStr = request.getParameter("bookId");
                    if (bookIdStr != null && user != null) {
                        try {
                            int bookId = Integer.parseInt(bookIdStr);
                            bookDAO.returnBook(user.getUserID(), bookId);
                            Iterator<Books> iterator = borrowedBooks.iterator();
                            while (iterator.hasNext()) {
                                Books book = iterator.next();
                                if (book.getBookID() == bookId) {
                                    iterator.remove();
                                }
                            }
                            session.setAttribute("borrowedBooks", borrowedBooks);
                        } catch (SQLException e) {
                            throw new ServletException("Error returning book: " + e.getMessage());
                        }
                    }
                    response.sendRedirect(request.getContextPath() + "/borrow.jsp");
                    break;
                }
                case "borrow": {
                    bookIdStr = request.getParameter("bookId");
                    if (bookIdStr != null && user != null) {
                        try {
                            int bookId = Integer.parseInt(bookIdStr);
                            boolean isDuplicate = bookDAO.isBookBorrowed(user.getUserID(), bookId);
                            if (isDuplicate) {
                                response.getWriter().write("duplicate");
                            } else {
                                Books newBook = bookDAO.getBookById(bookId);
                                bookDAO.borrowBook(user.getUserID(), bookId);
                                if (borrowedBooks == null) {
                                    borrowedBooks = new ArrayList<>();
                                }
                                borrowedBooks.add(newBook);
                                session.setAttribute("borrowedBooks", borrowedBooks);
                                response.getWriter().write("success");
                            }
                        } catch (SQLException e) {
                            throw new ServletException("Error borrowing book: " + e.getMessage());
                        }
                    } else {
                        response.sendRedirect(request.getContextPath() + "/detail.jsp");
                    }
                    break;
                }
                default: {
                    response.sendRedirect(request.getContextPath() + "/detail.jsp");
                    break;
                }
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}
