from django.db import models


class Absence(models.Model):
    STATUT_NON_JUSTIFIEE = 'non_justifiee'
    STATUT_JUSTIFIEE = 'justifiee'

    STATUT_CHOICES = [
        (STATUT_NON_JUSTIFIEE, 'Non justifiée'),
        (STATUT_JUSTIFIEE, 'Justifiée'),
    ]

    eleve = models.ForeignKey('etudiants.Etudiant', on_delete=models.CASCADE, related_name='absences')
    date = models.DateField()
    motif = models.CharField(max_length=255, blank=True)
    statut = models.CharField(max_length=20, choices=STATUT_CHOICES, default=STATUT_NON_JUSTIFIEE)
    date_enregistrement = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Absence de {self.eleve} le {self.date} ({self.get_statut_display()})"
