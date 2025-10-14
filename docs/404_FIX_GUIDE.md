# 🔧 404 Error Fix & Troubleshooting Guide

## ⚠️ Problem: All URLs Returning 404

You're experiencing 404 errors on all pages including the home page.

---

## ✅ Fixes Applied

### 1. Added Welcome File Configuration
**File:** `src/main/webapp/WEB-INF/web.xml`

Added:
```xml
<welcome-file-list>
    <welcome-file>index.jsp</welcome-file>
</welcome-file-list>
```

**Why:** This tells Tomcat what file to serve when accessing the root URL.

### 2. Updated HomeServlet URL Pattern
**File:** `src/main/java/com/example/medisphere/controller/HomeServlet.java`

Changed from:
```java
@WebServlet(name = "HomeServlet", urlPatterns = {"", "/home"})
```

To:
```java
@WebServlet(name = "HomeServlet", urlPatterns = {"/home", "/index"})
```

**Why:** The empty string pattern `""` doesn't work reliably in all servlet containers.

---

## 🚀 Deployment Steps

### IMPORTANT: You MUST redeploy the application!

#### Option 1: IntelliJ IDEA (Recommended)
1. **Stop Tomcat** (if running)
2. **Clean and rebuild:**
   ```bash
   ./mvnw clean package
   ```
3. **Redeploy in IntelliJ:**
   - Go to Run → Edit Configurations
   - Select your Tomcat configuration
   - Click "Deployment" tab
   - Remove old deployment
   - Add new artifact: `MediSphere:war exploded`
   - Click "Apply"
4. **Start Tomcat**
5. **Test URLs**

#### Option 2: Manual WAR Deployment
```bash
# 1. Build WAR
cd /home/protocol/claude/java/MediSphere
./mvnw clean package

# 2. Stop Tomcat
$CATALINA_HOME/bin/shutdown.sh

# 3. Remove old deployment
rm -rf $CATALINA_HOME/webapps/MediSphere_war_exploded
rm -f $CATALINA_HOME/webapps/MediSphere_war_exploded.war

# 4. Copy new WAR
cp target/MediSphere-1.0-SNAPSHOT.war $CATALINA_HOME/webapps/MediSphere.war

# 5. Start Tomcat
$CATALINA_HOME/bin/startup.sh

# 6. Wait 10-15 seconds for deployment
sleep 15

# 7. Test
curl http://localhost:8080/MediSphere/
```

#### Option 3: Maven Tomcat Plugin
```bash
# If you have tomcat7-maven-plugin configured
./mvnw tomcat7:redeploy
```

---

## 🔍 Testing After Deployment

### Test URLs in This Order:

#### 1. Root URL (via index.jsp → redirect to /home)
```
http://localhost:8080/MediSphere_war_exploded/
```
**Expected:** Redirect to home page

#### 2. Home Page (Direct)
```
http://localhost:8080/MediSphere_war_exploded/home
```
**Expected:** See modern landing page with gradient design

#### 3. Login Page
```
http://localhost:8080/MediSphere_war_exploded/login
```
**Expected:** See login form

#### 4. Register Page
```
http://localhost:8080/MediSphere_war_exploded/register
```
**Expected:** See registration form

#### 5. Test Login (Admin)
```
URL: http://localhost:8080/MediSphere_war_exploded/login
Email: admin@medisphere.com
Password: Admin@123
```
**Expected:** Redirect to beautiful admin dashboard

#### 6. Department CRUD
```
http://localhost:8080/MediSphere_war_exploded/admin/departements
```
**Expected:** See department list

---

## 🐛 If Still Getting 404 Errors

### Check #1: Verify Context Path
Your app might be deployed with a different context path. Try these URLs:

```
http://localhost:8080/MediSphere/
http://localhost:8080/MediSphere-1.0-SNAPSHOT/
http://localhost:8080/
```

**How to find your context path:**
1. Check Tomcat manager: http://localhost:8080/manager/html
2. Look at Tomcat console output when starting
3. Check: `$CATALINA_HOME/webapps/` folder names

### Check #2: Verify Tomcat is Running
```bash
# Check if Tomcat process is running
ps aux | grep tomcat

# Check if port 8080 is listening
netstat -tuln | grep 8080
# or
lsof -i :8080
```

### Check #3: View Tomcat Logs
```bash
# Real-time log viewing
tail -f $CATALINA_HOME/logs/catalina.out

# Check for errors
grep -i "error" $CATALINA_HOME/logs/catalina.out
grep -i "exception" $CATALINA_HOME/logs/catalina.out
```

**Look for:**
- `ClassNotFoundException` - Missing dependencies
- `ServletException` - Servlet initialization errors
- `JPA/Hibernate errors` - Database connection issues
- `Port already in use` - Another process using port 8080

### Check #4: Verify Deployment
```bash
# Check if WAR was extracted
ls -la $CATALINA_HOME/webapps/

# You should see a directory like:
# MediSphere_war_exploded/
# or
# MediSphere/
```

If directory doesn't exist, deployment failed. Check Tomcat logs for errors.

### Check #5: Check Database Connection
```bash
# Verify MySQL is running
docker ps | grep mysql

# Should show: medisphere_db container

# If not running, start it:
cd /home/protocol/claude/java/MediSphere
docker-compose up -d
```

### Check #6: Verify Servlet Mappings
```bash
# Check compiled servlets exist
ls -la target/classes/com/example/medisphere/controller/

# Should show:
# HomeServlet.class
# LoginServlet.class
# DashboardServlet.class
# etc.
```

### Check #7: Clear Tomcat Work Directory
Sometimes Tomcat caches cause issues:
```bash
# Stop Tomcat
$CATALINA_HOME/bin/shutdown.sh

# Clear work directory
rm -rf $CATALINA_HOME/work/Catalina/localhost/*

# Clear temp
rm -rf $CATALINA_HOME/temp/*

# Restart Tomcat
$CATALINA_HOME/bin/startup.sh
```

---

## 📋 Complete URL Reference

### Working URLs (After Fix):

| URL | Description | Status |
|-----|-------------|--------|
| `/` | Root (redirects to /home) | ✅ Should work |
| `/home` | Home page | ✅ Should work |
| `/login` | Login form | ✅ Should work |
| `/register` | Registration form | ✅ Should work |
| `/dashboard` | Dashboard (auto-routes by role) | ✅ Should work (requires login) |
| `/admin/departements` | Department CRUD | ✅ Should work (requires admin login) |
| `/logout` | Logout | ✅ Should work |

### URL Flow:
```
1. User visits: http://localhost:8080/MediSphere_war_exploded/
   ↓
2. index.jsp executes: response.sendRedirect("/home")
   ↓
3. HomeServlet matches /home pattern
   ↓
4. Forwards to: /WEB-INF/views/home.jsp
   ↓
5. User sees: Beautiful landing page
```

---

## 🔧 Emergency Debugging Commands

### Quick Debug Script
```bash
#!/bin/bash
echo "=== MediSphere 404 Debugging ==="
echo ""
echo "1. Checking Tomcat process..."
ps aux | grep tomcat | grep -v grep

echo ""
echo "2. Checking port 8080..."
netstat -tuln | grep 8080

echo ""
echo "3. Checking deployed apps..."
ls -la $CATALINA_HOME/webapps/ | grep -i medisphere

echo ""
echo "4. Checking recent logs..."
tail -20 $CATALINA_HOME/logs/catalina.out

echo ""
echo "5. Checking MySQL..."
docker ps | grep mysql

echo ""
echo "6. Testing URL..."
curl -I http://localhost:8080/MediSphere_war_exploded/home
```

Save as `debug.sh` and run:
```bash
chmod +x debug.sh
./debug.sh
```

---

## 📊 Build Verification

Current build status:
```
✅ Compilation: SUCCESS
✅ Files: 74 source files
✅ WAR: target/MediSphere-1.0-SNAPSHOT.war (29MB)
✅ Welcome file: Configured
✅ Servlet patterns: Updated
```

---

## 🎯 Most Common Causes of 404

### 1. **Not Redeployed** (90% of cases)
**Fix:** Stop Tomcat, rebuild (`./mvnw clean package`), redeploy, restart

### 2. **Wrong Context Path**
**Fix:** Check actual deployment path in Tomcat, adjust URLs

### 3. **Tomcat Not Started**
**Fix:** Start Tomcat, wait for full deployment

### 4. **Database Not Running**
**Fix:** `docker-compose up -d`, wait for MySQL ready

### 5. **Port Conflict**
**Fix:** Kill process using port 8080, restart Tomcat

---

## ✅ Success Checklist

After redeployment, verify:
- [ ] Tomcat started without errors
- [ ] No exceptions in catalina.out
- [ ] WAR extracted to webapps directory
- [ ] MySQL container running
- [ ] Can access: http://localhost:8080/MediSphere_war_exploded/home
- [ ] Can access: http://localhost:8080/MediSphere_war_exploded/login
- [ ] Can login as admin
- [ ] Dashboard loads after login
- [ ] Department CRUD accessible

---

## 📞 Next Steps If Still Not Working

1. **Share Tomcat logs:**
   ```bash
   tail -100 $CATALINA_HOME/logs/catalina.out
   ```

2. **Share deployment directory:**
   ```bash
   ls -la $CATALINA_HOME/webapps/
   ```

3. **Try accessing Tomcat manager:**
   ```
   http://localhost:8080/manager/html
   ```
   (Shows all deployed apps and their status)

4. **Check IntelliJ console** for deployment errors

---

**Last Updated:** October 10, 2025  
**Status:** Fixes applied, awaiting redeployment test  
**Action Required:** REDEPLOY APPLICATION
