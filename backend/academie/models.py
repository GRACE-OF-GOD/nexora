from django.db import models


class Filiere(models.Model):
    nom = models.CharField(max_length=100)
    description = models.TextField(blank=True)

    def __str__(self):
        return self.nom


class Matiere(models.Model):
    nom = models.CharField(max_length=100)
    filiere = models.ForeignKey(Filiere, on_delete=models.CASCADE, related_name='matieres')

    def __str__(self):
        return f"{self.nom} ({self.filiere})"


class Note(models.Model):
    eleve = models.ForeignKey('etudiants.Etudiant', on_delete=models.CASCADE, related_name='notes')
    matiere = models.ForeignKey(Matiere, on_delete=models.CASCADE)
    valeur = models.DecimalField(max_digits=5, decimal_places=2)
    coefficient = models.PositiveSmallIntegerField(default=1)
    date = models.DateField(auto_now_add=True)
    semestre = models.CharField(max_length=20, default='Semestre 1')

    def __str__(self):
        return f"{self.eleve} - {self.matiere}: {self.valeur}"
