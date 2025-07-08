package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Books;
import utils.DBContext;

public class BookDAO extends DBContext {
    
    public boolean addBook(String title, String author, String publisher) throws SQLException {
        if (title == null || title.trim().isEmpty() || author == null || author.trim().isEmpty()) {
            throw new IllegalArgumentException("Title and author cannot be empty");
        }
        if (conn == null) {
            throw new SQLException("Database connection is null");
        }
        String sql = "INSERT INTO Books (Title, Author, Publisher) VALUES (?, ?, ?)";
        try ( PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, title);
            ps.setString(2, author);
            ps.setString(3, publisher);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            throw new SQLException("addBook error: " + e.getMessage());
        }
    }
    
    public int createBook(Books b) throws SQLException {
        if (b == null || b.getTitle() == null || b.getTitle().trim().isEmpty()) {
            throw new IllegalArgumentException("Book or title cannot be empty");
        }
        if (conn == null) {
            throw new SQLException("Database connection is null");
        }
        PreparedStatement stmt = null;
        try {
            String sql = "INSERT INTO Books (Title, Author, Publisher, Image) VALUES (?, ?, ?, ?)";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, b.getTitle());
            stmt.setString(2, b.getAuthor());
            stmt.setString(3, b.getPublisher());
            stmt.setString(4, b.getImage());
            return stmt.executeUpdate();
        } catch (SQLException e) {
            throw new SQLException("Error inserting book: " + e.getMessage());
        } finally {
            if (stmt != null) {
                stmt.close();
            }
        }
    }

    
    public List<Books> getAllBooks() throws SQLException {
        List<Books> bookList = new ArrayList<>();
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            if (conn == null) {
                throw new SQLException("Database connection is null");
            }
            String sql = "SELECT * FROM Books ORDER BY BookID DESC";
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();

            while (rs.next()) {
                Books book = new Books();
                book.setBookID(rs.getInt("BookID"));
                book.setTitle(rs.getString("Title"));
                book.setAuthor(rs.getString("Author"));
                book.setPublisher(rs.getString("Publisher"));
                book.setImage(rs.getString("Image"));
                bookList.add(book);
            }
        } catch (SQLException e) {
            throw new SQLException("Error retrieving book list: " + e.getMessage());
        } finally {
            if (rs != null) {
                rs.close();
            }
            if (stmt != null) {
                stmt.close();
            }
        }
        return bookList;
    }

    public List<Books> searchBooksByTitle(String searchQuery) throws SQLException {
        List<Books> bookList = new ArrayList<>();
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            String sql = "SELECT BookID, Title, Author, Publisher FROM Books WHERE Title LIKE ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, "%" + searchQuery + "%");
            rs = stmt.executeQuery();

            while (rs.next()) {
                Books book = new Books();
                book.setBookID(rs.getInt("BookID"));
                book.setTitle(rs.getString("Title"));
                book.setAuthor(rs.getString("Author"));
                book.setPublisher(rs.getString("Publisher"));
                bookList.add(book);
            }
        } catch (SQLException e) {
            throw new SQLException("Error searching books: " + e.getMessage());
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
        }
        return bookList;
    }

    public Books getBookById(int bookID) throws SQLException {
        PreparedStatement stmt = null;
        ResultSet rs = null;
        Books book = new Books();
        try {
            String sql = "SELECT [BookID], [Title], [Author], [Publisher], [Image] FROM [dbo].[Books] WHERE BookID = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, bookID);
            rs = stmt.executeQuery();

            if (rs.next()) {
                book.setBookID(rs.getInt("BookID"));
                book.setTitle(rs.getString("Title"));
                book.setAuthor(rs.getString("Author"));
                book.setPublisher(rs.getString("Publisher"));
                book.setImage(rs.getString("Image"));
            }
        } catch (SQLException e) {
            throw new SQLException("Error retrieving book: " + e.getMessage());
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
        }
        return book;
    }

    public List<Books> getAllBooksPaging(int pageSize) throws SQLException {
        List<Books> bookList = new ArrayList<>();
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            String sql = "SELECT [BookID], [Title], [Author], [Publisher], [Image] FROM [dbo].[Books] ORDER BY [BookID] OFFSET 0 ROWS FETCH NEXT ? ROWS ONLY";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, pageSize);
            rs = stmt.executeQuery();

            while (rs.next()) {
                Books book = new Books();
                book.setBookID(rs.getInt("BookID"));
                book.setTitle(rs.getString("Title"));
                book.setAuthor(rs.getString("Author"));
                book.setPublisher(rs.getString("Publisher"));
                book.setImage(rs.getString("Image"));
                bookList.add(book);
            }
        } catch (SQLException e) {
            throw new SQLException("Error retrieving book list: " + e.getMessage());
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
        }
        return bookList;
    }

    public List<Books> getBorrowedBooksByUserId(int userId) throws SQLException {
        List<Books> borrowedBooks = new ArrayList<>();
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            String sql = "SELECT b.BookID, b.Title, b.Image FROM [dbo].[Transactions] t JOIN [dbo].[Books] b ON t.BookID = b.BookID WHERE t.UserID = ? AND t.ReturnDate IS NULL";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            rs = stmt.executeQuery();

            while (rs.next()) {
                Books book = new Books();
                book.setBookID(rs.getInt("BookID"));
                book.setTitle(rs.getString("Title"));
                book.setImage(rs.getString("Image"));
                borrowedBooks.add(book);
            }
        } catch (SQLException e) {
            throw new SQLException("Error retrieving borrowed books: " + e.getMessage());
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
        }
        return borrowedBooks;
    }

    public void borrowBook(int userId, int bookId) throws SQLException {
        PreparedStatement stmt = null;
        try {
            String sql = "INSERT INTO [dbo].[Transactions] (UserID, BookID, BorrowDate, DueDate) " +
                         "VALUES (?, ?, GETDATE(), DATEADD(day, (SELECT DefaultLoanDays FROM LoanSettings WHERE SettingID = 1), GETDATE()))";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            stmt.setInt(2, bookId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            throw new SQLException("Error borrowing book: " + e.getMessage());
        } finally {
            if (stmt != null) stmt.close();
        }
    }

    public void returnBook(int userId, int bookId) throws SQLException {
        PreparedStatement stmt = null;
        try {
            String sql = "UPDATE [dbo].[Transactions] SET ReturnDate = GETDATE() WHERE UserID = ? AND BookID = ? AND ReturnDate IS NULL";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            stmt.setInt(2, bookId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            throw new SQLException("Error returning book: " + e.getMessage());
        } finally {
            if (stmt != null) stmt.close();
        }
    }

    public boolean isBookBorrowed(int userId, int bookId) throws SQLException {
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            String sql = "SELECT COUNT(*) FROM [dbo].[Transactions] WHERE UserID = ? AND BookID = ? AND ReturnDate IS NULL";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            stmt.setInt(2, bookId);
            rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            return false;
        } catch (SQLException e) {
            throw new SQLException("Error checking borrowed book: " + e.getMessage());
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
        }
    }
    
    public boolean deleteBook(int bookID) throws SQLException {
        if (conn == null) {
            throw new SQLException("Database connection is null");
        }
        String sql = "DELETE FROM Books WHERE BookID = ?";
        try ( PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookID);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            throw new SQLException("deleteBook error: " + e.getMessage());
        }
    }
    
    public int getExtendFee() throws SQLException {
        if (conn == null) {
            throw new SQLException("Database connection is null");
        }
        String sql = "SELECT ExtendFee FROM LoanSettings";
        try ( PreparedStatement ps = conn.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("ExtendFee");
            }
            return 5000; // Giá trị mặc định
        } catch (SQLException e) {
            throw new SQLException("getExtendFee error: " + e.getMessage());
        }
    }
    
    public int updateBook(Books book) throws SQLException {
        PreparedStatement stmt = null;
        try {
            String sql = "UPDATE Books SET Title = ?, Author = ?, Publisher = ?, Image = ? WHERE BookID = ?";
            stmt = conn.prepareStatement(sql);
            
            stmt.setString(1, book.getTitle());
            stmt.setString(2, book.getAuthor());
            stmt.setString(3, book.getPublisher());
            stmt.setString(4, book.getImage());
            stmt.setInt(5, book.getBookID());

            return stmt.executeUpdate();
        } catch (SQLException e) {
            throw new SQLException("Error updating book: " + e.getMessage());
        } finally {
            if (stmt != null) stmt.close();
        }
    }
  }
    