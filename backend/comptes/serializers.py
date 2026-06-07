from django.contrib.auth.models import User
from rest_framework import serializers

from .models import Profile


class ProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = Profile
        fields = ['role', 'telephone']


class UserSerializer(serializers.ModelSerializer):
    profile = ProfileSerializer(read_only=True)

    class Meta:
        model = User
        fields = ['id', 'username', 'email', 'first_name', 'last_name', 'profile']


class RegisterSerializer(serializers.Serializer):
    username = serializers.CharField(max_length=150)
    password = serializers.CharField(write_only=True)
    email = serializers.EmailField(required=False, allow_blank=True)
    first_name = serializers.CharField(required=False, allow_blank=True)
    last_name = serializers.CharField(required=False, allow_blank=True)
    role = serializers.ChoiceField(choices=Profile.ROLE_CHOICES)
    telephone = serializers.CharField(required=False, allow_blank=True)

    def validate_username(self, value):
        if User.objects.filter(username=value).exists():
            raise serializers.ValidationError('Ce nom d\'utilisateur est déjà pris.')
        return value

    def create(self, validated_data):
        password = validated_data.pop('password')
        role = validated_data.pop('role')
        telephone = validated_data.pop('telephone', '')
        user = User(
            username=validated_data.get('username'),
            email=validated_data.get('email', ''),
            first_name=validated_data.get('first_name', ''),
            last_name=validated_data.get('last_name', ''),
        )
        user.set_password(password)
        user.save()
        Profile.objects.create(user=user, role=role, telephone=telephone)
        return user
