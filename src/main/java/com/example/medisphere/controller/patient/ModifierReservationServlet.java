package com.example.medisphere.controller.patient;

import com.example.medisphere.model.entity.*;
import com.example.medisphere.model.enums.RoleUtilisateur;
import com.example.medisphere.model.enums.StatutConsultation;
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

 
@WebServlet(name = "ModifierReservationServlet", urlPatterns = {"/patient/modifier-reservation"})
public class ModifierReservationServlet extends HttpServlet {
    private static final String LOGIN_URL = "/auth/login";
    private static final String HISTORIQUE_URL = "/patient/historique";
    private static final String VIEW_PATH = "/WEB-INF/views/patient/modifier-reservation.jsp";
    
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
        
        
        String consultationIdParam = request.getParameter("id");
        if (consultationIdParam == null || consultationIdParam.isEmpty()) {
            session.setAttribute("error", "Aucune consultation sélectionnée");
            response.sendRedirect(request.getContextPath() + HISTORIQUE_URL);
            return;
        }
        
        try {
            Long consultationId = Long.parseLong(consultationIdParam);
            
            
            Patient patient = java.util.Optional.ofNullable(patientService.findByEmail(user.getEmail()))
                .orElseThrow(() -> new IllegalArgumentException("Patient introuvable"));
            
            
            Consultation consultation = consultationService.getConsultationById(consultationId)
                .orElseThrow(() -> new IllegalArgumentException("Consultation introuvable"));
            
            
            if (!consultation.getPatient().getIdPatient().equals(patient.getIdPatient())) {
                session.setAttribute("error", "Cette consultation ne vous appartient pas");
                response.sendRedirect(request.getContextPath() + HISTORIQUE_URL);
                return;
            }
            
            
            if (consultation.getStatut() != StatutConsultation.RESERVEE) {
                session.setAttribute("error", "Seules les consultations réservées peuvent être modifiées");
                response.sendRedirect(request.getContextPath() + HISTORIQUE_URL);
                return;
            }
            
            
            if (consultation.getDateConsultation().isBefore(LocalDate.now())) {
                session.setAttribute("error", "Impossible de modifier une consultation passée");
                response.sendRedirect(request.getContextPath() + HISTORIQUE_URL);
                return;
            }
            
            
            List<String> timeSlots = generateTimeSlots();
            
            request.setAttribute("consultation", consultation);
            request.setAttribute("timeSlots", timeSlots);
            request.setAttribute("minDate", LocalDate.now().toString());
            
            request.getRequestDispatcher(VIEW_PATH).forward(request, response);
            
        } catch (NumberFormatException e) {
            session.setAttribute("error", "ID de consultation invalide");
            response.sendRedirect(request.getContextPath() + HISTORIQUE_URL);
        } catch (Exception e) {
            session.setAttribute("error", e.getMessage());
            response.sendRedirect(request.getContextPath() + HISTORIQUE_URL);
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
            
            
            Long consultationId = Long.parseLong(request.getParameter("consultationId"));
            LocalDate newDate = LocalDate.parse(request.getParameter("dateConsultation"));
            LocalTime newTime = LocalTime.parse(request.getParameter("heureConsultation"));
            String newMotif = request.getParameter("motifConsultation");
            
            
            if (newMotif == null || newMotif.trim().isEmpty()) {
                throw new IllegalArgumentException("Le motif de consultation est obligatoire");
            }
            
            
            Consultation consultation = consultationService.modifyReservation(
                consultationId,
                patient.getIdPatient(),
                newDate,
                newTime,
                newMotif
            );
            
            session.setAttribute("success", "Réservation modifiée avec succès !");
            response.sendRedirect(request.getContextPath() + HISTORIQUE_URL);
            
        } catch (DateTimeParseException e) {
            session.setAttribute("error", "Format de date ou heure invalide");
            response.sendRedirect(request.getContextPath() + "/patient/modifier-reservation?id=" + 
                request.getParameter("consultationId"));
        } catch (IllegalArgumentException | IllegalStateException e) {
            session.setAttribute("error", e.getMessage());
            response.sendRedirect(request.getContextPath() + "/patient/modifier-reservation?id=" + 
                request.getParameter("consultationId"));
        } catch (Exception e) {
            session.setAttribute("error", "Erreur lors de la modification: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/patient/modifier-reservation?id=" + 
                request.getParameter("consultationId"));
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
