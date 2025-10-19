<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><c:out value="${action == 'save' ? 'Nouvelle Salle' : 'Modifier Salle'}"/> - MediSphere</title>
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
        .form-input:focus {
            border-color: #667eea;
            ring-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
    </style>
</head>
<body class="p-6">
    <div class="max-w-4xl mx-auto">
        <!-- Header -->
        <div class="bg-white rounded-2xl shadow-2xl p-6 mb-6 fade-in">
            <div class="flex justify-between items-center">
                <div>
                    <h1 class="text-4xl font-bold bg-gradient-to-r from-purple-600 to-blue-600 bg-clip-text text-transparent mb-2">
                        <i class="fas fa-door-open mr-3"></i>
                        <c:out value="${action == 'save' ? 'Nouvelle Salle' : 'Modifier Salle'}"/>
                    </h1>
                    <p class="text-gray-600">
                        <c:out value="${action == 'save' ? 'Ajouter une nouvelle salle de consultation' : 'Modifier les informations de la salle'}"/>
                    </p>
                </div>
                <a href="${pageContext.request.contextPath}/admin/salles" 
                   class="px-4 py-2 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 transition">
                    <i class="fas fa-arrow-left mr-2"></i>Retour
                </a>
            </div>
        </div>

        <!-- Error Message -->
        <c:if test="${not empty errorMessage}">
            <div class="bg-red-100 border-l-4 border-red-500 text-red-700 p-4 rounded-lg mb-6 fade-in">
                <i class="fas fa-exclamation-triangle mr-2"></i>${errorMessage}
            </div>
        </c:if>

        <!-- Form -->
        <div class="bg-white rounded-2xl shadow-2xl p-8 fade-in">
            <form method="post" action="${pageContext.request.contextPath}/admin/salles">
                <input type="hidden" name="action" value="${action}">
                <c:if test="${action == 'update'}">
                    <input type="hidden" name="id" value="${salle.idSalle}">
                </c:if>

                <div class="space-y-6">
                    <!-- Nom Salle -->
                    <div>
                        <label for="nomSalle" class="block text-sm font-semibold text-gray-700 mb-2">
                            <i class="fas fa-door-open mr-2 text-purple-600"></i>Nom de la Salle *
                        </label>
                        <input type="text" 
                               id="nomSalle" 
                               name="nomSalle" 
                               value="${salle.nomSalle}" 
                               required
                               maxlength="50"
                               class="form-input w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none transition"
                               placeholder="Ex: Salle 101, Salle de Consultation A">
                        <p class="mt-1 text-xs text-gray-500">
                            <i class="fas fa-info-circle mr-1"></i>Nom unique de la salle (max 50 caractères)
                        </p>
                    </div>

                    <!-- Two columns: Étage and Capacité -->
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <!-- Numéro Étage -->
                        <div>
                            <label for="numeroEtage" class="block text-sm font-semibold text-gray-700 mb-2">
                                <i class="fas fa-layer-group mr-2 text-purple-600"></i>Numéro d'Étage
                            </label>
                            <input type="number" 
                                   id="numeroEtage" 
                                   name="numeroEtage" 
                                   value="${salle.numeroEtage}" 
                                   min="0"
                                   max="50"
                                   class="form-input w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none transition"
                                   placeholder="Ex: 1">
                            <p class="mt-1 text-xs text-gray-500">
                                <i class="fas fa-info-circle mr-1"></i>Étage où se trouve la salle (optionnel)
                            </p>
                        </div>

                        <!-- Capacité -->
                        <div>
                            <label for="capacite" class="block text-sm font-semibold text-gray-700 mb-2">
                                <i class="fas fa-users mr-2 text-purple-600"></i>Capacité (personnes)
                            </label>
                            <input type="number" 
                                   id="capacite" 
                                   name="capacite" 
                                   value="${salle.capacite}" 
                                   min="1"
                                   max="100"
                                   class="form-input w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none transition"
                                   placeholder="Ex: 5">
                            <p class="mt-1 text-xs text-gray-500">
                                <i class="fas fa-info-circle mr-1"></i>Nombre de personnes maximum (optionnel)
                            </p>
                        </div>
                    </div>

                    <!-- Équipements -->
                    <div>
                        <label for="equipements" class="block text-sm font-semibold text-gray-700 mb-2">
                            <i class="fas fa-tools mr-2 text-purple-600"></i>Équipements
                        </label>
                        <textarea id="equipements" 
                                  name="equipements" 
                                  rows="4"
                                  class="form-input w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none transition"
                                  placeholder="Ex: Scanner, IRM, Table d'examen, Échographe...">${salle.equipements}</textarea>
                        <p class="mt-1 text-xs text-gray-500">
                            <i class="fas fa-info-circle mr-1"></i>Liste des équipements disponibles dans cette salle (optionnel)
                        </p>
                    </div>

                    <!-- Disponible -->
                    <div class="flex items-center space-x-3 p-4 bg-gray-50 rounded-lg">
                        <input type="checkbox" 
                               id="disponible" 
                               name="disponible" 
                               ${salle.disponible ? 'checked' : ''}
                               ${empty salle.idSalle ? 'checked' : ''}
                               class="w-5 h-5 text-purple-600 border-gray-300 rounded focus:ring-purple-500">
                        <label for="disponible" class="text-sm font-semibold text-gray-700">
                            <i class="fas fa-check-circle mr-2 text-green-600"></i>
                            Salle disponible pour les consultations
                        </label>
                    </div>

                    <!-- Required Fields Notice -->
                    <div class="bg-blue-50 border border-blue-200 rounded-lg p-4">
                        <p class="text-sm text-blue-800">
                            <i class="fas fa-info-circle mr-2"></i>
                            <strong>Note:</strong> Les champs marqués d'un astérisque (*) sont obligatoires
                        </p>
                    </div>

                    <!-- Action Buttons -->
                    <div class="flex gap-4 pt-4">
                        <button type="submit" 
                                class="flex-1 px-6 py-3 bg-gradient-to-r from-purple-600 to-blue-600 text-white font-semibold rounded-lg hover:shadow-xl transition transform hover:scale-105">
                            <i class="fas fa-save mr-2"></i>
                            <c:out value="${action == 'save' ? 'Créer la Salle' : 'Mettre à Jour'}"/>
                        </button>
                        <a href="${pageContext.request.contextPath}/admin/salles" 
                           class="flex-1 px-6 py-3 bg-gray-200 text-gray-700 font-semibold rounded-lg hover:bg-gray-300 transition text-center">
                            <i class="fas fa-times mr-2"></i>Annuler
                        </a>
                    </div>
                </div>
            </form>
        </div>

        <!-- Footer Info -->
        <div class="mt-6 text-center text-white/80 text-sm">
            <p><i class="fas fa-info-circle mr-2"></i>MediSphere - Système de gestion hospitalière</p>
        </div>
    </div>

    <script>
        // Auto-focus on first input
        document.getElementById('nomSalle').focus();

        // Form validation
        document.querySelector('form').addEventListener('submit', function(e) {
            const nomSalle = document.getElementById('nomSalle').value.trim();
            
            if (!nomSalle) {
                e.preventDefault();
                alert('Le nom de la salle est obligatoire');
                document.getElementById('nomSalle').focus();
                return false;
            }

            const capacite = document.getElementById('capacite').value;
            if (capacite && (capacite < 1 || capacite > 100)) {
                e.preventDefault();
                alert('La capacité doit être entre 1 et 100 personnes');
                document.getElementById('capacite').focus();
                return false;
            }

            const numeroEtage = document.getElementById('numeroEtage').value;
            if (numeroEtage && (numeroEtage < 0 || numeroEtage > 50)) {
                e.preventDefault();
                alert('Le numéro d\'étage doit être entre 0 et 50');
                document.getElementById('numeroEtage').focus();
                return false;
            }
        });
    </script>
</body>
</html>
