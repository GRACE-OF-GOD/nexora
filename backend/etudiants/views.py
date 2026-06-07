from django.http import JsonResponse
from django.shortcuts import get_object_or_404
from rest_framework import generics, permissions

from comptes.permissions import IsAdminOrEnseignant, IsOwnerOrAdminOrEnseignant
from .models import Etudiant
from .serializers import EtudiantCreateSerializer, EtudiantSerializer


class EtudiantListCreateView(generics.ListCreateAPIView):
    serializer_class = EtudiantSerializer
    permission_classes = [permissions.IsAuthenticated, IsAdminOrEnseignant]

    def get_queryset(self):
        profile = getattr(self.request.user, 'profile', None)
        if profile and profile.role in [profile.ROLE_ADMINISTRATION, profile.ROLE_ENSEIGNANT]:
            return Etudiant.objects.all()
        return Etudiant.objects.filter(user=self.request.user)


class EtudiantDetailView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Etudiant.objects.all()
    serializer_class = EtudiantSerializer
    permission_classes = [permissions.IsAuthenticated, IsOwnerOrAdminOrEnseignant]


class EtudiantCreateWithUserView(generics.CreateAPIView):
    serializer_class = EtudiantCreateSerializer
    permission_classes = [permissions.IsAuthenticated, IsAdminOrEnseignant]


class BulletinView(generics.GenericAPIView):
    permission_classes = [permissions.IsAuthenticated, IsOwnerOrAdminOrEnseignant]

    def get(self, request, pk):
        etudiant = get_object_or_404(Etudiant, pk=pk)
        self.check_object_permissions(request, etudiant)
        return JsonResponse(etudiant.bulletin_data())
