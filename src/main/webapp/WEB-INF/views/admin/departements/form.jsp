<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!doctype html>
<html lang="fr">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>
        <c:choose>
            <c:when test="${isEdit}">Modifier le Département</c:when>
            <c:otherwise>Nouveau Département</c:otherwise>
        </c:choose>
         - MediSphere
    </title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: #f5f7fa;
            color: #333;
        }

        .container {
            max-width: 700px;
            margin: 3rem auto;
            padding: 2rem;
        }

        .card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            padding: 2.5rem;
        }

        h1 {
            font-size: 2rem;
            color: #667eea;
            margin-bottom: 2rem;
            text-align: center;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        label {
            display: block;
            font-weight: 600;
            margin-bottom: 0.5rem;
            color: #555;
        }

        .required {
            color: #dc3545;
        }

        input[type="text"],
        textarea {
            width: 100%;
            padding: 0.8rem 1rem;
            border: 2px solid #e1e8ed;
            border-radius: 8px;
            font-size: 1rem;
            font-family: inherit;
            transition: border-color 0.3s;
        }

        input[type="text"]:focus,
        textarea:focus {
            outline: none;
            border-color: #667eea;
        }

        textarea {
            resize: vertical;
            min-height: 120px;
        }

        .alert {
            padding: 1rem 1.5rem;
            border-radius: 8px;
            margin-bottom: 1.5rem;
        }

        .alert-error {
            background: #f8d7da;
            border-left: 4px solid #dc3545;
            color: #721c24;
        }

        .form-actions {
            display: flex;
            gap: 1rem;
            margin-top: 2rem;
        }

        .btn {
            padding: 0.8rem 2rem;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s;
            border: none;
            cursor: pointer;
            font-size: 1rem;
            flex: 1;
            text-align: center;
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
        }

        .btn-secondary:hover {
            background: #667eea;
            color: white;
        }

        .helper-text {
            font-size: 0.85rem;
            color: #6c757d;
            margin-top: 0.3rem;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="card">
            <h1>
                <c:choose>
                    <c:when test="${isEdit}">✏️ Modifier le Département</c:when>
                    <c:otherwise>➕ Nouveau Département</c:otherwise>
                </c:choose>
            </h1>

            <!-- Error Message -->
            <c:if test="${not empty error}">
                <div class="alert alert-error">${error}</div>
            </c:if>

            <form method="post" action="${pageContext.request.contextPath}/admin/departements">
                <c:choose>
                    <c:when test="${isEdit}">
                        <input type="hidden" name="action" value="update" />
                        <input type="hidden" name="id" value="${departement.idDepartement}" />
                    </c:when>
                    <c:otherwise>
                        <input type="hidden" name="action" value="create" />
                    </c:otherwise>
                </c:choose>

                <div class="form-group">
                    <label for="nom">
                        Nom du Département <span class="required">*</span>
                    </label>
                    <input 
                        type="text" 
                        id="nom" 
                        name="nom" 
                        required 
                        minlength="2"
                        maxlength="100"
                        placeholder="Ex: Cardiologie, Dermatologie..."
                        value="${isEdit ? departement.nom : (not empty nom ? nom : '')}"
                    />
                    <div class="helper-text">Minimum 2 caractères, maximum 100 caractères</div>
                </div>

                <div class="form-group">
                    <label for="description">
                        Description
                    </label>
                    <textarea 
                        id="description" 
                        name="description"
                        placeholder="Description optionnelle du département..."
                    >${isEdit ? departement.description : (not empty description ? description : '')}</textarea>
                    <div class="helper-text">Facultatif - Décrivez les spécialités et services du département</div>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">
                        <c:choose>
                            <c:when test="${isEdit}">💾 Enregistrer les modifications</c:when>
                            <c:otherwise>➕ Créer le département</c:otherwise>
                        </c:choose>
                    </button>
                    <a href="${pageContext.request.contextPath}/admin/departements" class="btn btn-secondary">
                        ❌ Annuler
                    </a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
