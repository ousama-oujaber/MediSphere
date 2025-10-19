<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Modifier une Réservation - MediSphere</title>
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
                        <h1 class="text-2xl font-bold text-gray-800">Modifier une Réservation</h1>
                        <p class="text-gray-600">Mettez à jour les détails de votre consultation</p>
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
                <div class="max-w-4xl mx-auto">
                    <!-- Current Consultation Info -->
                    <div class="bg-gradient-to-r from-purple-50 to-purple-100 border border-purple-200 rounded-lg shadow-md p-6 mb-6">
                        <h2 class="text-xl font-semibold text-purple-800 mb-4">
                            <i class="fas fa-info-circle mr-2"></i>
                            Consultation Actuelle
                        </h2>
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                            <div class="flex items-center space-x-3">
                                <div class="w-12 h-12 bg-purple-600 rounded-lg flex items-center justify-center text-white">
                                    <i class="fas fa-user-md text-xl"></i>
                                </div>
                                <div>
                                    <p class="text-sm text-purple-600 font-medium">Docteur</p>
                                    <p class="text-gray-800 font-semibold">Dr. ${consultation.docteur.personne.nom} ${consultation.docteur.personne.prenom}</p>
                                    <p class="text-sm text-gray-600">${consultation.docteur.specialite}</p>
                                </div>
                            </div>
                            <div class="flex items-center space-x-3">
                                <div class="w-12 h-12 bg-purple-600 rounded-lg flex items-center justify-center text-white">
                                    <i class="fas fa-calendar-alt text-xl"></i>
                                </div>
                                <div>
                                    <p class="text-sm text-purple-600 font-medium">Date & Heure</p>
                                    <p class="text-gray-800 font-semibold">${consultation.dateConsultation}</p>
                                    <p class="text-sm text-gray-600">${consultation.heureConsultation}</p>
                                </div>
                            </div>
                        </div>
                        <div class="mt-4 pt-4 border-t border-purple-200">
                            <p class="text-sm text-purple-600 font-medium mb-2">Motif actuel</p>
                            <p class="text-gray-800">${consultation.motifConsultation}</p>
                        </div>
                    </div>

                    <!-- Modification Form -->
                    <div class="bg-white rounded-lg shadow-md p-6">
                        <h2 class="text-xl font-semibold text-gray-800 mb-6">
                            <i class="fas fa-edit mr-2"></i>
                            Nouvelles Informations
                        </h2>
                        
                        <form method="post" id="modificationForm" class="space-y-6">
                            <input type="hidden" name="consultationId" value="${consultation.idConsultation}">
                            
                            <!-- Date Selection -->
                            <div>
                                <label for="dateConsultation" class="block text-sm font-medium text-gray-700 mb-2">
                                    <i class="fas fa-calendar text-purple-600 mr-2"></i>
                                    Nouvelle Date de Consultation
                                </label>
                                <input type="date" 
                                       id="dateConsultation" 
                                       name="dateConsultation" 
                                       min="${minDate}"
                                       value="${consultation.dateConsultation}"
                                       class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-transparent"
                                       required>
                            </div>

                            <!-- Time Selection -->
                            <div>
                                <label for="heureConsultation" class="block text-sm font-medium text-gray-700 mb-2">
                                    <i class="fas fa-clock text-purple-600 mr-2"></i>
                                    Nouvelle Heure de Consultation
                                </label>
                                <select id="heureConsultation" 
                                        name="heureConsultation" 
                                        class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-transparent"
                                        required>
                                    <option value="">-- Sélectionnez une heure --</option>
                                    <c:forEach items="${timeSlots}" var="slot">
                                        <option value="${slot}" ${slot == consultation.heureConsultation ? 'selected' : ''}>${slot}</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <!-- Reason -->
                            <div>
                                <label for="motifConsultation" class="block text-sm font-medium text-gray-700 mb-2">
                                    <i class="fas fa-notes-medical text-purple-600 mr-2"></i>
                                    Nouveau Motif de Consultation
                                </label>
                                <textarea id="motifConsultation" 
                                          name="motifConsultation" 
                                          rows="4"
                                          class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-transparent"
                                          placeholder="Décrivez brièvement la raison de votre consultation..."
                                          required>${consultation.motifConsultation}</textarea>
                                <p class="mt-2 text-sm text-gray-500">
                                    <i class="fas fa-info-circle mr-1"></i>
                                    Les consultations durent 30 minutes
                                </p>
                            </div>

                            <!-- Action Buttons -->
                            <div class="flex space-x-4 pt-4">
                                <a href="${pageContext.request.contextPath}/patient/historique" 
                                   class="flex-1 px-6 py-3 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition text-center">
                                    <i class="fas fa-times mr-2"></i>
                                    Annuler
                                </a>
                                <button type="submit" 
                                        class="flex-1 bg-gradient-to-r from-purple-600 to-purple-700 text-white px-6 py-3 rounded-lg hover:from-purple-700 hover:to-purple-800 transition">
                                    <i class="fas fa-save mr-2"></i>
                                    Enregistrer les Modifications
                                </button>
                            </div>
                        </form>
                    </div>

                    <!-- Important Notice -->
                    <div class="mt-6 bg-blue-50 border-l-4 border-blue-500 p-4 rounded">
                        <div class="flex">
                            <i class="fas fa-info-circle text-blue-500 mt-1 mr-3"></i>
                            <div>
                                <h3 class="text-sm font-semibold text-blue-800">Informations Importantes</h3>
                                <ul class="mt-2 text-sm text-blue-700 space-y-1">
                                    <li>• Le docteur sera notifié de la modification</li>
                                    <li>• Votre réservation conservera son statut actuel</li>
                                    <li>• En cas de changement de date/heure, une nouvelle salle sera attribuée si nécessaire</li>
                                    <li>• Seules les consultations réservées (non validées) peuvent être modifiées</li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <script>
        // Form validation
        document.getElementById('modificationForm').addEventListener('submit', function(e) {
            const date = document.getElementById('dateConsultation').value;
            const time = document.getElementById('heureConsultation').value;
            const motif = document.getElementById('motifConsultation').value.trim();

            if (!date || !time || !motif) {
                e.preventDefault();
                alert('Veuillez remplir tous les champs obligatoires');
                return false;
            }

            // Check if date is not in the past
            const selectedDate = new Date(date);
            const today = new Date();
            today.setHours(0, 0, 0, 0);

            if (selectedDate < today) {
                e.preventDefault();
                alert('La date de consultation ne peut pas être dans le passé');
                return false;
            }

            return confirm('Êtes-vous sûr de vouloir modifier cette réservation ?');
        });
    </script>
</body>
</html>
