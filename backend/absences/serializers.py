from rest_framework import serializers

from .models import Absence


class AbsenceSerializer(serializers.ModelSerializer):
    eleve_nom = serializers.ReadOnlyField(source='eleve.user.username')

    class Meta:
        model = Absence
        fields = ['id', 'eleve', 'eleve_nom', 'date', 'motif', 'statut', 'date_enregistrement']
