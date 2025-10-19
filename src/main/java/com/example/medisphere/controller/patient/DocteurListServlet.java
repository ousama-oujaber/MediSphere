package com.example.medisphere.controller.patient;

import com.example.medisphere.model.entity.Departement;
import com.example.medisphere.model.entity.Docteur;
import com.example.medisphere.model.entity.Personne;
import com.example.medisphere.model.enums.RoleUtilisateur;
import com.example.medisphere.repository.impl.DepartementRepositoryImpl;
import com.example.medisphere.repository.impl.DocteurRepositoryImpl;
import com.example.medisphere.service.impl.DepartementServiceImpl;
import com.example.medisphere.service.impl.DocteurServiceImpl;
import com.example.medisphere.service.interfaces.IDepartementService;
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

 
@WebServlet(name = "DocteurListServlet", urlPatterns = {"/patient/docteurs"})
public class DocteurListServlet extends HttpServlet {
    
    private static final String DOCTEURS_VIEW = "/WEB-INF/views/patient/docteurs.jsp";
    private static final String LOGIN_URL = "/login";
    
    private IDocteurService docteurService;
    private IDepartementService departementService;
    
    @Override
    public void init() throws ServletException {
        super.init();
        DocteurRepositoryImpl docteurRepository = new DocteurRepositoryImpl(JPAUtil.getEntityManagerFactory());
        this.docteurService = new DocteurServiceImpl(docteurRepository);
        DepartementRepositoryImpl departementRepository = new DepartementRepositoryImpl(JPAUtil.getEntityManagerFactory());
        this.departementService = new DepartementServiceImpl(departementRepository);
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
            
            String departementIdParam = request.getParameter("departement");
            String specialiteParam = request.getParameter("specialite");
            
            List<Docteur> docteurs;
            
            
            if (departementIdParam != null && !departementIdParam.isEmpty()) {
                
                Long departementId = Long.parseLong(departementIdParam);
                docteurs = docteurService.getDocteursByDepartement(departementId);
            } else if (specialiteParam != null && !specialiteParam.isEmpty()) {
                
                docteurs = docteurService.getDocteursBySpecialite(specialiteParam);
            } else {
                
                docteurs = docteurService.getAllDocteurs();
            }
            
            
            List<Departement> departements = departementService.getAllDepartements();
            
            
            request.setAttribute("docteurs", docteurs);
            request.setAttribute("departements", departements);
            request.setAttribute("selectedDepartement", departementIdParam);
            request.setAttribute("selectedSpecialite", specialiteParam);
            
            request.getRequestDispatcher(DOCTEURS_VIEW).forward(request, response);
            
        } catch (Exception e) {
            request.setAttribute("error", "Erreur lors du chargement des docteurs: " + e.getMessage());
            request.getRequestDispatcher(DOCTEURS_VIEW).forward(request, response);
        }
    }
}
