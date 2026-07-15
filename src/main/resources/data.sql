-- ========================================================
-- Sample data for Gestion du Soutien Scolaire
-- ========================================================

USE gestion_du_soutien;

-- Admin user (login: admin / password: admin)
INSERT INTO users (nom, prenom, login, password, role, mat, adresse, email, matiere, tel, annee_scolaire, password_changed)
VALUES ('Admin', 'System', 'admin', 'admin', 'admin', 1, 'Casablanca', 'admin@smartschool.ma', ' Administration', '0611223344', '2024-2025', TRUE);

-- Sample professors (password = firstname in lowercase)
INSERT INTO users (nom, prenom, login, password, role, mat, adresse, email, matiere, tel, annee_scolaire, password_changed)
VALUES
    ('Alami', 'Said', 'said.alami', 'said', 'professeur', 101, 'Casablanca', 's.alami@smartschool.ma', 'Mathematiques', '0622334455', '2024-2025', TRUE),
    ('Benkirane', 'Fatima', 'fatima.benkirane', 'fatima', 'professeur', 102, 'Rabat', 'f.benkirane@smartschool.ma', 'Physique', '0633445566', '2024-2025', TRUE),
    ('El Fassi', 'Karim', 'karim.elfassi', 'karim', 'professeur', 103, 'Marrakech', 'k.elfassi@smartschool.ma', 'Informatique', '0644556677', '2024-2025', TRUE);

-- Sample students (password = firstname in lowercase)
INSERT INTO users (nom, prenom, login, password, role, mat, adresse, email, matiere, tel, annee_scolaire, password_changed)
VALUES
    ('Saber', 'Ilyes', 'ilyes.saber', 'ilyes', 'etudiant', 201, 'Casablanca', 'ilyes@student.ma', 'Informatique', '0655667788', '2024-2025', TRUE),
    ('Moussaoui', 'Amina', 'amina.moussaoui', 'amina', 'etudiant', 202, 'Rabat', 'amina@student.ma', 'Mathematiques', '0666778899', '2024-2025', TRUE),
    ('Bennani', 'Omar', 'omar.bennani', 'omar', 'etudiant', 203, 'Fes', 'omar@student.ma', 'Physique', '0677889900', '2024-2025', TRUE),
    ('Tahiri', 'Laila', 'laila.tahiri', 'laila', 'etudiant', 204, 'Agadir', 'laila@student.ma', 'Informatique', '0688990011', '2024-2025', TRUE);

-- Password change status for all users
INSERT INTO PasswordChangeStatus (user_id, password_changed)
SELECT users_id, TRUE FROM users;

-- Sample rooms
INSERT INTO salle (Num_salle, capacite, localisation, Nom_salle, Disponibilite)
VALUES
    (1, 30, 'Batiment A - RDC', 'Salle A1', 'Disponible'),
    (2, 25, 'Batiment A - 1er etage', 'Salle A2', 'Disponible'),
    (3, 40, 'Batiment B - RDC', 'Salle B1', 'Occupee'),
    (4, 20, 'Batiment B - 1er etage', 'Salle B2', 'Disponible');

-- Extended rooms for scheduling
INSERT INTO Sallecp (capacite, localisation, Nom_salle, Num_salle)
VALUES
    (30, 'Batiment A - RDC', 'Salle A1', 1),
    (25, 'Batiment A - 1er etage', 'Salle A2', 2),
    (40, 'Batiment B - RDC', 'Salle B1', 3),
    (20, 'Batiment B - 1er etage', 'Salle B2', 4);

INSERT INTO SalleAvailability (salle_id, start_time, end_time, status)
VALUES
    (1, '08:00:00', '18:00:00', 'disponible'),
    (2, '08:00:00', '18:00:00', 'disponible'),
    (3, '08:00:00', '18:00:00', 'occupee'),
    (4, '08:00:00', '18:00:00', 'disponible');

-- Sample courses
INSERT INTO cours (nom_cour, matiere, enseignant_id)
VALUES
    ('Analyse Mathematique', 'Mathematiques', 2),
    ('Mecanique Classique', 'Physique', 3),
    ('Programmation Java', 'Informatique', 4),
    ('Base de Donnees', 'Informatique', 4);

-- Sample sessions
INSERT INTO Seance (id_cour, salle_id)
VALUES
    (1, 1),
    (2, 2),
    (3, 4),
    (4, 1);

-- Sample session schedules
INSERT INTO SeanceSchedule (id_seance, date_seance, heure_debut, heure_fin)
VALUES
    (1, '2025-01-15', '09:00:00', '11:00:00'),
    (2, '2025-01-16', '10:00:00', '12:00:00'),
    (3, '2025-01-17', '14:00:00', '16:00:00'),
    (4, '2025-01-18', '08:00:00', '10:00:00');

-- Enroll students in sessions
INSERT INTO StudentSeance (student_id, seance_schedule_id)
VALUES
    (5, 1),
    (5, 3),
    (6, 1),
    (6, 2),
    (7, 2),
    (7, 4),
    (8, 3),
    (8, 4);

-- Sample attendance
INSERT INTO Presence (id_user, seance_id, status)
VALUES
    (5, 1, 'Present'),
    (6, 1, 'Present'),
    (5, 3, 'Absent'),
    (8, 3, 'Present');

-- Sample tuition payments
INSERT INTO scolarite1 (user_id, payment_amount, payment_method, payment_date, Montant_paye, Montant_reste, Etat)
VALUES
    (5, 5000.00, 'Virement', '2025-01-10', 5000.00, 0.00, 'Paye'),
    (6, 5000.00, 'Carte Bancaire', '2025-01-12', 2500.00, 2500.00, 'Partiel'),
    (7, 5000.00, 'Espece', '2025-01-08', 0.00, 5000.00, 'Non Paye'),
    (8, 5000.00, 'Virement', '2025-01-14', 5000.00, 0.00, 'Paye');

-- Sample announcements
INSERT INTO announcements (professor_id, seance_id, announcement_title, announcement_text)
VALUES
    (2, 1, 'Changement d horaire', 'La seance d analyse du 15 janvier est avancee de 30 minutes.'),
    (4, 3, 'Projet Java', 'N oubliez pas de soumettre votre projet Java avant le 20 janvier.');
