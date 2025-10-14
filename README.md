# 🏥 Digitalisation de la Gestion d'une Clinique Privée

## 🎯 Objectif du Projet

L’organisation souhaite digitaliser la gestion des activités d’une clinique privée.  
L’objectif est de fournir aux **patients**, **docteurs** et à **l’administration** un outil fiable, simple d’utilisation et sécurisé pour gérer les **consultations**, **plannings** et **dossiers médicaux**, tout en assurant une supervision complète des activités et des ressources de la clinique.

## 👨‍💻 Contexte Technique

Vous êtes **développeur Java EE** chargé de concevoir et développer une **application web JEE** respectant :
- Les **bonnes pratiques de programmation orientée objet**.
- Une **architecture professionnelle en couches (MVC)**.
- L’**automatisation des processus métier**.
- Une **gestion centralisée des données**.

---

## ⚙️ Fonctionnalités Principales

### 👤 Pour les Patients

- Créer et gérer leur compte patient.  
- Consulter la liste des docteurs disponibles par département (ex : cardiologie, dermatologie…).  
- Réserver un rendez-vous (consultation) avec un docteur :
  - Saisie : date, heure souhaitée, motif de consultation.  
  - Le système crée la consultation avec le statut **"Réservée"** et bloque automatiquement le créneau de 30 minutes dans la salle correspondante.  
- Annuler ou modifier une réservation.  
- Consulter l'historique des consultations et diagnostics.

---

### 🩺 Pour les Docteurs

- Consulter leur planning de consultations (réservations).  
- Valider ou refuser une réservation faite par un patient.  
- Réaliser une consultation : saisir le **compte rendu médical** (diagnostic, traitement).  
- Mettre à jour l'état d'une consultation :  
  - `RESERVEE`, `VALIDEE`, `ANNULEE`, `TERMINEE`  
- Accéder à l'historique médical des patients suivis.

---

### 🧑‍💼 Pour l’Administration

- Gérer les **départements** (ajout, modification, suppression).  
- Gérer les **docteurs** et leur rattachement aux départements.  
- Gérer les **salles** et optimiser leur occupation :
  - Une seule consultation par salle et par créneau de 30 minutes.  
  - Vérification automatique de la disponibilité selon la date et l'heure.  
- Superviser toutes les réservations et consultations.  
- Générer des **statistiques globales** :
  - Nombre de patients  
  - Nombre de consultations  
  - Taux d’occupation des salles  

---

## 📜 Règles de Gestion

- Un patient peut avoir plusieurs consultations, mais **une seule par créneau horaire**.  
- Un docteur appartient à **un seul département** mais peut avoir plusieurs consultations.  
- Une consultation suit le cycle :
  1. `RESERVEE` → par le patient  
  2. `VALIDEE` → par le docteur  
  3. `TERMINEE` ou `ANNULEE`  
- Une salle ne peut accueillir **qu’une seule consultation par créneau de 30 minutes**.  
- Les consultations passées restent consultables dans l’historique.

---

## 🧩 Modélisation des Entités

| Entité | Description |
|--------|--------------|
| **Personne (abstraite)** | nom, prénom, email, motDePasse |
| **Patient** | idPatient, poids, taille, consultations |
| **Docteur** | idDocteur, spécialité, département, planning |
| **Département** | idDepartement, nom, docteurs |
| **Salle** | idSalle, nomSalle, capacité, créneaux occupés (liste de LocalDateTime) |
| **Consultation** | idConsultation, date, heure, statut (`RESERVEE`, `VALIDEE`, `ANNULEE`, `TERMINEE`), compteRendu, patient, docteur, salle |

---

## 🧱 Architecture Technique

### 🔹 Backend

- **Architecture MVC (multi-couches)** : `Repository` / `Service` / `Controller` / `Vue`
- **Base de données** : MySQL ou PostgreSQL  
- **JPA / Hibernate** : persistance des entités  
- **Java EE / Jakarta EE** : Servlets & JSP  
- **Java Time API** : gestion des dates et horaires  
- **Gestion des exceptions** :  
  - Réservation en double  
  - Salle non disponible  
  - Patient/docteur introuvable

---

### 🎨 Frontend

- **JSP** pour les vues dynamiques  
- **JSTL** pour la logique de présentation :
  - `<c:forEach>` : affichage de listes  
  - `<c:if>` / `<c:choose>` : conditions  
  - `<fmt:formatDate>` : formatage de dates  
- **CSS / Bootstrap / Tailwind** : pour le style responsive  
- **JavaScript (optionnel)** : validation client & meilleure UX  

---

## 🔐 Gestion des Sessions (HttpSession)

- `session.setAttribute("userConnecte", user)` → stocke l'utilisateur connecté  
- `session.getAttribute("userConnecte")` → récupère l'utilisateur  
- `${sessionScope.userConnecte}` → accès via EL dans JSP  
- Stockage du type d’utilisateur : `PATIENT`, `DOCTEUR`, `ADMIN`  
  → pour la gestion des droits d’accès

---

## 🚦 Filtres (Servlet Filters)

- Redirection vers la page de **login** si la session est nulle.  
- Contrôle des droits selon le rôle :  
  - Un patient ne peut pas accéder à l’espace admin.  
- **Déconnexion** : `session.invalidate()` pour détruire la session.

---

## 🧠 User Stories

### Patients
- En tant que patient, je veux **réserver un rendez-vous** avec un docteur.  
- En tant que patient, je veux **annuler ou modifier** ma réservation.  
- En tant que patient, je veux **consulter l’historique** de mes consultations.  

### Docteurs
- En tant que docteur, je veux **consulter mon planning**.  
- En tant que docteur, je veux **valider ou refuser une réservation**.  
- En tant que docteur, je veux **saisir le compte rendu** d’une consultation.  

### Admin
- En tant qu’admin, je veux **gérer les départements et les docteurs**.  
- En tant qu’admin, je veux **gérer les salles** et **optimiser leur occupation**.  
- En tant qu’admin, je veux **superviser toutes les consultations**.

---

## 🏆 Bonus

- En tant qu’admin, je veux **générer des statistiques globales** (graphiques via **Chart.js** ou équivalent).

---
