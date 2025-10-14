<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!doctype html>
<html lang="fr">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>MediSphere - Gestion de Clinique Nouvelle Génération</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css" />
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@300;400;500;600;700&family=Inter:wght@300;400;500;600;700&display=swap');
        
        :root {
            --gradient-primary: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            --gradient-accent: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            --gradient-success: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
        }

        body {
            font-family: 'Inter', sans-serif;
        }

        h1, h2, h3, h4, h5, h6 {
            font-family: 'Space Grotesk', sans-serif;
        }
        
        .text-gradient {
            background: var(--gradient-primary);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .btn-gradient {
            background: var(--gradient-primary);
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
            overflow: hidden;
        }

        .btn-gradient::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(135deg, #764ba2 0%, #667eea 100%);
            opacity: 0;
            transition: opacity 0.4s;
        }

        .btn-gradient:hover::before {
            opacity: 1;
        }

        .btn-gradient span {
            position: relative;
            z-index: 1;
        }

        .btn-gradient:hover {
            transform: translateY(-2px);
            box-shadow: 0 20px 40px rgba(102, 126, 234, 0.4);
        }

        .hero-pattern {
            background-image: 
                radial-gradient(circle at 20% 50%, rgba(102, 126, 234, 0.08) 0%, transparent 50%),
                radial-gradient(circle at 80% 80%, rgba(118, 75, 162, 0.08) 0%, transparent 50%);
        }

        .floating {
            animation: floating 6s ease-in-out infinite;
        }

        @keyframes floating {
            0%, 100% { transform: translateY(0px); }
            50% { transform: translateY(-20px); }
        }

        .fade-in-up {
            animation: fadeInUp 0.8s ease-out forwards;
            opacity: 0;
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .stagger-1 { animation-delay: 0.1s; }
        .stagger-2 { animation-delay: 0.2s; }
        .stagger-3 { animation-delay: 0.3s; }
        .stagger-4 { animation-delay: 0.4s; }
        .stagger-5 { animation-delay: 0.5s; }
        .stagger-6 { animation-delay: 0.6s; }

        .feature-card {
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            border: 1px solid transparent;
        }

        .feature-card:hover {
            transform: translateY(-8px);
            border-color: rgba(102, 126, 234, 0.3);
            box-shadow: 0 20px 40px rgba(102, 126, 234, 0.15);
        }

        .glass-effect {
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
        }

        .scroll-indicator {
            animation: bounce 2s infinite;
        }

        @keyframes bounce {
            0%, 20%, 50%, 80%, 100% { transform: translateY(0); }
            40% { transform: translateY(-10px); }
            60% { transform: translateY(-5px); }
        }

        .ai-glow {
            box-shadow: 0 0 40px rgba(139, 92, 246, 0.3);
            animation: pulse-glow 3s ease-in-out infinite;
        }

        @keyframes pulse-glow {
            0%, 100% { box-shadow: 0 0 40px rgba(139, 92, 246, 0.3); }
            50% { box-shadow: 0 0 60px rgba(139, 92, 246, 0.5); }
        }
    </style>
</head>
<body class="bg-white antialiased">
    
    <!-- Navigation Bar -->
    <nav class="fixed top-0 w-full z-50 transition-all duration-300 glass-effect border-b border-gray-100">
        <div class="max-w-7xl mx-auto px-6 lg:px-8">
            <div class="flex justify-between items-center h-20">
                <a href="${pageContext.request.contextPath}/home" class="flex items-center space-x-3 group">
                    <div class="w-10 h-10 bg-gradient-to-br from-indigo-500 to-purple-600 rounded-xl flex items-center justify-center transform group-hover:rotate-12 transition-transform duration-300">
                        <span class="text-white text-2xl">🏥</span>
                    </div>
                    <span class="text-2xl font-bold text-gradient">MediSphere</span>
                </a>
                
                <div class="hidden md:flex items-center space-x-8">
                    <a href="#features" class="text-gray-600 hover:text-indigo-600 font-medium transition-colors">Fonctionnalités</a>
                    <a href="#roles" class="text-gray-600 hover:text-indigo-600 font-medium transition-colors">Solutions</a>
                    <a href="#ai-consultation" class="text-gray-600 hover:text-indigo-600 font-medium transition-colors">IA</a>
                </div>

                <div class="flex items-center space-x-4">
                    <c:choose>
                        <c:when test="${not empty sessionScope.userConnecte}">
                            <a href="${pageContext.request.contextPath}/dashboard" class="text-gray-700 hover:text-indigo-600 font-medium transition-colors">Tableau de bord</a>
                            <a href="${pageContext.request.contextPath}/logout" class="btn-gradient text-white px-6 py-2.5 rounded-full font-semibold shadow-lg">
                                <span>Déconnexion</span>
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/login" class="text-gray-700 hover:text-indigo-600 font-medium transition-colors">Connexion</a>
                            <a href="${pageContext.request.contextPath}/register" class="btn-gradient text-white px-6 py-2.5 rounded-full font-semibold shadow-lg">
                                <span>Commencer</span>
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <section class="relative pt-32 pb-20 md:pt-40 md:pb-32 overflow-hidden hero-pattern">
        <div class="max-w-7xl mx-auto px-6 lg:px-8">
            <div class="grid lg:grid-cols-2 gap-12 items-center">
                <!-- Left Content -->
                <div class="text-center lg:text-left">
                    <div class="inline-flex items-center space-x-2 bg-indigo-50 text-indigo-600 px-4 py-2 rounded-full text-sm font-semibold mb-8 fade-in-up">
                        <span class="w-2 h-2 bg-indigo-600 rounded-full animate-pulse"></span>
                        <span>Plateforme de Santé Nouvelle Génération</span>
                    </div>
                    
                    <h1 class="text-5xl md:text-6xl lg:text-7xl font-bold text-gray-900 mb-6 leading-tight fade-in-up stagger-1">
                        Transformez votre 
                        <span class="text-gradient">clinique</span> 
                        avec l'IA
                    </h1>
                    
                    <p class="text-xl text-gray-600 mb-10 leading-relaxed fade-in-up stagger-2">
                        MediSphere révolutionne la gestion médicale avec une plateforme intelligente qui optimise chaque aspect de votre clinique.
                    </p>
                    
                    <div class="flex flex-col sm:flex-row gap-4 justify-center lg:justify-start fade-in-up stagger-3">
                        <a href="${pageContext.request.contextPath}/register" class="btn-gradient text-white px-8 py-4 rounded-full font-bold text-lg shadow-2xl inline-flex items-center justify-center space-x-2 group">
                            <span>Essai gratuit</span>
                            <svg class="w-5 h-5 transform group-hover:translate-x-1 transition-transform" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7l5 5m0 0l-5 5m5-5H6"/>
                            </svg>
                        </a>
                        <a href="#features" class="bg-white text-gray-700 border-2 border-gray-200 px-8 py-4 rounded-full font-bold text-lg hover:border-indigo-300 hover:text-indigo-600 transition-all inline-flex items-center justify-center space-x-2">
                            <span>Découvrir</span>
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"/>
                            </svg>
                        </a>
                    </div>

                    <div class="flex items-center justify-center lg:justify-start space-x-6 mt-12 fade-in-up stagger-4">
                        <div class="text-center">
                            <div class="text-3xl font-bold text-gray-900">500+</div>
                            <div class="text-sm text-gray-500">Cliniques</div>
                        </div>
                        <div class="w-px h-12 bg-gray-200"></div>
                        <div class="text-center">
                            <div class="text-3xl font-bold text-gray-900">50k+</div>
                            <div class="text-sm text-gray-500">Patients</div>
                        </div>
                        <div class="w-px h-12 bg-gray-200"></div>
                        <div class="text-center">
                            <div class="text-3xl font-bold text-gray-900">99.9%</div>
                            <div class="text-sm text-gray-500">Disponibilité</div>
                        </div>
                    </div>
                </div>

                <!-- Right Visual -->
                <div class="relative hidden lg:block fade-in-up stagger-5">
                    <div class="relative floating">
                        <div class="absolute inset-0 bg-gradient-to-br from-indigo-400 to-purple-600 rounded-3xl blur-3xl opacity-20"></div>
                        <div class="relative bg-white rounded-3xl shadow-2xl p-8 border border-gray-100">
                            <div class="space-y-4">
                                <div class="flex items-center space-x-4 p-4 bg-gradient-to-r from-indigo-50 to-purple-50 rounded-2xl">
                                    <div class="w-12 h-12 bg-gradient-to-br from-indigo-500 to-purple-600 rounded-xl flex items-center justify-center">
                                        <span class="text-white text-2xl">📅</span>
                                    </div>
                                    <div class="flex-1">
                                        <div class="font-semibold text-gray-900">Consultation Dr. Martin</div>
                                        <div class="text-sm text-gray-500">Aujourd'hui à 14h30</div>
                                    </div>
                                    <div class="px-3 py-1 bg-green-100 text-green-700 rounded-full text-xs font-semibold">Confirmé</div>
                                </div>
                                
                                <div class="flex items-center space-x-4 p-4 bg-gray-50 rounded-2xl opacity-75">
                                    <div class="w-12 h-12 bg-gray-200 rounded-xl flex items-center justify-center">
                                        <span class="text-gray-600 text-2xl">👨‍⚕️</span>
                                    </div>
                                    <div class="flex-1">
                                        <div class="font-semibold text-gray-900">5 Nouveaux patients</div>
                                        <div class="text-sm text-gray-500">Cette semaine</div>
                                    </div>
                                </div>

                                <div class="grid grid-cols-3 gap-4 pt-4">
                                    <div class="text-center p-4 bg-indigo-50 rounded-xl">
                                        <div class="text-2xl font-bold text-indigo-600">24</div>
                                        <div class="text-xs text-gray-600 mt-1">Rendez-vous</div>
                                    </div>
                                    <div class="text-center p-4 bg-purple-50 rounded-xl">
                                        <div class="text-2xl font-bold text-purple-600">8</div>
                                        <div class="text-xs text-gray-600 mt-1">Docteurs</div>
                                    </div>
                                    <div class="text-center p-4 bg-pink-50 rounded-xl">
                                        <div class="text-2xl font-bold text-pink-600">95%</div>
                                        <div class="text-xs text-gray-600 mt-1">Taux</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Scroll Indicator -->
        <div class="absolute bottom-8 left-1/2 transform -translate-x-1/2 scroll-indicator">
            <svg class="w-6 h-6 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 14l-7 7m0 0l-7-7m7 7V3"/>
            </svg>
        </div>
    </section>

    <!-- Features Section -->
    <section id="features" class="py-24 md:py-32 bg-gray-50">
        <div class="max-w-7xl mx-auto px-6 lg:px-8">
            <div class="text-center max-w-3xl mx-auto mb-20">
                <h2 class="text-4xl md:text-5xl font-bold text-gray-900 mb-6">
                    Tout ce dont vous avez besoin,
                    <span class="text-gradient">en un seul endroit</span>
                </h2>
                <p class="text-xl text-gray-600">
                    Des fonctionnalités puissantes conçues pour simplifier votre quotidien et améliorer la qualité des soins
                </p>
            </div>
            
            <div class="grid md:grid-cols-2 lg:grid-cols-3 gap-8">
                <!-- Feature 1 -->
                <div class="feature-card bg-white p-8 rounded-3xl shadow-lg">
                    <div class="w-14 h-14 bg-gradient-to-br from-indigo-500 to-indigo-600 rounded-2xl flex items-center justify-center text-3xl mb-6 shadow-lg shadow-indigo-200">
                        📅
                    </div>
                    <h3 class="text-2xl font-bold text-gray-900 mb-4">Planification Intelligente</h3>
                    <p class="text-gray-600 leading-relaxed">
                        Gestion automatique des créneaux avec optimisation en temps réel et prévention des conflits
                    </p>
                </div>

                <!-- Feature 2 -->
                <div class="feature-card bg-white p-8 rounded-3xl shadow-lg">
                    <div class="w-14 h-14 bg-gradient-to-br from-purple-500 to-purple-600 rounded-2xl flex items-center justify-center text-3xl mb-6 shadow-lg shadow-purple-200">
                        👨‍⚕️
                    </div>
                    <h3 class="text-2xl font-bold text-gray-900 mb-4">Espace Praticiens</h3>
                    <p class="text-gray-600 leading-relaxed">
                        Interface dédiée pour gérer consultations, validations et dossiers médicaux en toute simplicité
                    </p>
                </div>

                <!-- Feature 3 -->
                <div class="feature-card bg-white p-8 rounded-3xl shadow-lg">
                    <div class="w-14 h-14 bg-gradient-to-br from-pink-500 to-rose-600 rounded-2xl flex items-center justify-center text-3xl mb-6 shadow-lg shadow-pink-200">
                        🏥
                    </div>
                    <h3 class="text-2xl font-bold text-gray-900 mb-4">Gestion des Ressources</h3>
                    <p class="text-gray-600 leading-relaxed">
                        Optimisation automatique des salles avec tracking en temps réel de la disponibilité
                    </p>
                </div>
                
                <!-- Feature 4 -->
                <div class="feature-card bg-white p-8 rounded-3xl shadow-lg">
                    <div class="w-14 h-14 bg-gradient-to-br from-cyan-500 to-blue-600 rounded-2xl flex items-center justify-center text-3xl mb-6 shadow-lg shadow-cyan-200">
                        📊
                    </div>
                    <h3 class="text-2xl font-bold text-gray-900 mb-4">Analytics Avancées</h3>
                    <p class="text-gray-600 leading-relaxed">
                        Tableaux de bord interactifs avec insights en temps réel pour une prise de décision éclairée
                    </p>
                </div>

                <!-- Feature 5 -->
                <div class="feature-card bg-white p-8 rounded-3xl shadow-lg">
                    <div class="w-14 h-14 bg-gradient-to-br from-amber-500 to-orange-600 rounded-2xl flex items-center justify-center text-3xl mb-6 shadow-lg shadow-amber-200">
                        📋
                    </div>
                    <h3 class="text-2xl font-bold text-gray-900 mb-4">Dossiers Numériques</h3>
                    <p class="text-gray-600 leading-relaxed">
                        Historique médical complet et sécurisé accessible instantanément depuis n'importe où
                    </p>
                </div>

                <!-- Feature 6 -->
                <div class="feature-card bg-white p-8 rounded-3xl shadow-lg">
                    <div class="w-14 h-14 bg-gradient-to-br from-emerald-500 to-teal-600 rounded-2xl flex items-center justify-center text-3xl mb-6 shadow-lg shadow-emerald-200">
                        🔒
                    </div>
                    <h3 class="text-2xl font-bold text-gray-900 mb-4">Sécurité Maximale</h3>
                    <p class="text-gray-600 leading-relaxed">
                        Chiffrement de bout en bout et conformité RGPD pour une protection totale des données
                    </p>
                </div>
            </div>
        </div>
    </section>

    <!-- Roles Section -->
    <section id="roles" class="py-24 md:py-32 bg-white">
        <div class="max-w-7xl mx-auto px-6 lg:px-8">
            <div class="text-center max-w-3xl mx-auto mb-20">
                <h2 class="text-4xl md:text-5xl font-bold text-gray-900 mb-6">
                    Une solution adaptée à
                    <span class="text-gradient">chaque profil</span>
                </h2>
                <p class="text-xl text-gray-600">
                    Interfaces personnalisées et workflows optimisés pour tous les acteurs de votre clinique
                </p>
            </div>
            
            <div class="grid md:grid-cols-3 gap-8">
                <!-- Patient Card -->
                <div class="group relative bg-gradient-to-br from-indigo-50 to-purple-50 p-8 rounded-3xl hover:shadow-2xl transition-all duration-500 border-2 border-transparent hover:border-indigo-200">
                    <div class="text-6xl mb-6 transform group-hover:scale-110 transition-transform duration-300">👤</div>
                    <h3 class="text-2xl font-bold text-gray-900 mb-6">Patients</h3>
                    <ul class="space-y-4">
                        <li class="flex items-start">
                            <svg class="w-6 h-6 text-indigo-500 mr-3 flex-shrink-0 mt-0.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>
                            </svg>
                            <span class="text-gray-700">Réservation en ligne simplifiée</span>
                        </li>
                        <li class="flex items-start">
                            <svg class="w-6 h-6 text-indigo-500 mr-3 flex-shrink-0 mt-0.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>
                            </svg>
                            <span class="text-gray-700">Accès à votre dossier médical 24/7</span>
                        </li>
                        <li class="flex items-start">
                            <svg class="w-6 h-6 text-indigo-500 mr-3 flex-shrink-0 mt-0.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>
                            </svg>
                            <span class="text-gray-700">Rappels et notifications automatiques</span>
                        </li>
                        <li class="flex items-start">
                            <svg class="w-6 h-6 text-indigo-500 mr-3 flex-shrink-0 mt-0.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>
                            </svg>
                            <span class="text-gray-700">Historique de consultations complet</span>
                        </li>
                    </ul>
                </div>

                <!-- Doctor Card -->
                <div class="group relative bg-gradient-to-br from-purple-50 to-pink-50 p-8 rounded-3xl hover:shadow-2xl transition-all duration-500 border-2 border-transparent hover:border-purple-200">
                    <div class="text-6xl mb-6 transform group-hover:scale-110 transition-transform duration-300">🩺</div>
                    <h3 class="text-2xl font-bold text-gray-900 mb-6">Praticiens</h3>
                    <ul class="space-y-4">
                        <li class="flex items-start">
                            <svg class="w-6 h-6 text-purple-500 mr-3 flex-shrink-0 mt-0.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>
                            </svg>
                            <span class="text-gray-700">Planning intelligent et synchronisé</span>
                        </li>
                        <li class="flex items-start">
                            <svg class="w-6 h-6 text-purple-500 mr-3 flex-shrink-0 mt-0.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>
                            </svg>
                            <span class="text-gray-700">Saisie rapide des comptes rendus</span>
                        </li>
                        <li class="flex items-start">
                            <svg class="w-6 h-6 text-purple-500 mr-3 flex-shrink-0 mt-0.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>
                            </svg>
                            <span class="text-gray-700">Validation des rendez-vous en un clic</span>
                        </li>
                        <li class="flex items-start">
                            <svg class="w-6 h-6 text-purple-500 mr-3 flex-shrink-0 mt-0.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>
                            </svg>
                            <span class="text-gray-700">Dashboard personnalisé et statistiques</span>
                        </li>
                    </ul>
                </div>

                <!-- Admin Card -->
                <div class="group relative bg-gradient-to-br from-pink-50 to-rose-50 p-8 rounded-3xl hover:shadow-2xl transition-all duration-500 border-2 border-transparent hover:border-pink-200">
                    <div class="text-6xl mb-6 transform group-hover:scale-110 transition-transform duration-300">🧑‍💼</div>
                    <h3 class="text-2xl font-bold text-gray-900 mb-6">Administration</h3>
                    <ul class="space-y-4">
                        <li class="flex items-start">
                            <svg class="w-6 h-6 text-pink-500 mr-3 flex-shrink-0 mt-0.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>
                            </svg>
                            <span class="text-gray-700">Gestion centralisée multi-départements</span>
                        </li>
                        <li class="flex items-start">
                            <svg class="w-6 h-6 text-pink-500 mr-3 flex-shrink-0 mt-0.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>
                            </svg>
                            <span class="text-gray-700">Rapports et analytics en temps réel</span>
                        </li>
                        <li class="flex items-start">
                            <svg class="w-6 h-6 text-pink-500 mr-3 flex-shrink-0 mt-0.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>
                            </svg>
                            <span class="text-gray-700">Optimisation des ressources et salles</span>
                        </li>
                        <li class="flex items-start">
                            <svg class="w-6 h-6 text-pink-500 mr-3 flex-shrink-0 mt-0.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>
                            </svg>
                            <span class="text-gray-700">Tableaux de bord avec KPIs clés</span>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </section>

    <!-- AI Consultation Section -->
    <section id="ai-consultation" class="py-24 md:py-32 bg-gradient-to-br from-violet-50 via-purple-50 to-fuchsia-50">
        <div class="max-w-4xl mx-auto px-6 lg:px-8">
            <div class="text-center mb-12">
                <div class="inline-flex items-center space-x-2 bg-purple-100 text-purple-700 px-4 py-2 rounded-full text-sm font-semibold mb-6">
                    <span>✨</span>
                    <span>Propulsé par l'Intelligence Artificielle</span>
                </div>
                <h2 class="text-4xl md:text-5xl font-bold text-gray-900 mb-6">
                    Conseiller IA pour
                    <span class="text-gradient">votre clinique</span>
                </h2>
                <p class="text-xl text-gray-600">
                    Obtenez des recommandations personnalisées basées sur vos besoins spécifiques
                </p>
            </div>

            <div class="bg-white p-8 md:p-10 rounded-3xl shadow-2xl ai-glow border border-purple-100">
                <div class="space-y-6">
                    <div>
                        <label for="clinic-description" class="block text-lg font-semibold text-gray-900 mb-3">
                            Décrivez votre clinique
                        </label>
                        <textarea 
                            id="clinic-description" 
                            rows="4" 
                            class="w-full p-4 border-2 border-gray-200 rounded-2xl focus:ring-2 focus:ring-purple-500 focus:border-transparent transition-all resize-none text-gray-700"
                            placeholder="Ex: Clinique dentaire de 5 praticiens avec forte demande de rendez-vous urgents et gestion de suivi post-opératoire..."
                        ></textarea>
                    </div>
                    
                    <button 
                        onclick="generateConsultation()" 
                        id="generate-btn" 
                        class="btn-gradient text-white px-8 py-4 rounded-2xl font-bold text-lg w-full flex items-center justify-center space-x-3 disabled:opacity-50 disabled:cursor-not-allowed shadow-xl"
                        disabled
                    >
                        <span id="btn-text">Obtenir mon analyse IA</span>
                        <svg id="loading-spinner" class="animate-spin h-6 w-6 text-white hidden" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                            <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                        </svg>
                    </button>

                    <!-- AI Response -->
                    <div id="ai-response-container" class="mt-8 p-6 bg-gradient-to-br from-purple-50 to-indigo-50 rounded-2xl border-2 border-purple-200 hidden">
                        <div class="flex items-start space-x-3 mb-4">
                            <div class="w-10 h-10 bg-gradient-to-br from-purple-500 to-indigo-600 rounded-xl flex items-center justify-center flex-shrink-0">
                                <span class="text-white text-xl">✨</span>
                            </div>
                            <div class="flex-1">
                                <h4 class="text-xl font-bold text-gray-900 mb-2">Analyse MediSphere</h4>
                                <div id="ai-response" class="text-gray-700 leading-relaxed prose prose-purple max-w-none"></div>
                            </div>
                        </div>
                        
                        <div id="sources" class="mt-6 pt-6 border-t border-purple-200 hidden">
                            <p class="font-semibold text-gray-900 mb-3 flex items-center">
                                <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.828 10.172a4 4 0 00-5.656 0l-4 4a4 4 0 105.656 5.656l1.102-1.101m-.758-4.899a4 4 0 005.656 0l4-4a4 4 0 00-5.656-5.656l-1.1 1.1"/>
                                </svg>
                                Sources
                            </p>
                            <ul id="sources-list" class="space-y-2"></ul>
                        </div>
                    </div>
                    
                    <div id="error-message" class="mt-4 p-4 text-sm rounded-2xl bg-red-50 text-red-800 border border-red-200 hidden flex items-start space-x-3" role="alert">
                        <svg class="w-5 h-5 flex-shrink-0 mt-0.5" fill="currentColor" viewBox="0 0 20 20">
                            <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd"/>
                        </svg>
                        <span id="error-text"></span>
                    </div>
                </div>

                <div class="mt-8 pt-6 border-t border-gray-100">
                    <div class="flex items-center justify-center space-x-2 text-sm text-gray-500">
                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"/>
                        </svg>
                        <span>Vos données sont sécurisées et confidentielles</span>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Stats Section -->
    <section class="py-24 md:py-32 bg-white">
        <div class="max-w-7xl mx-auto px-6 lg:px-8">
            <div class="grid grid-cols-2 md:grid-cols-4 gap-8">
                <div class="text-center">
                    <div class="text-5xl font-bold text-gradient mb-2">500+</div>
                    <div class="text-gray-600 font-medium">Cliniques Partenaires</div>
                </div>
                <div class="text-center">
                    <div class="text-5xl font-bold text-gradient mb-2">50k+</div>
                    <div class="text-gray-600 font-medium">Patients Actifs</div>
                </div>
                <div class="text-center">
                    <div class="text-5xl font-bold text-gradient mb-2">99.9%</div>
                    <div class="text-gray-600 font-medium">Disponibilité</div>
                </div>
                <div class="text-center">
                    <div class="text-5xl font-bold text-gradient mb-2">24/7</div>
                    <div class="text-gray-600 font-medium">Support Technique</div>
                </div>
            </div>
        </div>
    </section>

    <!-- CTA Section -->
    <section class="py-24 md:py-32 bg-gradient-to-br from-indigo-600 via-purple-600 to-pink-600 relative overflow-hidden">
        <div class="absolute inset-0 opacity-10">
            <div class="absolute inset-0" style="background-image: radial-gradient(circle at 2px 2px, white 1px, transparent 0); background-size: 40px 40px;"></div>
        </div>
        
        <div class="max-w-4xl mx-auto px-6 text-center relative z-10">
            <h2 class="text-4xl md:text-6xl font-bold text-white mb-6">
                Prêt à transformer votre clinique ?
            </h2>
            <p class="text-xl md:text-2xl text-indigo-100 mb-10 max-w-2xl mx-auto">
                Rejoignez des centaines de cliniques qui ont déjà choisi MediSphere pour optimiser leur gestion
            </p>
            <div class="flex flex-col sm:flex-row gap-4 justify-center">
                <a href="${pageContext.request.contextPath}/register" class="bg-white text-indigo-600 px-10 py-4 rounded-full font-bold text-xl shadow-2xl hover:shadow-3xl transform hover:scale-105 transition-all duration-300 inline-flex items-center justify-center space-x-2">
                    <span>Commencer gratuitement</span>
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7l5 5m0 0l-5 5m5-5H6"/>
                    </svg>
                </a>
                <a href="#features" class="border-2 border-white text-white px-10 py-4 rounded-full font-bold text-xl hover:bg-white hover:text-indigo-600 transition-all duration-300">
                    En savoir plus
                </a>
            </div>
            <p class="text-indigo-100 text-sm mt-6">
                ✓ Aucune carte bancaire requise  ✓ Configuration en 5 minutes  ✓ Support francophone
            </p>
        </div>
    </section>

    <!-- Footer -->
    <footer class="bg-gray-900 text-gray-300 py-16">
        <div class="max-w-7xl mx-auto px-6 lg:px-8">
            <div class="grid md:grid-cols-4 gap-12 mb-12">
                <div class="md:col-span-2">
                    <div class="flex items-center space-x-3 mb-6">
                        <div class="w-10 h-10 bg-gradient-to-br from-indigo-500 to-purple-600 rounded-xl flex items-center justify-center">
                            <span class="text-white text-2xl">🏥</span>
                        </div>
                        <span class="text-2xl font-bold text-white">MediSphere</span>
                    </div>
                    <p class="text-gray-400 leading-relaxed mb-6">
                        La plateforme de gestion de clinique nouvelle génération. Simplifiez vos processus, optimisez vos ressources et améliorez l'expérience patient.
                    </p>
                    <div class="flex space-x-4">
                        <a href="#" class="w-10 h-10 bg-gray-800 rounded-xl flex items-center justify-center hover:bg-indigo-600 transition-colors">
                            <span class="text-xl">📘</span>
                        </a>
                        <a href="#" class="w-10 h-10 bg-gray-800 rounded-xl flex items-center justify-center hover:bg-indigo-600 transition-colors">
                            <span class="text-xl">🐦</span>
                        </a>
                        <a href="#" class="w-10 h-10 bg-gray-800 rounded-xl flex items-center justify-center hover:bg-indigo-600 transition-colors">
                            <span class="text-xl">💼</span>
                        </a>
                    </div>
                </div>
                
                <div>
                    <h4 class="text-white font-bold mb-4">Produit</h4>
                    <ul class="space-y-3">
                        <li><a href="#features" class="hover:text-white transition-colors">Fonctionnalités</a></li>
                        <li><a href="#" class="hover:text-white transition-colors">Tarifs</a></li>
                        <li><a href="#" class="hover:text-white transition-colors">Sécurité</a></li>
                        <li><a href="#" class="hover:text-white transition-colors">Mises à jour</a></li>
                    </ul>
                </div>
                
                <div>
                    <h4 class="text-white font-bold mb-4">Support</h4>
                    <ul class="space-y-3">
                        <li><a href="#" class="hover:text-white transition-colors">Documentation</a></li>
                        <li><a href="#" class="hover:text-white transition-colors">Centre d'aide</a></li>
                        <li><a href="#" class="hover:text-white transition-colors">Contact</a></li>
                        <li><a href="#" class="hover:text-white transition-colors">Status</a></li>
                    </ul>
                </div>
            </div>
            
            <div class="pt-8 border-t border-gray-800 flex flex-col md:flex-row justify-between items-center space-y-4 md:space-y-0">
                <p class="text-gray-500 text-sm">
                    © 2025 MediSphere. Tous droits réservés.
                </p>
                <div class="flex space-x-6 text-sm">
                    <a href="#" class="hover:text-white transition-colors">Confidentialité</a>
                    <a href="#" class="hover:text-white transition-colors">Conditions</a>
                    <a href="#" class="hover:text-white transition-colors">Cookies</a>
                </div>
            </div>
        </div>
    </footer>

    <!-- JavaScript -->
    <script>
        const API_KEY = "AIzaSyBWi9qYWn08gHv5RVOorY2Ck97sUIzAQn0";
        const API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-exp:generateContent?key=" + API_KEY;
        const MAX_RETRIES = 3;

        const descriptionInput = document.getElementById('clinic-description');
        const generateBtn = document.getElementById('generate-btn');
        const btnText = document.getElementById('btn-text');
        const loadingSpinner = document.getElementById('loading-spinner');
        const responseContainer = document.getElementById('ai-response-container');
        const aiResponseDiv = document.getElementById('ai-response');
        const errorMessageDiv = document.getElementById('error-message');
        const errorText = document.getElementById('error-text');
        const sourcesDiv = document.getElementById('sources');
        const sourcesList = document.getElementById('sources-list');

        descriptionInput.addEventListener('input', () => {
            generateBtn.disabled = descriptionInput.value.trim().length === 0;
        });
        
        function displayError(message) {
            errorText.textContent = message;
            errorMessageDiv.classList.remove('hidden');
            setTimeout(() => errorMessageDiv.classList.add('hidden'), 5000);
        }

        function hideError() {
            errorMessageDiv.classList.add('hidden');
        }

        async function tryFetch(url, options, retries = 0) {
            try {
                const response = await fetch(url, options);
                if (response.status === 429 && retries < MAX_RETRIES) {
                    const delay = Math.pow(2, retries) * 1000 + Math.random() * 1000;
                    await new Promise(resolve => setTimeout(resolve, delay));
                    return tryFetch(url, options, retries + 1);
                }
                if (!response.ok) {
                    const errorBody = await response.json();
                    throw new Error(errorBody.error?.message || `Erreur API: ${response.status}`);
                }
                return response.json();
            } catch (error) {
                if (retries < MAX_RETRIES) {
                    const delay = Math.pow(2, retries) * 1000 + Math.random() * 1000;
                    await new Promise(resolve => setTimeout(resolve, delay));
                    return tryFetch(url, options, retries + 1);
                }
                throw error;
            }
        }

        async function generateConsultation() {
            const userQuery = descriptionInput.value.trim();
            if (!userQuery) {
                displayError("Veuillez décrire votre clinique pour obtenir une analyse.");
                return;
            }
            
            hideError();
            aiResponseDiv.innerHTML = '';
            sourcesList.innerHTML = '';
            responseContainer.classList.add('hidden');
            sourcesDiv.classList.add('hidden');
            
            generateBtn.disabled = true;
            btnText.textContent = "Analyse en cours...";
            loadingSpinner.classList.remove('hidden');

            const systemPrompt = `Tu es un expert en gestion de cliniques médicales intégré à MediSphere.
Analyse la description de la clinique et fournis 3 recommandations concrètes et actionnables.
Format: Courts paragraphes clairs. Sois professionnel mais accessible.`;

            const payload = {
                contents: [{ parts: [{ text: userQuery }] }],
                tools: [{ "google_search": {} }],
                systemInstruction: { parts: [{ text: systemPrompt }] },
            };

            const options = {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(payload)
            };

            try {
                const result = await tryFetch(API_URL, options);
                const candidate = result.candidates?.[0];

                if (candidate && candidate.content?.parts?.[0]?.text) {
                    const text = candidate.content.parts[0].text;
                    aiResponseDiv.innerHTML = formatResponse(text);
                    responseContainer.classList.remove('hidden');

                    const groundingMetadata = candidate.groundingMetadata;
                    if (groundingMetadata && groundingMetadata.groundingAttributions) {
                        const sources = groundingMetadata.groundingAttributions
                            .map(attr => ({
                                uri: attr.web?.uri,
                                title: attr.web?.title,
                            }))
                            .filter(s => s.uri && s.title);

                        if (sources.length > 0) {
                            sources.forEach(source => {
                                const li = document.createElement('li');
                                const a = document.createElement('a');
                                a.href = source.uri;
                                a.textContent = source.title;
                                a.target = "_blank";
                                a.className = "text-purple-600 hover:text-purple-800 hover:underline transition-colors";
                                li.appendChild(a);
                                sourcesList.appendChild(li);
                            });
                            sourcesDiv.classList.remove('hidden');
                        }
                    }
                } else {
                    displayError("L'IA n'a pas pu générer de réponse. Veuillez réessayer.");
                }
            } catch (error) {
                console.error("Erreur Gemini API:", error);
                displayError("Erreur de communication avec l'IA. Veuillez réessayer.");
            } finally {
                loadingSpinner.classList.add('hidden');
                btnText.textContent = "Obtenir mon analyse IA";
                generateBtn.disabled = descriptionInput.value.trim().length === 0;
            }
        }
        
        function formatResponse(text) {
            let formatted = text
                .replace(/^- (.*)$/gm, '<li class="flex items-start"><svg class="w-5 h-5 text-purple-500 mr-2 flex-shrink-0 mt-0.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/></svg><span>$1</span></li>')
                .replace(/\*\*([^*]+)\*\*/g, '<strong class="font-semibold text-gray-900">$1</strong>')
                .replace(/### (.*)/g, '<h5 class="text-lg font-bold text-gray-900 mt-4 mb-2">$1</h5>')
                .replace(/\n\n/g, '</p><p class="mt-3">')
                .replace(/\n/g, '<br>');
            
            if (formatted.includes('<li>')) {
                formatted = formatted.replace(/(<li>.*<\/li>)/s, '<ul class="space-y-3 my-4">$1</ul>');
            }
            
            return `<div class="space-y-2">${formatted}</div>`;
        }

        // Smooth scroll
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                const target = document.querySelector(this.getAttribute('href'));
                if (target) {
                    target.scrollIntoView({ behavior: 'smooth', block: 'start' });
                }
            });
        });

        // Navbar scroll effect
        let lastScroll = 0;
        const nav = document.querySelector('nav');
        window.addEventListener('scroll', () => {
            const currentScroll = window.pageYOffset;
            if (currentScroll > 100) {
                nav.classList.add('shadow-xl');
            } else {
                nav.classList.remove('shadow-xl');
            }
            lastScroll = currentScroll;
        });
    </script>
</body>
</html>