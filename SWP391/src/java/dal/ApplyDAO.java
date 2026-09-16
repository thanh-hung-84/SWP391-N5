package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import model.ApplyModel;

public class ApplyDAO extends DBContext {

    private static final String BASE_SELECT =
            "SELECT a.ApplyID, a.JobPostID, jp.Title AS JobTitle, "
            + "a.CandidateID, c.CandidateName, c.Email AS CandidateEmail, c.PhoneNumber AS CandidatePhone, "
            + "a.CVID, cv.Position AS CvPosition, "
            + "a.Status, a.Note, a.FinalResult, a.ConclusionNote, a.ConclusionBy, cb.CandidateName AS ConclusionByName, "
            + "a.ConclusionDate, a.DayCreate, "
            + "(SELECT COUNT(*) FROM Interview i WHERE i.ApplyID = a.ApplyID) AS ScheduledInterviewCount "
            + "FROM Apply a "
            + "JOIN Candidate c ON a.CandidateID = c.CandidateID "
            + "JOIN JobPost jp ON a.JobPostID = jp.JobPostID "
            + "JOIN CV cv ON a.CVID = cv.CVID "
            + "LEFT JOIN Employee ceb ON a.ConclusionBy = ceb.EmployeeID "
            + "LEFT JOIN Candidate cb ON ceb.CandidateID = cb.CandidateID ";

    /** Applications that have not been concluded yet, newest first. Used for the scheduling worklist. */
    public List<ApplyModel> getActiveApplies() {
        List<ApplyModel> list = new ArrayList<>();
        if (c == null) return list;

        String sql = BASE_SELECT + "WHERE a.FinalResult IS NULL ORDER BY a.DayCreate DESC";

        try (PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (Exception e) {
            System.err.println("ApplyDAO.getActiveApplies error: " + e.getMessage());
        }
        return list;
    }

    public ApplyModel getApplyById(int applyId) {
        if (c == null) return null;
        String sql = BASE_SELECT + "WHERE a.ApplyID = ?";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, applyId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (Exception e) {
            System.err.println("ApplyDAO.getApplyById error: " + e.getMessage());
        }
        return null;
    }

    public boolean updateStatus(int applyId, String status) {
        if (c == null) return false;
        String sql = "UPDATE Apply SET Status = ? WHERE ApplyID = ?";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, applyId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("ApplyDAO.updateStatus error: " + e.getMessage());
            return false;
        }
    }

    /** Records the HR/Manager conclusion for a candidate's application after interviews are done. */
    public boolean concludeApply(int applyId, String finalResult, String conclusionNote, int concludedByStaffId, String newStatus) {
        if (c == null) return false;
        String sql = "UPDATE Apply SET FinalResult = ?, ConclusionNote = ?, ConclusionBy = ?, "
                + "ConclusionDate = ?, Status = ? WHERE ApplyID = ?";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, finalResult);
            ps.setString(2, conclusionNote);
            ps.setInt(3, concludedByStaffId);
            ps.setTimestamp(4, new Timestamp(System.currentTimeMillis()));
            ps.setString(5, newStatus);
            ps.setInt(6, applyId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("ApplyDAO.concludeApply error: " + e.getMessage());
            return false;
        }
    }

    private ApplyModel mapRow(ResultSet rs) throws Exception {
        ApplyModel a = new ApplyModel();
        a.setApplyId(rs.getInt("ApplyID"));
        a.setJobPostId(rs.getInt("JobPostID"));
        a.setJobTitle(rs.getString("JobTitle"));
        a.setCandidateId(rs.getInt("CandidateID"));
        a.setCandidateName(rs.getString("CandidateName"));
        a.setCandidateEmail(rs.getString("CandidateEmail"));
        a.setCandidatePhone(rs.getString("CandidatePhone"));
        a.setCvId(rs.getInt("CVID"));
        a.setCvPosition(rs.getString("CvPosition"));
        a.setStatus(rs.getString("Status"));
        a.setNote(rs.getString("Note"));
        a.setFinalResult(rs.getString("FinalResult"));
        a.setConclusionNote(rs.getString("ConclusionNote"));
        int conclusionBy = rs.getInt("ConclusionBy");
        a.setConclusionBy(rs.wasNull() ? null : conclusionBy);
        a.setConclusionByName(rs.getString("ConclusionByName"));
        a.setConclusionDate(rs.getTimestamp("ConclusionDate"));
        a.setDayCreate(rs.getTimestamp("DayCreate"));
        a.setScheduledInterviewCount(rs.getInt("ScheduledInterviewCount"));
        return a;
    }
}
