-- ============================================
-- Schéma Base de Données - Gestion Clinique
-- ============================================

-- Suppression des tables si elles existent (ordre inversé à cause des FK)
DROP TABLE IF EXISTS consultation;
DROP TABLE IF EXISTS creneau_occupe;
DROP TABLE IF EXISTS docteur;
DROP TABLE IF EXISTS patient;
DROP TABLE IF EXISTS personne;
DROP TABLE IF EXISTS salle;
DROP TABLE IF EXISTS departement;

-- ============================================
-- Table: departement
-- ============================================
CREATE TABLE departement (
                             id_departement BIGINT PRIMARY KEY AUTO_INCREMENT,
                             nom VARCHAR(100) NOT NULL UNIQUE,
                             description TEXT,
                             date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                             INDEX idx_nom_departement (nom)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Table: personne (table mère abstraite)
-- ============================================
CREATE TABLE personne (
                          id_personne BIGINT PRIMARY KEY AUTO_INCREMENT,
                          type_personne VARCHAR(20) NOT NULL, -- 'PATIENT', 'DOCTEUR', 'ADMIN'
                          nom VARCHAR(100) NOT NULL,
                          prenom VARCHAR(100) NOT NULL,
                          email VARCHAR(150) NOT NULL UNIQUE,
                          mot_de_passe VARCHAR(255) NOT NULL,
                          telephone VARCHAR(20),
                          adresse TEXT,
                          date_naissance DATE,
                          date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                          date_modification TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                          actif BOOLEAN DEFAULT TRUE,
                          INDEX idx_email (email),
                          INDEX idx_type_personne (type_personne),
                          CHECK (type_personne IN ('PATIENT', 'DOCTEUR', 'ADMIN'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Table: patient
-- ============================================
CREATE TABLE patient (
                         id_patient BIGINT PRIMARY KEY AUTO_INCREMENT,
                         id_personne BIGINT NOT NULL UNIQUE,
                         numero_dossier VARCHAR(50) UNIQUE,
                         poids DECIMAL(5,2),
                         taille DECIMAL(5,2),
                         groupe_sanguin VARCHAR(5),
                         allergies TEXT,
                         antecedents_medicaux TEXT,
                         FOREIGN KEY (id_personne) REFERENCES personne(id_personne) ON DELETE CASCADE,
                         INDEX idx_numero_dossier (numero_dossier)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Table: docteur
-- ============================================
CREATE TABLE docteur (
                         id_docteur BIGINT PRIMARY KEY AUTO_INCREMENT,
                         id_personne BIGINT NOT NULL UNIQUE,
                         id_departement BIGINT NOT NULL,
                         specialite VARCHAR(100) NOT NULL,
                         numero_ordre VARCHAR(50) UNIQUE,
                         annees_experience INT,
                         biographie TEXT,
                         tarif_consultation DECIMAL(10,2),
                         disponible BOOLEAN DEFAULT TRUE,
                         FOREIGN KEY (id_personne) REFERENCES personne(id_personne) ON DELETE CASCADE,
                         FOREIGN KEY (id_departement) REFERENCES departement(id_departement) ON DELETE RESTRICT,
                         INDEX idx_specialite (specialite),
                         INDEX idx_departement (id_departement),
                         INDEX idx_disponible (disponible)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Table: salle
-- ============================================
CREATE TABLE salle (
                       id_salle BIGINT PRIMARY KEY AUTO_INCREMENT,
                       nom_salle VARCHAR(50) NOT NULL UNIQUE,
                       numero_etage INT,
                       capacite INT DEFAULT 1,
                       equipements TEXT,
                       disponible BOOLEAN DEFAULT TRUE,
                       date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                       INDEX idx_nom_salle (nom_salle),
                       INDEX idx_disponible (disponible)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Table: consultation
-- ============================================
CREATE TABLE consultation (
                              id_consultation BIGINT PRIMARY KEY AUTO_INCREMENT,
                              id_patient BIGINT NOT NULL,
                              id_docteur BIGINT NOT NULL,
                              id_salle BIGINT NOT NULL,
                              date_consultation DATE NOT NULL,
                              heure_consultation TIME NOT NULL,
                              date_heure_debut DATETIME NOT NULL,
                              date_heure_fin DATETIME NOT NULL,
                              statut VARCHAR(20) NOT NULL DEFAULT 'RESERVEE',
                              motif_consultation TEXT NOT NULL,
                              compte_rendu TEXT,
                              diagnostic TEXT,
                              traitement_prescrit TEXT,
                              observations TEXT,
                              date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                              date_modification TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                              FOREIGN KEY (id_patient) REFERENCES patient(id_patient) ON DELETE CASCADE,
                              FOREIGN KEY (id_docteur) REFERENCES docteur(id_docteur) ON DELETE RESTRICT,
                              FOREIGN KEY (id_salle) REFERENCES salle(id_salle) ON DELETE RESTRICT,
                              INDEX idx_patient (id_patient),
                              INDEX idx_docteur (id_docteur),
                              INDEX idx_salle (id_salle),
                              INDEX idx_date_consultation (date_consultation),
                              INDEX idx_statut (statut),
                              INDEX idx_date_heure_debut (date_heure_debut),
                              CHECK (statut IN ('RESERVEE', 'VALIDEE', 'ANNULEE', 'TERMINEE')),
    -- Contrainte: Un patient ne peut pas avoir 2 consultations au même moment
                              UNIQUE KEY unique_patient_datetime (id_patient, date_heure_debut)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Table: creneau_occupe (pour gérer les créneaux de 30 min)
-- ============================================
CREATE TABLE creneau_occupe (
                                id_creneau BIGINT PRIMARY KEY AUTO_INCREMENT,
                                id_salle BIGINT NOT NULL,
                                id_consultation BIGINT NOT NULL,
                                date_heure_debut DATETIME NOT NULL,
                                date_heure_fin DATETIME NOT NULL,
                                FOREIGN KEY (id_salle) REFERENCES salle(id_salle) ON DELETE CASCADE,
                                FOREIGN KEY (id_consultation) REFERENCES consultation(id_consultation) ON DELETE CASCADE,
                                INDEX idx_salle_date (id_salle, date_heure_debut),
    -- Contrainte: Une salle ne peut pas avoir 2 créneaux qui se chevauchent
                                UNIQUE KEY unique_salle_creneau (id_salle, date_heure_debut)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Insertion de données de test
-- ============================================

-- Insertion des départements
INSERT INTO departement (nom, description) VALUES
                                               ('Cardiologie', 'Département spécialisé dans les maladies cardiovasculaires'),
                                               ('Dermatologie', 'Département spécialisé dans les maladies de la peau'),
                                               ('Pédiatrie', 'Département spécialisé dans la santé des enfants'),
                                               ('Neurologie', 'Département spécialisé dans les maladies du système nerveux'),
                                               ('Orthopédie', 'Département spécialisé dans les problèmes osseux et articulaires');

-- Insertion des personnes (Admin)
INSERT INTO personne (type_personne, nom, prenom, email, mot_de_passe, telephone) VALUES
    ('ADMIN', 'Admin', 'Système', 'admin@clinique.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '0600000000');
-- Mot de passe: admin123 (hashé avec BCrypt)

-- Insertion des personnes (Docteurs)
INSERT INTO personne (type_personne, nom, prenom, email, mot_de_passe, telephone, date_naissance) VALUES
                                                                                                      ('DOCTEUR', 'Benali', 'Amina', 'a.benali@clinique.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '0612345678', '1980-05-15'),
                                                                                                      ('DOCTEUR', 'El Amrani', 'Karim', 'k.elamrani@clinique.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '0623456789', '1975-08-22'),
                                                                                                      ('DOCTEUR', 'Idrissi', 'Fatima', 'f.idrissi@clinique.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '0634567890', '1985-03-10'),
                                                                                                      ('DOCTEUR', 'Tazi', 'Mohamed', 'm.tazi@clinique.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '0645678901', '1978-11-30');

-- Insertion des docteurs
INSERT INTO docteur (id_personne, id_departement, specialite, numero_ordre, annees_experience, tarif_consultation) VALUES
                                                                                                                       (2, 1, 'Cardiologue', 'ORD-001-2020', 15, 500.00),
                                                                                                                       (3, 2, 'Dermatologue', 'ORD-002-2018', 20, 400.00),
                                                                                                                       (4, 3, 'Pédiatre', 'ORD-003-2015', 10, 350.00),
                                                                                                                       (5, 4, 'Neurologue', 'ORD-004-2019', 12, 600.00);

-- Insertion des personnes (Patients)
INSERT INTO personne (type_personne, nom, prenom, email, mot_de_passe, telephone, date_naissance) VALUES
                                                                                                      ('PATIENT', 'Alaoui', 'Hassan', 'h.alaoui@email.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '0656789012', '1990-07-12'),
                                                                                                      ('PATIENT', 'Rachidi', 'Samira', 's.rachidi@email.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '0667890123', '1995-02-25'),
                                                                                                      ('PATIENT', 'Mansouri', 'Youssef', 'y.mansouri@email.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '0678901234', '1988-09-18');

-- Insertion des patients
INSERT INTO patient (id_personne, numero_dossier, poids, taille, groupe_sanguin) VALUES
                                                                                     (6, 'PAT-2025-001', 75.5, 178.0, 'A+'),
                                                                                     (7, 'PAT-2025-002', 62.0, 165.0, 'O+'),
                                                                                     (8, 'PAT-2025-003', 85.0, 182.0, 'B+');

-- Insertion des salles
INSERT INTO salle (nom_salle, numero_etage, capacite, equipements) VALUES
                                                                       ('Salle 101', 1, 1, 'Bureau, Table d''examen, Ordinateur'),
                                                                       ('Salle 102', 1, 1, 'Bureau, Table d''examen, ECG'),
                                                                       ('Salle 201', 2, 1, 'Bureau, Table d''examen, Dermatoscope'),
                                                                       ('Salle 202', 2, 1, 'Bureau, Table d''examen pédiatrique, Jouets'),
                                                                       ('Salle 301', 3, 1, 'Bureau, Table d''examen, Matériel neurologique');

-- Insertion de consultations exemples
INSERT INTO consultation (id_patient, id_docteur, id_salle, date_consultation, heure_consultation, date_heure_debut, date_heure_fin, statut, motif_consultation, compte_rendu) VALUES
                                                                                                                                                                                   (1, 1, 1, '2025-10-08', '09:00:00', '2025-10-08 09:00:00', '2025-10-08 09:30:00', 'RESERVEE', 'Contrôle cardiaque annuel', NULL),
                                                                                                                                                                                   (2, 2, 3, '2025-10-08', '10:00:00', '2025-10-08 10:00:00', '2025-10-08 10:30:00', 'VALIDEE', 'Problème de peau', NULL),
                                                                                                                                                                                   (3, 4, 5, '2025-10-08', '14:00:00', '2025-10-08 14:00:00', '2025-10-08 14:30:00', 'RESERVEE', 'Migraines récurrentes', NULL),
                                                                                                                                                                                   (1, 1, 1, '2025-09-15', '09:00:00', '2025-09-15 09:00:00', '2025-09-15 09:30:00', 'TERMINEE', 'Consultation cardiaque', 'Patient en bonne santé. Tension artérielle normale. RAS.');

-- Insertion des créneaux occupés
INSERT INTO creneau_occupe (id_salle, id_consultation, date_heure_debut, date_heure_fin) VALUES
                                                                                             (1, 1, '2025-10-08 09:00:00', '2025-10-08 09:30:00'),
                                                                                             (3, 2, '2025-10-08 10:00:00', '2025-10-08 10:30:00'),
                                                                                             (5, 3, '2025-10-08 14:00:00', '2025-10-08 14:30:00'),
                                                                                             (1, 4, '2025-09-15 09:00:00', '2025-09-15 09:30:00');

-- ============================================
-- Vues utiles pour les statistiques
-- ============================================

-- Vue : Statistiques globales
CREATE VIEW v_statistiques_globales AS
SELECT
    (SELECT COUNT(*) FROM patient) AS total_patients,
    (SELECT COUNT(*) FROM docteur) AS total_docteurs,
    (SELECT COUNT(*) FROM departement) AS total_departements,
    (SELECT COUNT(*) FROM salle) AS total_salles,
    (SELECT COUNT(*) FROM consultation) AS total_consultations,
    (SELECT COUNT(*) FROM consultation WHERE statut = 'TERMINEE') AS consultations_terminees,
    (SELECT COUNT(*) FROM consultation WHERE statut = 'RESERVEE') AS consultations_reservees,
    (SELECT COUNT(*) FROM consultation WHERE statut = 'VALIDEE') AS consultations_validees,
    (SELECT COUNT(*) FROM consultation WHERE statut = 'ANNULEE') AS consultations_annulees;

-- Vue: Planning des docteurs
CREATE VIEW v_planning_docteur AS
SELECT
    c.id_consultation,
    c.date_consultation,
    c.heure_consultation,
    c.statut,
    c.motif_consultation,
    d.id_docteur,
    CONCAT(p_doc.prenom, ' ', p_doc.nom) AS nom_docteur,
    d.specialite,
    pat.id_patient,
    CONCAT(p_pat.prenom, ' ', p_pat.nom) AS nom_patient,
    s.nom_salle
FROM consultation c
         INNER JOIN docteur d ON c.id_docteur = d.id_docteur
         INNER JOIN personne p_doc ON d.id_personne = p_doc.id_personne
         INNER JOIN patient pat ON c.id_patient = pat.id_patient
         INNER JOIN personne p_pat ON pat.id_personne = p_pat.id_personne
         INNER JOIN salle s ON c.id_salle = s.id_salle
ORDER BY c.date_consultation DESC, c.heure_consultation;

-- Vue: Taux d'occupation des salles
CREATE VIEW v_taux_occupation_salles AS
SELECT
    s.id_salle,
    s.nom_salle,
    COUNT(co.id_creneau) AS total_creneaux_occupes,
    s.disponible
FROM salle s
         LEFT JOIN creneau_occupe co ON s.id_salle = co.id_salle
GROUP BY s.id_salle, s.nom_salle, s.disponible
ORDER BY total_creneaux_occupes DESC;

-- ============================================
-- Procédures stockées utiles
-- ============================================

DELIMITER //

-- Procédure: Vérifier disponibilité d'une salle à un créneau donné
CREATE PROCEDURE sp_verifier_disponibilite_salle(
    IN p_id_salle BIGINT,
    IN p_date_heure_debut DATETIME,
    IN p_date_heure_fin DATETIME,
    OUT p_disponible BOOLEAN
)
BEGIN
    DECLARE v_count INT;

    SELECT COUNT(*) INTO v_count
    FROM creneau_occupe
    WHERE id_salle = p_id_salle
      AND (
        (date_heure_debut < p_date_heure_fin AND date_heure_fin > p_date_heure_debut)
        );

    IF v_count = 0 THEN
        SET p_disponible = TRUE;
    ELSE
        SET p_disponible = FALSE;
    END IF;
END //

-- Procédure: Obtenir les créneaux disponibles pour une date donnée
CREATE PROCEDURE sp_creneaux_disponibles(
    IN p_date DATE
)
BEGIN
    -- Créneaux de 8h à 18h (30 min chacun)
    WITH RECURSIVE creneaux AS (
        SELECT
            TIME('08:00:00') AS heure_debut,
            TIME('08:30:00') AS heure_fin
        UNION ALL
        SELECT
            ADDTIME(heure_debut, '00:30:00'),
            ADDTIME(heure_fin, '00:30:00')
        FROM creneaux
        WHERE heure_fin < TIME('18:00:00')
    )
    SELECT
        c.heure_debut,
        c.heure_fin,
        s.id_salle,
        s.nom_salle
    FROM creneaux c
             CROSS JOIN salle s
    WHERE NOT EXISTS (
        SELECT 1
        FROM creneau_occupe co
        WHERE co.id_salle = s.id_salle
          AND DATE(co.date_heure_debut) = p_date
          AND TIME(co.date_heure_debut) = c.heure_debut
    )
      AND s.disponible = TRUE
    ORDER BY c.heure_debut, s.nom_salle;
END //

DELIMITER ;

-- ============================================
-- Index supplémentaires pour optimisation
-- ============================================

-- Index composite pour recherches fréquentes
CREATE INDEX idx_consultation_patient_date ON consultation(id_patient, date_consultation);
CREATE INDEX idx_consultation_docteur_date ON consultation(id_docteur, date_consultation);
CREATE INDEX idx_consultation_statut_date ON consultation(statut, date_consultation);

-- ============================================
-- Commentaires sur les tables
-- ============================================

ALTER TABLE departement COMMENT = 'Table des départements médicaux de la clinique';
ALTER TABLE personne COMMENT = 'Table mère abstraite pour tous les utilisateurs (héritage)';
ALTER TABLE patient COMMENT = 'Table des patients avec leurs informations médicales';
ALTER TABLE docteur COMMENT = 'Table des docteurs avec leurs spécialités';
ALTER TABLE salle COMMENT = 'Table des salles de consultation';
ALTER TABLE consultation COMMENT = 'Table des consultations avec gestion des statuts';
ALTER TABLE creneau_occupe COMMENT = 'Table de gestion des créneaux de 30 minutes par salle';