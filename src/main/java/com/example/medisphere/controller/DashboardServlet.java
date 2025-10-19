package com.example.medisphere.controller;

import com.example.medisphere.model.enums.RoleUtilisateur;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

 
@WebServlet(name = "DashboardServlet", urlPatterns = {"/dashboard"})
public class DashboardServlet extends HttpServlet {

    private static final String LOGIN_URL = "/login";
    private static final String ADMIN_DASHBOARD = "/WEB-INF/views/admin/dashboard.jsp";
    private static final String DOCTEUR_DASHBOARD = "/WEB-INF/views/docteur/dashboard.jsp";
    private static final String PATIENT_DASHBOARD = "/WEB-INF/views/patient/dashboard.jsp";
    private static final String DEFAULT_DASHBOARD = "/WEB-INF/views/dashboard.jsp";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        
        if (session == null || session.getAttribute("userConnecte") == null) {
            resp.sendRedirect(req.getContextPath() + LOGIN_URL);
            return;
        }

        String userRole = (String) session.getAttribute("userRole");
        
        String dashboardView = getDashboardView(userRole);
        req.getRequestDispatcher(dashboardView).forward(req, resp);
    }

    private String getDashboardView(String userRole) {
        if (userRole == null) {
            return DEFAULT_DASHBOARD;
        }

        return switch (userRole) {
            case "ADMIN" -> ADMIN_DASHBOARD;
            case "DOCTEUR" -> DOCTEUR_DASHBOARD;
            case "PATIENT" -> PATIENT_DASHBOARD;
            default -> DEFAULT_DASHBOARD;
        };
    }
}
