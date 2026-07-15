package com.util;

import java.sql.*;

public class Dbinteraction {

    // Database configuration is read from environment variables so the same WAR
    // can be deployed locally, via Docker, or on any cloud platform without code changes.
    private static final String DB_HOST = System.getenv().getOrDefault("DB_HOST", "localhost");
    private static final String DB_PORT = System.getenv().getOrDefault("DB_PORT", "3306");
    private static final String DB_NAME = System.getenv().getOrDefault("DB_NAME", "gestion_du_soutien");
    private static final String DB_USER = System.getenv().getOrDefault("DB_USER", "root");
    private static final String DB_PASS = System.getenv().getOrDefault("DB_PASS", "");
    private static final boolean DB_USE_SSL = Boolean.parseBoolean(System.getenv().getOrDefault("DB_USE_SSL", "false"));

    private static String buildUrl() {
        return "jdbc:mysql://" + DB_HOST + ":" + DB_PORT + "/" + DB_NAME
                + "?useSSL=" + DB_USE_SSL
                + "&allowPublicKeyRetrieval=true"
                + "&serverTimezone=UTC";
    }

    private static Connection conn ;
    private static Statement stat ;

    public static Connection connect(){
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(buildUrl(), DB_USER, DB_PASS);
            conn.setAutoCommit(true);
            stat=conn.createStatement();
            return conn;
        } catch (ClassNotFoundException | SQLException e ) {
            throw new RuntimeException("Failed to connect to the database. " +
                    "Please verify DB_HOST/DB_PORT/DB_NAME/DB_USER/DB_PASS environment variables.", e);
        }
    }
    public static void disconnect(){
        try {
            if (conn != null && !conn.isClosed()) {
                conn.close();
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
    public static Connection connect1() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(buildUrl(), DB_USER, DB_PASS);
            conn.setAutoCommit(true);
            return conn;
        } catch (ClassNotFoundException | SQLException e) {
            throw new RuntimeException("Failed to connect to the database. " +
                    "Please verify DB_HOST/DB_PORT/DB_NAME/DB_USER/DB_PASS environment variables.", e);
        }
    }


    public static int Maj(String sql){

        int nb ;

        try {
            nb =stat.executeUpdate(sql);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
 return nb ;
    }

    public static PreparedStatement prepareStatement(String sql) {
        try {
            return conn.prepareStatement(sql);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

    }


    public static int executeUpdate(PreparedStatement preparedStatement) {
        int nb;

        try {
            nb = preparedStatement.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return nb;
    }

    public static ResultSet select(String sql){
        ResultSet rs =null ;
        try {
            rs =stat.executeQuery(sql);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return rs ;
    }

    public static void setAutoCommit(boolean autoCommit) {
        try {
            conn.setAutoCommit(autoCommit);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }



    public static void commit() throws SQLException {
        if (conn != null) {
            conn.commit();
        }
    }

    public static void rollback() {
        try {
            if (conn != null) {
                conn.rollback();
            }
        } catch (SQLException e) {
            e.printStackTrace();  // Handle rollback failure (logging or other actions)
        }
    }
}