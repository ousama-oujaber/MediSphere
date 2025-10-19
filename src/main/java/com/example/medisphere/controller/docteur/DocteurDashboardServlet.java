package com.example.medisphere.controller.docteur;

import com.example.medisphere.model.entity.Consultation;
import com.example.medisphere.model.entity.Docteur;
import com.example.medisphere.model.entity.Personne;
import com.example.medisphere.model.enums.RoleUtilisateur;
import com.example.medisphere.model.enums.StatutConsultation;
import com.example.medisphere.repository.impl.ConsultationRepositoryImpl;
import com.example.medisphere.service.impl.ConsultationServiceImpl;
import com.example.medisphere.service.impl.DocteurServiceImpl;
import com.example.medisphere.service.interfaces.IConsultationService;
import com.example.medisphere.service.interfaces.IDocteurService;
import com.example.medisphere.util.JPAUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;
import java.util.Optional;

 
@WebServlet(name = "DocteurDashboardServlet", urlPatterns = {"/docteur/dashboard"})
public class DocteurDashboardServlet extends HttpServlet {
    
    private static final String DASHBOARD_VIEW = "/WEB-INF/views/docteur/dashboard.jsp";
    private static final String LOGIN_URL = "/login";
    
    private IConsultationService consultationService;
    private IDocteurService docteurService;
    
    @Override
    public void init() throws ServletException {
        super.init();
        ConsultationRepositoryImpl consultationRepository = new ConsultationRepositoryImpl(JPAUtil.getEntityManagerFactory());
        this.consultationService = new ConsultationServiceImpl(consultationRepository);
        this.docteurService = new DocteurServiceImpl();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        
        if (session == null || session.getAttribute("userConnecte") == null) {
            response.sendRedirect(request.getContextPath() + LOGIN_URL);
            return;
        }
        
        Personne user = (Personne) session.getAttribute("userConnecte");
        
        
        if (user.getTypePersonne() != RoleUtilisateur.DOCTEUR) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }
        
        
        Optional<Docteur> optDocteur = docteurService.getDocteurByEmail(user.getEmail());
        if (optDocteur.isEmpty()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Docteur introuvable");
            return;
        }
        
        Docteur docteur = optDocteur.get();
        Long docteurId = docteur.getIdDocteur();
        
        try {
            
            long totalConsultations = consultationService.countConsultationsByDocteur(docteurId);
            long consultationsReservees = consultationService.countConsultationsByDocteurAndStatut(docteurId, StatutConsultation.RESERVEE);
            long consultationsValidees = consultationService.countConsultationsByDocteurAndStatut(docteurId, StatutConsultation.VALIDEE);
            long consultationsTerminees = consultationService.countConsultationsByDocteurAndStatut(docteurId, StatutConsultation.TERMINEE);
            
            
            List<Consultation> consultationsAujourdhui = consultationService.getTodayConsultationsForDocteur(docteurId);
            
            
            List<Consultation> consultationsEnAttente = consultationService.getConsultationsByDocteurAndStatut(docteurId, StatutConsultation.RESERVEE);
            
            request.setAttribute("totalConsultations", totalConsultations);
            request.setAttribute("consultationsReservees", consultationsReservees);
            request.setAttribute("consultationsValidees", consultationsValidees);
            request.setAttribute("consultationsTerminees", consultationsTerminees);
            request.setAttribute("consultationsAujourdhui", consultationsAujourdhui);
            request.setAttribute("consultationsEnAttente", consultationsEnAttente);
            request.setAttribute("docteur", docteur);
            
            request.getRequestDispatcher(DASHBOARD_VIEW).forward(request, response);
            
        } catch (Exception e) {
            request.setAttribute("error", "Erreur lors du chargement du tableau de bord: " + e.getMessage());
            request.getRequestDispatcher(DASHBOARD_VIEW).forward(request, response);
        }
    }
}
