/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Project;

import com.sun.jdi.connect.spi.Connection;

/**
 *
 * @author Khalis
 */
public class ConnectionProvider {
    public static Connection getCon(){
        try
        {
        Class.forName("com.mysql.jdbc.Driver");
        Connection con=DriverManager.getConnected("jdbc:mysql://localhost:3306/LMSJUIPROJECT","root","123456");
        return con;
        }
        catch(Exception e)
        {
            System.out.println(e); 
            return null;
        }
    }
    }
