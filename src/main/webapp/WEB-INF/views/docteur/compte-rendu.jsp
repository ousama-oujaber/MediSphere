<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!doctype html>
<html lang="fr">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Compte Rendu Médical - MediSphere</title>
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
        }

        .status-validee {
            background-color: #DBEAFE;
            color: #1E40AF;
        }

        .status-terminee {
            background-color: #D1FAE5;
            color: #065F46;
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
                <a href="${pageContext.request.contextPath}/docteur/compte-rendu"
                   class="text-purple-600 font-semibold">
                    <i class="fas fa-file-medical mr-2"></i>Compte Rendu
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

    <!-- Single Consultation Form -->
    <c:if test="${not empty consultation}">
        <div class="mb-6">
            <a href="${pageContext.request.contextPath}/docteur/compte-rendu"
               class="text-purple-600 hover:text-purple-700 font-medium">
                <i class="fas fa-arrow-left mr-2"></i>Retour à la liste
            </a>
        </div>

        <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
            <!-- Main Form -->
            <div class="lg:col-span-2">
                <div class="card p-8">
                    <h2 class="text-2xl font-bold text-gray-800 mb-6">
                        <i class="fas fa-file-medical text-purple-600 mr-3"></i>
                        Compte Rendu Médical
                    </h2>

                    <!-- Patient & Consultation Info -->
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
                        <div class="border border-gray-200 rounded-xl p-4">
                            <h3 class="font-bold text-gray-800 mb-3 text-sm">
                                <i class="fas fa-user text-purple-600 mr-2"></i>Patient
                            </h3>
                            <p class="font-semibold text-gray-800 mb-1">
                                <c:out value="${consultation.patient.personne.prenom}" />
                                <c:out value="${consultation.patient.personne.nom}" />
                            </p>
                            <p class="text-sm text-gray-600">
                                <i class="fas fa-envelope mr-1"></i>
                                <c:out value="${consultation.patient.personne.email}" />
                            </p>
                            <c:if test="${not empty consultation.patient.poids or not empty consultation.patient.taille}">
                                <div class="flex gap-3 mt-2 text-sm">
                                    <c:if test="${not empty consultation.patient.poids}">
                                        <span class="text-gray-600">
                                            <i class="fas fa-weight mr-1"></i>${consultation.patient.poids} kg
                                        </span>
                                    </c:if>
                                    <c:if test="${not empty consultation.patient.taille}">
                                        <span class="text-gray-600">
                                            <i class="fas fa-ruler-vertical mr-1"></i>${consultation.patient.taille} cm
                                        </span>
                                    </c:if>
                                </div>
                            </c:if>
                        </div>

                        <div class="border border-gray-200 rounded-xl p-4">
                            <h3 class="font-bold text-gray-800 mb-3 text-sm">
                                <i class="fas fa-calendar-alt text-purple-600 mr-2"></i>Consultation
                            </h3>
                            <p class="text-sm mb-1">
                                <span class="text-gray-600">Date:</span>
                                <span class="font-semibold">
                                    ${consultation.dateConsultation} à ${consultation.heureConsultation}
                                </span>
                            </p>
                            <p class="text-sm mb-1">
                                <span class="text-gray-600">Salle:</span>
                                <span class="font-medium"><c:out value="${consultation.salle.nomSalle}" /></span>
                            </p>
                            <p class="text-sm">
                                <span class="text-gray-600">Statut:</span>
                                <span class="status-badge status-validee ml-1">
                                    <c:out value="${consultation.statut}" />
                                </span>
                            </p>
                        </div>
                    </div>

                    <!-- Motif -->
                    <div class="border border-gray-200 rounded-xl p-4 mb-6">
                        <h3 class="font-bold text-gray-800 mb-2 text-sm">
                            <i class="fas fa-comment-medical text-purple-600 mr-2"></i>
                            Motif de Consultation
                        </h3>
                        <p class="text-gray-700">
                            <c:out value="${consultation.motifConsultation}" />
                        </p>
                    </div>

                    <!-- Compte Rendu Form -->
                    <form method="post" action="${pageContext.request.contextPath}/docteur/compte-rendu">
                        <input type="hidden" name="consultationId" value="${consultation.idConsultation}">

                        <div class="mb-6">
                            <label class="block text-sm font-bold text-gray-800 mb-3">
                                <i class="fas fa-notes-medical text-purple-600 mr-2"></i>
                                Diagnostic et Traitement *
                            </label>
                            <textarea name="compteRendu" required rows="12"
                                      class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-purple-500 focus:border-transparent resize-none"
                                      placeholder="Saisissez le diagnostic, les observations cliniques, le traitement prescrit, les recommandations...&#10;&#10;Exemple:&#10;- Diagnostic : ...&#10;- Examen clinique : ...&#10;- Traitement prescrit : ...&#10;- Recommandations : ...&#10;- Suivi nécessaire : ..."></textarea>
                            <p class="text-xs text-gray-500 mt-2">
                                <i class="fas fa-info-circle mr-1"></i>
                                Ce compte rendu sera marqué comme confidentiel et consultable uniquement par le patient et les professionnels de santé autorisés.
                            </p>
                        </div>

                        <div class="flex gap-4">
                            <button type="submit"
                                    class="flex-1 bg-gradient-to-r from-green-500 to-green-600 text-white px-6 py-3 rounded-xl font-semibold hover:shadow-lg transition-all">
                                <i class="fas fa-save mr-2"></i>Enregistrer & Terminer la Consultation
                            </button>
                            <a href="${pageContext.request.contextPath}/docteur/planning"
                               class="px-6 py-3 border-2 border-gray-300 text-gray-700 rounded-xl font-medium hover:bg-gray-50 transition-colors">
                                <i class="fas fa-times mr-2"></i>Annuler
                            </a>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Patient History Sidebar -->
            <div class="lg:col-span-1">
                <div class="card p-6 sticky top-8">
                    <h3 class="font-bold text-gray-800 mb-4">
                        <i class="fas fa-history text-purple-600 mr-2"></i>
                        Historique Patient
                    </h3>

                    <c:choose>
                        <c:when test="${empty historiquePatient}">
                            <p class="text-sm text-gray-500 text-center py-8">
                                <i class="fas fa-inbox text-gray-300 text-3xl mb-2 block"></i>
                                Aucun historique
                            </p>
                        </c:when>
                        <c:otherwise>
                            <div class="space-y-4 max-h-96 overflow-y-auto">
                                <c:forEach var="historic" items="${historiquePatient}">
                                    <c:if test="${historic.idConsultation != consultation.idConsultation}">
                                        <div class="border border-gray-200 rounded-lg p-3">
                                            <div class="flex items-start justify-between mb-2">
                                                <p class="text-xs font-semibold text-gray-700">
                                                    ${historic.dateConsultation}
                                                </p>
                                                <span class="status-badge status-${historic.statut.name().toLowerCase()} text-xs">
                                                    <c:out value="${historic.statut}" />
                                                </span>
                                            </div>
                                            <p class="text-xs text-gray-600 mb-1">
                                                <i class="fas fa-user-md text-gray-400 mr-1"></i>
                                                Dr. <c:out value="${historic.docteur.personne.nom}" />
                                            </p>
                                            <c:if test="${not empty historic.compteRendu}">
                                                <p class="text-xs text-gray-700 mt-2 line-clamp-3">
                                                    ${historic.compteRendu}
                                                </p>
                                            </c:if>
                                        </div>
                                    </c:if>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </c:if>

    <!-- List of Validated Consultations -->
    <c:if test="${empty consultation}">
        <div class="mb-8">
            <h2 class="text-3xl font-bold text-gray-800 mb-2">
                <i class="fas fa-file-medical text-purple-600 mr-3"></i>
                Comptes Rendus à Rédiger
            </h2>
            <p class="text-gray-600">Consultations validées en attente de diagnostic</p>
        </div>

        <c:choose>
            <c:when test="${empty consultations}">
                <div class="card p-12 text-center">
                    <i class="fas fa-check-double text-6xl text-gray-300 mb-4"></i>
                    <h3 class="text-xl font-semibold text-gray-700 mb-2">Aucune consultation en attente</h3>
                    <p class="text-gray-500">Tous les comptes rendus sont à jour</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                    <c:forEach var="consultation" items="${consultations}">
                        <div class="card p-6 hover:shadow-xl transition-all">
                            <div class="flex items-start justify-between mb-4">
                                <div>
                                    <h3 class="text-lg font-bold text-gray-800 mb-1">
                                        <c:out value="${consultation.patient.personne.prenom}" />
                                        <c:out value="${consultation.patient.personne.nom}" />
                                    </h3>
                                    <p class="text-xs text-gray-500">
                                        ID: ${consultation.patient.idPatient}
                                    </p>
                                </div>
                                <span class="status-badge status-validee">
                                    <c:out value="${consultation.statut}" />
                                </span>
                            </div>

                            <div class="space-y-2 mb-4">
                                <p class="text-sm">
                                    <i class="fas fa-calendar text-purple-600 mr-2"></i>
                                    <span class="font-medium">
                                        ${consultation.dateConsultation}
                                    </span>
                                </p>
                                <p class="text-sm">
                                    <i class="fas fa-clock text-purple-600 mr-2"></i>
                                    <span class="font-medium">
                                        ${consultation.heureConsultation}
                                    </span>
                                </p>
                                <p class="text-sm">
                                    <i class="fas fa-door-open text-purple-600 mr-2"></i>
                                    <span class="font-medium"><c:out value="${consultation.salle.nomSalle}" /></span>
                                </p>
                                <p class="text-sm text-gray-600 line-clamp-2">
                                    <i class="fas fa-comment-medical text-purple-600 mr-2"></i>
                                    <c:out value="${consultation.motifConsultation}" />
                                </p>
                            </div>

                            <a href="${pageContext.request.contextPath}/docteur/compte-rendu?id=${consultation.idConsultation}"
                               class="block w-full text-center bg-gradient-to-r from-purple-600 to-indigo-600 text-white px-4 py-2 rounded-lg font-medium hover:shadow-lg transition-all">
                                <i class="fas fa-edit mr-2"></i>Rédiger Compte Rendu
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
