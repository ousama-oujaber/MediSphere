package com.example.medisphere.controller.patient;

import com.example.medisphere.model.entity.*;
import com.example.medisphere.model.enums.RoleUtilisateur;
import com.example.medisphere.service.interfaces.*;
import com.example.medisphere.service.impl.*;
import com.example.medisphere.repository.impl.*;
import com.example.medisphere.util.JPAUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/patient/reservation")
public class ReservationServlet extends HttpServlet {
    private static final String LOGIN_URL = "/auth/login";
    private static final String DASHBOARD_URL = "/patient/dashboard";
    private static final String VIEW_PATH = "/WEB-INF/views/patient/reservation.jsp";
    
    private IConsultationService consultationService;
    private IDocteurService docteurService;
    private IPatientService patientService;
    
    @Override
    public void init() throws ServletException {
        super.init();
        ConsultationRepositoryImpl consultationRepository = new ConsultationRepositoryImpl(JPAUtil.getEntityManagerFactory());
        this.consultationService = new ConsultationServiceImpl(consultationRepository);
        DocteurRepositoryImpl docteurRepository = new DocteurRepositoryImpl(JPAUtil.getEntityManagerFactory());
        this.docteurService = new DocteurServiceImpl(docteurRepository);
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
        
        
        String docteurIdParam = request.getParameter("docteurId");
        if (docteurIdParam == null || docteurIdParam.isEmpty()) {
            request.setAttribute("error", "Aucun docteur sélectionné");
            response.sendRedirect(request.getContextPath() + "/patient/docteurs");
            return;
        }
        
        try {
            Long docteurId = Long.parseLong(docteurIdParam);
            Docteur docteur = docteurService.getDocteurById(docteurId)
                .orElseThrow(() -> new IllegalArgumentException("Docteur introuvable"));
            
            
            List<String> timeSlots = generateTimeSlots();
            
            request.setAttribute("docteur", docteur);
            request.setAttribute("timeSlots", timeSlots);
            request.setAttribute("minDate", LocalDate.now().toString());
            
            request.getRequestDispatcher(VIEW_PATH).forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID du docteur invalide");
            response.sendRedirect(request.getContextPath() + "/patient/docteurs");
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            response.sendRedirect(request.getContextPath() + "/patient/docteurs");
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
        
        try {
            
            Patient patient = java.util.Optional.ofNullable(patientService.findByEmail(user.getEmail()))
                .orElseThrow(() -> new IllegalArgumentException("Patient introuvable"));
            
            
            Long docteurId = Long.parseLong(request.getParameter("docteurId"));
            LocalDate dateConsultation = LocalDate.parse(request.getParameter("dateConsultation"));
            LocalTime heureConsultation = LocalTime.parse(request.getParameter("heureConsultation"));
            String motifConsultation = request.getParameter("motifConsultation");
            
            
            if (motifConsultation == null || motifConsultation.trim().isEmpty()) {
                throw new IllegalArgumentException("Le motif de consultation est obligatoire");
            }
            
            
            Consultation consultation = consultationService.createReservation(
                patient.getIdPatient(),
                docteurId,
                dateConsultation,
                heureConsultation,
                motifConsultation
            );
            
            session.setAttribute("success", "Réservation effectuée avec succès !");
            response.sendRedirect(request.getContextPath() + DASHBOARD_URL);
            
        } catch (DateTimeParseException e) {
            session.setAttribute("error", "Format de date ou heure invalide");
            response.sendRedirect(request.getContextPath() + "/patient/reservation?" + 
                "docteurId=" + request.getParameter("docteurId"));
        } catch (IllegalArgumentException | IllegalStateException e) {
            session.setAttribute("error", e.getMessage());
            response.sendRedirect(request.getContextPath() + "/patient/reservation?" + 
                "docteurId=" + request.getParameter("docteurId"));
        } catch (Exception e) {
            session.setAttribute("error", "Erreur lors de la réservation: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/patient/reservation?" + 
                "docteurId=" + request.getParameter("docteurId"));
        }
    }
    
    private List<String> generateTimeSlots() {
        List<String> slots = new ArrayList<>();
        LocalTime startTime = LocalTime.of(8, 0);  // 8:00 AM
        LocalTime endTime = LocalTime.of(17, 0);   // 5:00 PM
        
        LocalTime currentTime = startTime;
        while (currentTime.isBefore(endTime) || currentTime.equals(endTime)) {
            slots.add(currentTime.toString());
            currentTime = currentTime.plusMinutes(30);
        }
        
        return slots;
    }
}
