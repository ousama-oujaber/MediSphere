<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nos Docteurs - MediSphere</title>

    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        .gradient-bg {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        .doctor-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 30px rgba(0,0,0,0.15);
        }
        .department-badge {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
    </style>
</head>

<body class="bg-gray-50">

<!-- Sidebar -->
<div class="fixed inset-y-0 left-0 w-64 gradient-bg text-white z-50 flex flex-col">
    <!-- Logo -->
    <div class="flex items-center justify-center h-20 border-b border-white border-opacity-20">
        <i class="fas fa-heartbeat text-3xl mr-2"></i>
        <span class="text-2xl font-bold">MediSphere</span>
    </div>

    <!-- Navigation -->
    <nav class="flex-1 px-4 py-6 space-y-2 overflow-y-auto">
        <a href="${pageContext.request.contextPath}/patient/dashboard"
           class="flex items-center px-4 py-3 rounded-lg hover:bg-white hover:bg-opacity-10 transition">
            <i class="fas fa-home w-6"></i>
            <span class="ml-3">Tableau de Bord</span>
        </a>

        <a href="${pageContext.request.contextPath}/patient/docteurs"
           class="flex items-center px-4 py-3 rounded-lg bg-white bg-opacity-20">
            <i class="fas fa-user-md w-6"></i>
            <span class="ml-3">Nos Docteurs</span>
        </a>

        <a href="${pageContext.request.contextPath}/patient/reservation"
           class="flex items-center px-4 py-3 rounded-lg hover:bg-white hover:bg-opacity-10 transition">
            <i class="fas fa-calendar-plus w-6"></i>
            <span class="ml-3">Réserver</span>
        </a>

        <a href="${pageContext.request.contextPath}/patient/historique"
           class="flex items-center px-4 py-3 rounded-lg hover:bg-white hover:bg-opacity-10 transition">
            <i class="fas fa-history w-6"></i>
            <span class="ml-3">Historique</span>
        </a>
    </nav>

    <!-- Logout -->
    <div class="p-4 border-t border-white border-opacity-20">
        <a href="${pageContext.request.contextPath}/auth/logout"
           class="flex items-center px-4 py-3 rounded-lg hover:bg-white hover:bg-opacity-10 transition">
            <i class="fas fa-sign-out-alt w-6"></i>
            <span class="ml-3">Déconnexion</span>
        </a>
    </div>
</div>

<!-- Main Content -->
<div class="ml-64 p-8">

    <!-- Header -->
    <div class="mb-8">
        <h1 class="text-3xl font-bold text-gray-800 mb-2">Nos Docteurs</h1>
        <p class="text-gray-600">Trouvez le spécialiste qu'il vous faut</p>
    </div>

    <!-- Error Message -->
    <c:if test="${not empty error}">
        <div class="mb-6 bg-red-50 border-l-4 border-red-500 p-4 rounded">
            <div class="flex items-center">
                <i class="fas fa-exclamation-circle text-red-500 mr-3"></i>
                <p class="text-red-700"><c:out value="${error}" /></p>
            </div>
        </div>
    </c:if>

    <!-- Filters -->
    <div class="bg-white rounded-xl shadow-sm p-6 mb-8">
        <form method="get" action="${pageContext.request.contextPath}/patient/docteurs" class="flex gap-4 items-end">
            <div class="flex-1">
                <label class="block text-sm font-medium text-gray-700 mb-2">
                    <i class="fas fa-hospital mr-1"></i> Filtrer par Département
                </label>
                <select name="departement"
                        class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500">
                    <option value="">Tous les départements</option>
                    <c:forEach var="dept" items="${departements}">
                        <option value="${dept.idDepartement}" <c:if test="${selectedDepartement == dept.idDepartement}">selected</c:if>>
                            <c:out value="${dept.nom}" />
                        </option>
                    </c:forEach>
                </select>
            </div>

            <button type="submit"
                    class="px-6 py-2 gradient-bg text-white rounded-lg hover:opacity-90 transition">
                <i class="fas fa-search mr-2"></i> Filtrer
            </button>

            <a href="${pageContext.request.contextPath}/patient/docteurs"
               class="px-6 py-2 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition">
                <i class="fas fa-redo mr-2"></i> Réinitialiser
            </a>
        </form>
    </div>

    <!-- Doctors Grid -->
    <c:choose>
        <c:when test="${empty docteurs}">
            <div class="bg-white rounded-xl shadow-sm p-12 text-center">
                <i class="fas fa-user-md text-6xl text-gray-300 mb-4"></i>
                <h3 class="text-xl font-semibold text-gray-700 mb-2">Aucun docteur trouvé</h3>
                <p class="text-gray-500 mb-6">Essayez de modifier vos critères de recherche</p>
                <a href="${pageContext.request.contextPath}/patient/docteurs"
                   class="inline-flex items-center px-6 py-3 gradient-bg text-white rounded-lg hover:opacity-90 transition">
                    <i class="fas fa-users mr-2"></i> Voir tous les docteurs
                </a>
            </div>
        </c:when>

        <c:otherwise>
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                <c:forEach var="docteur" items="${docteurs}">
                    <div class="doctor-card bg-white rounded-xl shadow-md overflow-hidden transition-all duration-300">
                        <div class="gradient-bg p-6 text-white text-center">
                            <div class="w-20 h-20 mx-auto bg-white bg-opacity-20 rounded-full flex items-center justify-center text-2xl font-bold mb-3">
                                ${docteur.personne.prenom.substring(0,1)}${docteur.personne.nom.substring(0,1)}
                            </div>
                            <h3 class="text-xl font-bold">Dr. ${docteur.personne.nom} ${docteur.personne.prenom}</h3>
                            <p class="text-white text-opacity-90 text-sm mt-1">
                                <i class="fas fa-stethoscope mr-1"></i> ${docteur.specialite}
                            </p>
                        </div>

                        <div class="p-6 text-center">
                            <div class="mb-4">
                                <span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium text-white department-badge">
                                    <i class="fas fa-hospital-alt mr-2"></i> ${docteur.departement.nom}
                                </span>
                            </div>

                            <div class="text-sm text-gray-600 space-y-2">
                                <p><i class="fas fa-envelope text-purple-600 w-5"></i> ${docteur.personne.email}</p>
                                <c:if test="${not empty docteur.personne.telephone}">
                                    <p><i class="fas fa-phone text-purple-600 w-5"></i> ${docteur.personne.telephone}</p>
                                </c:if>
                            </div>

                            <a href="${pageContext.request.contextPath}/patient/reservation?docteurId=${docteur.idDocteur}"
                               class="block w-full text-center px-6 py-3 mt-6 gradient-bg text-white rounded-lg hover:opacity-90 transition font-semibold">
                                <i class="fas fa-calendar-plus mr-2"></i> Prendre Rendez-vous
                            </a>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>

</div>

</body>
</html>
