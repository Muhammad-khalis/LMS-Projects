package lms;

import java.util.ArrayList;
import java.util.Scanner;
import java.time.LocalDate;

public class Student extends User {
    private static Scanner scanner = new Scanner(System.in);
    private ArrayList<Book> record = new ArrayList<>();

    public Student(String username, String password) {
        super(username, password);
    }

    @Override
    public String getRole() {
        return "student";
    }

    @Override
    public void menu() {
        boolean studentRunning = true;
        while (studentRunning) {
            System.out.println("\nStudent menu:");
            System.out.println("1. View Available Books");
            System.out.println("2. Issue Book");
            System.out.println("3. View Issued Books");
            System.out.println("4. Logout");
            System.out.print("Choose an option: ");
            int choice = scanner.nextInt();
            scanner.nextLine();

            switch (choice) {
                case 1:
                    viewAvailableBooks();
                    break;
                case 2:
                    issueBook();
                    break;
                case 3:
                    viewIssuedBooks();
                    break;
                case 4:
                    studentRunning = false;
                    System.out.println("Logged out.");
                    break;
                default:
                    System.out.println("Invalid choice. Please try again.");
            }
        }
    }

    private void viewAvailableBooks() {
        System.out.println("Books List:");
        int index = 1;
        for (Book book : Librarian.getBooks()) {
            System.out.println(index + ". " + book.getTitle() +
                " | Issue Date: " + book.getIssueDate() +
                " | Return Date: " + book.getReturnDate());
            index++;
        }
    }

    private void issueBook() {
        System.out.print("Enter the title of the book to issue: ");
        String title = scanner.nextLine();
        
        for (Book book : Librarian.getBooks()) {
            if (book.getTitle().equalsIgnoreCase(title)) {
                LocalDate issueDate = LocalDate.now();
                LocalDate returnDate = issueDate.plusDays(7);
                record.add(new Book(title, issueDate, returnDate));
                System.out.println("Book issued: " + title + 
                    " | Issue Date: " + issueDate + 
                    " | Return Date: " + returnDate);
                return;
            }
        }
        System.out.println("Book not found.");
    }

    private void viewIssuedBooks() {
        System.out.println("Issued books:");
        for (Book book : record) {
            System.out.println(book.getTitle() +
                " | Issue Date: " + book.getIssueDate() +
                " | Return Date: " + book.getReturnDate());
        }
    }
}
