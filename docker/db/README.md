# MediSphere Database Scripts

This directory contains the SQL scripts for initializing and populating the MediSphere database.

## Files Overview

### 1. `init.sql` 
- **Purpose**: Main database schema creation and initial data
- **Contains**: 
  - Complete database schema (tables, indexes, constraints)
  - Department data
  - Sample admin, doctors, and patients with production-like data
  - Views and stored procedures
- **Usage**: Automatically executed when Docker container starts

### 2. `insert_admin.sql`
- **Purpose**: Creates production admin accounts
- **Contains**: 
  - Admin accounts with strong credentials
  - System admin account creation
- **Usage**: Run manually when setting up production environment

### 3. `fake_data_login.sql` ⭐
- **Purpose**: Creates test accounts with simple, easy-to-remember credentials
- **Contains**: Test accounts for all user roles
- **Usage**: Perfect for development and login testing

## 🔑 Test Login Credentials

After running `fake_data_login.sql`, you can use these credentials to test login functionality:

### Admin Accounts
```
Email: admin@test.com      | Password: admin123
Email: admin2@test.com     | Password: admin123
```

### Doctor Accounts  
```
Email: doctor1@test.com    | Password: doctor123  | Specialty: Cardiologue
Email: doctor2@test.com    | Password: doctor123  | Specialty: Dermatologue  
Email: doctor3@test.com    | Password: doctor123  | Specialty: Pédiatre
```

### Patient Accounts
```
Email: patient1@test.com   | Password: patient123  | File: TEST-PAT-001
Email: patient2@test.com   | Password: patient123  | File: TEST-PAT-002
Email: patient3@test.com   | Password: patient123  | File: TEST-PAT-003
```

## 🚀 Quick Start for Testing

1. **Start the database** (using Docker Compose):
   ```bash
   docker-compose up -d db
   ```

2. **Run the fake data script**:
   ```bash
   # Option 1: Connect to MySQL container and run script
   docker exec -i medisphere-db mysql -u root -p medisphere < docker/db/fake_data_login.sql
   
   # Option 2: Use MySQL client directly
   mysql -h localhost -P 3306 -u root -p medisphere < docker/db/fake_data_login.sql
   ```

3. **Test login** with any of the credentials above

## 🛠️ Development Tips

- **Clear test data**: Uncomment the DELETE statements at the top of `fake_data_login.sql` if you need to reset test data
- **Custom test data**: Modify `fake_data_login.sql` to add your own test scenarios
- **Production setup**: Use `insert_admin.sql` for production admin accounts with strong passwords

## 📁 Database Schema Summary

### Main Tables
- `personne` - Base user table (admin, doctor, patient)
- `patient` - Patient-specific information
- `docteur` - Doctor-specific information  
- `departement` - Medical departments
- `salle` - Consultation rooms
- `consultation` - Appointments and medical consultations
- `creneau_occupe` - Time slot management

### User Roles
- `ADMIN` - System administrators
- `DOCTEUR` - Medical doctors
- `PATIENT` - Patients

## 🔒 Security Notes

⚠️ **Important**: The fake data script uses plain text passwords for testing convenience. In production:
- Use proper password hashing (BCrypt)
- Implement strong password policies
- Change default credentials immediately
- Use environment variables for sensitive data