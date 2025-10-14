package com.example.medisphere.controller.admin;

import com.example.medisphere.model.entity.Departement;
import com.example.medisphere.repository.impl.DepartementRepositoryImpl;
import com.example.medisphere.repository.interfaces.IDepartementRepository;
import com.example.medisphere.service.impl.DepartementServiceImpl;
import com.example.medisphere.service.interfaces.IDepartementService;
import com.example.medisphere.util.JPAUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.util.Optional;


@WebServlet(name = "DepartementServlet", urlPatterns = {"/admin/departements"})
public class DepartementServlet extends HttpServlet {

    private static final String LIST_VIEW = "/WEB-INF/views/admin/departements/list.jsp";
    private static final String FORM_VIEW = "/WEB-INF/views/admin/departements/form.jsp";
    
    private transient IDepartementService departementService;

    @Override
    public void init() throws ServletException {
        IDepartementRepository repository = new DepartementRepositoryImpl(JPAUtil.getEntityManagerFactory());
        this.departementService = new DepartementServiceImpl(repository);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        
        try {
            if (action == null || "list".equals(action)) {
                listDepartements(req, resp);
            } else if ("create".equals(action)) {
                showCreateForm(req, resp);
            } else if ("edit".equals(action)) {
                showEditForm(req, resp);
            } else if ("delete".equals(action)) {
                deleteDepartement(req, resp);
            } else {
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Action invalide");
            }
        } catch (Exception e) {
            req.setAttribute("error", "Erreur: " + e.getMessage());
            listDepartements(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        
        try {
            if ("create".equals(action)) {
                createDepartement(req, resp);
            } else if ("update".equals(action)) {
                updateDepartement(req, resp);
            } else {
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Action invalide");
            }
        } catch (IllegalArgumentException | IllegalStateException e) {
            req.setAttribute("error", e.getMessage());
            req.setAttribute("nom", req.getParameter("nom"));
            req.setAttribute("description", req.getParameter("description"));
            req.getRequestDispatcher(FORM_VIEW).forward(req, resp);
        } catch (Exception e) {
            req.setAttribute("error", "Erreur: " + e.getMessage());
            listDepartements(req, resp);
        }
    }

    private void listDepartements(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        List<Departement> departements = departementService.getDepartementsWithDocteurs();
        req.setAttribute("departements", departements);
        req.getRequestDispatcher(LIST_VIEW).forward(req, resp);
    }


    private void showCreateForm(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        req.setAttribute("isEdit", false);
        req.getRequestDispatcher(FORM_VIEW).forward(req, resp);
    }


    private void showEditForm(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        Long id = Long.parseLong(req.getParameter("id"));
        Optional<Departement> departement = departementService.getDepartementById(id);
        
        if (departement.isPresent()) {
            req.setAttribute("departement", departement.get());
            req.setAttribute("isEdit", true);
            req.getRequestDispatcher(FORM_VIEW).forward(req, resp);
        } else {
            req.setAttribute("error", "Département introuvable");
            listDepartements(req, resp);
        }
    }


    private void createDepartement(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        String nom = req.getParameter("nom");
        String description = req.getParameter("description");

        departementService.createDepartement(nom, description);
        
        req.getSession().setAttribute("success", "Département créé avec succès");
        resp.sendRedirect(req.getContextPath() + "/admin/departements");
    }


    private void updateDepartement(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        Long id = Long.parseLong(req.getParameter("id"));
        String nom = req.getParameter("nom");
        String description = req.getParameter("description");

        departementService.updateDepartement(id, nom, description);
        
        req.getSession().setAttribute("success", "Département mis à jour avec succès");
        resp.sendRedirect(req.getContextPath() + "/admin/departements");
    }


    private void deleteDepartement(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        Long id = Long.parseLong(req.getParameter("id"));
        
        boolean deleted = departementService.deleteDepartement(id);
        
        if (deleted) {
            req.getSession().setAttribute("success", "Département supprimé avec succès");
        } else {
            req.getSession().setAttribute("error", "Département introuvable");
        }
        
        resp.sendRedirect(req.getContextPath() + "/admin/departements");
    }
}
