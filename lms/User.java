/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package lms;

/**
 *
 * @author hammadi
 */
abstract class User {
    String username;
    String password;
    
    public User (String username,String password) {
    this.username=username;
    this.password=password;
}
    
public boolean login(String username, String password) {
    return this.username.equals(username) && this.password.equals(password);
}

     public String getUsername() {
        return username;
    }
     
    public abstract String getRole();    
    public abstract void menu();

    String getPassword() {
     
      
        return null;
     
      
    }

   
    
}