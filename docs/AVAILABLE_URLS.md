# MediSphere - Available URLs

## Base URL
```
http://localhost:8080/MediSphere_war_exploded
```

## ✅ Working URLs (Implemented)

### Public Routes

#### 1. Home Page (Landing)
- **URL:** `http://localhost:8080/MediSphere_war_exploded/`
- **URL:** `http://localhost:8080/MediSphere_war_exploded/home`
- **Method:** GET
- **Servlet:** `HomeServlet`
- **View:** `/WEB-INF/views/home.jsp`
- **Description:** Modern landing page with gradient design
- **Status:** ✅ Fully Implemented

#### 2. Login
- **URL:** `http://localhost:8080/MediSphere_war_exploded/login`
- **Method:** GET (show form), POST (submit)
- **Servlet:** `LoginServlet`
- **View:** `/WEB-INF/views/auth/login.jsp`
- **Description:** User authentication
- **POST Parameters:**
  - `email` (String)
  - `password` (String)
- **Session Variables Created:**
  - `userConnecte` (Patient object)
  - `userId` (Long)
  - `userRole` (String: "PATIENT", "DOCTEUR", "ADMIN")
- **Status:** ✅ Fully Implemented

#### 3. Register
- **URL:** `http://localhost:8080/MediSphere_war_exploded/register`
- **Method:** GET (show form), POST (submit)
- **Servlet:** `RegisterServlet`
- **View:** `/WEB-INF/views/auth/register.jsp`
- **Description:** Patient registration
- **POST Parameters:**
  - `nom` (String)
  - `prenom` (String)
  - `email` (String)
  - `telephone` (String)
  - `password` (String)
  - `dateNaissance` (Date: yyyy-MM-dd)
  - `adresse` (String)
  - `numeroDossier` (String)
- **Status:** ✅ Fully Implemented

#### 4. Logout
- **URL:** `http://localhost:8080/MediSphere_war_exploded/logout`
- **Method:** GET
- **Servlet:** `LogoutServlet`
- **Description:** Destroy session and logout
- **Redirects to:** `/home`
- **Status:** ✅ Fully Implemented

### Protected Routes (Require Authentication)

#### 5. Dashboard
- **URL:** `http://localhost:8080/MediSphere_war_exploded/dashboard`
- **Method:** GET
- **Servlet:** `DashboardServlet`
- **View:** `/WEB-INF/views/dashboard.jsp`
- **Description:** User dashboard with logout link
- **Required Session:** `userConnecte`
- **Status:** ✅ Fully Implemented

### Admin Routes

#### 6. Department Management (CRUD)
- **Base URL:** `http://localhost:8080/MediSphere_war_exploded/admin/departements`
- **Method:** GET, POST
- **Servlet:** `DepartementServlet`
- **Views:**
  - List: `/WEB-INF/views/admin/departements/list.jsp`
  - Form: `/WEB-INF/views/admin/departements/form.jsp`
- **Description:** Full CRUD for departments
- **Status:** ✅ Fully Implemented

**Actions:**

**6.1 List All Departments**
```
GET /admin/departements
GET /admin/departements?action=list
```
- Displays all departments with doctor count
- Shows create button
- Shows edit/delete buttons for each department

**6.2 Create Department (Show Form)**
```
GET /admin/departements?action=create
```
- Shows department creation form

**6.3 Create Department (Submit)**
```
POST /admin/departements?action=create
Parameters: nom (String, 2-100 chars, unique)
```
- Creates new department
- Validates name uniqueness
- Redirects to list on success

**6.4 Edit Department (Show Form)**
```
GET /admin/departements?action=edit&id={departmentId}
```
- Shows edit form with existing data
- Example: `/admin/departements?action=edit&id=1`

**6.5 Update Department (Submit)**
```
POST /admin/departements?action=edit&id={departmentId}
Parameters: nom (String, 2-100 chars, unique)
```
- Updates existing department
- Validates name uniqueness (excluding current department)
- Redirects to list on success

**6.6 Delete Department**
```
GET /admin/departements?action=delete&id={departmentId}
```
- Deletes department if no doctors assigned
- Shows error if department has doctors
- Example: `/admin/departements?action=delete&id=1`

#### 7. Legacy Hello Servlet (Demo)
- **URL:** `http://localhost:8080/MediSphere_war_exploded/hello-servlet`
- **Method:** GET
- **Servlet:** `HelloServlet`
- **Description:** Demo servlet (can be removed)
- **Status:** ✅ Working (legacy code)

---

## ⏳ Placeholder Routes (Not Yet Implemented)

These servlets exist but have no code yet:

### Admin Placeholders
- `/admin/salles` - `SalleServlet` (empty)
- `/admin/docteurs` - `DocteurManagementServlet` (empty)
- `/admin/statistiques` - `StatistiqueServlet` (empty)
- `/admin/dashboard` - `AdminDashboardServlet` (empty)

### Doctor Placeholders
- `/docteur/dashboard` - `DocteurDashboardServlet` (empty)
- `/docteur/planning` - `PlanningServlet` (empty)
- `/docteur/validation` - `ValidationReservationServlet` (empty)
- `/docteur/compte-rendu` - `CompteRenduServlet` (empty)

### Patient Placeholders
- `/patient/dashboard` - `PatientDashboardServlet` (empty)
- `/patient/reservation` - `ReservationServlet` (empty)
- `/patient/docteurs` - `DocteurListServlet` (empty)
- `/patient/historique` - `ConsultHistoriqueServlet` (empty)

---

## 🔧 Troubleshooting 404 Errors

### Common Issues:

1. **Root URL gives 404**
   - **Problem:** Accessing just `http://localhost:8080/MediSphere_war_exploded/`
   - **Solution:** This should work now! The `index.jsp` redirects to `/home` which is handled by `HomeServlet`
   - **Test:** Make sure Tomcat is running and the app is deployed

2. **Context Path Issues**
   - **Problem:** Using wrong context path
   - **Your context path:** `/MediSphere_war_exploded`
   - **Check in Tomcat:** The context path depends on your deployment name
   - **Alternative:** If you renamed it, use `http://localhost:8080/MediSphere/`

3. **Servlet Not Loading**
   - **Problem:** Servlet class not compiled
   - **Solution:** Run `./mvnw clean package` to rebuild
   - **Check:** Look for errors in Tomcat logs

4. **JSP Not Found**
   - **Problem:** JSP files in wrong location
   - **Solution:** All views must be under `/WEB-INF/views/`
   - **Protected:** Files under `/WEB-INF/` cannot be accessed directly

### Testing Steps:

1. **Verify Compilation:**
```bash
cd /home/protocol/claude/java/MediSphere
./mvnw clean package
```

2. **Check WAR file:**
```bash
ls -la target/MediSphere-1.0-SNAPSHOT.war
```

3. **Deploy to Tomcat:**
   - Copy WAR to Tomcat's `webapps/` directory
   - Or use IDE deployment (IntelliJ/Eclipse)
   - Or use `mvn tomcat7:deploy`

4. **Check Tomcat Logs:**
```bash
tail -f $CATALINA_HOME/logs/catalina.out
```

5. **Test URLs in order:**
   - ✅ Home: `http://localhost:8080/MediSphere_war_exploded/`
   - ✅ Login: `http://localhost:8080/MediSphere_war_exploded/login`
   - ✅ Register: `http://localhost:8080/MediSphere_war_exploded/register`
   - ✅ After login → Dashboard: `http://localhost:8080/MediSphere_war_exploded/dashboard`

---

## 🔐 Authentication Flow

### User Registration & Login:
```
1. GET /register → Show registration form
2. POST /register → Create patient account
3. GET /login → Show login form
4. POST /login → Authenticate user
   ↓
   Session created with:
   - userConnecte (Patient object)
   - userId (Long)
   - userRole (String)
   ↓
5. Redirect to /dashboard
6. Access protected routes
7. GET /logout → Destroy session
```

### Session Variables:
- `userConnecte` - Full user object (Patient/Docteur/Admin)
- `userId` - User ID (Long)
- `userRole` - Role (String: "PATIENT", "DOCTEUR", "ADMIN")

### Protected Routes:
- `/dashboard` - Requires `userConnecte` in session
- `/admin/*` - Requires `userRole = "ADMIN"` (not yet enforced)
- `/docteur/*` - Requires `userRole = "DOCTEUR"` (not yet enforced)
- `/patient/*` - Requires `userRole = "PATIENT"` (not yet enforced)

---

## 📋 Quick Test Checklist

- [ ] Root URL loads home page: `http://localhost:8080/MediSphere_war_exploded/`
- [ ] Login page accessible: `http://localhost:8080/MediSphere_war_exploded/login`
- [ ] Register page accessible: `http://localhost:8080/MediSphere_war_exploded/register`
- [ ] Can create account via register form
- [ ] Can login with credentials
- [ ] Dashboard shows after login
- [ ] Logout destroys session
- [ ] Department list accessible: `http://localhost:8080/MediSphere_war_exploded/admin/departements`
- [ ] Can create new department
- [ ] Can edit existing department
- [ ] Can delete department (without doctors)

---

## 🚀 Next Steps

1. **Add Authentication Filters:**
   - Create `AuthenticationFilter` to protect `/dashboard`, `/admin/*`, `/docteur/*`, `/patient/*`
   - Create `AuthorizationFilter` to check roles

2. **Implement More CRUDs:**
   - Salle (Room) management
   - Docteur management
   - Patient management (admin)

3. **Complete Dashboard Routing:**
   - Implement role-based dashboard redirect
   - Patient dashboard → `/patient/dashboard`
   - Doctor dashboard → `/docteur/dashboard`
   - Admin dashboard → `/admin/dashboard`

4. **Add Features:**
   - Password hashing (BCrypt)
   - Remember me functionality
   - Password reset
   - Email verification

---

**Last Updated:** October 10, 2025  
**Build Status:** ✅ SUCCESS (72 files compiled)
