from django.contrib.auth.models import User
from django.db import models


class Profile(models.Model):
    ROLE_ETUDIANT = 'etudiant'
    ROLE_ENSEIGNANT = 'enseignant'
    ROLE_ADMINISTRATION = 'administration'

    ROLE_CHOICES = [
        (ROLE_ETUDIANT, 'Étudiant'),
        (ROLE_ENSEIGNANT, 'Enseignant'),
        (ROLE_ADMINISTRATION, 'Administration'),
    ]

    user = models.OneToOneField(User, on_delete=models.CASCADE)
    role = models.CharField(max_length=20, choices=ROLE_CHOICES)
    telephone = models.CharField(max_length=20, blank=True)

    def __str__(self):
        return f"{self.user.username} ({self.get_role_display()})"
