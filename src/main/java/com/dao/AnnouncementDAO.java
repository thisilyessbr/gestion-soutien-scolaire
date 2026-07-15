package com.dao;

import com.model.Announcement;
import com.util.Dbinteraction;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AnnouncementDAO {


    public void addAnnouncement(Announcement announcement) throws SQLException {
        Dbinteraction.connect();

        String sql = "INSERT INTO announcements (professor_id, seance_id, announcement_text, announcement_title) VALUES (?, ?, ?, ?)";

        try (PreparedStatement statement = Dbinteraction.prepareStatement(sql)) {
            statement.setInt(1, announcement.getProfessorId());
            statement.setInt(2, announcement.getSeanceId());
            statement.setString(3, announcement.getAnnouncementText());
            statement.setString(4, announcement.getAnnouncementTitle());

            statement.executeUpdate();
        } finally {
            Dbinteraction.disconnect();
        }
    }

    }

    // Add other methods for retrieving, updating, or deleting announcements as needed


