package dal;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBContext {

    protected Connection c;

    public DBContext() {
        try {
            String url = "jdbc:sqlserver://localhost:1433;databaseName=HRM_LoTrinhNS;encrypt=true;trustServerCertificate=true";
            String username = "sa";
            String pass = "123";
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            c = DriverManager.getConnection(url, username, pass);
        } catch (Exception e) {
            System.err.println("Database connection failed: " + e.getMessage());
        }
    }

    public void closeConnection() {
        try {
            if (c != null && !c.isClosed()) {
                c.close();
            }
        } catch (Exception e) {
            System.err.println("Close connection failed: " + e.getMessage());
        }
    }

    public static void main(String[] args) {
        DBContext db = new DBContext();
        try {
            if (db.c != null && !db.c.isClosed()) {
                System.out.println("==========================================");
                System.out.println(">>> KET NOI SQL SERVER THANH CONG! <<<");
                System.out.println("Database: HRM_LoTrinhNS da san sang.");
                System.out.println("==========================================");
            } else {
                System.out.println(">>> KET NOI THAT BAI: Bien connection c bi null! <<<");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}