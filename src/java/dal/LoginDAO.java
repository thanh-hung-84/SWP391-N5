package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import tool.EncodePassword;

public class LoginDAO extends DBContext {

    public boolean loginCandidate(String email, String password) {
        if (c == null) return false;
        String sql = "SELECT PasswordHash FROM Candidate WHERE Email = ?";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return false;
                String storedHash = rs.getString("PasswordHash");
                String inputHash = EncodePassword.encodePasswordbyHash(password);
                return inputHash != null && inputHash.equals(storedHash);
            }
        } catch (Exception e) {
            System.err.println("Login error: " + e.getMessage());
            return false;
        }
    }
}
