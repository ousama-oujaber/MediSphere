<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tableau de Bord Patient - MediSphere</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .gradient-bg {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        .card-hover:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
        }
        .icon-wrapper {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        .status-badge {
            padding: 0.25rem 0.75rem;
            border-radius: 9999px;
            font-size: 0.75rem;
            font-weight: 600;
        }
        .status-reservee {
            background-color: #fef3c7;
            color: #92400e;
        }
        .status-validee {
            background-color: #dbeafe;
            color: #1e40af;
        }
        .status-terminee {
            background-color: #d1fae5;
            color: #065f46;
        }
        .status-annulee {
            background-color: #fee2e2;
            color: #991b1b;
        }
    </style>
</head>
<body class="bg-gray-50">

    <!-- Navigation Sidebar -->
    <div class="fixed inset-y-0 left-0 w-64 gradient-bg text-white transform transition-transform duration-300 ease-in-out z-50">
        <div class="flex flex-col h-full">
            <!-- Logo -->
            <div class="flex items-center justify-center h-20 border-b border-white border-opacity-20">
                <i class="fas fa-heartbeat text-3xl mr-2"></i>
                <span class="text-2xl font-bold">MediSphere</span>
            </div>
            
            <!-- User Info -->
            <div class="p-6 border-b border-white border-opacity-20">
                <div class="flex items-center space-x-3">
                    <div class="w-12 h-12 rounded-full bg-white bg-opacity-20 flex items-center justify-center">
                        <i class="fas fa-user text-xl"></i>
                    </div>
                    <div>
                        <p class="font-semibold"><c:out value="${patient.personne.prenom}" /> <c:out value="${patient.personne.nom}" /></p>
                        <p class="text-sm opacity-75">Patient</p>
                    </div>
                </div>
            </div>
            
            <!-- Navigation Menu -->
            <nav class="flex-1 px-4 py-6 space-y-2 overflow-y-auto">
                <a href="${pageContext.request.contextPath}/patient/dashboard" 
                   class="flex items-center px-4 py-3 rounded-lg bg-white bg-opacity-20 transition-colors">
                    <i class="fas fa-home w-6"></i>
                    <span class="ml-3">Tableau de Bord</span>
                </a>
                <a href="${pageContext.request.contextPath}/patient/docteurs" 
                   class="flex items-center px-4 py-3 rounded-lg hover:bg-white hover:bg-opacity-10 transition-colors">
                    <i class="fas fa-user-md w-6"></i>
                    <span class="ml-3">Nos Docteurs</span>
                </a>
                <a href="${pageContext.request.contextPath}/patient/reservation" 
                   class="flex items-center px-4 py-3 rounded-lg hover:bg-white hover:bg-opacity-10 transition-colors">
                    <i class="fas fa-calendar-plus w-6"></i>
                    <span class="ml-3">Réserver</span>
                </a>
                <a href="${pageContext.request.contextPath}/patient/historique" 
                   class="flex items-center px-4 py-3 rounded-lg hover:bg-white hover:bg-opacity-10 transition-colors">
                    <i class="fas fa-history w-6"></i>
                    <span class="ml-3">Historique</span>
                </a>
            </nav>
            
            <!-- Logout -->
            <div class="p-4 border-t border-white border-opacity-20">
                <a href="${pageContext.request.contextPath}/logout" 
                   class="flex items-center px-4 py-3 rounded-lg hover:bg-white hover:bg-opacity-10 transition-colors">
                    <i class="fas fa-sign-out-alt w-6"></i>
                    <span class="ml-3">Déconnexion</span>
                </a>
            </div>
        </div>
    </div>

    <!-- Main Content -->
    <div class="ml-64 p-8">
        <!-- Header -->
        <div class="mb-8">
            <h1 class="text-3xl font-bold text-gray-800 mb-2">Tableau de Bord</h1>
            <p class="text-gray-600">Bienvenue, <c:out value="${patient.personne.prenom}" />! Voici un aperçu de vos consultations.</p>
        </div>

        <!-- Error/Success Messages -->
        <c:if test="${not empty error}">
            <div class="mb-6 bg-red-50 border-l-4 border-red-500 p-4 rounded">
                <div class="flex items-center">
                    <i class="fas fa-exclamation-circle text-red-500 mr-3"></i>
                    <p class="text-red-700"><c:out value="${error}" /></p>
                </div>
            </div>
        </c:if>
        
        <c:if test="${not empty success}">
            <div class="mb-6 bg-green-50 border-l-4 border-green-500 p-4 rounded">
                <div class="flex items-center">
                    <i class="fas fa-check-circle text-green-500 mr-3"></i>
                    <p class="text-green-700"><c:out value="${success}" /></p>
                </div>
            </div>
        </c:if>

        <!-- Statistics Cards -->
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
            <!-- Total Consultations -->
            <div class="bg-white rounded-xl shadow-sm p-6 card-hover transition-all">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-gray-500 text-sm font-medium mb-1">Total Consultations</p>
                        <p class="text-3xl font-bold text-gray-800">${totalConsultations}</p>
                    </div>
                    <div class="icon-wrapper w-14 h-14 rounded-lg flex items-center justify-center">
                        <i class="fas fa-notes-medical text-white text-xl"></i>
                    </div>
                </div>
            </div>

            <!-- Reserved -->
            <div class="bg-white rounded-xl shadow-sm p-6 card-hover transition-all">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-gray-500 text-sm font-medium mb-1">Réservées</p>
                        <p class="text-3xl font-bold text-yellow-600">${consultationsReservees}</p>
                    </div>
                    <div class="w-14 h-14 rounded-lg bg-yellow-100 flex items-center justify-center">
                        <i class="fas fa-clock text-yellow-600 text-xl"></i>
                    </div>
                </div>
            </div>

            <!-- Validated -->
            <div class="bg-white rounded-xl shadow-sm p-6 card-hover transition-all">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-gray-500 text-sm font-medium mb-1">Validées</p>
                        <p class="text-3xl font-bold text-blue-600">${consultationsValidees}</p>
                    </div>
                    <div class="w-14 h-14 rounded-lg bg-blue-100 flex items-center justify-center">
                        <i class="fas fa-check-circle text-blue-600 text-xl"></i>
                    </div>
                </div>
            </div>

            <!-- Completed -->
            <div class="bg-white rounded-xl shadow-sm p-6 card-hover transition-all">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-gray-500 text-sm font-medium mb-1">Terminées</p>
                        <p class="text-3xl font-bold text-green-600">${consultationsTerminees}</p>
                    </div>
                    <div class="w-14 h-14 rounded-lg bg-green-100 flex items-center justify-center">
                        <i class="fas fa-check-double text-green-600 text-xl"></i>
                    </div>
                </div>
            </div>
        </div>

        <!-- Quick Actions -->
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
            <a href="${pageContext.request.contextPath}/patient/docteurs" 
               class="bg-white rounded-xl shadow-sm p-6 card-hover transition-all hover:shadow-md">
                <div class="flex items-center space-x-4">
                    <div class="w-12 h-12 rounded-lg bg-purple-100 flex items-center justify-center">
                        <i class="fas fa-user-md text-purple-600 text-xl"></i>
                    </div>
                    <div>
                        <h3 class="font-semibold text-gray-800">Consulter les Docteurs</h3>
                        <p class="text-sm text-gray-500">Parcourir par spécialité</p>
                    </div>
                </div>
            </a>

            <a href="${pageContext.request.contextPath}/patient/reservation" 
               class="bg-white rounded-xl shadow-sm p-6 card-hover transition-all hover:shadow-md">
                <div class="flex items-center space-x-4">
                    <div class="w-12 h-12 rounded-lg bg-blue-100 flex items-center justify-center">
                        <i class="fas fa-calendar-plus text-blue-600 text-xl"></i>
                    </div>
                    <div>
                        <h3 class="font-semibold text-gray-800">Nouvelle Réservation</h3>
                        <p class="text-sm text-gray-500">Prendre rendez-vous</p>
                    </div>
                </div>
            </a>

            <a href="${pageContext.request.contextPath}/patient/historique" 
               class="bg-white rounded-xl shadow-sm p-6 card-hover transition-all hover:shadow-md">
                <div class="flex items-center space-x-4">
                    <div class="w-12 h-12 rounded-lg bg-green-100 flex items-center justify-center">
                        <i class="fas fa-history text-green-600 text-xl"></i>
                    </div>
                    <div>
                        <h3 class="font-semibold text-gray-800">Mon Historique</h3>
                        <p class="text-sm text-gray-500">Voir toutes mes consultations</p>
                    </div>
                </div>
            </a>
        </div>

        <!-- Upcoming Consultations -->
        <div class="bg-white rounded-xl shadow-sm mb-8">
            <div class="p-6 border-b border-gray-100">
                <h2 class="text-xl font-bold text-gray-800">
                    <i class="fas fa-calendar-alt text-purple-600 mr-2"></i>
                    Consultations à Venir
                </h2>
            </div>
            <div class="p-6">
                <c:choose>
                    <c:when test="${empty upcomingConsultations}">
                        <div class="text-center py-8">
                            <i class="fas fa-calendar-times text-gray-300 text-5xl mb-4"></i>
                            <p class="text-gray-500">Aucune consultation à venir</p>
                            <a href="${pageContext.request.contextPath}/patient/reservation" 
                               class="inline-block mt-4 px-6 py-2 gradient-bg text-white rounded-lg hover:opacity-90 transition-opacity">
                                Prendre un rendez-vous
                            </a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="overflow-x-auto">
                            <table class="w-full">
                                <thead>
                                    <tr class="text-left text-sm font-semibold text-gray-600 border-b">
                                        <th class="pb-3 px-4">Date & Heure</th>
                                        <th class="pb-3 px-4">Docteur</th>
                                        <th class="pb-3 px-4">Département</th>
                                        <th class="pb-3 px-4">Salle</th>
                                        <th class="pb-3 px-4">Statut</th>
                                        <th class="pb-3 px-4">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="consultation" items="${upcomingConsultations}">
                                    <tr class="border-b border-gray-100 hover:bg-gray-50 transition-colors">
                                        <td class="py-4 px-4">
                                            <div>
                                                <p class="font-medium text-gray-800">${consultation.dateConsultation}</p>
                                                <p class="text-sm text-gray-500">
                                                    <i class="fas fa-clock mr-1"></i>${consultation.heureConsultation}
                                                </p>
                                            </div>
                                        </td>
                                        <td class="py-4 px-4">
                                            <p class="font-medium text-gray-800">
                                                Dr. <c:out value="${consultation.docteur.personne.prenom}" />
                                                <c:out value="${consultation.docteur.personne.nom}" />
                                            </p>
                                            <p class="text-sm text-gray-500">
                                                <c:out value="${consultation.docteur.specialite}" />
                                            </p>
                                        </td>
                                        <td class="py-4 px-4">
                                            <c:out value="${consultation.docteur.departement.nom}" />
                                        </td>
                                        <td class="py-4 px-4">
                                            <c:out value="${consultation.salle.nomSalle}" />
                                        </td>
                                        <td class="py-4 px-4">
                                            <span class="status-badge status-${consultation.statut.name().toLowerCase()}">
                                                <c:out value="${consultation.statut}" />
                                            </span>
                                        </td>
                                        <td class="py-4 px-4">
                                            <c:if test="${consultation.statut == 'RESERVEE'}">
                                                <div class="flex space-x-2">
                                                    <a href="${pageContext.request.contextPath}/patient/modifier-reservation?id=${consultation.idConsultation}"
                                                       class="text-blue-600 hover:text-blue-900 text-sm">
                                                        <i class="fas fa-edit mr-1"></i>
                                                        Modifier
                                                    </a>
                                                </div>
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Recent Completed Consultations -->
        <c:if test="${not empty recentConsultations}">
            <div class="bg-white rounded-xl shadow-sm">
                <div class="p-6 border-b border-gray-100">
                    <h2 class="text-xl font-bold text-gray-800">
                        <i class="fas fa-file-medical text-purple-600 mr-2"></i>
                        Consultations Récentes Terminées
                    </h2>
                </div>
                <div class="p-6">
                    <div class="space-y-4">
                        <c:forEach var="consultation" items="${recentConsultations}">
                            <div class="border border-gray-200 rounded-lg p-4 hover:shadow-md transition-shadow">
                                <div class="flex items-start justify-between mb-3">
                                    <div>
                                        <p class="font-semibold text-gray-800">
                                            Dr. <c:out value="${consultation.docteur.personne.prenom}" />
                                            <c:out value="${consultation.docteur.personne.nom}" />
                                        </p>
                                        <p class="text-sm text-gray-500">
                                            ${consultation.dateConsultation} à ${consultation.heureConsultation}
                                        </p>
                                    </div>
                                    <span class="status-badge status-terminee">
                                        <c:out value="${consultation.statut}" />
                                    </span>
                                </div>
                                <c:if test="${not empty consultation.compteRendu}">
                                    <div class="bg-gray-50 rounded-lg p-3">
                                        <p class="text-sm font-medium text-gray-700 mb-1">
                                            <i class="fas fa-file-medical text-purple-600 mr-1"></i>
                                            Compte Rendu:
                                        </p>
                                        <p class="text-sm text-gray-600">
                                            <c:out value="${consultation.compteRendu}" />
                                        </p>
                                    </div>
                                </c:if>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </c:if>
    </div>

</body>
</html>
