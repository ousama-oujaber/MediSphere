package com.example.medisphere.controller.patient;

import com.example.medisphere.model.entity.Consultation;
import com.example.medisphere.model.entity.Patient;
import com.example.medisphere.model.entity.Personne;
import com.example.medisphere.model.enums.RoleUtilisateur;
import com.example.medisphere.model.enums.StatutConsultation;
import com.example.medisphere.repository.impl.ConsultationRepositoryImpl;
import com.example.medisphere.service.impl.ConsultationServiceImpl;
import com.example.medisphere.service.impl.PatientServiceImpl;
import com.example.medisphere.service.interfaces.IConsultationService;
import com.example.medisphere.service.interfaces.IPatientService;
import com.example.medisphere.util.JPAUtil;
import com.example.medisphere.repository.impl.PatientRepositoryImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

 
@WebServlet(name = "PatientDashboardServlet", urlPatterns = {"/patient/dashboard"})
public class PatientDashboardServlet extends HttpServlet {
    
    private static final String DASHBOARD_VIEW = "/WEB-INF/views/patient/dashboard.jsp";
    private static final String LOGIN_URL = "/login";
    
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
        
    
    Optional<Patient> optPatient = java.util.Optional.ofNullable(patientService.findByEmail(user.getEmail()));
        if (optPatient.isEmpty()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Patient introuvable");
            return;
        }
        
        Patient patient = optPatient.get();
        Long patientId = patient.getIdPatient();
        
        try {
            
            List<Consultation> allConsultations = consultationService.getHistoriquePatient(patientId);
            
            
            long totalConsultations = allConsultations.size();
            long consultationsReservees = allConsultations.stream()
                .filter(c -> c.getStatut() == StatutConsultation.RESERVEE)
                .count();
            long consultationsValidees = allConsultations.stream()
                .filter(c -> c.getStatut() == StatutConsultation.VALIDEE)
                .count();
            long consultationsTerminees = allConsultations.stream()
                .filter(c -> c.getStatut() == StatutConsultation.TERMINEE)
                .count();
            
            
            LocalDate today = LocalDate.now();
            List<Consultation> upcomingConsultations = allConsultations.stream()
                .filter(c -> (c.getStatut() == StatutConsultation.RESERVEE || c.getStatut() == StatutConsultation.VALIDEE))
                .filter(c -> !c.getDateConsultation().isBefore(today))
                .sorted((c1, c2) -> c1.getDateConsultation().compareTo(c2.getDateConsultation()))
                .limit(5)
                .toList();
            
            
            List<Consultation> recentConsultations = allConsultations.stream()
                .filter(c -> c.getStatut() == StatutConsultation.TERMINEE)
                .sorted((c1, c2) -> c2.getDateConsultation().compareTo(c1.getDateConsultation()))
                .limit(3)
                .toList();
            
            
            request.setAttribute("totalConsultations", totalConsultations);
            request.setAttribute("consultationsReservees", consultationsReservees);
            request.setAttribute("consultationsValidees", consultationsValidees);
            request.setAttribute("consultationsTerminees", consultationsTerminees);
            request.setAttribute("upcomingConsultations", upcomingConsultations);
            request.setAttribute("recentConsultations", recentConsultations);
            request.setAttribute("patient", patient);
            
            request.getRequestDispatcher(DASHBOARD_VIEW).forward(request, response);
            
        } catch (Exception e) {
            request.setAttribute("error", "Erreur lors du chargement du tableau de bord: " + e.getMessage());
            request.getRequestDispatcher(DASHBOARD_VIEW).forward(request, response);
        }
    }
}
