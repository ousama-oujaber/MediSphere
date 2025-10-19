<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!doctype html>
<html lang="fr">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Tableau de Bord Docteur - MediSphere</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@300;400;500;600;700&family=Inter:wght@300;400;500;600;700&display=swap');

        :root {
            --gradient-primary: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            --gradient-accent: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            --gradient-success: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            --gradient-warning: linear-gradient(135deg, #ffc837 0%, #ff8008 100%);
        }

        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #667eea08 0%, #764ba208 100%);
        }

        h1, h2, h3, h4, h5, h6 {
            font-family: 'Space Grotesk', sans-serif;
        }

        .text-gradient {
            background: var(--gradient-primary);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 10px 40px rgba(102, 126, 234, 0.1);
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            border: 1px solid rgba(102, 126, 234, 0.1);
        }

        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 60px rgba(102, 126, 234, 0.2);
        }

        .stat-card {
            position: relative;
            overflow: hidden;
        }

        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            right: 0;
            width: 150px;
            height: 150px;
            background: radial-gradient(circle, rgba(102, 126, 234, 0.1) 0%, transparent 70%);
            border-radius: 50%;
            transform: translate(30%, -30%);
        }

        .btn-gradient {
            background: var(--gradient-primary);
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
        }

        .btn-gradient:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 30px rgba(102, 126, 234, 0.4);
        }

        .fade-in-up {
            animation: fadeInUp 0.6s ease-out forwards;
            opacity: 0;
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .stagger-1 { animation-delay: 0.1s; }
        .stagger-2 { animation-delay: 0.2s; }
        .stagger-3 { animation-delay: 0.3s; }
        .stagger-4 { animation-delay: 0.4s; }

        .icon-wrapper {
            width: 60px;
            height: 60px;
            border-radius: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
        }

        .gradient-purple { background: var(--gradient-primary); }
        .gradient-pink { background: var(--gradient-accent); }
        .gradient-blue { background: var(--gradient-success); }
        .gradient-orange { background: var(--gradient-warning); }

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
                <a href="${pageContext.request.contextPath}/docteur/planning"
                   class="text-gray-600 hover:text-purple-600 transition-colors">
                    <i class="fas fa-calendar-alt mr-2"></i>Planning
                </a>
                <a href="${pageContext.request.contextPath}/docteur/validation"
                   class="text-gray-600 hover:text-purple-600 transition-colors relative">
                    <i class="fas fa-check-circle mr-2"></i>Validations
                    <c:if test="${consultationsReservees > 0}">
                        <span class="absolute -top-2 -right-2 bg-red-500 text-white text-xs rounded-full w-5 h-5 flex items-center justify-center">
                            ${consultationsReservees}
                        </span>
                    </c:if>
                </a>
                <div class="text-right">
                    <p class="text-sm font-semibold text-gray-800">
                        Dr. <c:out value="${docteur.personne.prenom}" /> <c:out value="${docteur.personne.nom}" />
                    </p>
                    <p class="text-xs text-purple-600">
                        <i class="fas fa-stethoscope mr-1"></i><c:out value="${docteur.specialite}" />
                    </p>
                </div>
                <a href="${pageContext.request.contextPath}/logout"
                   class="px-4 py-2 text-sm font-medium text-white bg-red-500 hover:bg-red-600 rounded-xl transition-all duration-300">
                    <i class="fas fa-sign-out-alt mr-2"></i>Déconnexion
                </a>
            </div>
        </div>
    </div>
</nav>

<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">

    <!-- Success/Error Messages -->
    <c:if test="${not empty sessionScope.success}">
        <div class="mb-6 p-4 bg-green-50 border-l-4 border-green-500 text-green-700 rounded-lg fade-in-up">
            <i class="fas fa-check-circle mr-2"></i>${sessionScope.success}
        </div>
        <c:remove var="success" scope="session"/>
    </c:if>

    <c:if test="${not empty error}">
        <div class="mb-6 p-4 bg-red-50 border-l-4 border-red-500 text-red-700 rounded-lg fade-in-up">
            <i class="fas fa-exclamation-circle mr-2"></i>${error}
        </div>
    </c:if>

    <!-- Welcome Section -->
    <div class="mb-8 fade-in-up">
        <h2 class="text-3xl font-bold text-gray-800 mb-2">
            Bienvenue, <span class="text-gradient">Dr. <c:out value="${docteur.personne.prenom}" /></span>
        </h2>
        <p class="text-gray-600">Tableau de bord médecin - Gérez vos consultations efficacement</p>
    </div>

    <!-- Statistics Cards -->
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
        <!-- Total Consultations -->
        <div class="card stat-card p-6 fade-in-up stagger-1">
            <div class="flex items-start justify-between mb-4">
                <div class="icon-wrapper gradient-purple text-white">
                    <i class="fas fa-clipboard-list"></i>
                </div>
            </div>
            <h3 class="text-2xl font-bold text-gray-800 mb-1">${totalConsultations}</h3>
            <p class="text-sm text-gray-600">Total Consultations</p>
        </div>

        <!-- Pending Validations -->
        <div class="card stat-card p-6 fade-in-up stagger-2">
            <div class="flex items-start justify-between mb-4">
                <div class="icon-wrapper gradient-orange text-white">
                    <i class="fas fa-hourglass-half"></i>
                </div>
                <c:if test="${consultationsReservees > 0}">
                    <span class="text-xs font-semibold text-orange-600 bg-orange-50 px-3 py-1 rounded-full">
                        En attente
                    </span>
                </c:if>
            </div>
            <h3 class="text-2xl font-bold text-gray-800 mb-1">${consultationsReservees}</h3>
            <p class="text-sm text-gray-600">À Valider</p>
        </div>

        <!-- Validated Consultations -->
        <div class="card stat-card p-6 fade-in-up stagger-3">
            <div class="flex items-start justify-between mb-4">
                <div class="icon-wrapper gradient-blue text-white">
                    <i class="fas fa-check-double"></i>
                </div>
            </div>
            <h3 class="text-2xl font-bold text-gray-800 mb-1">${consultationsValidees}</h3>
            <p class="text-sm text-gray-600">Validées</p>
        </div>

        <!-- Completed Consultations -->
        <div class="card stat-card p-6 fade-in-up stagger-4">
            <div class="flex items-start justify-between mb-4">
                <div class="icon-wrapper gradient-pink text-white">
                    <i class="fas fa-flag-checkered"></i>
                </div>
            </div>
            <h3 class="text-2xl font-bold text-gray-800 mb-1">${consultationsTerminees}</h3>
            <p class="text-sm text-gray-600">Terminées</p>
        </div>
    </div>

    <!-- Quick Actions -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
        <a href="${pageContext.request.contextPath}/docteur/planning"
           class="card p-6 fade-in-up stagger-1 hover:scale-105 transition-transform">
            <div class="flex items-center space-x-4">
                <div class="icon-wrapper gradient-purple text-white">
                    <i class="fas fa-calendar-alt"></i>
                </div>
                <div>
                    <h3 class="font-semibold text-gray-800">Mon Planning</h3>
                    <p class="text-sm text-gray-600">Voir toutes mes consultations</p>
                </div>
            </div>
        </a>

        <a href="${pageContext.request.contextPath}/docteur/validation"
           class="card p-6 fade-in-up stagger-2 hover:scale-105 transition-transform">
            <div class="flex items-center space-x-4">
                <div class="icon-wrapper gradient-orange text-white">
                    <i class="fas fa-check-circle"></i>
                </div>
                <div>
                    <h3 class="font-semibold text-gray-800">Valider Réservations</h3>
                    <p class="text-sm text-gray-600">${consultationsReservees} en attente</p>
                </div>
            </div>
        </a>

        <a href="${pageContext.request.contextPath}/docteur/compte-rendu"
           class="card p-6 fade-in-up stagger-3 hover:scale-105 transition-transform">
            <div class="flex items-center space-x-4">
                <div class="icon-wrapper gradient-blue text-white">
                    <i class="fas fa-file-medical"></i>
                </div>
                <div>
                    <h3 class="font-semibold text-gray-800">Comptes Rendus</h3>
                    <p class="text-sm text-gray-600">Ajouter diagnostics</p>
                </div>
            </div>
        </a>
    </div>

    <!-- Today's Consultations -->
    <div class="card p-6 fade-in-up">
        <div class="flex items-center justify-between mb-6">
            <h3 class="text-xl font-bold text-gray-800">
                <i class="fas fa-calendar-day text-purple-600 mr-2"></i>
                Consultations d'Aujourd'hui
            </h3>
            <span class="text-sm text-gray-600">${consultationsAujourdhui.size()} consultation(s)</span>
        </div>

        <c:choose>
            <c:when test="${empty consultationsAujourdhui}">
                <div class="text-center py-12">
                    <i class="fas fa-calendar-check text-6xl text-gray-300 mb-4"></i>
                    <p class="text-gray-500">Aucune consultation prévue aujourd'hui</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="overflow-x-auto">
                    <table class="w-full">
                        <thead>
                        <tr class="border-b border-gray-200">
                            <th class="text-left py-3 px-4 font-semibold text-gray-700">Heure</th>
                            <th class="text-left py-3 px-4 font-semibold text-gray-700">Patient</th>
                            <th class="text-left py-3 px-4 font-semibold text-gray-700">Motif</th>
                            <th class="text-left py-3 px-4 font-semibold text-gray-700">Salle</th>
                            <th class="text-left py-3 px-4 font-semibold text-gray-700">Statut</th>
                            <th class="text-left py-3 px-4 font-semibold text-gray-700">Action</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="consultation" items="${consultationsAujourdhui}">
                            <tr class="border-b border-gray-100 hover:bg-gray-50 transition-colors">
                                <td class="py-3 px-4">
                                    ${consultation.heureConsultation}
                                </td>
                                <td class="py-3 px-4">
                                    <div>
                                        <p class="font-medium text-gray-800">
                                            <c:out value="${consultation.patient.personne.prenom}" />
                                            <c:out value="${consultation.patient.personne.nom}" />
                                        </p>
                                        <p class="text-xs text-gray-500">
                                            <c:out value="${consultation.patient.personne.email}" />
                                        </p>
                                    </div>
                                </td>
                                <td class="py-3 px-4 text-gray-600">
                                    <c:out value="${consultation.motifConsultation}" />
                                </td>
                                <td class="py-3 px-4 text-gray-600">
                                    <c:out value="${consultation.salle.nomSalle}" />
                                </td>
                                <td class="py-3 px-4">
                                    <span class="status-badge status-${consultation.statut.name().toLowerCase()}">
                                        <c:out value="${consultation.statut}" />
                                    </span>
                                </td>
                                <td class="py-3 px-4">
                                    <c:choose>
                                        <c:when test="${consultation.statut.name() == 'RESERVEE'}">
                                            <a href="${pageContext.request.contextPath}/docteur/validation?id=${consultation.idConsultation}"
                                               class="text-orange-600 hover:text-orange-700 font-medium">
                                                <i class="fas fa-check-circle mr-1"></i>Valider
                                            </a>
                                        </c:when>
                                        <c:when test="${consultation.statut.name() == 'VALIDEE'}">
                                            <a href="${pageContext.request.contextPath}/docteur/compte-rendu?id=${consultation.idConsultation}"
                                               class="text-blue-600 hover:text-blue-700 font-medium">
                                                <i class="fas fa-file-medical mr-1"></i>Compte Rendu
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-gray-400">-</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Pending Validations Section -->
    <c:if test="${not empty consultationsEnAttente and consultationsEnAttente.size() > 0}">
        <div class="card p-6 mt-8 fade-in-up">
            <div class="flex items-center justify-between mb-6">
                <h3 class="text-xl font-bold text-gray-800">
                    <i class="fas fa-hourglass-half text-orange-600 mr-2"></i>
                    Réservations en Attente de Validation
                </h3>
                <a href="${pageContext.request.contextPath}/docteur/validation"
                   class="text-purple-600 hover:text-purple-700 font-medium">
                    Voir tout <i class="fas fa-arrow-right ml-1"></i>
                </a>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <c:forEach var="consultation" items="${consultationsEnAttente}" begin="0" end="3">
                    <div class="border border-gray-200 rounded-xl p-4 hover:border-purple-300 transition-colors">
                        <div class="flex items-start justify-between mb-3">
                            <div>
                                <p class="font-semibold text-gray-800">
                                    <c:out value="${consultation.patient.personne.prenom}" />
                                    <c:out value="${consultation.patient.personne.nom}" />
                                </p>
                                <p class="text-sm text-gray-500">
                                    ${consultation.dateConsultation} à ${consultation.heureConsultation}
                                </p>
                            </div>
                            <span class="status-badge status-reservee">
                                <c:out value="${consultation.statut}" />
                            </span>
                        </div>
                        <p class="text-sm text-gray-600 mb-3">
                            <i class="fas fa-comment-medical text-gray-400 mr-1"></i>
                            <c:out value="${consultation.motifConsultation}" />
                        </p>
                        <a href="${pageContext.request.contextPath}/docteur/validation?id=${consultation.idConsultation}"
                           class="btn-gradient text-white px-4 py-2 rounded-lg text-sm font-medium inline-block w-full text-center">
                            <i class="fas fa-check-circle mr-2"></i>Valider cette réservation
                        </a>
                    </div>
                </c:forEach>
            </div>
        </div>
    </c:if>
</div>

</body>
</html>
