<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Médecins - MediSphere</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@300;400;500;600;700&family=Inter:wght@300;400;500;600&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }
        h1, h2, h3, h4, h5, h6 {
            font-family: 'Space Grotesk', sans-serif;
        }
        .card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
        }
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            transition: all 0.3s ease;
        }
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(102, 126, 234, 0.4);
        }
        .table-hover tbody tr:hover {
            background-color: rgba(102, 126, 234, 0.05);
        }
        .badge-success {
            background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
        }
        .badge-danger {
            background: linear-gradient(135deg, #eb3349 0%, #f45c43 100%);
        }
    </style>
</head>
<body class="p-6">
    <div class="container mx-auto max-w-7xl">
        <!-- Header -->
        <div class="flex items-center justify-between mb-8">
            <div>
                <h1 class="text-4xl font-bold text-white mb-2">
                    <i class="fas fa-user-md mr-3"></i>Gestion des Médecins
                </h1>
                <p class="text-white/80">Gérez les médecins de votre établissement</p>
            </div>
            <a href="${pageContext.request.contextPath}/dashboard" class="text-white hover:text-white/80 transition">
                <i class="fas fa-arrow-left mr-2"></i>Retour au Dashboard
            </a>
        </div>

        <!-- Success/Error Messages -->
        <c:if test="${not empty success}">
            <div class="card p-4 mb-6 border-l-4 border-green-500 bg-green-50">
                <div class="flex items-center">
                    <i class="fas fa-check-circle text-green-500 text-xl mr-3"></i>
                    <p class="text-green-800 font-medium">${success}</p>
                </div>
            </div>
        </c:if>

        <c:if test="${not empty error}">
            <div class="card p-4 mb-6 border-l-4 border-red-500 bg-red-50">
                <div class="flex items-center">
                    <i class="fas fa-exclamation-circle text-red-500 text-xl mr-3"></i>
                    <p class="text-red-800 font-medium">${error}</p>
                </div>
            </div>
        </c:if>

        <!-- Main Card -->
        <div class="card p-8">
            <!-- Actions Bar -->
            <div class="flex items-center justify-between mb-6">
                <h2 class="text-2xl font-bold text-gray-800">
                    <i class="fas fa-list mr-2 text-purple-600"></i>Liste des Médecins
                </h2>
                <a href="${pageContext.request.contextPath}/admin/docteurs?action=new" 
                   class="btn-primary text-white px-6 py-3 rounded-lg font-semibold inline-flex items-center">
                    <i class="fas fa-plus mr-2"></i>Nouveau Médecin
                </a>
            </div>

            <!-- Doctors Table -->
            <div class="overflow-x-auto">
                <c:choose>
                    <c:when test="${empty docteurs}">
                        <div class="text-center py-12">
                            <i class="fas fa-user-md text-gray-300 text-6xl mb-4"></i>
                            <p class="text-gray-500 text-lg">Aucun médecin trouvé</p>
                            <p class="text-gray-400 mt-2">Commencez par ajouter un nouveau médecin</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <table class="min-w-full table-hover">
                            <thead>
                                <tr class="bg-gradient-to-r from-purple-50 to-blue-50 border-b-2 border-purple-200">
                                    <th class="px-6 py-4 text-left text-sm font-bold text-gray-700 uppercase tracking-wider">
                                        Nom Complet
                                    </th>
                                    <th class="px-6 py-4 text-left text-sm font-bold text-gray-700 uppercase tracking-wider">
                                        Spécialité
                                    </th>
                                    <th class="px-6 py-4 text-left text-sm font-bold text-gray-700 uppercase tracking-wider">
                                        Département
                                    </th>
                                    <th class="px-6 py-4 text-left text-sm font-bold text-gray-700 uppercase tracking-wider">
                                        Email
                                    </th>
                                    <th class="px-6 py-4 text-left text-sm font-bold text-gray-700 uppercase tracking-wider">
                                        Téléphone
                                    </th>
                                    <th class="px-6 py-4 text-left text-sm font-bold text-gray-700 uppercase tracking-wider">
                                        Expérience
                                    </th>
                                    <th class="px-6 py-4 text-left text-sm font-bold text-gray-700 uppercase tracking-wider">
                                        Statut
                                    </th>
                                    <th class="px-6 py-4 text-center text-sm font-bold text-gray-700 uppercase tracking-wider">
                                        Actions
                                    </th>
                                </tr>
                            </thead>
                            <tbody class="bg-white divide-y divide-gray-200">
                                <c:forEach var="docteur" items="${docteurs}">
                                    <tr class="hover:bg-purple-50 transition-colors">
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            <div class="flex items-center">
                                                <div class="flex-shrink-0 h-10 w-10 bg-gradient-to-br from-purple-400 to-blue-500 rounded-full flex items-center justify-center text-white font-bold">
                                                    ${docteur.personne.prenom.substring(0,1)}${docteur.personne.nom.substring(0,1)}
                                                </div>
                                                <div class="ml-4">
                                                    <div class="text-sm font-bold text-gray-900">
                                                        Dr. ${docteur.personne.nom} ${docteur.personne.prenom}
                                                    </div>
                                                    <div class="text-xs text-gray-500">
                                                        <c:if test="${not empty docteur.numeroOrdre}">
                                                            N° Ordre: ${docteur.numeroOrdre}
                                                        </c:if>
                                                    </div>
                                                </div>
                                            </div>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            <span class="px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full bg-blue-100 text-blue-800">
                                                ${docteur.specialite}
                                            </span>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                                            ${docteur.departement.nom}
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600">
                                            <i class="fas fa-envelope mr-1 text-gray-400"></i>${docteur.personne.email}
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600">
                                            <c:choose>
                                                <c:when test="${not empty docteur.personne.telephone}">
                                                    <i class="fas fa-phone mr-1 text-gray-400"></i>${docteur.personne.telephone}
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-gray-400">-</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                                            <c:choose>
                                                <c:when test="${not empty docteur.anneesExperience}">
                                                    ${docteur.anneesExperience} ans
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-gray-400">-</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            <c:choose>
                                                <c:when test="${docteur.disponible}">
                                                    <span class="badge-success px-3 py-1 text-xs font-bold text-white rounded-full">
                                                        <i class="fas fa-check-circle mr-1"></i>Disponible
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge-danger px-3 py-1 text-xs font-bold text-white rounded-full">
                                                        <i class="fas fa-times-circle mr-1"></i>Indisponible
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap text-center text-sm font-medium">
                                            <a href="${pageContext.request.contextPath}/admin/docteurs?action=edit&id=${docteur.idDocteur}" 
                                               class="text-blue-600 hover:text-blue-900 mx-2" title="Modifier">
                                                <i class="fas fa-edit text-lg"></i>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/admin/docteurs?action=delete&id=${docteur.idDocteur}" 
                                               class="text-red-600 hover:text-red-900 mx-2" 
                                               onclick="return confirm('Êtes-vous sûr de vouloir supprimer ce médecin ?')" 
                                               title="Supprimer">
                                                <i class="fas fa-trash text-lg"></i>
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>

                        <!-- Summary -->
                        <div class="mt-6 p-4 bg-gradient-to-r from-purple-50 to-blue-50 rounded-lg">
                            <p class="text-gray-700 font-medium">
                                <i class="fas fa-info-circle mr-2 text-purple-600"></i>
                                Total: <span class="font-bold text-purple-700">${docteurs.size()}</span> médecin(s)
                            </p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</body>
</html>
