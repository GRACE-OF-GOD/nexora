from rest_framework import serializers

from .models import Filiere, Matiere, Note


class FiliereSerializer(serializers.ModelSerializer):
    class Meta:
        model = Filiere
        fields = ['id', 'nom', 'description']


class MatiereSerializer(serializers.ModelSerializer):
    filiere_nom = serializers.ReadOnlyField(source='filiere.nom')

    class Meta:
        model = Matiere
        fields = ['id', 'nom', 'filiere', 'filiere_nom']


class NoteSerializer(serializers.ModelSerializer):
    eleve_nom = serializers.ReadOnlyField(source='eleve.user.username')
    matiere_nom = serializers.ReadOnlyField(source='matiere.nom')

    class Meta:
        model = Note
        fields = ['id', 'eleve', 'eleve_nom', 'matiere', 'matiere_nom', 'valeur', 'coefficient', 'date', 'semestre']

    def validate_valeur(self, value):
        if value < 0 or value > 20:
            raise serializers.ValidationError('La note doit être comprise entre 0 et 20.')
        return value

    def validate_coefficient(self, value):
        if value <= 0:
            raise serializers.ValidationError('Le coefficient doit être supérieur à 0.')
        return value
