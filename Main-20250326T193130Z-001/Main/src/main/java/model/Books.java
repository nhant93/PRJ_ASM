/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author giaph
 */
public class Books {

    private int bookID;
    private String title;
    private String author;
    private String publisher;
    private String image;
    private int daysLeft;
    private String daysLeftDisplay;

    public int getDaysLeft() {
        return daysLeft;
    }

    public void setDaysLeft(int daysLeft) {
        this.daysLeft = daysLeft;
    }

    public String getDaysLeftDisplay() {
        return daysLeftDisplay;
    }

    public void setDaysLeftDisplay(String daysLeftDisplay) {
        this.daysLeftDisplay = daysLeftDisplay;
    }

    public Books() {
    }

    public Books(String title, String image) {
        this.title = title;
        this.image = image;
    }

    public Books(int bookID, String title, String author, String publisher, String image) {
        this.bookID = bookID;
        this.title = title;
        this.author = author;
        this.publisher = publisher;
        this.image = image;
    }
    
    public int getBookID() {
        return bookID;
    }

    public void setBookID(int bookID) {
        this.bookID = bookID;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public String getPublisher() {
        return publisher;
    }

    public void setPublisher(String publisher) {
        this.publisher = publisher;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }
    
    @Override
    public String toString() {
        return "Books{" + "bookID=" + bookID
                + ", title=" + title
                + ", author=" + author
                + ", publisher=" + publisher + '}';
    }
}