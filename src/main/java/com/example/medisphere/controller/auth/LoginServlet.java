package com.example.medisphere.controller.auth;

import com.example.medisphere.model.entity.Personne;
import com.example.medisphere.service.impl.AuthServiceImpl;
import com.example.medisphere.service.interfaces.IAuthService;
import com.example.medisphere.util.JPAUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    private static final String LOGIN_VIEW = "/WEB-INF/views/auth/login.jsp";
    private static final String DASHBOARD_VIEW = "/dashboard";
    private static final String ERROR_ATTR = "error";

    private IAuthService authService;


    @Override
    public void init() {
        authService = new AuthServiceImpl();
    }

    @Override
    protected void doGet(jakarta.servlet.http.HttpServletRequest request, jakarta.servlet.http.HttpServletResponse response)
            throws jakarta.servlet.ServletException, java.io.IOException {
        request.getRequestDispatcher(LOGIN_VIEW).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String motDePasse = request.getParameter("motDePasse");

        try {
            Personne user = authService.authenticate(email, motDePasse);
            if (user != null) {
                HttpSession session = request.getSession();
                session.setAttribute("userConnecte", user);
                session.setAttribute("userId", user.getIdPersonne());
                session.setAttribute("userRole", user.getTypePersonne().name());

                response.sendRedirect(request.getContextPath() + DASHBOARD_VIEW);
                return;
            }

            request.setAttribute(ERROR_ATTR, "Email ou mot de passe incorrect");
            request.getRequestDispatcher(LOGIN_VIEW).forward(request, response);

        } catch (Exception e) {
            request.setAttribute(ERROR_ATTR, "Erreur lors de l'authentification");
            request.getRequestDispatcher(LOGIN_VIEW).forward(request, response);
        }
    }
}

