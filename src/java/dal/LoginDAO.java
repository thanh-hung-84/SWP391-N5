package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import tool.EncodePassword;

public class LoginDAO extends DBContext {

    // Helper class to return both user info and role
    public static class UserSession {
        public int roleId;
        public String username;

        public UserSession(int roleId, String username) {
            this.roleId = roleId;
            this.username = username;
        }
    }

    public UserSession loginUser(String email, String password) {
        if (c == null) return null;

        String sql = "SELECT username, password_hash, role_id FROM Users WHERE email = ?";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return null;

                String storedHash = rs.getString("password_hash");
                String username = rs.getString("username");
                int roleId = rs.getInt("role_id");
                
                String inputHash = EncodePassword.encodePasswordbyHash(password);

                if (inputHash != null && inputHash.equals(storedHash)) {
                    return new UserSession(roleId, username);
                }
            }
        } catch (Exception e) {
            System.err.println("Login error: " + e.getMessage());
        }
        return null;
    }
    public static void main(String[] args) {
    LoginDAO dao = new LoginDAO();
    UserSession session = dao.loginUser("candidate@app.com", "123456");
    dao.closeConnection();

    if (session != null) {
        System.out.println("SUCCESS!");
        System.out.println("Username: " + session.username);
        System.out.println("Role ID: " + session.roleId);
    } else {
        System.err.println("FAILED: Authentication failed.");
    }
}
}