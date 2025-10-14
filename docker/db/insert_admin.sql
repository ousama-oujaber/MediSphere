-- ============================================
-- Insert Admin Account for MediSphere
-- ============================================
-- This script creates an admin account with the following credentials:
-- Email: admin@medisphere.com
-- Password: Admin@123 (should be hashed in production)
-- ============================================

USE medisphere;

-- Check if admin already exists
SET @admin_exists = (
    SELECT COUNT(*) 
    FROM personne 
    WHERE email = 'admin@medisphere.com'
);

-- Insert admin only if doesn't exist
INSERT INTO personne (
    type_personne,
    nom,
    prenom,
    email,
    mot_de_passe,
    telephone,
    adresse,
    date_naissance,
    actif
)
SELECT 
    'ADMIN',
    'Admin',
    'System',
    'admin@medisphere.com',
    'Admin@123',  -- Note: In production, this should be hashed with BCrypt
    '+212 6 12 34 56 78',
    'MediSphere Clinic, Casablanca, Morocco',
    '1990-01-01',
    TRUE
WHERE @admin_exists = 0;

-- Display result
SELECT 
    CASE 
        WHEN @admin_exists = 0 THEN 'Admin account created successfully!'
        ELSE 'Admin account already exists!'
    END AS result;

-- Show admin account details (for verification)
SELECT 
    id_personne,
    type_personne,
    nom,
    prenom,
    email,
    telephone,
    actif,
    date_creation
FROM personne 
WHERE email = 'admin@medisphere.com';

-- ============================================
-- Additional Admin Accounts (Optional)
-- ============================================

-- Insert additional admin accounts if needed
INSERT IGNORE INTO personne (
    type_personne,
    nom,
    prenom,
    email,
    mot_de_passe,
    telephone,
    actif
) VALUES 
(
    'ADMIN',
    'Oujaber',
    'Oussama',
    'oussama.admin@medisphere.com',
    'Oussama@123',
    '+212 6 11 22 33 44',
    TRUE
);

-- ============================================
-- Summary Query
-- ============================================

SELECT 
    type_personne AS 'Role',
    COUNT(*) AS 'Total Users',
    SUM(CASE WHEN actif = TRUE THEN 1 ELSE 0 END) AS 'Active Users'
FROM personne
GROUP BY type_personne
ORDER BY 
    CASE type_personne
        WHEN 'ADMIN' THEN 1
        WHEN 'DOCTEUR' THEN 2
        WHEN 'PATIENT' THEN 3
    END;

-- ============================================
-- Admin Credentials Summary
-- ============================================
SELECT '===================================================' AS '';
SELECT 'ADMIN ACCOUNTS CREATED' AS '';
SELECT '===================================================' AS '';
SELECT 
    CONCAT(prenom, ' ', nom) AS 'Full Name',
    email AS 'Email',
    'Admin@123 or Oussama@123' AS 'Password (Default)',
    actif AS 'Active'
FROM personne 
WHERE type_personne = 'ADMIN'
ORDER BY date_creation;
SELECT '===================================================' AS '';
SELECT 'NOTE: Please change the default password after first login!' AS '';
SELECT '===================================================' AS '';
