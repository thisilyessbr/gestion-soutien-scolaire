-- ========================================================
-- Schema for Gestion du Soutien Scolaire
-- Educational support management application (Jakarta EE)
-- ========================================================

CREATE DATABASE IF NOT EXISTS gestion_du_soutien
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE gestion_du_soutien;

-- Users table (admins, professors, students)
CREATE TABLE IF NOT EXISTS users (
    users_id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    login VARCHAR(100) UNIQUE,
    password VARCHAR(255),
    role ENUM('admin', 'professeur', 'etudiant') NOT NULL,
    mat INT,
    adresse VARCHAR(255),
    email VARCHAR(255),
    matiere VARCHAR(100),
    tel VARCHAR(20),
    annee_scolaire VARCHAR(20),
    password_changed BOOLEAN DEFAULT FALSE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tracks whether a professor/student has changed the default password
CREATE TABLE IF NOT EXISTS PasswordChangeStatus (
    user_id INT PRIMARY KEY,
    password_changed BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (user_id) REFERENCES users(users_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Rooms / classrooms
CREATE TABLE IF NOT EXISTS salle (
    Num_salle INT PRIMARY KEY,
    capacite INT,
    localisation VARCHAR(255),
    Nom_salle VARCHAR(100),
    Disponibilite VARCHAR(50) DEFAULT 'Disponible'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Extended room table used by scheduling
CREATE TABLE IF NOT EXISTS Sallecp (
    id_salle INT AUTO_INCREMENT PRIMARY KEY,
    capacite INT,
    localisation VARCHAR(255),
    Nom_salle VARCHAR(100),
    Num_salle INT UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS SalleAvailability (
    id INT AUTO_INCREMENT PRIMARY KEY,
    salle_id INT,
    start_time TIME DEFAULT '00:00:00',
    end_time TIME DEFAULT '23:59:59',
    status VARCHAR(50) DEFAULT 'disponible',
    FOREIGN KEY (salle_id) REFERENCES Sallecp(id_salle) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Courses
CREATE TABLE IF NOT EXISTS cours (
    id_cour INT AUTO_INCREMENT PRIMARY KEY,
    nom_cour VARCHAR(100) NOT NULL,
    matiere VARCHAR(100),
    enseignant_id INT,
    FOREIGN KEY (enseignant_id) REFERENCES users(users_id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Sessions (linking a course and a room)
CREATE TABLE IF NOT EXISTS Seance (
    id_seance INT AUTO_INCREMENT PRIMARY KEY,
    id_cour INT,
    salle_id INT,
    FOREIGN KEY (id_cour) REFERENCES cours(id_cour) ON DELETE CASCADE,
    FOREIGN KEY (salle_id) REFERENCES Sallecp(id_salle) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Session schedule details
CREATE TABLE IF NOT EXISTS SeanceSchedule (
    id_schedule INT AUTO_INCREMENT PRIMARY KEY,
    id_seance INT,
    date_seance DATE,
    heure_debut TIME,
    heure_fin TIME,
    FOREIGN KEY (id_seance) REFERENCES Seance(id_seance) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Students enrolled in sessions
CREATE TABLE IF NOT EXISTS StudentSeance (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    seance_schedule_id INT,
    FOREIGN KEY (student_id) REFERENCES users(users_id) ON DELETE CASCADE,
    FOREIGN KEY (seance_schedule_id) REFERENCES SeanceSchedule(id_schedule) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Attendance tracking
CREATE TABLE IF NOT EXISTS Presence (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_user INT,
    seance_id INT,
    status VARCHAR(50),
    FOREIGN KEY (id_user) REFERENCES users(users_id) ON DELETE CASCADE,
    FOREIGN KEY (seance_id) REFERENCES Seance(id_seance) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tuition / payment tracking
CREATE TABLE IF NOT EXISTS scolarite1 (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    payment_amount DECIMAL(10, 2),
    payment_method VARCHAR(100),
    payment_date DATE,
    Montant_paye DECIMAL(10, 2),
    Montant_reste DECIMAL(10, 2),
    Etat VARCHAR(50),
    FOREIGN KEY (user_id) REFERENCES users(users_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Announcements
CREATE TABLE IF NOT EXISTS announcements (
    announcement_id INT AUTO_INCREMENT PRIMARY KEY,
    professor_id INT,
    seance_id INT,
    announcement_title VARCHAR(255),
    announcement_text TEXT,
    announcement_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (professor_id) REFERENCES users(users_id) ON DELETE CASCADE,
    FOREIGN KEY (seance_id) REFERENCES Seance(id_seance) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
