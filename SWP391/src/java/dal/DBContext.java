
package dal;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBContext {
    private static final String DEFAULT_URL =
            "jdbc:sqlserver://localhost:1433;databaseName=SWP391;encrypt=true;trustServerCertificate=true";

    protected Connection c;

    public DBContext() {
        try {
            String url = setting("swp391.db.url", "SWP391_DB_URL", DEFAULT_URL);
            String username = setting("swp391.db.user", "SWP391_DB_USER", "sa");
            String password = setting("swp391.db.password", "SWP391_DB_PASSWORD", null);
            if (password == null || password.trim().isEmpty()) {
                throw new IllegalStateException(
                        "Missing database password. Set SWP391_DB_PASSWORD or -Dswp391.db.password.");
            }

            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            c = DriverManager.getConnection(url, username, password);
        } catch (Exception e) {
            System.err.println("Database connection failed: " + e.getMessage());
        }
    }

    private String setting(String propertyName, String environmentName, String defaultValue) {
        String value = System.getProperty(propertyName);
        if (value == null || value.trim().isEmpty()) {
            value = System.getenv(environmentName);
        }
        return value == null || value.trim().isEmpty() ? defaultValue : value;
    }

    public void closeConnection() {
        try {
            if (c != null && !c.isClosed()) c.close();
        } catch (Exception e) {
            System.err.println("Close connection failed: " + e.getMessage());
        }
    }
}
