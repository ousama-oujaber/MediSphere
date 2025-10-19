<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!doctype html>
<html lang="fr">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Admin Dashboard - MediSphere</title>
    <script src="https://cdn.tailwindcss.com "></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css " rel="stylesheet">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@300 ;400;500;600;700&family=Inter:wght@300;400;500;600;700&display=swap');

        :root {
            --gradient-primary: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            --gradient-accent: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            --gradient-success: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            --gradient-warning: linear-gradient(135deg, #ffc837 0%, #ff8008 100%);
        }

        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #667eea08 0%, #764ba208 100%);
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

        .card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 10px 40px rgba(102, 126, 234, 0.1);
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            border: 1px solid rgba(102, 126, 234, 0.1);
        }

        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 60px rgba(102, 126, 234, 0.2);
        }

        .stat-card {
            position: relative;
            overflow: hidden;
        }

        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            right: 0;
            width: 150px;
            height: 150px;
            background: radial-gradient(circle, rgba(102, 126, 234, 0.1) 0%, transparent 70%);
            border-radius: 50%;
            transform: translate(30%, -30%);
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
            box-shadow: 0 10px 30px rgba(102, 126, 234, 0.4);
        }

        .fade-in-up {
            animation: fadeInUp 0.6s ease-out forwards;
            opacity: 0;
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(20px);
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

        .icon-wrapper {
            width: 60px;
            height: 60px;
            border-radius: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
        }

        .gradient-purple { background: var(--gradient-primary); }
        .gradient-pink { background: var(--gradient-accent); }
        .gradient-blue { background: var(--gradient-success); }
        .gradient-orange { background: var(--gradient-warning); }
    </style>
</head>
<body class="min-h-screen">
<!-- Navigation Bar -->
<nav class="bg-white shadow-lg border-b border-gray-100">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between items-center h-20">
            <div class="flex items-center space-x-3">
                <div class="w-12 h-12 bg-gradient-to-br from-purple-600 to-indigo-600 rounded-xl flex items-center justify-center">
                    <i class="fas fa-hospital text-white text-xl"></i>
                </div>
                <div>
                    <h1 class="text-2xl font-bold text-gradient">MediSphere</h1>
                    <p class="text-xs text-gray-500">Administration</p>
                </div>
            </div>

            <div class="flex items-center space-x-4">
                <div class="text-right mr-4">
                    <p class="text-sm font-semibold text-gray-800">
                        <c:out value="${sessionScope.userConnecte.prenom}" />
                        <c:out value="${sessionScope.userConnecte.nom}" />
                    </p>
                    <p class="text-xs text-purple-600">
                        <i class="fas fa-crown mr-1"></i>Administrateur
                    </p>
                </div>
                <a href="${pageContext.request.contextPath}/logout"
                   class="px-4 py-2 text-sm font-medium text-white bg-red-500 hover:bg-red-600 rounded-xl transition-all duration-300 hover:shadow-lg">
                    <i class="fas fa-sign-out-alt mr-2"></i>Déconnexion
                </a>
            </div>
        </div>
    </div>
</nav>

<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">

    <!-- Welcome Section -->
    <div class="mb-8 fade-in-up">
        <h2 class="text-3xl font-bold text-gray-800 mb-2">
            Bienvenue, <span class="text-gradient"><c:out value="${sessionScope.userConnecte.prenom}" /></span>
        </h2>
        <p class="text-gray-600">Tableau de bord administrateur - Gérez votre clinique efficacement</p>
    </div>

    <!-- Statistics Cards -->
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
        <!-- Departments Card -->
        <div class="card stat-card p-6 fade-in-up stagger-1">
            <div class="flex items-start justify-between mb-4">
                <div class="icon-wrapper gradient-purple text-white">
                    <i class="fas fa-building"></i>
                </div>
                <span class="text-xs font-semibold text-green-600 bg-green-50 px-3 py-1 rounded-full">
                        <i class="fas fa-arrow-up mr-1"></i>12%
                    </span>
            </div>
            <h3 class="text-2xl font-bold text-gray-800 mb-1">15</h3>
            <p class="text-sm text-gray-600">Départements</p>
        </div>

        <!-- Doctors Card -->
        <div class="card stat-card p-6 fade-in-up stagger-2">
            <div class="flex items-start justify-between mb-4">
                <div class="icon-wrapper gradient-blue text-white">
                    <i class="fas fa-user-md"></i>
                </div>
                <span class="text-xs font-semibold text-green-600 bg-green-50 px-3 py-1 rounded-full">
                        <i class="fas fa-arrow-up mr-1"></i>8%
                    </span>
            </div>
            <h3 class="text-2xl font-bold text-gray-800 mb-1">42</h3>
            <p class="text-sm text-gray-600">Médecins</p>
        </div>

        <!-- Patients Card -->
        <div class="card stat-card p-6 fade-in-up stagger-3">
            <div class="flex items-start justify-between mb-4">
                <div class="icon-wrapper gradient-pink text-white">
                    <i class="fas fa-users"></i>
                </div>
                <span class="text-xs font-semibold text-green-600 bg-green-50 px-3 py-1 rounded-full">
                        <i class="fas fa-arrow-up mr-1"></i>24%
                    </span>
            </div>
            <h3 class="text-2xl font-bold text-gray-800 mb-1">1,258</h3>
            <p class="text-sm text-gray-600">Patients</p>
        </div>

        <!-- Rooms Card -->
        <div class="card stat-card p-6 fade-in-up stagger-4">
            <div class="flex items-start justify-between mb-4">
                <div class="icon-wrapper gradient-orange text-white">
                    <i class="fas fa-door-open"></i>
                </div>
                <span class="text-xs font-semibold text-blue-600 bg-blue-50 px-3 py-1 rounded-full">
                        <i class="fas fa-check mr-1"></i>Actif
                    </span>
            </div>
            <h3 class="text-2xl font-bold text-gray-800 mb-1">28</h3>
            <p class="text-sm text-gray-600">Salles disponibles</p>
        </div>
    </div>

    <!-- Quick Actions -->
    <div class="mb-8">
        <h3 class="text-xl font-bold text-gray-800 mb-4">
            <i class="fas fa-bolt text-yellow-500 mr-2"></i>Actions Rapides
        </h3>
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">

            <!-- Manage Departments -->
            <a href="${pageContext.request.contextPath}/admin/departements"
               class="card p-6 hover:scale-105 transition-all duration-300 cursor-pointer group">
                <div class="flex items-center space-x-4">
                    <div class="icon-wrapper gradient-purple text-white group-hover:scale-110 transition-transform">
                        <i class="fas fa-building"></i>
                    </div>
                    <div class="flex-1">
                        <h4 class="font-bold text-gray-800 text-lg mb-1">Gérer les Départements</h4>
                        <p class="text-sm text-gray-600">Ajouter, modifier ou supprimer</p>
                    </div>
                    <i class="fas fa-arrow-right text-purple-600 group-hover:translate-x-2 transition-transform"></i>
                </div>
            </a>

            <!-- Manage Doctors -->
            <a href="${pageContext.request.contextPath}/admin/docteurs"
               class="card p-6 hover:scale-105 transition-all duration-300 cursor-pointer group">
                <div class="flex items-center space-x-4">
                    <div class="icon-wrapper gradient-blue text-white group-hover:scale-110 transition-transform">
                        <i class="fas fa-user-md"></i>
                    </div>
                    <div class="flex-1">
                        <h4 class="font-bold text-gray-800 text-lg mb-1">Gérer les Médecins</h4>
                        <p class="text-sm text-gray-600">Équipe médicale</p>
                    </div>
                    <i class="fas fa-arrow-right text-blue-600 group-hover:translate-x-2 transition-transform"></i>
                </div>
            </a>

            <!-- Manage Rooms -->
            <a href="${pageContext.request.contextPath}/admin/salles"
               class="card p-6 hover:scale-105 transition-all duration-300 cursor-pointer group">
                <div class="flex items-center space-x-4">
                    <div class="icon-wrapper gradient-orange text-white group-hover:scale-110 transition-transform">
                        <i class="fas fa-door-open"></i>
                    </div>
                    <div class="flex-1">
                        <h4 class="font-bold text-gray-800 text-lg mb-1">Gérer les Salles</h4>
                        <p class="text-sm text-gray-600">Salles de consultation</p>
                    </div>
                    <i class="fas fa-arrow-right text-orange-600 group-hover:translate-x-2 transition-transform"></i>
                </div>
            </a>

            <!-- View Statistics -->
            <a href="${pageContext.request.contextPath}/admin/statistiques"
               class="card p-6 hover:scale-105 transition-all duration-300 cursor-pointer group">
                <div class="flex items-center space-x-4">
                    <div class="icon-wrapper gradient-pink text-white group-hover:scale-110 transition-transform">
                        <i class="fas fa-chart-line"></i>
                    </div>
                    <div class="flex-1">
                        <h4 class="font-bold text-gray-800 text-lg mb-1">Statistiques</h4>
                        <p class="text-sm text-gray-600">Rapports et analyses</p>
                    </div>
                    <i class="fas fa-arrow-right text-pink-600 group-hover:translate-x-2 transition-transform"></i>
                </div>
            </a>

            <!-- Manage Patients -->
            <a href="${pageContext.request.contextPath}/admin/patients"
               class="card p-6 hover:scale-105 transition-all duration-300 cursor-pointer group">
                <div class="flex items-center space-x-4">
                    <div class="icon-wrapper gradient-success text-white group-hover:scale-110 transition-transform">
                        <i class="fas fa-users"></i>
                    </div>
                    <div class="flex-1">
                        <h4 class="font-bold text-gray-800 text-lg mb-1">Gérer les Patients</h4>
                        <p class="text-sm text-gray-600">Dossiers patients</p>
                    </div>
                    <i class="fas fa-arrow-right text-green-600 group-hover:translate-x-2 transition-transform"></i>
                </div>
            </a>

            <!-- Settings -->
            <a href="${pageContext.request.contextPath}/admin/settings"
               class="card p-6 hover:scale-105 transition-all duration-300 cursor-pointer group">
                <div class="flex items-center space-x-4">
                    <div class="icon-wrapper bg-gradient-to-br from-gray-600 to-gray-800 text-white group-hover:scale-110 transition-transform">
                        <i class="fas fa-cog"></i>
                    </div>
                    <div class="flex-1">
                        <h4 class="font-bold text-gray-800 text-lg mb-1">Paramètres</h4>
                        <p class="text-sm text-gray-600">Configuration système</p>
                    </div>
                    <i class="fas fa-arrow-right text-gray-600 group-hover:translate-x-2 transition-transform"></i>
                </div>
            </a>

        </div>
    </div>

    <!-- Recent Activity -->
    <div class="card p-6">
        <div class="flex items-center justify-between mb-6">
            <h3 class="text-xl font-bold text-gray-800">
                <i class="fas fa-clock text-blue-500 mr-2"></i>Activité Récente
            </h3>
            <a href="#" class="text-sm text-purple-600 hover:text-purple-800 font-medium">
                Voir tout <i class="fas fa-arrow-right ml-1"></i>
            </a>
        </div>

        <div class="space-y-4">
            <div class="flex items-center space-x-4 p-4 bg-gray-50 rounded-xl hover:bg-gray-100 transition-colors">
                <div class="w-10 h-10 bg-green-100 text-green-600 rounded-full flex items-center justify-center">
                    <i class="fas fa-user-plus"></i>
                </div>
                <div class="flex-1">
                    <p class="text-sm font-medium text-gray-800">Nouveau patient enregistré</p>
                    <p class="text-xs text-gray-500">Il y a 5 minutes</p>
                </div>
            </div>

            <div class="flex items-center space-x-4 p-4 bg-gray-50 rounded-xl hover:bg-gray-100 transition-colors">
                <div class="w-10 h-10 bg-blue-100 text-blue-600 rounded-full flex items-center justify-center">
                    <i class="fas fa-calendar-check"></i>
                </div>
                <div class="flex-1">
                    <p class="text-sm font-medium text-gray-800">Consultation planifiée</p>
                    <p class="text-xs text-gray-500">Il y a 15 minutes</p>
                </div>
            </div>

            <div class="flex items-center space-x-4 p-4 bg-gray-50 rounded-xl hover:bg-gray-100 transition-colors">
                <div class="w-10 h-10 bg-purple-100 text-purple-600 rounded-full flex items-center justify-center">
                    <i class="fas fa-user-md"></i>
                </div>
                <div class="flex-1">
                    <p class="text-sm font-medium text-gray-800">Nouveau médecin ajouté</p>
                    <p class="text-xs text-gray-500">Il y a 1 heure</p>
                </div>
            </div>
        </div>
    </div>

</div>

<!-- Footer -->
<footer class="bg-white border-t border-gray-100 mt-12">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6">
        <div class="text-center text-sm text-gray-600">
            <p>&copy; 2025 MediSphere. Tous droits réservés.</p>
        </div>
    </div>
</footer>

</body>
</html>