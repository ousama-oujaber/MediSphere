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
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Optional;

 
@WebServlet(name = "PlanningServlet", urlPatterns = {"/docteur/planning"})
public class PlanningServlet extends HttpServlet {
    
    private static final String PLANNING_VIEW = "/WEB-INF/views/docteur/planning.jsp";
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
            
            String dateParam = request.getParameter("date");
            String statutParam = request.getParameter("statut");
            
            List<Consultation> consultations;
            
            
            if (dateParam != null && !dateParam.isEmpty()) {
                
                LocalDate date = LocalDate.parse(dateParam);
                consultations = consultationService.getConsultationsByDocteurAndDateRange(docteurId, date, date);
            } else if (statutParam != null && !statutParam.isEmpty()) {
                
                StatutConsultation statut = StatutConsultation.valueOf(statutParam);
                consultations = consultationService.getConsultationsByDocteurAndStatut(docteurId, statut);
            } else {
                
                consultations = consultationService.getConsultationsByDocteur(docteurId);
            }
            
            
            request.setAttribute("consultations", consultations);
            request.setAttribute("selectedDate", dateParam);
            request.setAttribute("selectedStatut", statutParam);
            request.setAttribute("docteur", docteur);
            
            request.getRequestDispatcher(PLANNING_VIEW).forward(request, response);
            
        } catch (Exception e) {
            request.setAttribute("error", "Erreur lors du chargement du planning: " + e.getMessage());
            request.getRequestDispatcher(PLANNING_VIEW).forward(request, response);
        }
    }
}
