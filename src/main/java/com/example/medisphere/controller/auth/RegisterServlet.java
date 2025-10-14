package com.example.medisphere.controller.auth;

import com.example.medisphere.util.JPAUtil;
import com.example.medisphere.repository.impl.PatientRepositoryImpl;
import com.example.medisphere.repository.interfaces.IPatientRepository;
import com.example.medisphere.service.impl.PatientServiceImpl;
import com.example.medisphere.service.interfaces.IPatientService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;


@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {
    
    private static final String REGISTER_VIEW = "/WEB-INF/views/auth/register.jsp";
    private static final String ERROR_ATTR = "error";
    
    private transient IPatientService patientService;
    
    @Override
    public void init() throws ServletException {
        IPatientRepository patientRepository = new PatientRepositoryImpl(JPAUtil.getEntityManagerFactory());
        this.patientService = new PatientServiceImpl(patientRepository);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
                request.getRequestDispatcher(REGISTER_VIEW).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        String nom = request.getParameter("nom");
        String prenom = request.getParameter("prenom");
        String email = request.getParameter("email");
        String motDePasse = request.getParameter("motDePasse");
        String confirmMotDePasse = request.getParameter("confirmMotDePasse");
        String telephone = request.getParameter("telephone");
        
        try {
            if (!motDePasse.equals(confirmMotDePasse)) {
                setErrorAndForward(request, response, "Les mots de passe ne correspondent pas", 
                    nom, prenom, email, telephone);
                return;
            }
            
            patientService.registerPatient(nom, prenom, email, motDePasse, telephone);
            
            request.getSession().setAttribute("successMessage",
                "Inscription réussie ! Vous pouvez maintenant vous connecter.");
            response.sendRedirect(request.getContextPath() + "/login");
            
        } catch (IllegalStateException | IllegalArgumentException e) {
            setErrorAndForward(request, response, e.getMessage(), nom, prenom, email, telephone);
            
        } catch (Exception e) {
            setErrorAndForward(request, response,
                "Une erreur est survenue lors de l'inscription. Veuillez réessayer.", 
                nom, prenom, email, telephone);
        }
    }

    private void setErrorAndForward(HttpServletRequest request, HttpServletResponse response,
                                     String errorMessage, String nom, String prenom, 
                                     String email, String telephone) 
            throws ServletException, IOException {
        request.setAttribute(ERROR_ATTR, errorMessage);
        request.setAttribute("nom", nom);
        request.setAttribute("prenom", prenom);
        request.setAttribute("email", email);
        request.setAttribute("telephone", telephone);
        request.getRequestDispatcher(REGISTER_VIEW).forward(request, response);
    }
}
