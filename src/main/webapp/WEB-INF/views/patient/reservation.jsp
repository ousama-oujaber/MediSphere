<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Réserver une Consultation - MediSphere</title>
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
                       class="flex items-center space-x-3 px-4 py-3 bg-purple-900 rounded-lg transition">
                        <i class="fas fa-calendar-plus"></i>
                        <span>Réserver</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/patient/historique" 
                       class="flex items-center space-x-3 px-4 py-3 rounded-lg hover:bg-purple-700 transition">
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
                        <h1 class="text-2xl font-bold text-gray-800">Réserver une Consultation</h1>
                        <p class="text-gray-600">Prenez rendez-vous avec votre docteur</p>
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
                    <!-- Doctor Info Card -->
                    <div class="bg-white rounded-lg shadow-md p-6 mb-6">
                        <h2 class="text-xl font-semibold text-gray-800 mb-4">Information du Docteur</h2>
                        <div class="flex items-center space-x-6">
                            <div class="w-20 h-20 bg-gradient-to-br from-purple-500 to-purple-700 rounded-full flex items-center justify-center text-white text-2xl font-bold">
                                ${docteur.personne.prenom.substring(0,1)}${docteur.personne.nom.substring(0,1)}
                            </div>
                            <div>
                                <h3 class="text-2xl font-bold text-gray-800">Dr. ${docteur.personne.nom} ${docteur.personne.prenom}</h3>
                                <p class="text-gray-600 mt-1">
                                    <i class="fas fa-stethoscope text-purple-600 mr-2"></i>
                                    ${docteur.specialite}
                                </p>
                                <p class="text-gray-600 mt-1">
                                    <span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium bg-gradient-to-r from-purple-100 to-purple-200 text-purple-800">
                                            ${docteur.departement.nom}
                                    </span>
                                </p>
                            </div>
                        </div>
                    </div>

                    <!-- Reservation Form -->
                    <div class="bg-white rounded-lg shadow-md p-6">
                        <h2 class="text-xl font-semibold text-gray-800 mb-6">Détails de la Réservation</h2>
                        
                        <form method="post" id="reservationForm" class="space-y-6">
                            <input type="hidden" name="docteurId" value="${docteur.idDocteur}">
                            
                            <!-- Date Selection -->
                            <div>
                                <label for="dateConsultation" class="block text-sm font-medium text-gray-700 mb-2">
                                    <i class="fas fa-calendar text-purple-600 mr-2"></i>
                                    Date de Consultation
                                </label>
                                <input type="date" 
                                       id="dateConsultation" 
                                       name="dateConsultation" 
                                       min="${minDate}"
                                       class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-transparent"
                                       required>
                            </div>

                            <!-- Time Selection -->
                            <div>
                                <label for="heureConsultation" class="block text-sm font-medium text-gray-700 mb-2">
                                    <i class="fas fa-clock text-purple-600 mr-2"></i>
                                    Heure de Consultation
                                </label>
                                <select id="heureConsultation" 
                                        name="heureConsultation" 
                                        class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-transparent"
                                        required>
                                    <option value="">-- Sélectionnez une heure --</option>
                                    <c:forEach items="${timeSlots}" var="slot">
                                        <option value="${slot}">${slot}</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <!-- Reason -->
                            <div>
                                <label for="motifConsultation" class="block text-sm font-medium text-gray-700 mb-2">
                                    <i class="fas fa-notes-medical text-purple-600 mr-2"></i>
                                    Motif de Consultation
                                </label>
                                <textarea id="motifConsultation" 
                                          name="motifConsultation" 
                                          rows="4"
                                          class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-transparent"
                                          placeholder="Décrivez brièvement la raison de votre consultation..."
                                          required></textarea>
                                <p class="mt-2 text-sm text-gray-500">
                                    <i class="fas fa-info-circle mr-1"></i>
                                    Les consultations durent 30 minutes
                                </p>
                            </div>

                            <!-- Action Buttons -->
                            <div class="flex space-x-4 pt-4">
                                <a href="${pageContext.request.contextPath}/patient/docteurs" 
                                   class="flex-1 px-6 py-3 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition text-center">
                                    <i class="fas fa-arrow-left mr-2"></i>
                                    Retour
                                </a>
                                <button type="submit" 
                                        class="flex-1 bg-gradient-to-r from-purple-600 to-purple-700 text-white px-6 py-3 rounded-lg hover:from-purple-700 hover:to-purple-800 transition">
                                    <i class="fas fa-check mr-2"></i>
                                    Confirmer la Réservation
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
                                    <li>• Votre réservation sera confirmée par le docteur</li>
                                    <li>• Vous recevrez une notification lors de la validation</li>
                                    <li>• Vous pouvez annuler votre réservation depuis votre tableau de bord</li>
                                    <li>• Veuillez arriver 10 minutes avant l'heure de votre rendez-vous</li>
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
        document.getElementById('reservationForm').addEventListener('submit', function(e) {
            const date = document.getElementById('dateConsultation').value;
            const time = document.getElementById('heureConsultation').value;
            const motif = document.getElementById('motifConsultation').value.trim();
            
            if (!date || !time || !motif) {
                e.preventDefault();
                alert('Veuillez remplir tous les champs obligatoires');
                return false;
            }
            
            // Confirm reservation
            if (!confirm('Confirmer la réservation pour le ' + date + ' à ' + time + ' ?')) {
                e.preventDefault();
                return false;
            }
        });
    </script>
</body>
</html>
