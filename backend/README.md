# Backend Django Nexora

API Django pour l'application de gestion scolaire Nexora.

## Description

Ce backend expose une API REST pour :

- gestion des comptes et authentification JWT
- gestion des étudiants
- gestion des absences
- gestion des filières, matières et notes
- calcul de moyenne et génération de bulletin

## Prérequis

- Python 3.11+ (ou version compatible)
- virtualenv

## Installation

```powershell
cd c:\Users\TH USER\Desktop\gestion_ecole\nexora\backend
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
```

## Lancer le serveur

```powershell
cd backend
.\.venv\Scripts\python.exe manage.py runserver
```

L’API sera disponible sur : `http://127.0.0.1:8000/`

## Créer un superutilisateur

```powershell
.\.venv\Scripts\python.exe manage.py createsuperuser
```

Puis connecte-toi sur : `http://127.0.0.1:8000/admin/`

## Endpoints principaux

### Authentification

- `POST /comptes/register/` : créer un utilisateur
- `POST /comptes/login/` : connexion session
- `POST /comptes/logout/` : déconnexion
- `GET/PUT /comptes/profil/` : profil utilisateur
- `POST /comptes/token/` : obtenir token JWT
- `POST /comptes/token/refresh/` : renouveler le token JWT

### Étudiants

- `GET /etudiants/` : lister les étudiants
- `POST /etudiants/` : ajouter un étudiant (requiert un `User` existant)
- `POST /etudiants/create-with-user/` : créer un `User` + `Etudiant` en une seule requête
- `GET /etudiants/<pk>/` : récupérer un étudiant
- `PUT/PATCH /etudiants/<pk>/` : modifier un étudiant
- `DELETE /etudiants/<pk>/` : supprimer un étudiant
- `GET /etudiants/<pk>/bulletin/` : récupérer le bulletin d’un étudiant

### Académie

- `GET /academie/filieres/` : lister les filières
- `POST /academie/filieres/` : créer une filière
- `GET /academie/filieres/<pk>/` : récupérer une filière
- `PUT/PATCH /academie/filieres/<pk>/` : modifier une filière
- `DELETE /academie/filieres/<pk>/` : supprimer une filière

- `GET /academie/matieres/` : lister les matières
- `POST /academie/matieres/` : créer une matière
- `GET /academie/matieres/<pk>/` : récupérer une matière
- `PUT/PATCH /academie/matieres/<pk>/` : modifier une matière
- `DELETE /academie/matieres/<pk>/` : supprimer une matière

- `GET /academie/notes/` : lister les notes
- `POST /academie/notes/` : ajouter une note
- `GET /academie/notes/<pk>/` : récupérer une note
- `PUT/PATCH /academie/notes/<pk>/` : modifier une note
- `DELETE /academie/notes/<pk>/` : supprimer une note

- `GET /academie/moyenne/<etudiant_id>/` : calculer la moyenne d’un étudiant

### Absences

- `GET /absences/` : liste des absences
- `POST /absences/` : marquer une absence
- `GET /absences/<pk>/` : détail d’une absence
- `PUT/PATCH /absences/<pk>/` : modifier une absence
- `DELETE /absences/<pk>/` : supprimer une absence
- `GET /absences/etudiant/<eleve_id>/` : absences d’un étudiant

### Admin

- `GET /admin/` : interface Django admin

## Sécurité

- JWT est utilisé pour l’authentification des API
- Les endpoints POST/PUT/PATCH/DELETE sont protégés
- Seuls les rôles `administration` et `enseignant` peuvent modifier les données métier

## Base de données

- En développement : SQLite (`backend/db.sqlite3`)
- Pour la production, il est préférable d’utiliser PostgreSQL ou MySQL

## Notes

- Le frontend Flutter devra appeler l’API via `Bearer <token>` dans l’en-tête `Authorization`
- Le backend est prêt pour une intégration Flutter, mais il reste à produire des fixtures de test et une documentation Postman si nécessaire
