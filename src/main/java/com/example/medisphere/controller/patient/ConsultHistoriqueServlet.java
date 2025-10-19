package com.example.medisphere.controller.patient;

import com.example.medisphere.model.entity.Consultation;
import com.example.medisphere.model.entity.Patient;
import com.example.medisphere.model.entity.Personne;
import com.example.medisphere.model.enums.RoleUtilisateur;
import com.example.medisphere.model.enums.StatutConsultation;
import com.example.medisphere.service.interfaces.IConsultationService;
import com.example.medisphere.service.interfaces.IPatientService;
import com.example.medisphere.service.impl.ConsultationServiceImpl;
import com.example.medisphere.service.impl.PatientServiceImpl;
import com.example.medisphere.repository.impl.ConsultationRepositoryImpl;
import com.example.medisphere.repository.impl.PatientRepositoryImpl;
import com.example.medisphere.util.JPAUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

 
@WebServlet(name = "ConsultHistoriqueServlet", urlPatterns = {"/patient/historique"})
public class ConsultHistoriqueServlet extends HttpServlet {
    
    private static final String VIEW_PATH = "/WEB-INF/views/patient/historique.jsp";
    private static final String LOGIN_URL = "/auth/login";
    
    private IConsultationService consultationService;
    private IPatientService patientService;
    
    @Override
    public void init() throws ServletException {
        super.init();
        ConsultationRepositoryImpl consultationRepository = new ConsultationRepositoryImpl(JPAUtil.getEntityManagerFactory());
        this.consultationService = new ConsultationServiceImpl(consultationRepository);
        PatientRepositoryImpl patientRepository = new PatientRepositoryImpl(JPAUtil.getEntityManagerFactory());
        this.patientService = new PatientServiceImpl(patientRepository);
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
        if (user.getTypePersonne() != RoleUtilisateur.PATIENT) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }
        
        try {
            
            Patient patient = java.util.Optional.ofNullable(patientService.findByEmail(user.getEmail()))
                .orElseThrow(() -> new IllegalArgumentException("Patient introuvable"));
            
            
            List<Consultation> consultations = consultationService.getHistoriquePatient(patient.getIdPatient());
            
            
            String statusFilter = request.getParameter("statut");
            if (statusFilter != null && !statusFilter.isEmpty() && !statusFilter.equals("ALL")) {
                try {
                    StatutConsultation statut = StatutConsultation.valueOf(statusFilter);
                    consultations = consultations.stream()
                        .filter(c -> c.getStatut() == statut)
                        .collect(Collectors.toList());
                } catch (IllegalArgumentException e) {
                    
                }
            }
            
            
            consultations.sort((c1, c2) -> {
                int dateCompare = c2.getDateConsultation().compareTo(c1.getDateConsultation());
                if (dateCompare != 0) return dateCompare;
                return c2.getHeureConsultation().compareTo(c1.getHeureConsultation());
            });
            
            request.setAttribute("consultations", consultations);
            request.setAttribute("selectedStatus", statusFilter != null ? statusFilter : "ALL");
            request.getRequestDispatcher(VIEW_PATH).forward(request, response);
            
        } catch (Exception e) {
            request.setAttribute("error", "Erreur lors du chargement de l'historique: " + e.getMessage());
            request.getRequestDispatcher(VIEW_PATH).forward(request, response);
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
        if (user.getTypePersonne() != RoleUtilisateur.PATIENT) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }
        
        
        String action = request.getParameter("action");
        if ("cancel".equals(action)) {
            try {
                Long consultationId = Long.parseLong(request.getParameter("consultationId"));
                Patient patient = patientService.getPatientById(user.getIdPersonne())
                    .orElseThrow(() -> new IllegalArgumentException("Patient introuvable"));
                
                consultationService.cancelReservation(consultationId, patient.getIdPatient());
                session.setAttribute("success", "Réservation annulée avec succès");
                
            } catch (Exception e) {
                session.setAttribute("error", e.getMessage());
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/patient/historique");
    }
}
