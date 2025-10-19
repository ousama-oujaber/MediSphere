-- ============================================
-- Fake Data for Login Testing - MediSphere
-- ============================================
-- This script creates test accounts with easy-to-remember credentials
-- for testing the login functionality for all user roles:
-- 
-- ADMIN:
--   Email: admin@test.com    | Password: admin123
--   Email: admin2@test.com   | Password: admin123
--
-- DOCTORS:
--   Email: doctor1@test.com  | Password: doctor123
--   Email: doctor2@test.com  | Password: doctor123
--   Email: doctor3@test.com  | Password: doctor123
--
-- PATIENTS:
--   Email: patient1@test.com | Password: patient123
--   Email: patient2@test.com | Password: patient123
--   Email: patient3@test.com | Password: patient123
-- ============================================

USE medisphere;

-- ============================================
-- Clear existing test data (optional)
-- ============================================
-- DELETE FROM consultation WHERE id_patient IN (SELECT id_patient FROM patient WHERE id_personne IN (SELECT id_personne FROM personne WHERE email LIKE '%@test.com'));
-- DELETE FROM patient WHERE id_personne IN (SELECT id_personne FROM personne WHERE email LIKE '%@test.com');
-- DELETE FROM docteur WHERE id_personne IN (SELECT id_personne FROM personne WHERE email LIKE '%@test.com');
-- DELETE FROM personne WHERE email LIKE '%@test.com';

-- ============================================
-- TEST ADMIN ACCOUNTS
-- ============================================
INSERT INTO personne (type_personne, nom, prenom, email, mot_de_passe, telephone, adresse, date_naissance, actif) VALUES
-- Main test admin
('ADMIN', 'TestAdmin', 'System', 'admin@test.com', 'admin123', '+212 6 00 00 00 01', '123 Admin Street, Test City', '1985-01-01', TRUE),
-- Secondary admin for testing
('ADMIN', 'AdminSecond', 'Test', 'admin2@test.com', 'admin123', '+212 6 00 00 00 02', '456 Management Ave, Test City', '1982-05-15', TRUE);

-- ============================================
-- TEST DOCTOR ACCOUNTS
-- ============================================
INSERT INTO personne (type_personne, nom, prenom, email, mot_de_passe, telephone, adresse, date_naissance, actif) VALUES
-- Cardiologist
('DOCTEUR', 'Heart', 'Dr. John', 'doctor1@test.com', 'doctor123', '+212 6 11 11 11 01', '100 Medical Plaza, Test City', '1975-03-20', TRUE),
-- Dermatologist  
('DOCTEUR', 'Skin', 'Dr. Sarah', 'doctor2@test.com', 'doctor123', '+212 6 11 11 11 02', '200 Health Center, Test City', '1980-07-10', TRUE),
-- Pediatrician
('DOCTEUR', 'Child', 'Dr. Ahmed', 'doctor3@test.com', 'doctor123', '+212 6 11 11 11 03', '300 Kids Clinic, Test City', '1978-12-05', TRUE);

-- Get the IDs of the inserted doctor persons (assuming they are the last 3 inserted)
SET @doctor1_person_id = (SELECT id_personne FROM personne WHERE email = 'doctor1@test.com');
SET @doctor2_person_id = (SELECT id_personne FROM personne WHERE email = 'doctor2@test.com');
SET @doctor3_person_id = (SELECT id_personne FROM personne WHERE email = 'doctor3@test.com');

-- Insert doctor records
INSERT INTO docteur (id_personne, id_departement, specialite, numero_ordre, annees_experience, biographie, tarif_consultation, disponible) VALUES
(@doctor1_person_id, 1, 'Cardiologue', 'TEST-CARD-001', 15, 'Cardiologue expérimenté spécialisé dans les maladies cardiovasculaires. Diplômé de la Faculté de Médecine de Rabat.', 500.00, TRUE),
(@doctor2_person_id, 2, 'Dermatologue', 'TEST-DERM-002', 12, 'Dermatologue expert en dermatologie médicale et esthétique. Formation en dermatologie à Casablanca.', 400.00, TRUE),
(@doctor3_person_id, 3, 'Pédiatre', 'TEST-PED-003', 10, 'Pédiatre dévoué avec une passion pour la santé des enfants. Spécialisé en pédiatrie générale.', 350.00, TRUE);

-- ============================================
-- TEST PATIENT ACCOUNTS
-- ============================================
INSERT INTO personne (type_personne, nom, prenom, email, mot_de_passe, telephone, adresse, date_naissance, actif) VALUES
-- Patient 1
('PATIENT', 'Patient', 'Test One', 'patient1@test.com', 'patient123', '+212 6 22 22 22 01', '10 Patient Street, Test City', '1990-01-15', TRUE),
-- Patient 2
('PATIENT', 'Patient', 'Test Two', 'patient2@test.com', 'patient123', '+212 6 22 22 22 02', '20 Health Road, Test City', '1985-08-22', TRUE),
-- Patient 3
('PATIENT', 'Patient', 'Test Three', 'patient3@test.com', 'patient123', '+212 6 22 22 22 03', '30 Care Avenue, Test City', '1992-11-30', TRUE);

-- Get the IDs of the inserted patient persons
SET @patient1_person_id = (SELECT id_personne FROM personne WHERE email = 'patient1@test.com');
SET @patient2_person_id = (SELECT id_personne FROM personne WHERE email = 'patient2@test.com');
SET @patient3_person_id = (SELECT id_personne FROM personne WHERE email = 'patient3@test.com');

-- Insert patient records
INSERT INTO patient (id_personne, numero_dossier, poids, taille, groupe_sanguin, allergies, antecedents_medicaux) VALUES
(@patient1_person_id, 'TEST-PAT-001', 70.5, 175.0, 'A+', 'Aucune allergie connue', 'Aucun antécédent médical particulier'),
(@patient2_person_id, 'TEST-PAT-002', 65.0, 168.0, 'O+', 'Allergie aux arachides', 'Hypertension familiale'),
(@patient3_person_id, 'TEST-PAT-003', 80.0, 180.0, 'B+', 'Allergie au pollen', 'Diabète de type 2 - contrôlé');

-- ============================================
-- Sample Consultations for Testing
-- ============================================
SET @test_doctor1_id = (SELECT id_docteur FROM docteur WHERE id_personne = @doctor1_person_id);
SET @test_doctor2_id = (SELECT id_docteur FROM docteur WHERE id_personne = @doctor2_person_id);
SET @test_doctor3_id = (SELECT id_docteur FROM docteur WHERE id_personne = @doctor3_person_id);

SET @test_patient1_id = (SELECT id_patient FROM patient WHERE id_personne = @patient1_person_id);
SET @test_patient2_id = (SELECT id_patient FROM patient WHERE id_personne = @patient2_person_id);
SET @test_patient3_id = (SELECT id_patient FROM patient WHERE id_personne = @patient3_person_id);

-- Insert sample consultations
INSERT INTO consultation (id_patient, id_docteur, id_salle, date_consultation, heure_consultation, date_heure_debut, date_heure_fin, statut, motif_consultation, compte_rendu) VALUES
-- Future appointments
(@test_patient1_id, @test_doctor1_id, 1, '2025-10-20', '09:00:00', '2025-10-20 09:00:00', '2025-10-20 09:30:00', 'RESERVEE', 'Contrôle cardiaque de routine', NULL),
(@test_patient2_id, @test_doctor2_id, 3, '2025-10-21', '10:00:00', '2025-10-21 10:00:00', '2025-10-21 10:30:00', 'VALIDEE', 'Consultation dermatologique', NULL),
(@test_patient3_id, @test_doctor3_id, 4, '2025-10-22', '14:00:00', '2025-10-22 14:00:00', '2025-10-22 14:30:00', 'RESERVEE', 'Consultation pédiatrique', NULL),
-- Past consultations for history
(@test_patient1_id, @test_doctor1_id, 1, '2025-09-20', '09:00:00', '2025-09-20 09:00:00', '2025-09-20 09:30:00', 'TERMINEE', 'Bilan cardiologique', 'Patient en bonne santé cardiovasculaire. Tension artérielle normale (12/8). ECG normal. Recommandation: maintenir une activité physique régulière.'),
(@test_patient2_id, @test_doctor2_id, 3, '2025-08-15', '11:00:00', '2025-08-15 11:00:00', '2025-08-15 11:30:00', 'TERMINEE', 'Problème cutané', 'Diagnostic: Eczéma léger. Traitement prescrit: crème hydratante et corticoïde local. Rendez-vous de contrôle dans 3 semaines.');

-- ============================================
-- Display Test Credentials Summary
-- ============================================
SELECT '=================================================================' AS '';
SELECT '                    TEST LOGIN CREDENTIALS                       ' AS '';
SELECT '=================================================================' AS '';
SELECT '' AS '';

SELECT 'ADMIN ACCOUNTS:' AS '';
SELECT CONCAT('Email: ', email, ' | Password: admin123') AS 'Admin Credentials'
FROM personne 
WHERE type_personne = 'ADMIN' AND email LIKE '%@test.com'
ORDER BY email;

SELECT '' AS '';
SELECT 'DOCTOR ACCOUNTS:' AS '';
SELECT CONCAT('Email: ', p.email, ' | Password: doctor123 | Speciality: ', d.specialite) AS 'Doctor Credentials'
FROM personne p
JOIN docteur d ON p.id_personne = d.id_personne
WHERE p.type_personne = 'DOCTEUR' AND p.email LIKE '%@test.com'
ORDER BY p.email;

SELECT '' AS '';
SELECT 'PATIENT ACCOUNTS:' AS '';
SELECT CONCAT('Email: ', p.email, ' | Password: patient123 | File Number: ', pat.numero_dossier) AS 'Patient Credentials'
FROM personne p
JOIN patient pat ON p.id_personne = pat.id_personne
WHERE p.type_personne = 'PATIENT' AND p.email LIKE '%@test.com'
ORDER BY p.email;

SELECT '' AS '';
SELECT '=================================================================' AS '';
SELECT 'All test accounts created successfully!' AS '';
SELECT 'You can now test login functionality with the above credentials.' AS '';
SELECT '=================================================================' AS '';

-- ============================================
-- Verification Queries
-- ============================================
SELECT 'VERIFICATION - User counts by role:' AS '';
SELECT 
    type_personne AS 'Role',
    COUNT(*) AS 'Total Users',
    SUM(CASE WHEN email LIKE '%@test.com' THEN 1 ELSE 0 END) AS 'Test Users',
    SUM(CASE WHEN actif = TRUE THEN 1 ELSE 0 END) AS 'Active Users'
FROM personne
GROUP BY type_personne
ORDER BY 
    CASE type_personne
        WHEN 'ADMIN' THEN 1
        WHEN 'DOCTEUR' THEN 2
        WHEN 'PATIENT' THEN 3
    END;