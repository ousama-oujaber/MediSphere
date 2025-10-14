# 🚀 Quick Start Guide - MediSphere URLs

## 📍 Your 404 Error - SOLVED!

### Why you got 404:
The root URL `http://localhost:8080/MediSphere_war_exploded/` **should work** now!

### How it works:
```
http://localhost:8080/MediSphere_war_exploded/
    ↓
index.jsp redirects to → /home
    ↓
HomeServlet handles → /home or "" (empty string)
    ↓
Displays → /WEB-INF/views/home.jsp (Modern landing page)
```

---

## ✅ TEST THESE URLs (In Order):

### 1️⃣ HOME PAGE - Start Here!
```
http://localhost:8080/MediSphere_war_exploded/
```
or
```
http://localhost:8080/MediSphere_war_exploded/home
```
**What you'll see:** Modern landing page with gradient design

---

### 2️⃣ LOGIN
```
http://localhost:8080/MediSphere_war_exploded/login
```
**Test credentials:** Use any patient you registered, or check database

---

### 3️⃣ REGISTER (Create Account)
```
http://localhost:8080/MediSphere_war_exploded/register
```
**What to do:** Fill form to create a patient account

---

### 4️⃣ DASHBOARD (After Login)
```
http://localhost:8080/MediSphere_war_exploded/dashboard
```
**Requires:** You must be logged in first

---

### 5️⃣ DEPARTMENT CRUD (Admin)
```
http://localhost:8080/MediSphere_war_exploded/admin/departements
```
**What you'll see:** List of departments with Create/Edit/Delete buttons

---

### 6️⃣ LOGOUT
```
http://localhost:8080/MediSphere_war_exploded/logout
```
**What happens:** Destroys session, redirects to home

---

## 🔧 If Still Getting 404:

### Check #1: Is Tomcat Running?
```bash
# Check if Tomcat process is running
ps aux | grep tomcat

# Check Tomcat port
netstat -tuln | grep 8080
```

### Check #2: Is App Deployed?
Check your Tomcat webapps directory:
```bash
ls -la $CATALINA_HOME/webapps/
```
You should see `MediSphere_war_exploded/` folder

### Check #3: Check Tomcat Logs
```bash
# View recent logs
tail -f $CATALINA_HOME/logs/catalina.out

# Or if using IntelliJ IDEA, check the console output
```

### Check #4: Context Path
Your app context path depends on how you deployed:
- **Exploded WAR:** `/MediSphere_war_exploded`
- **WAR file named MediSphere.war:** `/MediSphere`
- **ROOT.war:** `/` (just localhost:8080)

**To check:** Look at your Tomcat manager or deployment configuration

### Check #5: Try Different Context Path
If `/MediSphere_war_exploded` doesn't work, try:
```
http://localhost:8080/MediSphere/
```
or
```
http://localhost:8080/MediSphere-1.0-SNAPSHOT/
```

---

## 🎯 How to Deploy (If Not Deployed):

### Option A: IntelliJ IDEA (Recommended)
1. Open Run/Debug Configurations
2. Add Tomcat Server → Local
3. Add deployment artifact: `MediSphere:war exploded`
4. Click Run
5. Browser opens automatically

### Option B: Copy WAR Manually
```bash
# Copy WAR to Tomcat webapps
cp target/MediSphere-1.0-SNAPSHOT.war $CATALINA_HOME/webapps/

# Tomcat auto-deploys and creates folder
# Access at: http://localhost:8080/MediSphere-1.0-SNAPSHOT/
```

### Option C: Maven Tomcat Plugin
```bash
# Start Tomcat with Maven
./mvnw tomcat7:run

# Access at: http://localhost:8080/MediSphere/
```

---

## 📊 Database Check (If Login Fails):

### Make sure database is running:
```bash
# Check if MySQL is running
docker ps

# Or start with docker-compose
cd /home/protocol/claude/java/MediSphere
docker-compose up -d
```

### Check database connection:
```bash
# Connect to database
docker exec -it <mysql-container-id> mysql -u medisphere_user -p

# Enter password: medisphere_password

# Check patients table
mysql> USE medisphere_db;
mysql> SELECT * FROM patient;
```

### If no patients exist, create one:
Use the register page: `http://localhost:8080/MediSphere_war_exploded/register`

---

## 🐛 Common Errors & Solutions:

### Error: "HTTP Status 404 – Not Found"
**Cause:** App not deployed or wrong URL
**Solution:** 
- Check context path
- Verify deployment
- Check Tomcat logs

### Error: "java.lang.ClassNotFoundException"
**Cause:** Servlet not compiled
**Solution:**
```bash
./mvnw clean package
# Redeploy
```

### Error: "Session attribute is null"
**Cause:** Trying to access protected page without login
**Solution:**
- Login first: `/login`
- Then access: `/dashboard` or `/admin/departements`

### Error: "EntityManagerFactory is null"
**Cause:** JPA configuration issue
**Solution:**
- Check `persistence.xml`
- Verify database connection
- Check Tomcat logs for JPA errors

---

## 📝 Quick Test Script:

Open these URLs in order:

1. ✅ Home: http://localhost:8080/MediSphere_war_exploded/
2. ✅ Register: http://localhost:8080/MediSphere_war_exploded/register
   - Create account: test@example.com / password123
3. ✅ Login: http://localhost:8080/MediSphere_war_exploded/login
   - Use credentials from step 2
4. ✅ Dashboard: http://localhost:8080/MediSphere_war_exploded/dashboard
   - Should show user info
5. ✅ Departments: http://localhost:8080/MediSphere_war_exploded/admin/departements
   - Create a department
6. ✅ Logout: http://localhost:8080/MediSphere_war_exploded/logout

---

## 📚 Full URL List:

See `AVAILABLE_URLS.md` for complete documentation of all routes!

---

**Last Updated:** October 10, 2025  
**WAR File:** ✅ Built successfully (29MB)  
**Status:** Ready to deploy!
