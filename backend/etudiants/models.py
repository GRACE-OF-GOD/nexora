from django.contrib.auth.models import User
from django.db import models


class Etudiant(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    matricule = models.CharField(max_length=20, unique=True)
    filiere = models.ForeignKey('academie.Filiere', on_delete=models.SET_NULL, null=True, blank=True)
    date_naissance = models.DateField(null=True, blank=True)
    groupe = models.CharField(max_length=50, blank=True)

    def __str__(self):
        return f"{self.user.get_full_name() or self.user.username} ({self.matricule})"

    def moyenne(self):
        notes = self.notes.all()
        if not notes:
            return None
        total = sum(note.valeur * note.coefficient for note in notes)
        coeff_sum = sum(note.coefficient for note in notes)
        return total / coeff_sum if coeff_sum else None

    def notes_par_semestre(self):
        result = {}
        for note in self.notes.order_by('semestre', 'matiere__nom'):
            semestre = note.semestre or 'Non défini'
            if semestre not in result:
                result[semestre] = []
            result[semestre].append({
                'matiere': str(note.matiere),
                'valeur': float(note.valeur),
                'coefficient': note.coefficient,
                'date': note.date.isoformat(),
            })
        return result

    def bulletin_data(self):
        return {
            'id': self.id,
            'username': self.user.username,
            'nom': self.user.get_full_name(),
            'matricule': self.matricule,
            'filiere': str(self.filiere) if self.filiere else None,
            'groupe': self.groupe,
            'moyenne_generale': float(self.moyenne()) if self.moyenne() is not None else None,
            'notes_par_semestre': self.notes_par_semestre(),
        }
