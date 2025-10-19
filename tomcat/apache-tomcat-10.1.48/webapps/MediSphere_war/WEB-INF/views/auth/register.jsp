<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inscription - MediSphere</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap');
        
        body {
            font-family: 'Inter', sans-serif;
        }

        .gradient-bg {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            position: relative;
            overflow: hidden;
        }

        .gradient-bg::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(255,255,255,0.1) 1px, transparent 1px);
            background-size: 50px 50px;
            animation: movePattern 20s linear infinite;
        }

        @keyframes movePattern {
            0% { transform: translate(0, 0); }
            100% { transform: translate(50px, 50px); }
        }

        .register-card {
            animation: slideUp 0.6s ease-out;
        }

        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .input-field {
            transition: all 0.3s ease;
        }

        .input-field:focus {
            transform: translateY(-2px);
        }

        .blob {
            position: absolute;
            border-radius: 50%;
            filter: blur(60px);
            opacity: 0.5;
            animation: blobAnimation 8s ease-in-out infinite;
        }

        @keyframes blobAnimation {
            0%, 100% { transform: translate(0, 0) scale(1); }
            33% { transform: translate(30px, -50px) scale(1.1); }
            66% { transform: translate(-20px, 20px) scale(0.9); }
        }

        .btn-gradient {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            position: relative;
            overflow: hidden;
        }

        .btn-gradient::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent);
            transition: left 0.5s;
        }

        .btn-gradient:hover::before {
            left: 100%;
        }

        .logo-pulse {
            animation: pulse 2s ease-in-out infinite;
        }

        @keyframes pulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.05); }
        }

        .progress-step {
            transition: all 0.3s ease;
        }

        .progress-step.active {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .password-strength-bar {
            height: 4px;
            border-radius: 2px;
            transition: all 0.3s ease;
        }
    </style>
</head>
<body class="gradient-bg min-h-screen flex items-center justify-center p-4 relative">
    
    <!-- Animated background blobs -->
    <div class="blob w-72 h-72 bg-purple-400 absolute top-20 left-20" style="animation-delay: 0s;"></div>
    <div class="blob w-96 h-96 bg-indigo-400 absolute bottom-20 right-20" style="animation-delay: 2s;"></div>
    <div class="blob w-80 h-80 bg-pink-400 absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2" style="animation-delay: 4s;"></div>

    <!-- Register Card Container -->
    <div class="register-card relative z-10 w-full max-w-2xl">
        <!-- Glass morphism card -->
        <div class="bg-white/95 backdrop-blur-xl rounded-3xl shadow-2xl p-8 md:p-10">
            
            <!-- Logo and Header -->
            <div class="text-center mb-8">
                <div class="inline-flex items-center justify-center w-16 h-16 bg-gradient-to-br from-indigo-500 to-purple-600 rounded-2xl mb-4 logo-pulse shadow-xl">
                    <span class="text-3xl">🏥</span>
                </div>
                <h1 class="text-3xl font-bold text-gray-900 mb-2">
                    Rejoignez MediSphere
                </h1>
                <p class="text-gray-600">
                    Créez votre compte pour commencer votre parcours santé
                </p>
            </div>

            <!-- Progress Steps -->
            <div class="flex items-center justify-center space-x-4 mb-8">
                <div class="flex items-center space-x-2">
                    <div class="progress-step active w-8 h-8 rounded-full flex items-center justify-center text-sm font-semibold">
                        1
                    </div>
                    <span class="text-sm font-medium text-gray-700">Informations</span>
                </div>
                <div class="w-12 h-1 bg-gray-200 rounded"></div>
                <div class="flex items-center space-x-2">
                    <div class="progress-step w-8 h-8 rounded-full bg-gray-200 flex items-center justify-center text-sm font-semibold text-gray-500">
                        2
                    </div>
                    <span class="text-sm font-medium text-gray-500">Sécurité</span>
                </div>
            </div>

            <!-- Alert Messages -->
            <c:if test="${not empty error}">
                <div class="mb-6 p-4 bg-red-50 border-l-4 border-red-500 rounded-lg flex items-start space-x-3">
                    <svg class="w-6 h-6 text-red-500 flex-shrink-0 mt-0.5" fill="currentColor" viewBox="0 0 20 20">
                        <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd"/>
                    </svg>
                    <p class="text-red-800 text-sm font-medium">${error}</p>
                </div>
            </c:if>

            <!-- Registration Form -->
            <form action="${pageContext.request.contextPath}/register" method="post" class="space-y-6" id="registerForm">
                
                <!-- Name Fields (Grid) -->
                <div class="grid md:grid-cols-2 gap-6">
                    <!-- First Name -->
                    <div class="space-y-2">
                        <label for="nom" class="block text-sm font-semibold text-gray-700">
                            Nom <span class="text-red-500">*</span>
                        </label>
                        <div class="relative">
                            <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
                                <svg class="w-5 h-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
                                </svg>
                            </div>
                            <input 
                                id="nom" 
                                name="nom" 
                                type="text" 
                                required 
                                value="${nom}"
                                placeholder="Votre nom"
                                class="input-field w-full pl-12 pr-4 py-3 border-2 border-gray-200 rounded-xl focus:border-indigo-500 focus:ring-4 focus:ring-indigo-100 transition-all outline-none text-gray-900 placeholder-gray-400"
                            />
                        </div>
                    </div>

                    <!-- Last Name -->
                    <div class="space-y-2">
                        <label for="prenom" class="block text-sm font-semibold text-gray-700">
                            Prénom <span class="text-red-500">*</span>
                        </label>
                        <div class="relative">
                            <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
                                <svg class="w-5 h-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
                                </svg>
                            </div>
                            <input 
                                id="prenom" 
                                name="prenom" 
                                type="text" 
                                required 
                                value="${prenom}"
                                placeholder="Votre prénom"
                                class="input-field w-full pl-12 pr-4 py-3 border-2 border-gray-200 rounded-xl focus:border-indigo-500 focus:ring-4 focus:ring-indigo-100 transition-all outline-none text-gray-900 placeholder-gray-400"
                            />
                        </div>
                    </div>
                </div>

                <!-- Email Field -->
                <div class="space-y-2">
                    <label for="email" class="block text-sm font-semibold text-gray-700">
                        Adresse email <span class="text-red-500">*</span>
                    </label>
                    <div class="relative">
                        <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
                            <svg class="w-5 h-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 12a4 4 0 10-8 0 4 4 0 008 0zm0 0v1.5a2.5 2.5 0 005 0V12a9 9 0 10-9 9m4.5-1.206a8.959 8.959 0 01-4.5 1.207"/>
                            </svg>
                        </div>
                        <input 
                            id="email" 
                            name="email" 
                            type="email" 
                            required 
                            value="${email}"
                            placeholder="votre.email@exemple.com"
                            class="input-field w-full pl-12 pr-4 py-3 border-2 border-gray-200 rounded-xl focus:border-indigo-500 focus:ring-4 focus:ring-indigo-100 transition-all outline-none text-gray-900 placeholder-gray-400"
                        />
                    </div>
                    <p class="text-xs text-gray-500 mt-1">Nous ne partagerons jamais votre email</p>
                </div>

                <!-- Phone Field -->
                <div class="space-y-2">
                    <label for="telephone" class="block text-sm font-semibold text-gray-700">
                        Téléphone <span class="text-gray-400 text-xs font-normal">(optionnel)</span>
                    </label>
                    <div class="relative">
                        <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
                            <svg class="w-5 h-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z"/>
                            </svg>
                        </div>
                        <input 
                            id="telephone" 
                            name="telephone" 
                            type="tel" 
                            value="${telephone}"
                            placeholder="+212 6 12 34 56 78"
                            class="input-field w-full pl-12 pr-4 py-3 border-2 border-gray-200 rounded-xl focus:border-indigo-500 focus:ring-4 focus:ring-indigo-100 transition-all outline-none text-gray-900 placeholder-gray-400"
                        />
                    </div>
                </div>

                <!-- Password Fields Grid -->
                <div class="grid md:grid-cols-2 gap-6">
                    <!-- Password -->
                    <div class="space-y-2">
                        <label for="motDePasse" class="block text-sm font-semibold text-gray-700">
                            Mot de passe <span class="text-red-500">*</span>
                        </label>
                        <div class="relative">
                            <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
                                <svg class="w-5 h-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"/>
                                </svg>
                            </div>
                            <input 
                                id="motDePasse" 
                                name="motDePasse" 
                                type="password" 
                                required 
                                minlength="6"
                                placeholder="••••••••"
                                class="input-field w-full pl-12 pr-12 py-3 border-2 border-gray-200 rounded-xl focus:border-indigo-500 focus:ring-4 focus:ring-indigo-100 transition-all outline-none text-gray-900 placeholder-gray-400"
                            />
                            <button 
                                type="button" 
                                onclick="togglePassword('motDePasse')"
                                class="absolute inset-y-0 right-0 pr-4 flex items-center text-gray-400 hover:text-gray-600 transition-colors"
                            >
                                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"/>
                                </svg>
                            </button>
                        </div>
                        <div class="space-y-1">
                            <div id="password-strength" class="password-strength-bar bg-gray-200 rounded"></div>
                            <p id="password-hint" class="text-xs text-gray-500">Au moins 6 caractères</p>
                        </div>
                    </div>

                    <!-- Confirm Password -->
                    <div class="space-y-2">
                        <label for="confirmMotDePasse" class="block text-sm font-semibold text-gray-700">
                            Confirmer <span class="text-red-500">*</span>
                        </label>
                        <div class="relative">
                            <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
                                <svg class="w-5 h-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                                </svg>
                            </div>
                            <input 
                                id="confirmMotDePasse" 
                                name="confirmMotDePasse" 
                                type="password" 
                                required 
                                minlength="6"
                                placeholder="••••••••"
                                class="input-field w-full pl-12 pr-12 py-3 border-2 border-gray-200 rounded-xl focus:border-indigo-500 focus:ring-4 focus:ring-indigo-100 transition-all outline-none text-gray-900 placeholder-gray-400"
                            />
                            <button 
                                type="button" 
                                onclick="togglePassword('confirmMotDePasse')"
                                class="absolute inset-y-0 right-0 pr-4 flex items-center text-gray-400 hover:text-gray-600 transition-colors"
                            >
                                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"/>
                                </svg>
                            </button>
                        </div>
                        <p id="match-hint" class="text-xs text-gray-500">Les mots de passe doivent correspondre</p>
                    </div>
                </div>

                <!-- Terms and Conditions -->
                <div class="flex items-start space-x-3 p-4 bg-gray-50 rounded-xl">
                    <input 
                        id="terms" 
                        type="checkbox" 
                        required
                        class="w-5 h-5 text-indigo-600 border-gray-300 rounded focus:ring-indigo-500 focus:ring-2 mt-0.5"
                    />
                    <label for="terms" class="text-sm text-gray-700">
                        J'accepte les <a href="#" class="text-indigo-600 hover:text-indigo-700 font-medium">conditions d'utilisation</a> et la <a href="#" class="text-indigo-600 hover:text-indigo-700 font-medium">politique de confidentialité</a> de MediSphere
                    </label>
                </div>

                <!-- Submit Button -->
                <button 
                    type="submit" 
                    class="btn-gradient w-full py-3.5 text-white font-semibold rounded-xl shadow-lg hover:shadow-xl transform hover:-translate-y-0.5 active:translate-y-0 transition-all duration-200 flex items-center justify-center space-x-2"
                >
                    <span>Créer mon compte</span>
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7l5 5m0 0l-5 5m5-5H6"/>
                    </svg>
                </button>

                <!-- Security Notice -->
                <div class="flex items-center justify-center space-x-2 text-xs text-gray-500">
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"/>
                    </svg>
                    <span>Vos données sont cryptées et sécurisées</span>
                </div>
            </form>

            <!-- Login Link -->
            <div class="mt-8 text-center">
                <p class="text-sm text-gray-600">
                    Vous avez déjà un compte ?
                    <a href="${pageContext.request.contextPath}/login" class="font-semibold text-indigo-600 hover:text-indigo-700 transition-colors">
                        Se connecter
                    </a>
                </p>
            </div>
        </div>

        <!-- Back to Home Link -->
        <div class="mt-6 text-center">
            <a href="${pageContext.request.contextPath}/home" class="inline-flex items-center space-x-2 text-white hover:text-indigo-100 transition-colors text-sm font-medium">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"/>
                </svg>
                <span>Retour à l'accueil</span>
            </a>
        </div>
    </div>

    <script>
        // Toggle password visibility
        function togglePassword(fieldId) {
            const field = document.getElementById(fieldId);
            field.type = field.type === 'password' ? 'text' : 'password';
        }

        // Password strength checker
        const passwordInput = document.getElementById('motDePasse');
        const strengthBar = document.getElementById('password-strength');
        const passwordHint = document.getElementById('password-hint');

        passwordInput.addEventListener('input', function() {
            const password = this.value;
            let strength = 0;
            
            if (password.length >= 6) strength++;
            if (password.length >= 10) strength++;
            if (/[a-z]/.test(password) && /[A-Z]/.test(password)) strength++;
            if (/\d/.test(password)) strength++;
            if (/[^a-zA-Z\d]/.test(password)) strength++;

            strengthBar.className = 'password-strength-bar rounded';
            
            if (strength === 0) {
                strengthBar.classList.add('bg-gray-200');
                passwordHint.textContent = 'Au moins 6 caractères';
                passwordHint.className = 'text-xs text-gray-500';
            } else if (strength <= 2) {
                strengthBar.classList.add('bg-red-500');
                strengthBar.style.width = '33%';
                passwordHint.textContent = 'Mot de passe faible';
                passwordHint.className = 'text-xs text-red-500';
            } else if (strength <= 3) {
                strengthBar.classList.add('bg-yellow-500');
                strengthBar.style.width = '66%';
                passwordHint.textContent = 'Mot de passe moyen';
                passwordHint.className = 'text-xs text-yellow-600';
            } else {
                strengthBar.classList.add('bg-green-500');
                strengthBar.style.width = '100%';
                passwordHint.textContent = 'Mot de passe fort';
                passwordHint.className = 'text-xs text-green-600';
            }
        });

        // Password match checker
        const confirmInput = document.getElementById('confirmMotDePasse');
        const matchHint = document.getElementById('match-hint');

        confirmInput.addEventListener('input', function() {
            if (this.value === '') {
                matchHint.textContent = 'Les mots de passe doivent correspondre';
                matchHint.className = 'text-xs text-gray-500';
                this.classList.remove('border-green-500', 'border-red-500');
                this.classList.add('border-gray-200');
            } else if (this.value === passwordInput.value) {
                matchHint.textContent = '✓ Les mots de passe correspondent';
                matchHint.className = 'text-xs text-green-600';
                this.classList.remove('border-red-500', 'border-gray-200');
                this.classList.add('border-green-500');
            } else {
                matchHint.textContent = '✗ Les mots de passe ne correspondent pas';
                matchHint.className = 'text-xs text-red-500';
                this.classList.remove('border-green-500', 'border-gray-200');
                this.classList.add('border-red-500');
            }
        });

        // Form validation
        const form = document.getElementById('registerForm');
        form.addEventListener('submit', function(e) {
            const password = passwordInput.value;
            const confirmPassword = confirmInput.value;
            
            if (password !== confirmPassword) {
                e.preventDefault();
                confirmInput.focus();
                matchHint.textContent = '✗ Les mots de passe ne correspondent pas';
                matchHint.className = 'text-xs text-red-500';
                confirmInput.classList.add('border-red-500');
                return false;
            }
            
            if (password.length < 6) {
                e.preventDefault();
                passwordInput.focus();
                passwordHint.textContent = 'Le mot de passe doit contenir au moins 6 caractères';
                passwordHint.className = 'text-xs text-red-500';
                passwordInput.classList.add('border-red-500');
                return false;
            }
        });

        // Real-time validation for all inputs
        const inputs = form.querySelectorAll('input[required]');
        inputs.forEach(input => {
            input.addEventListener('blur', function() {
                if (this.value.trim() === '' && this.hasAttribute('required')) {
                    this.classList.add('border-red-500');
                    this.classList.remove('border-gray-200', 'border-green-500');
                } else if (this.value.trim() !== '') {
                    this.classList.remove('border-red-500', 'border-gray-200');
                    this.classList.add('border-green-500');
                }
            });

            input.addEventListener('input', function() {
                if (this.value.trim() !== '' && this.classList.contains('border-red-500')) {
                    this.classList.remove('border-red-500');
                    this.classList.add('border-gray-200');
                }
            });
        });
    </script>
</body>
</html>