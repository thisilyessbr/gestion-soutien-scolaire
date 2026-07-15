package com.model;

import java.sql.Timestamp;

public class Announcement {
    private int announcementId;
    private int professorId;
    private int seanceId;
    private String announcementText;
    private String announcementTitle;
    private Timestamp announcementDate;

    // Constructors
    public Announcement() {
        // Default constructor
    }

    public Announcement(int announcementId, int professorId, int seanceId, String announcementText, Timestamp announcementDate) {
        this.announcementId = announcementId;
        this.professorId = professorId;
        this.seanceId = seanceId;
        this.announcementText = announcementText;
        this.announcementDate = announcementDate;
    }

    public String getAnnouncementTitle() {
        return announcementTitle;
    }

    public void setAnnouncementTitle(String announcementTitle) {
        this.announcementTitle = announcementTitle;
    }

    // Getters
    public int getAnnouncementId() {
        return announcementId;
    }

    public int getProfessorId() {
        return professorId;
    }

    public int getSeanceId() {
        return seanceId;
    }

    public String getAnnouncementText() {
        return announcementText;
    }

    public Timestamp getAnnouncementDate() {
        return announcementDate;
    }

    // Setters
    public void setAnnouncementId(int announcementId) {
        this.announcementId = announcementId;
    }

    public void setProfessorId(int professorId) {
        this.professorId = professorId;
    }

    public void setSeanceId(int seanceId) {
        this.seanceId = seanceId;
    }

    public void setAnnouncementText(String announcementText) {
        this.announcementText = announcementText;
    }

    public void setAnnouncementDate(Timestamp announcementDate) {
        this.announcementDate = announcementDate;
    }
}
