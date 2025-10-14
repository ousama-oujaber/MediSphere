<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><c:choose><c:when test="${action == 'update'}">Modifier</c:when><c:otherwise>Nouveau</c:otherwise></c:choose> Médecin - MediSphere</title>
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
        .input-field {
            border: 2px solid #e2e8f0;
            transition: all 0.3s ease;
        }
        .input-field:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            transition: all 0.3s ease;
        }
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(102, 126, 234, 0.4);
        }
        .form-section {
            border-left: 4px solid #667eea;
            padding-left: 1rem;
        }
    </style>
</head>
<body class="p-6">
    <div class="container mx-auto max-w-4xl">
        <!-- Header -->
        <div class="flex items-center justify-between mb-8">
            <div>
                <h1 class="text-4xl font-bold text-white mb-2">
                    <i class="fas fa-user-md mr-3"></i>
                    <c:choose>
                        <c:when test="${action == 'update'}">Modifier Médecin</c:when>
                        <c:otherwise>Nouveau Médecin</c:otherwise>
                    </c:choose>
                </h1>
                <p class="text-white/80">Remplissez les informations du médecin</p>
            </div>
            <a href="${pageContext.request.contextPath}/admin/docteurs" class="text-white hover:text-white/80 transition">
                <i class="fas fa-arrow-left mr-2"></i>Retour à la liste
            </a>
        </div>

        <!-- Error Messages -->
        <c:if test="${not empty error}">
            <div class="card p-4 mb-6 border-l-4 border-red-500 bg-red-50">
                <div class="flex items-center">
                    <i class="fas fa-exclamation-circle text-red-500 text-xl mr-3"></i>
                    <p class="text-red-800 font-medium">${error}</p>
                </div>
            </div>
        </c:if>

        <!-- Form Card -->
        <div class="card p-8">
            <form method="post" action="${pageContext.request.contextPath}/admin/docteurs?action=${action}" class="space-y-8">
                <!-- Hidden ID for update -->
                <c:if test="${action == 'update'}">
                    <input type="hidden" name="id" value="${docteur.idDocteur}">
                </c:if>

                <!-- Personal Information Section -->
                <div class="form-section">
                    <h2 class="text-2xl font-bold text-gray-800 mb-6">
                        <i class="fas fa-user mr-2 text-purple-600"></i>Informations Personnelles
                    </h2>
                    
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <div>
                            <label for="nom" class="block text-sm font-bold text-gray-700 mb-2">
                                Nom <span class="text-red-500">*</span>
                            </label>
                            <input type="text" id="nom" name="nom" 
                                   value="<c:if test="${not empty docteur}">${docteur.personne.nom}</c:if>"
                                   class="input-field w-full px-4 py-3 rounded-lg focus:outline-none" 
                                   required>
                        </div>

                        <div>
                            <label for="prenom" class="block text-sm font-bold text-gray-700 mb-2">
                                Prénom <span class="text-red-500">*</span>
                            </label>
                            <input type="text" id="prenom" name="prenom" 
                                   value="<c:if test="${not empty docteur}">${docteur.personne.prenom}</c:if>"
                                   class="input-field w-full px-4 py-3 rounded-lg focus:outline-none" 
                                   required>
                        </div>

                        <div>
                            <label for="email" class="block text-sm font-bold text-gray-700 mb-2">
                                Email <span class="text-red-500">*</span>
                            </label>
                            <input type="email" id="email" name="email" 
                                   value="<c:if test="${not empty docteur}">${docteur.personne.email}</c:if>"
                                   class="input-field w-full px-4 py-3 rounded-lg focus:outline-none" 
                                   required>
                        </div>

                        <div>
                            <label for="telephone" class="block text-sm font-bold text-gray-700 mb-2">
                                Téléphone
                            </label>
                            <input type="tel" id="telephone" name="telephone" 
                                   value="<c:if test="${not empty docteur}">${docteur.personne.telephone}</c:if>"
                                   class="input-field w-full px-4 py-3 rounded-lg focus:outline-none" 
                                   placeholder="+212 6 XX XX XX XX">
                        </div>

                        <div class="md:col-span-2">
                            <label for="motDePasse" class="block text-sm font-bold text-gray-700 mb-2">
                                Mot de passe
                                <c:choose>
                                    <c:when test="${action == 'update'}">
                                        <span class="text-gray-500 font-normal text-xs">(Laisser vide pour ne pas changer)</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-red-500">*</span>
                                    </c:otherwise>
                                </c:choose>
                            </label>
                            <input type="password" id="motDePasse" name="motDePasse" 
                                   class="input-field w-full px-4 py-3 rounded-lg focus:outline-none" 
                                   <c:if test="${action != 'update'}">required</c:if>
                                   minlength="8">
                            <p class="text-xs text-gray-500 mt-1">
                                <i class="fas fa-info-circle mr-1"></i>Minimum 8 caractères
                            </p>
                        </div>
                    </div>
                </div>

                <!-- Professional Information Section -->
                <div class="form-section">
                    <h2 class="text-2xl font-bold text-gray-800 mb-6">
                        <i class="fas fa-stethoscope mr-2 text-purple-600"></i>Informations Professionnelles
                    </h2>
                    
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <div>
                            <label for="specialite" class="block text-sm font-bold text-gray-700 mb-2">
                                Spécialité <span class="text-red-500">*</span>
                            </label>
                            <input type="text" id="specialite" name="specialite" 
                                   value="<c:if test="${not empty docteur}">${docteur.specialite}</c:if>"
                                   class="input-field w-full px-4 py-3 rounded-lg focus:outline-none" 
                                   placeholder="Ex: Cardiologie, Pédiatrie..."
                                   required>
                        </div>

                        <div>
                            <label for="departementId" class="block text-sm font-bold text-gray-700 mb-2">
                                Département <span class="text-red-500">*</span>
                            </label>
                            <select id="departementId" name="departementId" 
                                    class="input-field w-full px-4 py-3 rounded-lg focus:outline-none" 
                                    required>
                                <option value="">Sélectionner un département</option>
                                <c:forEach var="dept" items="${departements}">
                                    <option value="${dept.idDepartement}" 
                                            <c:if test="${not empty docteur && docteur.departement.idDepartement == dept.idDepartement}">selected</c:if>>
                                        ${dept.nom}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div>
                            <label for="numeroOrdre" class="block text-sm font-bold text-gray-700 mb-2">
                                Numéro d'Ordre
                            </label>
                            <input type="text" id="numeroOrdre" name="numeroOrdre" 
                                   value="<c:if test="${not empty docteur}">${docteur.numeroOrdre}</c:if>"
                                   class="input-field w-full px-4 py-3 rounded-lg focus:outline-none" 
                                   placeholder="Ex: 12345">
                        </div>

                        <div>
                            <label for="anneesExperience" class="block text-sm font-bold text-gray-700 mb-2">
                                Années d'Expérience
                            </label>
                            <input type="number" id="anneesExperience" name="anneesExperience" 
                                   value="<c:if test="${not empty docteur}">${docteur.anneesExperience}</c:if>"
                                   class="input-field w-full px-4 py-3 rounded-lg focus:outline-none" 
                                   min="0" max="50"
                                   placeholder="Ex: 5">
                        </div>

                        <div>
                            <label for="tarifConsultation" class="block text-sm font-bold text-gray-700 mb-2">
                                Tarif Consultation (MAD)
                            </label>
                            <input type="number" id="tarifConsultation" name="tarifConsultation" 
                                   value="<c:if test="${not empty docteur}">${docteur.tarifConsultation}</c:if>"
                                   class="input-field w-full px-4 py-3 rounded-lg focus:outline-none" 
                                   step="0.01" min="0"
                                   placeholder="Ex: 500.00">
                        </div>

                        <div class="flex items-center">
                            <input type="checkbox" id="disponible" name="disponible" 
                                   <c:if test="${empty docteur || docteur.disponible}">checked</c:if>
                                   class="w-5 h-5 text-purple-600 rounded focus:ring-purple-500">
                            <label for="disponible" class="ml-3 text-sm font-bold text-gray-700">
                                <i class="fas fa-check-circle mr-1 text-green-500"></i>Disponible
                            </label>
                        </div>

                        <div class="md:col-span-2">
                            <label for="biographie" class="block text-sm font-bold text-gray-700 mb-2">
                                Biographie
                            </label>
                            <textarea id="biographie" name="biographie" rows="4"
                                      class="input-field w-full px-4 py-3 rounded-lg focus:outline-none" 
                                      placeholder="Décrivez le parcours et les qualifications du médecin..."><c:if test="${not empty docteur}">${docteur.biographie}</c:if></textarea>
                        </div>
                    </div>
                </div>

                <!-- Action Buttons -->
                <div class="flex items-center justify-between pt-6 border-t">
                    <a href="${pageContext.request.contextPath}/admin/docteurs" 
                       class="px-6 py-3 border-2 border-gray-300 rounded-lg font-semibold text-gray-700 hover:bg-gray-100 transition">
                        <i class="fas fa-times mr-2"></i>Annuler
                    </a>
                    <button type="submit" 
                            class="btn-primary text-white px-8 py-3 rounded-lg font-semibold">
                        <i class="fas fa-save mr-2"></i>
                        <c:choose>
                            <c:when test="${action == 'update'}">Mettre à jour</c:when>
                            <c:otherwise>Créer</c:otherwise>
                        </c:choose>
                    </button>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
