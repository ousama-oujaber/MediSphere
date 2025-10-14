package com.example.medisphere.controller.admin;

import com.example.medisphere.model.entity.Patient;
import com.example.medisphere.model.entity.Personne;
import com.example.medisphere.model.enums.RoleUtilisateur;
import com.example.medisphere.repository.impl.PatientRepositoryImpl;
import com.example.medisphere.service.impl.PatientServiceImpl;
import com.example.medisphere.service.interfaces.IPatientService;
import com.example.medisphere.util.JPAUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;


@WebServlet(name = "PatientServlet", urlPatterns = {"/admin/patients"})
public class PatientServlet extends HttpServlet {
    
    private IPatientService patientService;
    
    @Override
    public void init() throws ServletException {
        super.init();
        PatientRepositoryImpl patientRepository = new PatientRepositoryImpl(JPAUtil.getEntityManagerFactory());
        this.patientService = new PatientServiceImpl(patientRepository);
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        if (!isAdminAuthenticated(request, response)) {
            return;
        }
        
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }
        
        try {
            switch (action) {
                case "list":
                    listPatients(request, response);
                    break;
                case "new":
                    showNewForm(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "delete":
                    deletePatient(request, response);
                    break;
                case "search":
                    searchPatients(request, response);
                    break;
                default:
                    listPatients(request, response);
                    break;
            }
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Erreur: " + e.getMessage());
            listPatients(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        if (!isAdminAuthenticated(request, response)) {
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            if ("save".equals(action)) {
                savePatient(request, response);
            } else if ("update".equals(action)) {
                updatePatient(request, response);
            } else {
                listPatients(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Erreur: " + e.getMessage());
            if ("save".equals(action)) {
                showNewForm(request, response);
            } else if ("update".equals(action)) {
                showEditForm(request, response);
            } else {
                listPatients(request, response);
            }
        }
    }
    
    private void listPatients(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Patient> patients = patientService.getAllPatients();
        request.setAttribute("patients", patients);
        request.getRequestDispatcher("/WEB-INF/views/admin/patients/list.jsp").forward(request, response);
    }
    
    private void searchPatients(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        List<Patient> patients;
        
        if (keyword != null && !keyword.trim().isEmpty()) {
            patients = patientService.searchPatients(keyword);
            request.setAttribute("keyword", keyword);
        } else {
            patients = patientService.getAllPatients();
        }
        
        request.setAttribute("patients", patients);
        request.getRequestDispatcher("/WEB-INF/views/admin/patients/list.jsp").forward(request, response);
    }
    
    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String numeroDossier = patientService.generateNumeroDossier();
        request.setAttribute("numeroDossier", numeroDossier);
        request.getRequestDispatcher("/WEB-INF/views/admin/patients/form.jsp").forward(request, response);
    }
    
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Long id = Long.parseLong(request.getParameter("id"));
        Optional<Patient> patient = patientService.getPatientById(id);
        
        if (patient.isPresent()) {
            request.setAttribute("patient", patient.get());
            request.getRequestDispatcher("/WEB-INF/views/admin/patients/form.jsp").forward(request, response);
        } else {
            request.setAttribute("errorMessage", "Patient non trouvé");
            listPatients(request, response);
        }
    }
    
    private void savePatient(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Patient patient = extractPatientFromRequest(request);
        
        try {
            patientService.createPatient(patient);
            request.setAttribute("successMessage", "Patient créé avec succès");
            listPatients(request, response);
        } catch (IllegalArgumentException e) {
            request.setAttribute("errorMessage", e.getMessage());
            request.setAttribute("patient", patient);
            showNewForm(request, response);
        }
    }
    
    private void updatePatient(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Patient patient = extractPatientFromRequest(request);
        Long id = Long.parseLong(request.getParameter("id"));
        patient.setIdPatient(id);
        
        Optional<Patient> existingPatient = patientService.getPatientById(id);
        if (existingPatient.isPresent()) {
            Personne personne = existingPatient.get().getPersonne();
            personne.setNom(request.getParameter("nom"));
            personne.setPrenom(request.getParameter("prenom"));
            personne.setEmail(request.getParameter("email"));
            personne.setTelephone(request.getParameter("telephone"));
            personne.setAdresse(request.getParameter("adresse"));
            patient.setPersonne(personne);
        }
        
        try {
            patientService.updatePatient(patient);
            request.setAttribute("successMessage", "Patient mis à jour avec succès");
            listPatients(request, response);
        } catch (IllegalArgumentException e) {
            request.setAttribute("errorMessage", e.getMessage());
            request.setAttribute("patient", patient);
            showEditForm(request, response);
        }
    }
    
    private void deletePatient(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Long id = Long.parseLong(request.getParameter("id"));
        
        try {
            boolean deleted = patientService.deletePatient(id);
            if (deleted) {
                request.setAttribute("successMessage", "Patient supprimé avec succès");
            } else {
                request.setAttribute("errorMessage", "Échec de la suppression du patient");
            }
        } catch (IllegalStateException e) {
            request.setAttribute("errorMessage", e.getMessage());
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Erreur lors de la suppression: " + e.getMessage());
        }
        
        listPatients(request, response);
    }
    
    private Patient extractPatientFromRequest(HttpServletRequest request) {
        Patient patient = new Patient();
        Personne personne = new Personne();
        
        personne.setNom(request.getParameter("nom"));
        personne.setPrenom(request.getParameter("prenom"));
        personne.setEmail(request.getParameter("email"));
        personne.setTelephone(request.getParameter("telephone"));
        personne.setAdresse(request.getParameter("adresse"));
        personne.setTypePersonne(RoleUtilisateur.PATIENT);
        personne.setActif(true);
        personne.setDateCreation(LocalDateTime.now());
        
        if (request.getParameter("motDePasse") != null && !request.getParameter("motDePasse").trim().isEmpty()) {
            personne.setMotDePasse(request.getParameter("motDePasse"));
        } else {
            personne.setMotDePasse("patient123");
        }
        
        patient.setPersonne(personne);
        
        patient.setNumeroDossier(request.getParameter("numeroDossier"));
        
        String poidsStr = request.getParameter("poids");
        if (poidsStr != null && !poidsStr.trim().isEmpty()) {
            patient.setPoids(new BigDecimal(poidsStr));
        }
        
        String tailleStr = request.getParameter("taille");
        if (tailleStr != null && !tailleStr.trim().isEmpty()) {
            patient.setTaille(new BigDecimal(tailleStr));
        }
        
        patient.setGroupeSanguin(request.getParameter("groupeSanguin"));
        patient.setAllergies(request.getParameter("allergies"));
        patient.setAntecedentsMedicaux(request.getParameter("antecedentsMedicaux"));
        
        return patient;
    }
    
    private boolean isAdminAuthenticated(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("userConnecte") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        
        String userRole = (String) session.getAttribute("userRole");
        if (!"ADMIN".equals(userRole)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Accès refusé. Administrateur uniquement.");
            return false;
        }
        
        return true;
    }
}
