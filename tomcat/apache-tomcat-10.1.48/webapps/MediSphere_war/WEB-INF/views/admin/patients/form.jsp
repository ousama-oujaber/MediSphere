<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${empty patient ? 'Nouveau' : 'Modifier'} Patient - MediSphere</title>
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
        .form-input {
            border: 2px solid #e2e8f0;
            transition: all 0.3s ease;
        }
        .form-input:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        .section-title {
            border-left: 4px solid #667eea;
            padding-left: 12px;
        }
    </style>Khli 3nk had lmod bas
</head>
<body class="p-6">
    <div class="max-w-5xl mx-auto">
        <!-- Header -->
        <div class="card-glass p-6 mb-6">
            <div class="flex items-center justify-between">
                <h1 class="text-4xl font-bold gradient-text">
                    <i class="fas fa-user-injured mr-3"></i>
                    ${empty patient ? 'Nouveau Patient' : 'Modifier Patient'}
                </h1>
                <a href="${pageContext.request.contextPath}/admin/patients" 
                   class="px-4 py-2 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 transition-colors">
                    <i class="fas fa-arrow-left mr-2"></i>Retour à la liste
                </a>
            </div>
    </div>

        <!-- Error Messages -->
        <c:if test="${not empty errorMessage}">
            <div class="card-glass p-4 mb-6 border-l-4 border-red-500">
                <div class="flex items-center">
                    <i class="fas fa-exclamation-circle text-red-500 text-2xl mr-3"></i>
                    <p class="text-red-700 font-semibold">${errorMessage}</p>
                </div>
            </div>
        </c:if>

        <!-- Form -->
        <form action="${pageContext.request.contextPath}/admin/patients" method="post" id="patientForm" class="card-glass p-8">
            <input type="hidden" name="action" value="${empty patient ? 'save' : 'update'}">
            <c:if test="${not empty patient}">
                <input type="hidden" name="id" value="${patient.idPatient}">
            </c:if>

            <!-- Section: Informations Personnelles -->
            <div class="mb-8">
                <h2 class="section-title text-2xl font-bold text-gray-800 mb-6">
                    <i class="fas fa-user mr-2"></i>Informations Personnelles
                </h2>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <!-- Numéro de Dossier -->
                    <div>
                        <label for="numeroDossier" class="block text-gray-700 font-semibold mb-2">
                            <i class="fas fa-hashtag mr-2"></i>Numéro de Dossier *
                        </label>
                        <input type="text" 
                               id="numeroDossier" 
                               name="numeroDossier" 
                               value="${empty patient ? numeroDossier : patient.numeroDossier}"
                               readonly
                               class="form-input w-full px-4 py-3 rounded-lg outline-none bg-gray-50"
                               required>
                    </div>

                    <!-- Email -->
                    <div>
                        <label for="email" class="block text-gray-700 font-semibold mb-2">
                            <i class="fas fa-envelope mr-2"></i>Email *
                        </label>
                        <input type="email" 
                               id="email" 
                               name="email" 
                               value="${patient.email}"
                               class="form-input w-full px-4 py-3 rounded-lg outline-none"
                               required>
                    </div>

                    <!-- Nom -->
                    <div>
                        <label for="nom" class="block text-gray-700 font-semibold mb-2">
                            <i class="fas fa-user mr-2"></i>Nom *
                        </label>
                        <input type="text" 
                               id="nom" 
                               name="nom" 
                               value="${patient.nom}"
                               class="form-input w-full px-4 py-3 rounded-lg outline-none"
                               maxlength="100"
                               required>
                    </div>

                    <!-- Prénom -->
                    <div>
                        <label for="prenom" class="block text-gray-700 font-semibold mb-2">
                            <i class="fas fa-user mr-2"></i>Prénom *
                        </label>
                        <input type="text" 
                               id="prenom" 
                               name="prenom" 
                               value="${patient.prenom}"
                               class="form-input w-full px-4 py-3 rounded-lg outline-none"
                               maxlength="100"
                               required>
                    </div>

                    <!-- Téléphone -->
                    <div>
                        <label for="telephone" class="block text-gray-700 font-semibold mb-2">
                            <i class="fas fa-phone mr-2"></i>Téléphone
                        </label>
                        <input type="tel" 
                               id="telephone" 
                               name="telephone" 
                               value="${patient.personne.telephone}"
                               class="form-input w-full px-4 py-3 rounded-lg outline-none"
                               maxlength="20">
                    </div>

                    <!-- Mot de passe (uniquement pour création) -->
                    <c:if test="${empty patient}">
                        <div>
                            <label for="motDePasse" class="block text-gray-700 font-semibold mb-2">
                                <i class="fas fa-lock mr-2"></i>Mot de Passe
                            </label>
                            <input type="password" 
                                   id="motDePasse" 
                                   name="motDePasse" 
                                   class="form-input w-full px-4 py-3 rounded-lg outline-none"
                                   placeholder="Laisser vide pour 'patient123'"
                                   minlength="6">
                            <p class="text-sm text-gray-500 mt-1">Par défaut: patient123</p>
                        </div>
                    </c:if>

                    <!-- Adresse -->
                    <div class="md:col-span-2">
                        <label for="adresse" class="block text-gray-700 font-semibold mb-2">
                            <i class="fas fa-map-marker-alt mr-2"></i>Adresse
                        </label>
                        <textarea id="adresse" 
                                  name="adresse" 
                                  rows="2"
                                  class="form-input w-full px-4 py-3 rounded-lg outline-none resize-none"
                                  maxlength="255">${patient.personne.adresse}</textarea>
                    </div>
                </div>
            </div>

            <!-- Section: Informations Médicales -->
            <div class="mb-8">
                <h2 class="section-title text-2xl font-bold text-gray-800 mb-6">
                    <i class="fas fa-heartbeat mr-2"></i>Informations Médicales
                </h2>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <!-- Groupe Sanguin -->
                    <div>
                        <label for="groupeSanguin" class="block text-gray-700 font-semibold mb-2">
                            <i class="fas fa-tint mr-2"></i>Groupe Sanguin
                        </label>
                        <select id="groupeSanguin" 
                                name="groupeSanguin" 
                                class="form-input w-full px-4 py-3 rounded-lg outline-none">
                            <option value="">-- Sélectionner --</option>
                            <option value="A+" ${patient.groupeSanguin == 'A+' ? 'selected' : ''}>A+</option>
                            <option value="A-" ${patient.groupeSanguin == 'A-' ? 'selected' : ''}>A-</option>
                            <option value="B+" ${patient.groupeSanguin == 'B+' ? 'selected' : ''}>B+</option>
                            <option value="B-" ${patient.groupeSanguin == 'B-' ? 'selected' : ''}>B-</option>
                            <option value="AB+" ${patient.groupeSanguin == 'AB+' ? 'selected' : ''}>AB+</option>
                            <option value="AB-" ${patient.groupeSanguin == 'AB-' ? 'selected' : ''}>AB-</option>
                            <option value="O+" ${patient.groupeSanguin == 'O+' ? 'selected' : ''}>O+</option>
                            <option value="O-" ${patient.groupeSanguin == 'O-' ? 'selected' : ''}>O-</option>
                        </select>
                    </div>

                    <!-- Poids -->
                    <div>
                        <label for="poids" class="block text-gray-700 font-semibold mb-2">
                            <i class="fas fa-weight mr-2"></i>Poids (kg)
                        </label>
                        <input type="number" 
                               id="poids" 
                               name="poids" 
                               value="${patient.poids}"
                               step="0.1"
                               min="0"
                               max="500"
                               class="form-input w-full px-4 py-3 rounded-lg outline-none">
                    </div>

                    <!-- Taille -->
                    <div>
                        <label for="taille" class="block text-gray-700 font-semibold mb-2">
                            <i class="fas fa-ruler-vertical mr-2"></i>Taille (cm)
                        </label>
                        <input type="number" 
                               id="taille" 
                               name="taille" 
                               value="${patient.taille}"
                               step="0.1"
                               min="0"
                               max="300"
                               class="form-input w-full px-4 py-3 rounded-lg outline-none">
                    </div>

                    <!-- IMC (calculé) -->
                    <div>
                        <label class="block text-gray-700 font-semibold mb-2">
                            <i class="fas fa-calculator mr-2"></i>IMC
                        </label>
                        <input type="text" 
                               id="imcDisplay" 
                               readonly 
                               class="form-input w-full px-4 py-3 rounded-lg outline-none bg-gray-50"
                               placeholder="Automatique">
                    </div>

                    <!-- Allergies -->
                    <div class="md:col-span-2">
                        <label for="allergies" class="block text-gray-700 font-semibold mb-2">
                            <i class="fas fa-allergies mr-2"></i>Allergies
                        </label>
                        <textarea id="allergies" 
                                  name="allergies" 
                                  rows="3"
                                  class="form-input w-full px-4 py-3 rounded-lg outline-none resize-none"
                                  placeholder="Liste des allergies connues...">${patient.allergies}</textarea>
                    </div>

                    <!-- Antécédents Médicaux -->
                    <div class="md:col-span-2">
                        <label for="antecedentsMedicaux" class="block text-gray-700 font-semibold mb-2">
                            <i class="fas fa-notes-medical mr-2"></i>Antécédents Médicaux
                        </label>
                        <textarea id="antecedentsMedicaux" 
                                  name="antecedentsMedicaux" 
                                  rows="3"
                                  class="form-input w-full px-4 py-3 rounded-lg outline-none resize-none"
                                  placeholder="Historique médical du patient...">${patient.antecedentsMedicaux}</textarea>
                    </div>
                </div>
            </div>

            <!-- Buttons -->
            <div class="flex justify-end gap-4 pt-6 border-t">
                <a href="${pageContext.request.contextPath}/admin/patients" 
                   class="px-6 py-3 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 transition-colors font-semibold">
                    <i class="fas fa-times mr-2"></i>Annuler
                </a>
                <button type="submit" class="btn-gradient text-white px-8 py-3 rounded-lg font-semibold">
                    <i class="fas fa-save mr-2"></i>${empty patient ? 'Créer Patient' : 'Enregistrer'}
                </button>
            </div>
        </form>
    </div>

    <script>
        // Calculer l'IMC automatiquement
        function calculateIMC() {
            const poids = parseFloat(document.getElementById('poids').value);
            const taille = parseFloat(document.getElementById('taille').value);
            const imcDisplay = document.getElementById('imcDisplay');
            
            if (poids && taille && taille > 0) {
                const tailleM = taille / 100;
                const imc = (poids / (tailleM * tailleM)).toFixed(2);
                imcDisplay.value = imc;
                
                // Coloriser selon la catégorie
                if (imc < 18.5) {
                    imcDisplay.classList.add('text-yellow-600', 'font-semibold');
                } else if (imc >= 18.5 && imc < 25) {
                    imcDisplay.classList.add('text-green-600', 'font-semibold');
                } else if (imc >= 25 && imc < 30) {
                    imcDisplay.classList.add('text-orange-600', 'font-semibold');
                } else {
                    imcDisplay.classList.add('text-red-600', 'font-semibold');
                }
            } else {
                imcDisplay.value = '';
                imcDisplay.classList.remove('text-yellow-600', 'text-green-600', 'text-orange-600', 'text-red-600', 'font-semibold');
            }
        }
        
        document.getElementById('poids').addEventListener('input', calculateIMC);
        document.getElementById('taille').addEventListener('input', calculateIMC);
        
        // Calculer l'IMC au chargement si les valeurs existent
        window.addEventListener('load', calculateIMC);
        
        // Focus on first input
        document.getElementById('email').focus();
        
        // Validation du formulaire
        document.getElementById('patientForm').addEventListener('submit', function(e) {
            const nom = document.getElementById('nom').value.trim();
            const prenom = document.getElementById('prenom').value.trim();
            const email = document.getElementById('email').value.trim();
            
            if (!nom || !prenom || !email) {
                e.preventDefault();
                alert('Veuillez remplir tous les champs obligatoires (*)');
                return false;
            }
            
            // Validation email
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(email)) {
                e.preventDefault();
                alert('Veuillez entrer une adresse email valide');
                return false;
            }
        });
    </script>
</body>
</html>
