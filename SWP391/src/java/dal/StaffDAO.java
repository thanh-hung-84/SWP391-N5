package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.StaffModel;

/**
 * "Staff" here means an Employee (a Candidate who was hired) with an active
 * HR/Manager role. Email, phone, and display name live on Candidate; role and
 * employment status live on Employee. Columns are aliased back to the old
 * Staff-style names (StaffID, FullName) so the rest of the app is unaffected.
 */
public class StaffDAO extends DBContext {

    private static final String BASE_SELECT =
            "SELECT e.EmployeeID AS StaffID, e.RoleID, r.RoleName, "
            + "c.CandidateName AS FullName, c.Email, c.PhoneNumber "
            + "FROM Employee e "
            + "JOIN Candidate c ON e.CandidateID = c.CandidateID "
            + "JOIN Roles r ON e.RoleID = r.RoleID ";

    /** All active employees (HR Staff + Manager) who can be picked as interview participants. */
    public List<StaffModel> getActiveStaff() {
        List<StaffModel> list = new ArrayList<>();
        if (c == null) return list;

        String sql = BASE_SELECT + "WHERE e.IsActive = 1 ORDER BY c.CandidateName";

        try (PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (Exception e) {
            System.err.println("StaffDAO.getActiveStaff error: " + e.getMessage());
        }
        return list;
    }

    public StaffModel getStaffById(int staffId) {
        if (c == null) return null;
        String sql = BASE_SELECT + "WHERE e.EmployeeID = ?";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, staffId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (Exception e) {
            System.err.println("StaffDAO.getStaffById error: " + e.getMessage());
        }
        return null;
    }

    private StaffModel mapRow(ResultSet rs) throws Exception {
        StaffModel s = new StaffModel();
        s.setStaffId(rs.getInt("StaffID"));
        s.setRoleId(rs.getInt("RoleID"));
        s.setRoleName(rs.getString("RoleName"));
        s.setFullName(rs.getString("FullName"));
        s.setEmail(rs.getString("Email"));
        s.setPhoneNumber(rs.getString("PhoneNumber"));
        return s;
    }
}
