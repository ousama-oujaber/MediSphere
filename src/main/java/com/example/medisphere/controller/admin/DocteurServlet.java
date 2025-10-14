package com.example.medisphere.controller.admin;

import com.example.medisphere.model.entity.Departement;
import com.example.medisphere.model.entity.Docteur;
import com.example.medisphere.model.entity.Personne;
import com.example.medisphere.model.enums.RoleUtilisateur;
import com.example.medisphere.repository.impl.DepartementRepositoryImpl;
import com.example.medisphere.repository.interfaces.IDepartementRepository;
import com.example.medisphere.service.impl.DocteurServiceImpl;
import com.example.medisphere.service.interfaces.IDocteurService;
import com.example.medisphere.util.JPAUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;


@WebServlet(name = "DocteurServlet", urlPatterns = {"/admin/docteurs"})
public class DocteurServlet extends HttpServlet {

    private static final String LIST_VIEW = "/WEB-INF/views/admin/docteurs/list.jsp";
    private static final String FORM_VIEW = "/WEB-INF/views/admin/docteurs/form.jsp";
    private static final String LOGIN_URL = "/login";

    private IDocteurService docteurService;
    private IDepartementRepository departementRepository;

    @Override
    public void init() {
        this.docteurService = new DocteurServiceImpl();
        this.departementRepository = new DepartementRepositoryImpl(JPAUtil.getEntityManagerFactory());
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userConnecte") == null) {
            resp.sendRedirect(req.getContextPath() + LOGIN_URL);
            return;
        }

        String userRole = (String) session.getAttribute("userRole");
        if (!"ADMIN".equals(userRole)) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }

        String action = req.getParameter("action");
        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {
                case "new" -> showNewForm(req, resp);
                case "edit" -> showEditForm(req, resp);
                case "delete" -> deleteDoctor(req, resp);
                default -> listDoctors(req, resp);
            }
        } catch (Exception e) {
            req.setAttribute("error", "Error: " + e.getMessage());
            listDoctors(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userConnecte") == null) {
            resp.sendRedirect(req.getContextPath() + LOGIN_URL);
            return;
        }

        String userRole = (String) session.getAttribute("userRole");
        if (!"ADMIN".equals(userRole)) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }

        String action = req.getParameter("action");
        
        try {
            if ("create".equals(action)) {
                createDoctor(req, resp);
            } else if ("update".equals(action)) {
                updateDoctor(req, resp);
            } else {
                listDoctors(req, resp);
            }
        } catch (Exception e) {
            req.setAttribute("error", "Error: " + e.getMessage());
            req.setAttribute("docteur", buildDocteurFromRequest(req));
            loadDepartments(req);
            req.getRequestDispatcher(FORM_VIEW).forward(req, resp);
        }
    }


    private void listDoctors(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Docteur> docteurs = docteurService.getAllDocteurs();
        req.setAttribute("docteurs", docteurs);
        req.getRequestDispatcher(LIST_VIEW).forward(req, resp);
    }


    private void showNewForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        loadDepartments(req);
        req.setAttribute("action", "create");
        req.getRequestDispatcher(FORM_VIEW).forward(req, resp);
    }


    private void showEditForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Long id = Long.parseLong(req.getParameter("id"));
        Optional<Docteur> docteur = docteurService.getDocteurById(id);

        if (docteur.isPresent()) {
            req.setAttribute("docteur", docteur.get());
            req.setAttribute("action", "update");
            loadDepartments(req);
            req.getRequestDispatcher(FORM_VIEW).forward(req, resp);
        } else {
            req.setAttribute("error", "Doctor not found");
            listDoctors(req, resp);
        }
    }


    private void createDoctor(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Docteur docteur = buildDocteurFromRequest(req);
        
        docteurService.createDocteur(docteur);
        
        req.setAttribute("success", "Doctor created successfully");
        listDoctors(req, resp);
    }


    private void updateDoctor(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Long id = Long.parseLong(req.getParameter("id"));
        
        Optional<Docteur> existingDocteur = docteurService.getDocteurById(id);
        if (existingDocteur.isEmpty()) {
            req.setAttribute("error", "Doctor not found");
            listDoctors(req, resp);
            return;
        }
        
        Docteur docteur = existingDocteur.get();
        
        docteur.getPersonne().setNom(req.getParameter("nom"));
        docteur.getPersonne().setPrenom(req.getParameter("prenom"));
        docteur.getPersonne().setEmail(req.getParameter("email"));
        docteur.getPersonne().setTelephone(req.getParameter("telephone"));
        
        // Update password only if provided
        String password = req.getParameter("motDePasse");
        if (password != null && !password.trim().isEmpty()) {
            docteur.getPersonne().setMotDePasse(password);
        }
        
        docteur.setSpecialite(req.getParameter("specialite"));
        docteur.setNumeroOrdre(req.getParameter("numeroOrdre"));
        
        String experienceStr = req.getParameter("anneesExperience");
        if (experienceStr != null && !experienceStr.trim().isEmpty()) {
            docteur.setAnneesExperience(Integer.parseInt(experienceStr));
        }
        
        String tarifStr = req.getParameter("tarifConsultation");
        if (tarifStr != null && !tarifStr.trim().isEmpty()) {
            docteur.setTarifConsultation(new BigDecimal(tarifStr));
        }
        
        docteur.setBiographie(req.getParameter("biographie"));
        docteur.setDisponible(req.getParameter("disponible") != null);
        
        Long deptId = Long.parseLong(req.getParameter("departementId"));
        Optional<Departement> dept = departementRepository.findById(deptId);
        dept.ifPresent(docteur::setDepartement);
        
        docteurService.updateDocteur(docteur);
        
        req.setAttribute("success", "Doctor updated successfully");
        listDoctors(req, resp);
    }


    private void deleteDoctor(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Long id = Long.parseLong(req.getParameter("id"));
        
        if (docteurService.deleteDocteur(id)) {
            req.setAttribute("success", "Doctor deleted successfully");
        } else {
            req.setAttribute("error", "Failed to delete doctor");
        }
        
        listDoctors(req, resp);
    }


    private Docteur buildDocteurFromRequest(HttpServletRequest req) {
        Personne personne = new Personne();
        personne.setTypePersonne(RoleUtilisateur.DOCTEUR);
        personne.setNom(req.getParameter("nom"));
        personne.setPrenom(req.getParameter("prenom"));
        personne.setEmail(req.getParameter("email"));
        personne.setMotDePasse(req.getParameter("motDePasse"));
        personne.setTelephone(req.getParameter("telephone"));
        personne.setActif(true);

        Docteur docteur = new Docteur();
        docteur.setPersonne(personne);
        docteur.setSpecialite(req.getParameter("specialite"));
        docteur.setNumeroOrdre(req.getParameter("numeroOrdre"));
        
        String experienceStr = req.getParameter("anneesExperience");
        if (experienceStr != null && !experienceStr.trim().isEmpty()) {
            docteur.setAnneesExperience(Integer.parseInt(experienceStr));
        }
        
        String tarifStr = req.getParameter("tarifConsultation");
        if (tarifStr != null && !tarifStr.trim().isEmpty()) {
            docteur.setTarifConsultation(new BigDecimal(tarifStr));
        }
        
        docteur.setBiographie(req.getParameter("biographie"));
        docteur.setDisponible(req.getParameter("disponible") != null);

        Long deptId = Long.parseLong(req.getParameter("departementId"));
        Optional<Departement> dept = departementRepository.findById(deptId);
        dept.ifPresent(docteur::setDepartement);

        return docteur;
    }


    private void loadDepartments(HttpServletRequest req) {
        List<Departement> departements = departementRepository.findAll();
        req.setAttribute("départements", departements);
    }
}
