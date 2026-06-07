from django.contrib.auth.models import User
from rest_framework import serializers

from .models import Filiere, Matiere, Note


class FiliereSerializer(serializers.ModelSerializer):
    student_count = serializers.SerializerMethodField()

    class Meta:
        model = Filiere
        fields = ['id', 'code', 'nom', 'description', 'niveau', 'student_count']

    def get_student_count(self, obj):
        return obj.etudiant_set.count()


class MatiereSerializer(serializers.ModelSerializer):
    filiere_nom = serializers.ReadOnlyField(source='filiere.nom')
    enseignant_nom = serializers.ReadOnlyField(source='enseignant.username')

    class Meta:
        model = Matiere
        fields = ['id', 'code', 'nom', 'filiere', 'filiere_nom', 'volume_horaire', 'coefficient', 'enseignant', 'enseignant_nom']


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

    def create(self, validated_data):
        if 'coefficient' not in validated_data or validated_data['coefficient'] is None:
            validated_data['coefficient'] = validated_data['matiere'].coefficient
        return super().create(validated_data)
