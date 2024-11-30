package lms;

import java.util.ArrayList;
import java.util.Scanner;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;

public class Librarian extends User {
    private static Scanner scanner = new Scanner(System.in);
    private static ArrayList<Book> books = new ArrayList<>();

    public Librarian(String username, String password) {
        super(username, password);
    }

    @Override
    public String getRole() {
        return "Librarian";
    }

    @Override
    public void menu() {
        boolean adminRunning = true;
        while (adminRunning) {
            System.out.println("\nAdmin Menu:");
            System.out.println("1. Add Book");
            System.out.println("2. Logout");
            System.out.print("Choose an option: ");
            int choice = scanner.nextInt();
            scanner.nextLine();
            switch (choice) {
                case 1:
                    addBook();
                    break;
                case 2:
                    adminRunning = false;
                    System.out.println("Logged out.");
                    break;
                default:
                    System.out.println("Invalid choice. Please try again.");
            }
        }
    }

   private void addBook() {
    System.out.print("Enter book title: ");
    String bookName = scanner.nextLine();
    
    LocalDate issueDate = null;
    LocalDate returnDate = null;

    
    while (issueDate == null) {
        System.out.print("Enter issue date (yyyy-MM-dd): ");
        String issueDateString = scanner.nextLine();
        try {
            issueDate = LocalDate.parse(issueDateString);
        } catch (DateTimeParseException e) {
            System.out.println("Invalid date format. Please use yyyy-MM-dd.");
        }
    }

    
    while (returnDate == null) {
        System.out.print("Enter return date (yyyy-MM-dd): ");
        String returnDateString = scanner.nextLine();
        try {
            returnDate = LocalDate.parse(returnDateString);
        } catch (DateTimeParseException e) {
            System.out.println("Invalid date format. Please use yyyy-MM-dd.");
        }
    }
    
    books.add(new Book(bookName, issueDate, returnDate));
    System.out.println("Book added successfully.");
}


    public static ArrayList<Book> getBooks() {
        return books;
    }
}
