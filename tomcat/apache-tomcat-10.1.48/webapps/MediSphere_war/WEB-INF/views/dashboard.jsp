<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tableau de bord - MediSphere</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css" />
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 40px 20px;
            color: #333;
        }

        .dashboard-container {
            max-width: 900px;
            margin: 0 auto;
            background: #fff;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.2);
            padding: 40px;
            animation: fadeIn 0.5s ease-out;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            border-bottom: 2px solid #eee;
            padding-bottom: 15px;
        }

        header h1 {
            font-size: 24px;
            color: #667eea;
        }

        header a {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: #fff;
            padding: 10px 18px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        header a:hover {
            box-shadow: 0 8px 20px rgba(102, 126, 234, 0.4);
            transform: translateY(-2px);
        }

        .section-card {
            background: #fafafa;
            border-radius: 12px;
            padding: 25px;
            margin-bottom: 25px;
            box-shadow: 0 5px 18px rgba(0, 0, 0, 0.08);
            transition: transform 0.2s ease;
        }

        .section-card:hover {
            transform: translateY(-3px);
        }

        .section-card h3 {
            color: #764ba2;
            margin-bottom: 12px;
        }

        .section-card p {
            margin-bottom: 8px;
            font-size: 15px;
        }

        ul {
            list-style: none;
            margin-top: 10px;
        }

        ul li {
            margin: 10px 0;
        }

        ul li a {
            color: #667eea;
            text-decoration: none;
            font-weight: 500;
            transition: color 0.2s ease;
        }

        ul li a:hover {
            color: #764ba2;
            text-decoration: underline;
        }

        @media (max-width: 600px) {
            .dashboard-container {
                padding: 25px 20px;
            }

            header h1 {
                font-size: 20px;
            }
        }
    </style>
</head>
<body>
<div class="dashboard-container">
    <header>
        <h1>Bienvenue, <c:out value="${sessionScope.userConnecte.nom}"/> <c:out value="${sessionScope.userConnecte.prenom}"/></h1>
        <a href="${pageContext.request.contextPath}/logout">Se déconnecter</a>
    </header>

    <section class="section-card">
        <h3>Informations du profil</h3>
        <p><strong>Email :</strong> <c:out value="${sessionScope.userConnecte.email}"/></p>
        <p><strong>Rôle :</strong> <c:out value="${sessionScope.userRole}"/></p>
        <p><strong>ID :</strong> <c:out value="${sessionScope.userId}"/></p>
    </section>

    <section class="section-card">
        <h3>Actions rapides</h3>
        <ul>
            <li><a href="#">📅 Voir mes rendez-vous (placeholder)</a></li>
            <li><a href="#">🧑‍⚕️ Modifier mon profil (placeholder)</a></li>
        </ul>
    </section>
</div>
</body>
</html>
