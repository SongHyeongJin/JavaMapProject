package mvc.database;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    public static Connection getConnection() throws SQLException, ClassNotFoundException {

        Connection conn = null;

        String url = "jdbc:mysql://localhost:3306/mapprojectdb";
        String user = "mapproject";
        String password = "pwd1234";

        Class.forName("com.mysql.jdbc.Driver");
        conn = DriverManager.getConnection(url, user, password);

        return conn;
    }
}
