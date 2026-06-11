from django.conf import settings
from django.db import models


class Filiere(models.Model):
    code = models.CharField(max_length=50, unique=True, null=True, blank=True)
    nom = models.CharField(max_length=100)
    description = models.TextField(blank=True)
    niveau = models.CharField(max_length=50, blank=True)

    def __str__(self):
        return f"{self.nom} ({self.code})" if self.code else self.nom


class Matiere(models.Model):
    code = models.CharField(max_length=50, unique=True, null=True, blank=True)
    nom = models.CharField(max_length=100)
    filiere = models.ForeignKey(Filiere, on_delete=models.CASCADE, related_name='matieres')
    volume_horaire = models.PositiveIntegerField(default=0)
    coefficient = models.PositiveSmallIntegerField(default=1)
    enseignant = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name='matieres_responsable',
    )

    def __str__(self):
        return f"{self.nom} ({self.code})" if self.code else self.nom


class Note(models.Model):
    eleve = models.ForeignKey('etudiants.Etudiant', on_delete=models.CASCADE, related_name='notes')
    matiere = models.ForeignKey(Matiere, on_delete=models.CASCADE)
    valeur = models.DecimalField(max_digits=5, decimal_places=2)
    coefficient = models.PositiveSmallIntegerField(default=1)
    date = models.DateField(auto_now_add=True)
    semestre = models.CharField(max_length=20, default='Semestre 1')

    def __str__(self):
        return f"{self.eleve} - {self.matiere}: {self.valeur}"
