from django.contrib.auth.models import User
from rest_framework import serializers

from academie.models import Filiere
from .models import Etudiant


class EtudiantSerializer(serializers.ModelSerializer):
    user = serializers.PrimaryKeyRelatedField(queryset=User.objects.all())
    username = serializers.ReadOnlyField(source='user.username')
    filiere = serializers.PrimaryKeyRelatedField(queryset=Filiere.objects.all(), allow_null=True, required=False)
    filiere_nom = serializers.ReadOnlyField(source='filiere.nom')
    moyenne = serializers.FloatField(source='moyenne', read_only=True)

    class Meta:
        model = Etudiant
        fields = [
            'id',
            'user',
            'username',
            'matricule',
            'filiere',
            'filiere_nom',
            'date_naissance',
            'groupe',
            'moyenne',
        ]
