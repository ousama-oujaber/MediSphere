<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!doctype html>
<html lang="fr">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Mon Planning - MediSphere</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@300;400;500;600;700&family=Inter:wght@300;400;500;600;700&display=swap');

        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #667eea08 0%, #764ba208 100%);
        }

        h1, h2, h3 {
            font-family: 'Space Grotesk', sans-serif;
        }

        .text-gradient {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 10px 40px rgba(102, 126, 234, 0.1);
            border: 1px solid rgba(102, 126, 234, 0.1);
        }

        .status-badge {
            padding: 0.25rem 0.75rem;
            border-radius: 9999px;
            font-size: 0.75rem;
            font-weight: 600;
        }

        .status-reservee {
            background-color: #FEF3C7;
            color: #92400E;
        }

        .status-validee {
            background-color: #DBEAFE;
            color: #1E40AF;
        }

        .status-terminee {
            background-color: #D1FAE5;
            color: #065F46;
        }

        .status-annulee {
            background-color: #FEE2E2;
            color: #991B1B;
        }
    </style>
</head>
<body class="min-h-screen">

<!-- Navigation Bar -->
<nav class="bg-white shadow-lg border-b border-gray-100">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between items-center h-20">
            <div class="flex items-center space-x-3">
                <div class="w-12 h-12 bg-gradient-to-br from-purple-600 to-indigo-600 rounded-xl flex items-center justify-center">
                    <i class="fas fa-hospital text-white text-xl"></i>
                </div>
                <div>
                    <h1 class="text-2xl font-bold text-gradient">MediSphere</h1>
                    <p class="text-xs text-gray-500">Espace Docteur</p>
                </div>
            </div>

            <div class="flex items-center space-x-6">
                <a href="${pageContext.request.contextPath}/docteur/dashboard"
                   class="text-gray-600 hover:text-purple-600 transition-colors">
                    <i class="fas fa-home mr-2"></i>Dashboard
                </a>
                <a href="${pageContext.request.contextPath}/docteur/planning"
                   class="text-purple-600 font-semibold">
                    <i class="fas fa-calendar-alt mr-2"></i>Planning
                </a>
                <a href="${pageContext.request.contextPath}/docteur/validation"
                   class="text-gray-600 hover:text-purple-600 transition-colors">
                    <i class="fas fa-check-circle mr-2"></i>Validations
                </a>
                <div class="text-right">
                    <p class="text-sm font-semibold text-gray-800">
                        Dr. <c:out value="${docteur.personne.prenom}" /> <c:out value="${docteur.personne.nom}" />
                    </p>
                </div>
                <a href="${pageContext.request.contextPath}/logout"
                   class="px-4 py-2 text-sm font-medium text-white bg-red-500 hover:bg-red-600 rounded-xl transition-all">
                    <i class="fas fa-sign-out-alt mr-2"></i>Déconnexion
                </a>
            </div>
        </div>
    </div>
</nav>

<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">

    <!-- Success/Error Messages -->
    <c:if test="${not empty sessionScope.success}">
        <div class="mb-6 p-4 bg-green-50 border-l-4 border-green-500 text-green-700 rounded-lg">
            <i class="fas fa-check-circle mr-2"></i>${sessionScope.success}
        </div>
        <c:remove var="success" scope="session"/>
    </c:if>

    <c:if test="${not empty error}">
        <div class="mb-6 p-4 bg-red-50 border-l-4 border-red-500 text-red-700 rounded-lg">
            <i class="fas fa-exclamation-circle mr-2"></i>${error}
        </div>
    </c:if>

    <!-- Page Header -->
    <div class="mb-8">
        <h2 class="text-3xl font-bold text-gray-800 mb-2">
            <i class="fas fa-calendar-alt text-purple-600 mr-3"></i>Mon Planning
        </h2>
        <p class="text-gray-600">Gérez toutes vos consultations</p>
    </div>

    <!-- Filters -->
    <div class="card p-6 mb-8">
        <form method="get" action="${pageContext.request.contextPath}/docteur/planning" class="grid grid-cols-1 md:grid-cols-3 gap-4">
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">
                    <i class="fas fa-calendar mr-2"></i>Filtrer par date
                </label>
                <input type="date" name="date" value="${selectedDate}"
                       class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-transparent">
            </div>

            <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">
                    <i class="fas fa-filter mr-2"></i>Filtrer par statut
                </label>
                <select name="statut"
                        class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-transparent">
                    <option value="">Tous les statuts</option>
                    <option value="RESERVEE" ${selectedStatut == 'RESERVEE' ? 'selected' : ''}>Réservée</option>
                    <option value="VALIDEE" ${selectedStatut == 'VALIDEE' ? 'selected' : ''}>Validée</option>
                    <option value="TERMINEE" ${selectedStatut == 'TERMINEE' ? 'selected' : ''}>Terminée</option>
                    <option value="ANNULEE" ${selectedStatut == 'ANNULEE' ? 'selected' : ''}>Annulée</option>
                </select>
            </div>

            <div class="flex items-end space-x-2">
                <button type="submit"
                        class="flex-1 bg-gradient-to-r from-purple-600 to-indigo-600 text-white px-6 py-2 rounded-lg hover:shadow-lg transition-all">
                    <i class="fas fa-search mr-2"></i>Filtrer
                </button>
                <a href="${pageContext.request.contextPath}/docteur/planning"
                   class="px-6 py-2 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors">
                    <i class="fas fa-redo"></i>
                </a>
            </div>
        </form>
    </div>

    <!-- Consultations Table -->
    <div class="card p-6">
        <div class="flex items-center justify-between mb-6">
            <h3 class="text-xl font-bold text-gray-800">
                Liste des Consultations
            </h3>
            <span class="text-sm text-gray-600">${consultations.size()} consultation(s)</span>
        </div>

        <c:choose>
            <c:when test="${empty consultations}">
                <div class="text-center py-12">
                    <i class="fas fa-calendar-times text-6xl text-gray-300 mb-4"></i>
                    <p class="text-gray-500">Aucune consultation trouvée</p>
                    <p class="text-sm text-gray-400 mt-2">Modifiez vos filtres pour voir plus de résultats</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="overflow-x-auto">
                    <table class="w-full">
                        <thead>
                        <tr class="border-b border-gray-200">
                            <th class="text-left py-3 px-4 font-semibold text-gray-700">Date & Heure</th>
                            <th class="text-left py-3 px-4 font-semibold text-gray-700">Patient</th>
                            <th class="text-left py-3 px-4 font-semibold text-gray-700">Contact</th>
                            <th class="text-left py-3 px-4 font-semibold text-gray-700">Motif</th>
                            <th class="text-left py-3 px-4 font-semibold text-gray-700">Salle</th>
                            <th class="text-left py-3 px-4 font-semibold text-gray-700">Statut</th>
                            <th class="text-left py-3 px-4 font-semibold text-gray-700">Actions</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="consultation" items="${consultations}">
                            <tr class="border-b border-gray-100 hover:bg-gray-50 transition-colors">
                                <td class="py-3 px-4">
                                    <div>
                                        <p class="font-medium text-gray-800">
                                            ${consultation.dateConsultation}
                                        </p>
                                        <p class="text-sm text-gray-500">
                                            <i class="fas fa-clock mr-1"></i>
                                            ${consultation.heureConsultation}
                                        </p>
                                    </div>
                                </td>
                                <td class="py-3 px-4">
                                    <div>
                                        <p class="font-medium text-gray-800">
                                            <c:out value="${consultation.patient.personne.prenom}" />
                                            <c:out value="${consultation.patient.personne.nom}" />
                                        </p>
                                        <p class="text-xs text-gray-500">
                                            ID: ${consultation.patient.idPatient}
                                        </p>
                                    </div>
                                </td>
                                <td class="py-3 px-4">
                                    <p class="text-sm text-gray-600">
                                        <i class="fas fa-envelope text-gray-400 mr-1"></i>
                                        <c:out value="${consultation.patient.personne.email}" />
                                    </p>
                                    <c:if test="${not empty consultation.patient.personne.telephone}">
                                        <p class="text-sm text-gray-600">
                                            <i class="fas fa-phone text-gray-400 mr-1"></i>
                                            <c:out value="${consultation.patient.personne.telephone}" />
                                        </p>
                                    </c:if>
                                </td>
                                <td class="py-3 px-4">
                                    <p class="text-sm text-gray-600">
                                        <c:out value="${consultation.motifConsultation}" />
                                    </p>
                                </td>
                                <td class="py-3 px-4 text-gray-600">
                                    <i class="fas fa-door-open text-gray-400 mr-1"></i>
                                    <c:out value="${consultation.salle.nomSalle}" />
                                </td>
                                <td class="py-3 px-4">
                                    <span class="status-badge status-${consultation.statut.name().toLowerCase()}">
                                        <c:out value="${consultation.statut}" />
                                    </span>
                                </td>
                                <td class="py-3 px-4">
                                    <div class="flex space-x-2">
                                        <c:choose>
                                            <c:when test="${consultation.statut.name() == 'RESERVEE'}">
                                                <a href="${pageContext.request.contextPath}/docteur/validation?id=${consultation.idConsultation}"
                                                   class="text-orange-600 hover:text-orange-700 font-medium text-sm"
                                                   title="Valider la réservation">
                                                    <i class="fas fa-check-circle"></i>
                                                </a>
                                            </c:when>
                                            <c:when test="${consultation.statut.name() == 'VALIDEE'}">
                                                <a href="${pageContext.request.contextPath}/docteur/compte-rendu?id=${consultation.idConsultation}"
                                                   class="text-blue-600 hover:text-blue-700 font-medium text-sm"
                                                   title="Ajouter compte rendu">
                                                    <i class="fas fa-file-medical"></i>
                                                </a>
                                            </c:when>
                                            <c:when test="${consultation.statut.name() == 'TERMINEE'}">
                                                <button class="text-green-600 font-medium text-sm" title="Consultation terminée">
                                                    <i class="fas fa-check-double"></i>
                                                </button>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-gray-400 text-sm">-</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
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

</body>
</html>
