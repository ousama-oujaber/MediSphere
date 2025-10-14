<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Salles - MediSphere</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@300;400;500;600;700&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }
        h1, h2, h3 {
            font-family: 'Space Grotesk', sans-serif;
        }
        .fade-in {
            animation: fadeIn 0.5s ease-in;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .hover-scale {
            transition: transform 0.2s ease;
        }
        .hover-scale:hover {
            transform: scale(1.02);
        }
    </style>
</head>
<body class="p-6">
    <div class="max-w-7xl mx-auto">
        <!-- Header -->
        <div class="bg-white rounded-2xl shadow-2xl p-6 mb-6 fade-in">
            <div class="flex justify-between items-center">
                <div>
                    <h1 class="text-4xl font-bold bg-gradient-to-r from-purple-600 to-blue-600 bg-clip-text text-transparent mb-2">
                        <i class="fas fa-door-open mr-3"></i>Gestion des Salles
                    </h1>
                    <p class="text-gray-600">Gérez les salles de consultation de votre établissement</p>
                </div>
                <div class="flex gap-3">
                    <a href="${pageContext.request.contextPath}/dashboard" 
                       class="px-4 py-2 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 transition">
                        <i class="fas fa-arrow-left mr-2"></i>Retour
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/salles?action=new" 
                       class="px-6 py-2 bg-gradient-to-r from-purple-600 to-blue-600 text-white rounded-lg hover:shadow-lg transition hover-scale">
                        <i class="fas fa-plus mr-2"></i>Nouvelle Salle
                    </a>
                </div>
            </div>
        </div>

        <!-- Success/Error Messages -->
        <c:if test="${param.success == 'created'}">
            <div class="bg-green-100 border-l-4 border-green-500 text-green-700 p-4 rounded-lg mb-6 fade-in">
                <i class="fas fa-check-circle mr-2"></i>Salle créée avec succès !
            </div>
        </c:if>
        <c:if test="${param.success == 'updated'}">
            <div class="bg-blue-100 border-l-4 border-blue-500 text-blue-700 p-4 rounded-lg mb-6 fade-in">
                <i class="fas fa-check-circle mr-2"></i>Salle mise à jour avec succès !
            </div>
        </c:if>
        <c:if test="${param.success == 'deleted'}">
            <div class="bg-red-100 border-l-4 border-red-500 text-red-700 p-4 rounded-lg mb-6 fade-in">
                <i class="fas fa-trash mr-2"></i>Salle supprimée avec succès !
            </div>
        </c:if>
        <c:if test="${not empty param.error}">
            <div class="bg-red-100 border-l-4 border-red-500 text-red-700 p-4 rounded-lg mb-6 fade-in">
                <i class="fas fa-exclamation-triangle mr-2"></i>${param.error}
            </div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="bg-red-100 border-l-4 border-red-500 text-red-700 p-4 rounded-lg mb-6 fade-in">
                <i class="fas fa-exclamation-triangle mr-2"></i>${errorMessage}
            </div>
        </c:if>

        <!-- Salles List -->
        <div class="bg-white rounded-2xl shadow-2xl overflow-hidden fade-in">
            <div class="p-6 bg-gradient-to-r from-purple-50 to-blue-50 border-b">
                <h2 class="text-2xl font-bold text-gray-800">
                    <i class="fas fa-list mr-2"></i>Liste des Salles
                    <span class="text-sm font-normal text-gray-600 ml-3">(${salles.size()} salle(s))</span>
                </h2>
            </div>
            
            <div class="overflow-x-auto">
                <c:choose>
                    <c:when test="${empty salles}">
                        <div class="p-12 text-center text-gray-500">
                            <i class="fas fa-door-open text-6xl mb-4 text-gray-300"></i>
                            <p class="text-xl">Aucune salle trouvée</p>
                            <p class="mt-2">Commencez par créer une nouvelle salle</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <table class="w-full">
                            <thead class="bg-gray-50">
                                <tr>
                                    <th class="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                                        <i class="fas fa-hashtag mr-2"></i>ID
                                    </th>
                                    <th class="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                                        <i class="fas fa-door-open mr-2"></i>Nom
                                    </th>
                                    <th class="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                                        <i class="fas fa-layer-group mr-2"></i>Étage
                                    </th>
                                    <th class="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                                        <i class="fas fa-users mr-2"></i>Capacité
                                    </th>
                                    <th class="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                                        <i class="fas fa-tools mr-2"></i>Équipements
                                    </th>
                                    <th class="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                                        <i class="fas fa-check-circle mr-2"></i>Disponible
                                    </th>
                                    <th class="px-6 py-4 text-center text-xs font-semibold text-gray-600 uppercase tracking-wider">
                                        <i class="fas fa-cog mr-2"></i>Actions
                                    </th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-gray-200">
                                <c:forEach var="salle" items="${salles}">
                                    <tr class="hover:bg-gray-50 transition">
                                        <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                                            #${salle.idSalle}
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            <div class="text-sm font-semibold text-gray-900">${salle.nomSalle}</div>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            <c:choose>
                                                <c:when test="${not empty salle.numeroEtage}">
                                                    <span class="px-2 py-1 text-xs font-semibold rounded-full bg-purple-100 text-purple-800">
                                                        Étage ${salle.numeroEtage}
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-sm text-gray-400">-</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            <c:choose>
                                                <c:when test="${not empty salle.capacite}">
                                                    <span class="text-sm text-gray-900">
                                                        <i class="fas fa-user mr-1"></i>${salle.capacite} pers.
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-sm text-gray-400">-</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="px-6 py-4">
                                            <c:choose>
                                                <c:when test="${not empty salle.equipements}">
                                                    <div class="text-sm text-gray-600 max-w-xs truncate" title="${salle.equipements}">
                                                        ${salle.equipements}
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-sm text-gray-400">Aucun</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            <c:choose>
                                                <c:when test="${salle.disponible}">
                                                    <span class="px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800">
                                                        <i class="fas fa-check mr-1"></i>Disponible
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full bg-red-100 text-red-800">
                                                        <i class="fas fa-times mr-1"></i>Indisponible
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap text-center text-sm font-medium">
                                            <a href="${pageContext.request.contextPath}/admin/salles?action=edit&id=${salle.idSalle}" 
                                               class="text-blue-600 hover:text-blue-900 mr-3">
                                                <i class="fas fa-edit"></i> Modifier
                                            </a>
                                            <a href="${pageContext.request.contextPath}/admin/salles?action=delete&id=${salle.idSalle}" 
                                               class="text-red-600 hover:text-red-900"
                                               onclick="return confirm('Êtes-vous sûr de vouloir supprimer cette salle ?');">
                                                <i class="fas fa-trash"></i> Supprimer
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Footer Info -->
        <div class="mt-6 text-center text-white/80 text-sm">
            <p><i class="fas fa-info-circle mr-2"></i>MediSphere - Système de gestion hospitalière</p>
        </div>
    </div>
</body>
</html>
