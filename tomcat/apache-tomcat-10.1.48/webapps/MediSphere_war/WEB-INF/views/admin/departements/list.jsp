<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!doctype html>
<html lang="fr">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Gestion des Départements - MediSphere</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: #f5f7fa;
            color: #333;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 2rem;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
        }

        .header h1 {
            font-size: 2rem;
            color: #667eea;
        }

        .btn {
            padding: 0.7rem 1.5rem;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s;
            border: none;
            cursor: pointer;
            display: inline-block;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.5);
        }

        .btn-secondary {
            background: white;
            color: #667eea;
            border: 2px solid #667eea;
            padding: 0.5rem 1rem;
            font-size: 0.9rem;
        }

        .btn-secondary:hover {
            background: #667eea;
            color: white;
        }

        .btn-danger {
            background: #dc3545;
            color: white;
            padding: 0.5rem 1rem;
            font-size: 0.9rem;
        }

        .btn-danger:hover {
            background: #c82333;
        }

        .alert {
            padding: 1rem 1.5rem;
            border-radius: 8px;
            margin-bottom: 1.5rem;
        }

        .alert-success {
            background: #d4edda;
            border-left: 4px solid #28a745;
            color: #155724;
        }

        .alert-error {
            background: #f8d7da;
            border-left: 4px solid #dc3545;
            color: #721c24;
        }

        .card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            overflow: hidden;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        thead {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        th, td {
            padding: 1rem;
            text-align: left;
        }

        tbody tr {
            border-bottom: 1px solid #e9ecef;
            transition: background 0.2s;
        }

        tbody tr:hover {
            background: #f8f9fa;
        }

        .actions {
            display: flex;
            gap: 0.5rem;
        }

        .empty-state {
            text-align: center;
            padding: 3rem;
            color: #6c757d;
        }

        .empty-state i {
            font-size: 4rem;
            margin-bottom: 1rem;
            opacity: 0.3;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>📋 Gestion des Départements</h1>
            <a href="${pageContext.request.contextPath}/admin/departements?action=create" class="btn btn-primary">
                + Nouveau Département
            </a>
        </div>

        <!-- Success Message -->
        <c:if test="${not empty sessionScope.success}">
            <div class="alert alert-success">
                ${sessionScope.success}
            </div>
            <c:remove var="success" scope="session" />
        </c:if>

        <!-- Error Message -->
        <c:if test="${not empty sessionScope.error}">
            <div class="alert alert-error">
                ${sessionScope.error}
            </div>
            <c:remove var="error" scope="session" />
        </c:if>

        <c:if test="${not empty error}">
            <div class="alert alert-error">${error}</div>
        </c:if>

        <!-- Departments Table -->
        <div class="card">
            <c:choose>
                <c:when test="${empty departements}">
                    <div class="empty-state">
                        <div style="font-size: 4rem; margin-bottom: 1rem; opacity: 0.3;">📂</div>
                        <h3>Aucun département</h3>
                        <p>Commencez par créer votre premier département</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Nom</th>
                                <th>Description</th>
                                <th>Nombre de Docteurs</th>
                                <th>Date de Création</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="dept" items="${departements}">
                                <tr>
                                    <td>${dept.idDepartement}</td>
                                    <td><strong>${dept.nom}</strong></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty dept.description}">
                                                ${dept.description}
                                            </c:when>
                                            <c:otherwise>
                                                <em style="color: #6c757d;">Pas de description</em>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>${dept.docteurs.size()}</td>
                                    <td>
                                        <c:if test="${not empty dept.dateCreation}">
                                            ${dept.dateCreation.toLocalDate()}
                                        </c:if>
                                    </td>
                                    <td>
                                        <div class="actions">
                                            <a href="${pageContext.request.contextPath}/admin/departements?action=edit&id=${dept.idDepartement}" 
                                               class="btn btn-secondary">
                                                ✏️ Modifier
                                            </a>
                                            <c:choose>
                                                <c:when test="${dept.docteurs.size() > 0}">
                                                    <button class="btn btn-danger" disabled title="Impossible de supprimer: ${dept.docteurs.size()} docteur(s) associé(s)">
                                                        🗑️ Supprimer
                                                    </button>
                                                </c:when>
                                                <c:otherwise>
                                                    <a href="${pageContext.request.contextPath}/admin/departements?action=delete&id=${dept.idDepartement}" 
                                                       class="btn btn-danger"
                                                       onclick="return confirm('Êtes-vous sûr de vouloir supprimer ce département ?');">
                                                        🗑️ Supprimer
                                                    </a>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
        </div>

        <div style="margin-top: 2rem; text-align: center;">
            <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-secondary">
                ← Retour au Dashboard
            </a>
        </div>
    </div>
</body>
</html>
