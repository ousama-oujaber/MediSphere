<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Historique des Consultations - MediSphere</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-gray-50">
    <div class="flex h-screen">
        <!-- Sidebar -->
        <aside class="w-64 bg-gradient-to-b from-purple-600 to-purple-800 text-white">
            <div class="p-6">
                <div class="flex items-center space-x-2 mb-8">
                    <i class="fas fa-hospital text-3xl"></i>
                    <span class="text-2xl font-bold">MediSphere</span>
                </div>
                <nav class="space-y-2">
                    <a href="${pageContext.request.contextPath}/patient/dashboard" 
                       class="flex items-center space-x-3 px-4 py-3 rounded-lg hover:bg-purple-700 transition">
                        <i class="fas fa-chart-line"></i>
                        <span>Tableau de Bord</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/patient/docteurs" 
                       class="flex items-center space-x-3 px-4 py-3 rounded-lg hover:bg-purple-700 transition">
                        <i class="fas fa-user-md"></i>
                        <span>Nos Docteurs</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/patient/reservation" 
                       class="flex items-center space-x-3 px-4 py-3 rounded-lg hover:bg-purple-700 transition">
                        <i class="fas fa-calendar-plus"></i>
                        <span>Réserver</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/patient/historique" 
                       class="flex items-center space-x-3 px-4 py-3 bg-purple-900 rounded-lg transition">
                        <i class="fas fa-history"></i>
                        <span>Historique</span>
                    </a>
                </nav>
            </div>
            <div class="absolute bottom-0 w-64 p-6 border-t border-purple-500">
                <a href="${pageContext.request.contextPath}/auth/logout" 
                   class="flex items-center space-x-3 px-4 py-3 rounded-lg hover:bg-purple-700 transition text-white">
                    <i class="fas fa-sign-out-alt"></i>
                    <span>Déconnexion</span>
                </a>
            </div>
        </aside>

        <!-- Main Content -->
        <main class="flex-1 overflow-y-auto">
            <!-- Header -->
            <header class="bg-white shadow-sm">
                <div class="flex items-center justify-between px-8 py-4">
                    <div>
                        <h1 class="text-2xl font-bold text-gray-800">Historique des Consultations</h1>
                        <p class="text-gray-600">Consultez l'historique de vos rendez-vous médicaux</p>
                    </div>
                    <div class="flex items-center space-x-4">
                        <span class="text-gray-600">${sessionScope.userConnecte.nom} ${sessionScope.userConnecte.prenom}</span>
                        <div class="w-10 h-10 bg-gradient-to-br from-purple-500 to-purple-700 rounded-full flex items-center justify-center text-white font-semibold">
                            ${sessionScope.userConnecte.prenom.substring(0,1)}${sessionScope.userConnecte.nom.substring(0,1)}
                        </div>
                    </div>
                </div>
            </header>

            <!-- Alerts -->
            <c:if test="${not empty sessionScope.error}">
                <div class="mx-8 mt-6 bg-red-100 border-l-4 border-red-500 text-red-700 p-4 rounded" role="alert">
                    <div class="flex items-center">
                        <i class="fas fa-exclamation-circle mr-3"></i>
                        <p>${sessionScope.error}</p>
                    </div>
                </div>
                <c:remove var="error" scope="session"/>
            </c:if>

            <c:if test="${not empty sessionScope.success}">
                <div class="mx-8 mt-6 bg-green-100 border-l-4 border-green-500 text-green-700 p-4 rounded" role="alert">
                    <div class="flex items-center">
                        <i class="fas fa-check-circle mr-3"></i>
                        <p>${sessionScope.success}</p>
                    </div>
                </div>
                <c:remove var="success" scope="session"/>
            </c:if>

            <div class="p-8">
                <!-- Filter Section -->
                <div class="bg-white rounded-lg shadow-md p-6 mb-6">
                    <form method="get" class="flex items-center space-x-4">
                        <label for="statut" class="text-sm font-medium text-gray-700">
                            <i class="fas fa-filter text-purple-600 mr-2"></i>
                            Filtrer par statut:
                        </label>
                        <select id="statut" 
                                name="statut" 
                                onchange="this.form.submit()"
                                class="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-transparent">
                            <option value="ALL" ${selectedStatus == 'ALL' ? 'selected' : ''}>Tous les statuts</option>
                            <option value="RESERVEE" ${selectedStatus == 'RESERVEE' ? 'selected' : ''}>Réservée</option>
                            <option value="VALIDEE" ${selectedStatus == 'VALIDEE' ? 'selected' : ''}>Validée</option>
                            <option value="TERMINEE" ${selectedStatus == 'TERMINEE' ? 'selected' : ''}>Terminée</option>
                            <option value="ANNULEE" ${selectedStatus == 'ANNULEE' ? 'selected' : ''}>Annulée</option>
                        </select>
                        <span class="text-sm text-gray-600">
                            <i class="fas fa-info-circle mr-1"></i>
                            ${consultations.size()} consultation(s) trouvée(s)
                        </span>
                    </form>
                </div>

                <!-- Consultations Table -->
                <div class="bg-white rounded-lg shadow-md overflow-hidden">
                    <c:choose>
                        <c:when test="${empty consultations}">
                            <div class="text-center py-12">
                                <i class="fas fa-calendar-times text-6xl text-gray-300 mb-4"></i>
                                <p class="text-xl text-gray-500 mb-2">Aucune consultation trouvée</p>
                                <p class="text-gray-400 mb-6">Commencez par prendre un rendez-vous avec un de nos docteurs</p>
                                <a href="${pageContext.request.contextPath}/patient/docteurs" 
                                   class="inline-flex items-center px-6 py-3 bg-gradient-to-r from-purple-600 to-purple-700 text-white rounded-lg hover:from-purple-700 hover:to-purple-800 transition">
                                    <i class="fas fa-user-md mr-2"></i>
                                    Voir les Docteurs
                                </a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <table class="min-w-full divide-y divide-gray-200">
                                <thead class="bg-gray-50">
                                    <tr>
                                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Date & Heure</th>
                                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Docteur</th>
                                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Département</th>
                                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Salle</th>
                                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Motif</th>
                                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Statut</th>
                                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
                                    </tr>
                                </thead>
                                <tbody class="bg-white divide-y divide-gray-200">
                                    <c:forEach items="${consultations}" var="consultation">
                                        <tr class="hover:bg-gray-50">
                                            <td class="px-6 py-4 whitespace-nowrap">
                                                <div class="flex items-center">
                                                    <i class="fas fa-calendar text-purple-600 mr-2"></i>
                                                    <div>
                                                        <div class="text-sm font-medium text-gray-900">${consultation.dateConsultation}</div>
                                                        <div class="text-sm text-gray-500">${consultation.heureConsultation}</div>
                                                    </div>
                                                </div>
                                            </td>
                                            <td class="px-6 py-4 whitespace-nowrap">
                                                <div class="text-sm font-medium text-gray-900">Dr. ${consultation.docteur.personne.nom} ${consultation.docteur.personne.prenom}</div>
                                                <div class="text-sm text-gray-500">${consultation.docteur.specialite}</div>
                                            </td>
                                            <td class="px-6 py-4 whitespace-nowrap">
                                                <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium bg-gradient-to-r from-purple-100 to-purple-200 text-purple-800">
                                                        ${consultation.docteur.departement.nom}
                                                </span>
                                            </td>
                                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                                <i class="fas fa-door-open mr-1"></i>
                                                ${consultation.salle.numeroSalle}
                                            </td>
                                            <td class="px-6 py-4">
                                                <div class="text-sm text-gray-900 max-w-xs truncate" title="${consultation.motifConsultation}">
                                                    ${consultation.motifConsultation}
                                                </div>
                                            </td>
                                            <td class="px-6 py-4 whitespace-nowrap">
                                                <c:choose>
                                                    <c:when test="${consultation.statut == 'RESERVEE'}">
                                                        <span class="px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full bg-yellow-100 text-yellow-800">
                                                            <i class="fas fa-clock mr-1"></i>
                                                            Réservée
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${consultation.statut == 'VALIDEE'}">
                                                        <span class="px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full bg-blue-100 text-blue-800">
                                                            <i class="fas fa-check mr-1"></i>
                                                            Validée
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${consultation.statut == 'TERMINEE'}">
                                                        <span class="px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800">
                                                            <i class="fas fa-check-double mr-1"></i>
                                                            Terminée
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${consultation.statut == 'ANNULEE'}">
                                                        <span class="px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full bg-red-100 text-red-800">
                                                            <i class="fas fa-times mr-1"></i>
                                                            Annulée
                                                        </span>
                                                    </c:when>
                                                </c:choose>
                                            </td>
                                            <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                                                <c:if test="${consultation.statut == 'RESERVEE'}">
                                                    <div class="flex space-x-3">
                                                        <a href="${pageContext.request.contextPath}/patient/modifier-reservation?id=${consultation.idConsultation}"
                                                           class="text-blue-600 hover:text-blue-900">
                                                            <i class="fas fa-edit mr-1"></i>
                                                            Modifier
                                                        </a>
                                                        <button onclick="cancelConsultation(${consultation.idConsultation}, '${consultation.dateConsultation}', '${consultation.heureConsultation}')"
                                                                class="text-red-600 hover:text-red-900">
                                                            <i class="fas fa-times-circle mr-1"></i>
                                                            Annuler
                                                        </button>
                                                    </div>
                                                </c:if>
                                                <c:if test="${consultation.statut == 'TERMINEE' && not empty consultation.compteRendu}">
                                                    <button onclick="showCompteRendu('${consultation.compteRendu}')"
                                                            class="text-purple-600 hover:text-purple-900">
                                                        <i class="fas fa-file-medical mr-1"></i>
                                                        Voir CR
                                                    </button>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </main>
    </div>

    <!-- Modal for Compte Rendu -->
    <div id="compteRenduModal" class="hidden fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full z-50">
        <div class="relative top-20 mx-auto p-5 border w-11/12 md:w-3/4 lg:w-1/2 shadow-lg rounded-md bg-white">
            <div class="flex items-center justify-between mb-4">
                <h3 class="text-xl font-bold text-gray-900">
                    <i class="fas fa-file-medical text-purple-600 mr-2"></i>
                    Compte Rendu Médical
                </h3>
                <button onclick="closeModal()" class="text-gray-400 hover:text-gray-600">
                    <i class="fas fa-times text-2xl"></i>
                </button>
            </div>
            <div id="compteRenduContent" class="mt-4 p-4 bg-gray-50 rounded-lg text-gray-700 whitespace-pre-wrap">
            </div>
            <div class="mt-6 flex justify-end">
                <button onclick="closeModal()" 
                        class="px-6 py-2 bg-gray-600 text-white rounded-lg hover:bg-gray-700 transition">
                    Fermer
                </button>
            </div>
        </div>
    </div>

    <!-- Cancel Confirmation Form -->
    <form id="cancelForm" method="post" style="display: none;">
        <input type="hidden" name="action" value="cancel">
        <input type="hidden" name="consultationId" id="cancelConsultationId">
    </form>

    <script>
        function showCompteRendu(compteRendu) {
            document.getElementById('compteRenduContent').textContent = compteRendu;
            document.getElementById('compteRenduModal').classList.remove('hidden');
        }

        function closeModal() {
            document.getElementById('compteRenduModal').classList.add('hidden');
        }

        function cancelConsultation(consultationId, date, heure) {
            if (confirm('Êtes-vous sûr de vouloir annuler la consultation du ' + date + ' à ' + heure + ' ?')) {
                document.getElementById('cancelConsultationId').value = consultationId;
                document.getElementById('cancelForm').submit();
            }
        }

        // Close modal when clicking outside
        window.onclick = function(event) {
            const modal = document.getElementById('compteRenduModal');
            if (event.target == modal) {
                closeModal();
            }
        }
    </script>
</body>
</html>
