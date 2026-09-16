package model;

import java.sql.Date;

public class JobPostModel {
    private int jobPostId;
    private String title;
    private String category;
    private String position;
    private String location;
    private Date deadline;
    private boolean visible;

    public int getJobPostId() { return jobPostId; }
    public void setJobPostId(int jobPostId) { this.jobPostId = jobPostId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getPosition() { return position; }
    public void setPosition(String position) { this.position = position; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }

    public Date getDeadline() { return deadline; }
    public void setDeadline(Date deadline) { this.deadline = deadline; }

    public boolean isVisible() { return visible; }
    public void setVisible(boolean visible) { this.visible = visible; }
}
