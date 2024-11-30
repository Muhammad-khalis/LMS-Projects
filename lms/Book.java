/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package lms;

import java.time.LocalDate;

/**
 *
 * @author hammadi
 */
public class Book {
    private String title;
    private LocalDate issueDate; 
    private LocalDate returnDate; 

    public Book(String title, LocalDate issueDate, LocalDate returnDate) {
        this.title = title;
        this.issueDate = issueDate;
        this.returnDate = returnDate;
    }

    public String getTitle() {
        return title;
    }

    public LocalDate getIssueDate() {
        return issueDate;
    }

    public LocalDate getReturnDate() {
        return returnDate;
    }
}
