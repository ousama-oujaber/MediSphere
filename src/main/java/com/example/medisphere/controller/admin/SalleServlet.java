package com.example.medisphere.controller.admin;

import com.example.medisphere.model.entity.Salle;
import com.example.medisphere.service.impl.SalleServiceImpl;
import com.example.medisphere.service.interfaces.ISalleService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;


@WebServlet(name = "SalleServlet", urlPatterns = {"/admin/salles"})
public class SalleServlet extends HttpServlet {

    private static final String LIST_VIEW = "/WEB-INF/views/admin/salles/list.jsp";
    private static final String FORM_VIEW = "/WEB-INF/views/admin/salles/form.jsp";
    private static final String LOGIN_URL = "/login";

    private ISalleService salleService;

    @Override
    public void init() {
        salleService = new SalleServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userConnecte") == null) {
            response.sendRedirect(request.getContextPath() + LOGIN_URL);
            return;
        }

        String userRole = (String) session.getAttribute("userRole");
        if (!"ADMIN".equals(userRole)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Accès refusé");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "new":
                showNewForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteSalle(request, response);
                break;
            default:
                listSalles(request, response);
                break;
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

        String action = request.getParameter("action");
        if ("save".equals(action)) {
            saveSalle(request, response);
        } else if ("update".equals(action)) {
            updateSalle(request, response);
        }
    }

    private void listSalles(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Salle> salles = salleService.getAllSalles();
            request.setAttribute("salles", salles);
            request.getRequestDispatcher(LIST_VIEW).forward(request, response);
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Erreur lors du chargement des salles: " + e.getMessage());
            request.getRequestDispatcher(LIST_VIEW).forward(request, response);
        }
    }


    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("salle", new Salle());
        request.setAttribute("action", "save");
        request.getRequestDispatcher(FORM_VIEW).forward(request, response);
    }


    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Long id = Long.parseLong(request.getParameter("id"));
            Salle salle = salleService.getSalleById(id);

            if (salle == null) {
                request.setAttribute("errorMessage", "Salle non trouvée");
                listSalles(request, response);
                return;
            }

            request.setAttribute("salle", salle);
            request.setAttribute("action", "update");
            request.getRequestDispatcher(FORM_VIEW).forward(request, response);
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "ID invalide");
            listSalles(request, response);
        }
    }


    private void saveSalle(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Salle salle = extractSalleFromRequest(request);
            salleService.createSalle(salle);
            response.sendRedirect(request.getContextPath() + "/admin/salles?success=created");
        } catch (IllegalArgumentException e) {
            request.setAttribute("errorMessage", e.getMessage());
            request.setAttribute("salle", extractSalleFromRequest(request));
            request.setAttribute("action", "save");
            request.getRequestDispatcher(FORM_VIEW).forward(request, response);
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Erreur lors de la création: " + e.getMessage());
            request.setAttribute("salle", extractSalleFromRequest(request));
            request.setAttribute("action", "save");
            request.getRequestDispatcher(FORM_VIEW).forward(request, response);
        }
    }


    private void updateSalle(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Salle salle = extractSalleFromRequest(request);
            Long id = Long.parseLong(request.getParameter("id"));
            salle.setIdSalle(id);

            salleService.updateSalle(salle);
            response.sendRedirect(request.getContextPath() + "/admin/salles?success=updated");
        } catch (IllegalArgumentException e) {
            request.setAttribute("errorMessage", e.getMessage());
            request.setAttribute("salle", extractSalleFromRequest(request));
            request.setAttribute("action", "update");
            request.getRequestDispatcher(FORM_VIEW).forward(request, response);
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Erreur lors de la mise à jour: " + e.getMessage());
            request.setAttribute("salle", extractSalleFromRequest(request));
            request.setAttribute("action", "update");
            request.getRequestDispatcher(FORM_VIEW).forward(request, response);
        }
    }


    private void deleteSalle(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            Long id = Long.parseLong(request.getParameter("id"));
            salleService.deleteSalle(id);
            response.sendRedirect(request.getContextPath() + "/admin/salles?success=deleted");
        } catch (IllegalArgumentException e) {
            response.sendRedirect(request.getContextPath() + "/admin/salles?error=" + e.getMessage());
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/admin/salles?error=Erreur lors de la suppression");
        }
    }


    private Salle extractSalleFromRequest(HttpServletRequest request) {
        Salle salle = new Salle();
        salle.setNomSalle(request.getParameter("nomSalle"));

        String numeroEtageStr = request.getParameter("numeroEtage");
        if (numeroEtageStr != null && !numeroEtageStr.trim().isEmpty()) {
            salle.setNumeroEtage(Integer.parseInt(numeroEtageStr));
        }

        String capaciteStr = request.getParameter("capacite");
        if (capaciteStr != null && !capaciteStr.trim().isEmpty()) {
            salle.setCapacite(Integer.parseInt(capaciteStr));
        }

        salle.setEquipements(request.getParameter("equipements"));

        String disponibleStr = request.getParameter("disponible");
        salle.setDisponible(disponibleStr != null && disponibleStr.equals("on"));

        return salle;
    }
}
