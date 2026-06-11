from django.contrib.auth.models import User
from rest_framework import serializers

from academie.models import Filiere
from comptes.models import Profile
from .models import Etudiant


class UserCreateSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)

    class Meta:
        model = User
        fields = ['username', 'password', 'email', 'first_name', 'last_name']

    def create(self, validated_data):
        password = validated_data.pop('password')
        user = User(**validated_data)
        user.set_password(password)
        user.save()
        return user


class EtudiantCreateSerializer(serializers.ModelSerializer):
    user = UserCreateSerializer()
    filiere = serializers.PrimaryKeyRelatedField(queryset=Filiere.objects.all(), allow_null=True, required=False)

    class Meta:
        model = Etudiant
        fields = ['user', 'filiere', 'date_naissance', 'groupe', 'adresse', 'telephone', 'photo', 'statut']

    def create(self, validated_data):
        user_data = validated_data.pop('user')
        user = UserCreateSerializer().create(user_data)
        Profile.objects.create(user=user, role=Profile.ROLE_ETUDIANT)
        return Etudiant.objects.create(user=user, **validated_data)


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
            'adresse',
            'telephone',
            'photo',
            'statut',
            'moyenne',
        ]
