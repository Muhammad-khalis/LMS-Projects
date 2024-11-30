/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package lms;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Scanner;

/**
 *
 * @author hammadi
 */
public class LMS {
    private static Scanner scanner = new Scanner(System.in);
    private static ArrayList<User> users = new ArrayList<>();
    private static final String USER_FILE = "users.txt";

    public static void main(String[] args) throws IOException {
        loadUsers(); // Load users from file at the start
        while (true) {
            System.out.println("Welcome to Library Management System ");
            System.out.println("1. Register Librarian ");
            System.out.println("2. Register Student ");
            System.out.println("3. Login ");
            System.out.println("4. Exit ");
            int choice = scanner.nextInt();
            scanner.nextLine();

            switch (choice) {
                case 1:
                    registerLibrarian();
                    break;
                case 2:
                    registerStudent();
                    break;
                case 3:
                    login();
                    break;
                case 4:
                    System.out.println("Thanks for Visiting");
                    saveUsers(); // Save users before exiting
                    return; // Exit the program
                default:
                    System.out.println("Invalid choice. Please try again.");
            }
        }
    }

    private static void registerLibrarian() {
        System.out.print("Enter Your username: ");
        String username = scanner.nextLine();
        System.out.print("Enter Your password: ");
        String password = scanner.nextLine();
        users.add(new Librarian(username, password));
        System.out.println("Registered Successfully");
    }

    private static void registerStudent() {
        System.out.print("Enter Your username: ");
        String username = scanner.nextLine();
        System.out.print("Enter Your password: ");
        String password = scanner.nextLine();
        users.add(new Student(username, password));
        System.out.println("Registered Successfully");
    }

    private static void login() {
        System.out.print("Enter username: ");
        String username = scanner.nextLine();
        System.out.print("Enter password: ");
        String password = scanner.nextLine();

        User loggedInUser = findUser(username, password);

        if (loggedInUser != null) {
            System.out.println(loggedInUser.getUsername() + " logged in successfully as " + loggedInUser.getRole() + ".");
            loggedInUser.menu();
        } else {
            System.out.println("Login failed. Invalid credentials.");
        }
    }

    private static User findUser(String username, String password) {
        for (User user : users) {
            if (user.login(username, password)) {
                return user;
            }
        }
        return null; 
    }

    private static void saveUsers() {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(USER_FILE))) {
            for (User user : users) {
                writer.write(user.getUsername() + "," + user.getPassword() + "," + user.getRole());
                writer.newLine();
            }
            System.out.println("Users saved successfully.");
        } catch (IOException e) {
            System.out.println("Error saving users: " + e.getMessage());
        }
    }

    private static void loadUsers() throws IOException {
        try (BufferedReader reader = new BufferedReader(new FileReader(USER_FILE))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] parts = line.split(",");
                String username = parts[0];
                String password = parts[1];
                String role = parts[2];
                if (role.equals("Librarian")) {
                    users.add(new Librarian(username, password));
                } else if (role.equals("Student")) {
                    users.add(new Student(username, password));
                }
            }
            System.out.println("Users loaded successfully.");
        } catch (FileNotFoundException e) {
            System.out.println("User file not found. Starting fresh.");
        }
    }
}