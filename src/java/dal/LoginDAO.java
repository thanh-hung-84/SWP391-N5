package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import tool.EncodePassword;

public class LoginDAO extends DBContext {

    public static class UserSession {
        public final int candidateId;
        public final Integer staffId;
        public final Integer roleId;
        public final String roleName;
        public final String fullName;
        public final String email;

        public UserSession(int candidateId, Integer staffId, Integer roleId,
                String roleName, String fullName, String email) {
            this.candidateId = candidateId;
            this.staffId = staffId;
            this.roleId = roleId;
            this.roleName = roleName;
            this.fullName = fullName;
            this.email = email;
        }
    }

    public UserSession loginUser(String email, String password) {
        if (c == null) return null;

        String sql = "SELECT candidate.CandidateID, candidate.CandidateName, candidate.Email, "
                + "candidate.PasswordHash, employee.EmployeeID, employee.RoleID, "
                + "employee.IsActive AS EmployeeIsActive, role.RoleName "
                + "FROM Candidate candidate "
                + "LEFT JOIN Employee employee ON candidate.CandidateID = employee.CandidateID "
                + "LEFT JOIN Roles role ON employee.RoleID = role.RoleID "
                + "WHERE candidate.Email = ? AND candidate.IsActive = 1";

        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return null;

                String storedHash = rs.getString("PasswordHash");
                String inputHash = EncodePassword.encodePasswordbyHash(password);
                if (inputHash == null || !inputHash.equals(storedHash)) return null;

                int employeeId = rs.getInt("EmployeeID");
                Integer staffId = rs.wasNull() ? null : employeeId;
                if (staffId != null && !rs.getBoolean("EmployeeIsActive")) return null;

                int employeeRoleId = rs.getInt("RoleID");
                Integer roleId = rs.wasNull() ? null : employeeRoleId;
                String roleName = staffId == null ? "Candidate" : rs.getString("RoleName");
                return new UserSession(
                        rs.getInt("CandidateID"), staffId, roleId, roleName,
                        rs.getString("CandidateName"), rs.getString("Email")
                );
            }
        } catch (Exception e) {
            System.err.println("Login error: " + e.getMessage());
        }
        return null;
    }
}
