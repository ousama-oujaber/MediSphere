<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Patients - MediSphere</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@300;400;500;600;700&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }
        h1, h2, h3, h4, h5, h6 {
            font-family: 'Space Grotesk', sans-serif;
        }
        .card-glass {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.15);
        }
        .gradient-text {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        .btn-gradient {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            transition: all 0.3s ease;
        }
        .btn-gradient:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(102, 126, 234, 0.4);
        }
        .search-box {
            border: 2px solid #e2e8f0;
            transition: all 0.3s ease;
        }
        .search-box:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        .action-btn {
            transition: all 0.2s ease;
        }
        .action-btn:hover {
            transform: scale(1.1);
        }
        .badge-medical {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
    </style>
</head>
<body class="p-6">
    <div class="max-w-7xl mx-auto">
        <!-- Header -->
        <div class="card-glass p-6 mb-6">
            <div class="flex items-center justify-between">
                <div>
                    <h1 class="text-4xl font-bold gradient-text mb-2">
                        <i class="fas fa-user-injured mr-3"></i>Gestion des Patients
                    </h1>
                    <p class="text-gray-600">Gérer les dossiers patients de l'hôpital</p>
                </div>
                <div class="flex gap-3">
                    <a href="${pageContext.request.contextPath}/dashboard" 
                       class="px-4 py-2 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 transition-colors">
                        <i class="fas fa-arrow-left mr-2"></i>Retour au Dashboard
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/patients?action=new" 
                       class="btn-gradient text-white px-6 py-2 rounded-lg font-semibold">
                        <i class="fas fa-plus mr-2"></i>Nouveau Patient
                    </a>
                </div>
            </div>
        </div>

        <!-- Messages -->
        <c:if test="${not empty successMessage}">
            <div class="card-glass p-4 mb-6 border-l-4 border-green-500">
                <div class="flex items-center">
                    <i class="fas fa-check-circle text-green-500 text-2xl mr-3"></i>
                    <p class="text-green-700 font-semibold">${successMessage}</p>
                </div>
            </div>
        </c:if>

        <c:if test="${not empty errorMessage}">
            <div class="card-glass p-4 mb-6 border-l-4 border-red-500">
                <div class="flex items-center">
                    <i class="fas fa-exclamation-circle text-red-500 text-2xl mr-3"></i>
                    <p class="text-red-700 font-semibold">${errorMessage}</p>
                </div>
            </div>
        </c:if>

        <!-- Search Box -->
        <div class="card-glass p-6 mb-6">
            <form action="${pageContext.request.contextPath}/admin/patients" method="get" class="flex gap-3">
                <input type="hidden" name="action" value="search">
                <div class="flex-1">
                    <input type="text" 
                           name="keyword" 
                           value="${keyword}"
                           placeholder="Rechercher par nom, prénom, email ou numéro de dossier..." 
                           class="search-box w-full px-4 py-3 rounded-lg outline-none">
                </div>
                <button type="submit" class="btn-gradient text-white px-6 py-3 rounded-lg font-semibold">
                    <i class="fas fa-search mr-2"></i>Rechercher
                </button>
                <c:if test="${not empty keyword}">
                    <a href="${pageContext.request.contextPath}/admin/patients" 
                       class="px-6 py-3 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 transition-colors">
                        <i class="fas fa-times mr-2"></i>Réinitialiser
                    </a>
                </c:if>
            </form>
        </div>

        <!-- Patients Table -->
        <div class="card-glass p-6">
            <div class="flex items-center justify-between mb-6">
                <h2 class="text-2xl font-bold text-gray-800">
                    <i class="fas fa-list mr-2"></i>Liste des Patients
                    <span class="text-lg text-gray-500 ml-2">(${patients.size()} patients)</span>
                </h2>
            </div>

            <c:choose>
                <c:when test="${empty patients}">
                    <div class="text-center py-12">
                        <i class="fas fa-user-injured text-6xl text-gray-300 mb-4"></i>
                        <p class="text-gray-500 text-lg">Aucun patient trouvé</p>
                        <c:if test="${not empty keyword}">
                            <p class="text-gray-400 mt-2">Essayez une autre recherche</p>
                        </c:if>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="overflow-x-auto">
                        <table class="w-full">
                            <thead>
                                <tr class="border-b-2 border-gray-200">
                                    <th class="text-left py-4 px-4 font-semibold text-gray-700">N° Dossier</th>
                                    <th class="text-left py-4 px-4 font-semibold text-gray-700">Nom Complet</th>
                                    <th class="text-left py-4 px-4 font-semibold text-gray-700">Email</th>
                                    <th class="text-left py-4 px-4 font-semibold text-gray-700">Téléphone</th>
                                    <th class="text-left py-4 px-4 font-semibold text-gray-700">Groupe Sanguin</th>
                                    <th class="text-center py-4 px-4 font-semibold text-gray-700">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="patient" items="${patients}">
                                    <tr class="border-b border-gray-100 hover:bg-gray-50 transition-colors">
                                        <td class="py-4 px-4">
                                            <span class="badge-medical text-white px-3 py-1 rounded-full text-sm font-semibold">
                                                ${patient.numeroDossier}
                                            </span>
                                        </td>
                                        <td class="py-4 px-4">
                                            <div class="font-semibold text-gray-800">${patient.nomComplet}</div>
                                        </td>
                                        <td class="py-4 px-4 text-gray-600">
                                            <i class="fas fa-envelope text-gray-400 mr-2"></i>${patient.email}
                                        </td>
                                        <td class="py-4 px-4 text-gray-600">
                                            <i class="fas fa-phone text-gray-400 mr-2"></i>
                                            <c:choose>
                                                <c:when test="${not empty patient.personne.telephone}">
                                                    ${patient.personne.telephone}
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-gray-400">Non renseigné</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="py-4 px-4">
                                            <c:choose>
                                                <c:when test="${not empty patient.groupeSanguin}">
                                                    <span class="bg-red-100 text-red-700 px-3 py-1 rounded-full text-sm font-semibold">
                                                        <i class="fas fa-tint mr-1"></i>${patient.groupeSanguin}
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-gray-400">Non défini</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="py-4 px-4">
                                            <div class="flex justify-center gap-2">
                                                <a href="${pageContext.request.contextPath}/admin/patients?action=edit&id=${patient.idPatient}" 
                                                   class="action-btn bg-blue-500 hover:bg-blue-600 text-white px-4 py-2 rounded-lg"
                                                   title="Modifier">
                                                    <i class="fas fa-edit"></i>
                                                </a>
                                                <a href="${pageContext.request.contextPath}/admin/patients?action=delete&id=${patient.idPatient}" 
                                                   onclick="return confirm('Êtes-vous sûr de vouloir supprimer ce patient ?');"
                                                   class="action-btn bg-red-500 hover:bg-red-600 text-white px-4 py-2 rounded-lg"
                                                   title="Supprimer">
                                                    <i class="fas fa-trash"></i>
                                                </a>
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

    <script>
        // Auto-hide success messages after 5 seconds
        setTimeout(function() {
            const successMessage = document.querySelector('.border-green-500');
            if (successMessage) {
                successMessage.style.transition = 'opacity 0.5s';
                successMessage.style.opacity = '0';
                setTimeout(() => successMessage.remove(), 500);
            }
        }, 5000);
    </script>
</body>
</html>
