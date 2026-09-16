package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.JobPostModel;

public class JobPostDAO extends DBContext {

    /** Job posts currently open (Visible = 1), used to scope quick-created Barems. */
    public List<JobPostModel> getOpenJobPosts() {
        List<JobPostModel> list = new ArrayList<>();
        if (c == null) return list;

        String sql = "SELECT JobPostID, Title, Category, Position, Location, Deadline, Visible "
                + "FROM JobPost WHERE Visible = 1 ORDER BY DayCreate DESC";

        try (PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (Exception e) {
            System.err.println("JobPostDAO.getOpenJobPosts error: " + e.getMessage());
        }
        return list;
    }

    public JobPostModel getJobPostById(int jobPostId) {
        if (c == null) return null;
        String sql = "SELECT JobPostID, Title, Category, Position, Location, Deadline, Visible "
                + "FROM JobPost WHERE JobPostID = ?";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, jobPostId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (Exception e) {
            System.err.println("JobPostDAO.getJobPostById error: " + e.getMessage());
        }
        return null;
    }

    private JobPostModel mapRow(ResultSet rs) throws Exception {
        JobPostModel j = new JobPostModel();
        j.setJobPostId(rs.getInt("JobPostID"));
        j.setTitle(rs.getString("Title"));
        j.setCategory(rs.getString("Category"));
        j.setPosition(rs.getString("Position"));
        j.setLocation(rs.getString("Location"));
        j.setDeadline(rs.getDate("Deadline"));
        j.setVisible(rs.getBoolean("Visible"));
        return j;
    }
}
