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

@WebServlet(name = "ValidationReservationServlet", urlPatterns = {"/docteur/validation"})
public class ValidationReservationServlet extends HttpServlet {
    
    private static final String VALIDATION_VIEW = "/WEB-INF/views/docteur/validation.jsp";
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
            String consultationIdParam = request.getParameter("id");
            
            if (consultationIdParam != null && !consultationIdParam.isEmpty()) {
                
                Long consultationId = Long.parseLong(consultationIdParam);
                Optional<Consultation> optConsultation = consultationService.getConsultationById(consultationId);
                
                if (optConsultation.isPresent()) {
                    Consultation consultation = optConsultation.get();
                    
                    
                    if (consultation.getDocteur().getIdDocteur().equals(docteurId)) {
                        request.setAttribute("consultation", consultation);
                    } else {
                        request.setAttribute("error", "Cette consultation ne vous appartient pas");
                    }
                } else {
                    request.setAttribute("error", "Consultation introuvable");
                }
            } else {
                
                List<Consultation> consultationsEnAttente = 
                    consultationService.getConsultationsByDocteurAndStatut(docteurId, StatutConsultation.RESERVEE);
                request.setAttribute("consultations", consultationsEnAttente);
            }
            
            request.setAttribute("docteur", docteur);
            request.getRequestDispatcher(VALIDATION_VIEW).forward(request, response);
            
        } catch (Exception e) {
            request.setAttribute("error", "Erreur: " + e.getMessage());
            request.getRequestDispatcher(VALIDATION_VIEW).forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
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
        
        String action = request.getParameter("action");
        String consultationIdParam = request.getParameter("consultationId");
        
        try {
            if (consultationIdParam == null || consultationIdParam.isEmpty()) {
                throw new IllegalArgumentException("ID de consultation manquant");
            }
            
            Long consultationId = Long.parseLong(consultationIdParam);
            
            if ("valider".equals(action)) {
                
                consultationService.validerReservation(consultationId, docteurId);
                session.setAttribute("success", "Réservation validée avec succès");
                
            } else if ("rejeter".equals(action)) {
                
                String motifAnnulation = request.getParameter("motifAnnulation");
                consultationService.rejeterReservation(consultationId, docteurId, motifAnnulation);
                session.setAttribute("success", "Réservation rejetée avec succès");
                
            } else {
                throw new IllegalArgumentException("Action invalide");
            }
            
            response.sendRedirect(request.getContextPath() + "/docteur/validation");
            
        } catch (Exception e) {
            session.setAttribute("error", "Erreur: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/docteur/validation");
        }
    }
}
