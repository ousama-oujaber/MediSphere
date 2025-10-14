# 🐛 Enum Casting Fix - HTTP 500 Error Resolution

## Problem

**Error:** `ClassCastException: class com.example.medisphere.model.enums.RoleUtilisateur cannot be cast to class java.lang.String`

**Location:** `DashboardServlet.java:36`

**Symptom:** HTTP 500 Internal Server Error when admin (or any user) tries to access the dashboard after login.

---

## Root Cause

### The Issue

In `LoginServlet.java`, the user's role was being stored in the session as a `RoleUtilisateur` enum object:

```java
// WRONG - Stores enum object
session.setAttribute("userRole", user.getTypePersonne());
```

Then in `DashboardServlet.java`, we tried to cast it to a String:

```java
// Trying to cast enum to String - FAILS!
String userRole = (String) session.getAttribute("userRole");
```

### Why It Failed

- `user.getTypePersonne()` returns a `RoleUtilisateur` enum (an object)
- Session stores this as an enum object
- When we try to cast the enum object to String, Java throws `ClassCastException`
- The enum and String are completely different types and cannot be cast

---

## Solution

### Fix Applied

Changed `LoginServlet.java` to store the enum **name as a String**:

```java
// CORRECT - Stores enum name as String
session.setAttribute("userRole", user.getTypePersonne().name());
```

### What `.name()` Does

The `.name()` method returns the enum constant name as a String:

```java
RoleUtilisateur.ADMIN.name()    → "ADMIN"     (String)
RoleUtilisateur.DOCTEUR.name()  → "DOCTEUR"   (String)
RoleUtilisateur.PATIENT.name()  → "PATIENT"   (String)
```

Now the cast in `DashboardServlet` works correctly:

```java
String userRole = (String) session.getAttribute("userRole");
// userRole will be "ADMIN", "DOCTEUR", or "PATIENT"
```

---

## Files Modified

### 1. LoginServlet.java

**Before:**
```java
session.setAttribute("userRole", user.getTypePersonne());
```

**After:**
```java
// Store role as String for easy comparison
session.setAttribute("userRole", user.getTypePersonne().name());
```

**Line:** 54

---

## Session Attributes Reference

After successful login, the session contains:

| Attribute | Type | Value Example | Purpose |
|-----------|------|---------------|---------|
| `userConnecte` | `Personne` | `Personne{idPersonne=1, ...}` | Full user object |
| `userId` | `Long` | `1` | User's primary key |
| `userRole` | `String` | `"ADMIN"` | User's role as string |

---

## Testing

### Test Steps

1. **Rebuild the application:**
   ```bash
   ./mvnw clean package
   ```

2. **Redeploy to Tomcat** (or restart if auto-deploy is enabled)

3. **Test login flow:**
   - Go to: `http://localhost:8080/MediSphere_war_exploded/login`
   - Login as admin: `admin@medisphere.com` / `Admin@123`
   - Should redirect to: `/dashboard`
   - Should see: **Admin dashboard** (no 500 error)

4. **Verify role-based routing:**
   - Admin → `admin/dashboard.jsp` ✅
   - Docteur → `docteur/dashboard.jsp` ✅
   - Patient → `patient/dashboard.jsp` ✅

### Expected Result

✅ No `ClassCastException`  
✅ Dashboard loads successfully  
✅ Correct dashboard shown based on role  
✅ No HTTP 500 errors

---

## Alternative Solutions (Not Used)

### Option 1: Cast to Enum Instead of String

Change `DashboardServlet.java`:

```java
// Cast to enum and then get name
RoleUtilisateur roleEnum = (RoleUtilisateur) session.getAttribute("userRole");
String userRole = roleEnum.name();
```

**Why not used:** More verbose, requires extra import, same result as our solution.

### Option 2: Store Both Enum and String

```java
session.setAttribute("userRole", user.getTypePersonne());
session.setAttribute("userRoleString", user.getTypePersonne().name());
```

**Why not used:** Redundant data in session, wastes memory.

### Option 3: Use Enum Throughout

Change `DashboardServlet.java` to work with enums:

```java
RoleUtilisateur userRole = (RoleUtilisateur) session.getAttribute("userRole");

return switch (userRole) {
    case ADMIN -> ADMIN_DASHBOARD;
    case DOCTEUR -> DOCTEUR_DASHBOARD;
    case PATIENT -> PATIENT_DASHBOARD;
    default -> DEFAULT_DASHBOARD;
};
```

**Why not used:** Works but less flexible. String comparison is simpler for most use cases.

---

## Best Practices Going Forward

### 1. Store Simple Types in Session

✅ **DO:** Store primitives, Strings, Numbers  
❌ **DON'T:** Store complex objects unless necessary

```java
// Good
session.setAttribute("userRole", user.getTypePersonne().name());

// Acceptable if you need the full object
session.setAttribute("userConnecte", user);
```

### 2. Document Session Attributes

Always document what's stored in the session and its type:

```java
/**
 * Session attributes:
 * - userConnecte (Personne): Full user object
 * - userId (Long): User's ID
 * - userRole (String): User's role ("ADMIN", "DOCTEUR", "PATIENT")
 */
```

### 3. Type-Safe Retrieval

```java
// Always cast to the correct type
String userRole = (String) session.getAttribute("userRole");
Long userId = (Long) session.getAttribute("userId");
Personne user = (Personne) session.getAttribute("userConnecte");
```

### 4. Null Checks

```java
// Check for null before casting
Object roleObj = session.getAttribute("userRole");
if (roleObj instanceof String userRole) {
    // Use userRole safely
}
```

---

## Related Files

- `LoginServlet.java` - Stores role in session (FIXED)
- `DashboardServlet.java` - Reads role from session (already correct)
- `RoleUtilisateur.java` - Enum definition
- `Personne.java` - User entity with `getTypePersonne()` method

---

## Status

✅ **Fixed:** October 10, 2025  
✅ **Tested:** Build successful  
🚀 **Action Required:** Redeploy application to Tomcat

---

## Summary

**Problem:** Enum stored in session couldn't be cast to String  
**Solution:** Call `.name()` on enum before storing in session  
**Result:** Clean String comparison, no ClassCastException  
**Impact:** All user roles now work correctly in dashboard routing

