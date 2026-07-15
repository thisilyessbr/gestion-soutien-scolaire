package com.dao;
import com.util.Dbinteraction;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class SessionDAO {

    public void uploadDevoir(int professorId, int seanceId, InputStream fileInputStream, String fileName) throws SQLException {
        PreparedStatement preparedStatement = null;

        try {
            Dbinteraction.connect();
            String sql = "INSERT INTO Sessions (prof_id, seance_schedule_id, pdf_data, pdf_file_name) VALUES (?, (SELECT  id_schedule FROM SeanceSchedule WHERE id_seance = ?), ?, ?)";

            preparedStatement = Dbinteraction.prepareStatement(sql);

            preparedStatement.setInt(1, professorId);
            preparedStatement.setInt(2, seanceId);
            preparedStatement.setBlob(3, fileInputStream);
            preparedStatement.setString(4, fileName);

            preparedStatement.executeUpdate();
        } finally {

            if (preparedStatement != null) {
                preparedStatement.close();
            }

        }
    }

}
