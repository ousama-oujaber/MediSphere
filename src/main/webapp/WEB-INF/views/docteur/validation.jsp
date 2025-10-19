<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!doctype html>
<html lang="fr">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Validation Réservations - MediSphere</title>
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
            background-clip: text;
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
            background-color: #FEF3C7;
            color: #92400E;
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
                   class="text-gray-600 hover:text-purple-600 transition-colors">
                    <i class="fas fa-calendar-alt mr-2"></i>Planning
                </a>
                <a href="${pageContext.request.contextPath}/docteur/validation"
                   class="text-purple-600 font-semibold">
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

    <c:if test="${not empty sessionScope.error}">
        <div class="mb-6 p-4 bg-red-50 border-l-4 border-red-500 text-red-700 rounded-lg">
            <i class="fas fa-exclamation-circle mr-2"></i>${sessionScope.error}
        </div>
        <c:remove var="error" scope="session"/>
    </c:if>

    <c:if test="${not empty error}">
        <div class="mb-6 p-4 bg-red-50 border-l-4 border-red-500 text-red-700 rounded-lg">
            <i class="fas fa-exclamation-circle mr-2"></i>${error}
        </div>
    </c:if>

    <!-- Single Consultation Validation -->
    <c:if test="${not empty consultation}">
        <div class="mb-6">
            <a href="${pageContext.request.contextPath}/docteur/validation"
               class="text-purple-600 hover:text-purple-700 font-medium">
                <i class="fas fa-arrow-left mr-2"></i>Retour à la liste
            </a>
        </div>

        <div class="card p-8">
            <h2 class="text-2xl font-bold text-gray-800 mb-6">
                <i class="fas fa-user-check text-purple-600 mr-3"></i>
                Valider la Réservation
            </h2>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
                <!-- Patient Information -->
                <div class="border border-gray-200 rounded-xl p-6">
                    <h3 class="font-bold text-gray-800 mb-4 flex items-center">
                        <i class="fas fa-user text-purple-600 mr-2"></i>
                        Informations Patient
                    </h3>
                    <div class="space-y-3">
                        <div>
                            <p class="text-sm text-gray-500">Nom complet</p>
                            <p class="font-semibold text-gray-800">
                                <c:out value="${consultation.patient.personne.prenom}" />
                                <c:out value="${consultation.patient.personne.nom}" />
                            </p>
                        </div>
                        <div>
                            <p class="text-sm text-gray-500">Email</p>
                            <p class="font-medium text-gray-800">
                                <c:out value="${consultation.patient.personne.email}" />
                            </p>
                        </div>
                        <c:if test="${not empty consultation.patient.personne.telephone}">
                            <div>
                                <p class="text-sm text-gray-500">Téléphone</p>
                                <p class="font-medium text-gray-800">
                                    <c:out value="${consultation.patient.personne.telephone}" />
                                </p>
                            </div>
                        </c:if>
                        <c:if test="${not empty consultation.patient.poids or not empty consultation.patient.taille}">
                            <div class="flex gap-4">
                                <c:if test="${not empty consultation.patient.poids}">
                                    <div>
                                        <p class="text-sm text-gray-500">Poids</p>
                                        <p class="font-medium text-gray-800">${consultation.patient.poids} kg</p>
                                    </div>
                                </c:if>
                                <c:if test="${not empty consultation.patient.taille}">
                                    <div>
                                        <p class="text-sm text-gray-500">Taille</p>
                                        <p class="font-medium text-gray-800">${consultation.patient.taille} cm</p>
                                    </div>
                                </c:if>
                            </div>
                        </c:if>
                    </div>
                </div>

                <!-- Consultation Details -->
                <div class="border border-gray-200 rounded-xl p-6">
                    <h3 class="font-bold text-gray-800 mb-4 flex items-center">
                        <i class="fas fa-calendar-alt text-purple-600 mr-2"></i>
                        Détails Consultation
                    </h3>
                    <div class="space-y-3">
                        <div>
                            <p class="text-sm text-gray-500">Date</p>
                            <p class="font-semibold text-gray-800">
                                ${consultation.dateConsultation}
                            </p>
                        </div>
                        <div>
                            <p class="text-sm text-gray-500">Heure</p>
                            <p class="font-semibold text-gray-800">
                                ${consultation.heureConsultation}
                            </p>
                        </div>
                        <div>
                            <p class="text-sm text-gray-500">Salle</p>
                            <p class="font-medium text-gray-800">
                                <c:out value="${consultation.salle.nomSalle}" />
                            </p>
                        </div>
                        <div>
                            <p class="text-sm text-gray-500">Statut</p>
                            <span class="status-badge">
                                <c:out value="${consultation.statut}" />
                            </span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Motif de Consultation -->
            <div class="border border-gray-200 rounded-xl p-6 mb-8">
                <h3 class="font-bold text-gray-800 mb-3 flex items-center">
                    <i class="fas fa-comment-medical text-purple-600 mr-2"></i>
                    Motif de Consultation
                </h3>
                <p class="text-gray-700">
                    <c:out value="${consultation.motifConsultation}" />
                </p>
            </div>

            <!-- Action Buttons -->
            <div class="flex flex-col sm:flex-row gap-4">
                <form method="post" action="${pageContext.request.contextPath}/docteur/validation" class="flex-1">
                    <input type="hidden" name="consultationId" value="${consultation.idConsultation}">
                    <input type="hidden" name="action" value="valider">
                    <button type="submit"
                            class="w-full bg-gradient-to-r from-green-500 to-green-600 text-white px-6 py-3 rounded-xl font-semibold hover:shadow-lg transition-all">
                        <i class="fas fa-check-circle mr-2"></i>Valider la Réservation
                    </button>
                </form>

                <button onclick="document.getElementById('rejectModal').classList.remove('hidden')"
                        class="flex-1 bg-gradient-to-r from-red-500 to-red-600 text-white px-6 py-3 rounded-xl font-semibold hover:shadow-lg transition-all">
                    <i class="fas fa-times-circle mr-2"></i>Rejeter la Réservation
                </button>
            </div>
        </div>

        <!-- Reject Modal -->
        <div id="rejectModal" class="hidden fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
            <div class="bg-white rounded-2xl p-8 max-w-md w-full mx-4">
                <h3 class="text-xl font-bold text-gray-800 mb-4">
                    <i class="fas fa-exclamation-triangle text-red-500 mr-2"></i>
                    Rejeter la Réservation
                </h3>
                <form method="post" action="${pageContext.request.contextPath}/docteur/validation">
                    <input type="hidden" name="consultationId" value="${consultation.idConsultation}">
                    <input type="hidden" name="action" value="rejeter">

                    <div class="mb-6">
                        <label class="block text-sm font-medium text-gray-700 mb-2">
                            Motif d'annulation (optionnel)
                        </label>
                        <textarea name="motifAnnulation" rows="4"
                                  class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-transparent"
                                  placeholder="Précisez la raison du rejet..."></textarea>
                    </div>

                    <div class="flex gap-3">
                        <button type="button"
                                onclick="document.getElementById('rejectModal').classList.add('hidden')"
                                class="flex-1 px-4 py-2 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors">
                            Annuler
                        </button>
                        <button type="submit"
                                class="flex-1 bg-red-500 text-white px-4 py-2 rounded-lg hover:bg-red-600 transition-colors">
                            Confirmer le Rejet
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </c:if>

    <!-- List of Pending Reservations -->
    <c:if test="${empty consultation}">
        <div class="mb-8">
            <h2 class="text-3xl font-bold text-gray-800 mb-2">
                <i class="fas fa-check-circle text-purple-600 mr-3"></i>
                Réservations à Valider
            </h2>
            <p class="text-gray-600">Gérez les demandes de consultation</p>
        </div>

        <c:choose>
            <c:when test="${empty consultations}">
                <div class="card p-12 text-center">
                    <i class="fas fa-check-double text-6xl text-gray-300 mb-4"></i>
                    <h3 class="text-xl font-semibold text-gray-700 mb-2">Aucune réservation en attente</h3>
                    <p class="text-gray-500">Toutes les réservations ont été traitées</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <c:forEach var="consultation" items="${consultations}">
                        <div class="card p-6 hover:shadow-xl transition-all">
                            <div class="flex items-start justify-between mb-4">
                                <div>
                                    <h3 class="text-lg font-bold text-gray-800 mb-1">
                                        <c:out value="${consultation.patient.personne.prenom}" />
                                        <c:out value="${consultation.patient.personne.nom}" />
                                    </h3>
                                    <p class="text-sm text-gray-500">
                                        <i class="fas fa-envelope mr-1"></i>
                                        <c:out value="${consultation.patient.personne.email}" />
                                    </p>
                                </div>
                                <span class="status-badge">
                                    <c:out value="${consultation.statut}" />
                                </span>
                            </div>

                            <div class="space-y-2 mb-4">
                                <p class="text-sm">
                                    <i class="fas fa-calendar text-purple-600 mr-2"></i>
                                    <span class="font-medium">
                                        ${consultation.dateConsultation} à ${consultation.heureConsultation}
                                    </span>
                                </p>
                                <p class="text-sm">
                                    <i class="fas fa-door-open text-purple-600 mr-2"></i>
                                    <span class="font-medium"><c:out value="${consultation.salle.nomSalle}" /></span>
                                </p>
                                <p class="text-sm text-gray-600">
                                    <i class="fas fa-comment-medical text-purple-600 mr-2"></i>
                                    <c:out value="${consultation.motifConsultation}" />
                                </p>
                            </div>

                            <a href="${pageContext.request.contextPath}/docteur/validation?id=${consultation.idConsultation}"
                               class="block w-full text-center bg-gradient-to-r from-purple-600 to-indigo-600 text-white px-4 py-2 rounded-lg font-medium hover:shadow-lg transition-all">
                                <i class="fas fa-eye mr-2"></i>Voir Détails
                            </a>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </c:if>
</div>

</body>
</html>
