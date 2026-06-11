from django.http import JsonResponse, HttpResponse
from django.shortcuts import get_object_or_404
from rest_framework import generics, permissions, serializers

from comptes.permissions import IsAdminOrEnseignant, IsAdminOrEnseignantOrReadOnly, IsOwnerOrAdminOrEnseignant
from .models import Filiere, Matiere, Note
from .serializers import FiliereSerializer, MatiereSerializer, NoteSerializer
from etudiants.models import Etudiant


def index(request):
    return HttpResponse('API académie : gestion des filières, matières et notes')


class FiliereListCreateView(generics.ListCreateAPIView):
    queryset = Filiere.objects.all()
    serializer_class = FiliereSerializer
    permission_classes = [permissions.IsAuthenticated, IsAdminOrEnseignantOrReadOnly]


class FiliereDetailView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Filiere.objects.all()
    serializer_class = FiliereSerializer
    permission_classes = [permissions.IsAuthenticated, IsAdminOrEnseignantOrReadOnly]

    def destroy(self, request, *args, **kwargs):
        instance = self.get_object()
        if instance.etudiant_set.exists():
            raise serializers.ValidationError('Impossible de supprimer une filière qui contient des étudiants.')
        return super().destroy(request, *args, **kwargs)


class MatiereListCreateView(generics.ListCreateAPIView):
    queryset = Matiere.objects.all()
    serializer_class = MatiereSerializer
    permission_classes = [permissions.IsAuthenticated, IsAdminOrEnseignantOrReadOnly]


class MatiereDetailView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Matiere.objects.all()
    serializer_class = MatiereSerializer
    permission_classes = [permissions.IsAuthenticated, IsAdminOrEnseignantOrReadOnly]


class NoteListCreateView(generics.ListCreateAPIView):
    serializer_class = NoteSerializer
    permission_classes = [permissions.IsAuthenticated, IsAdminOrEnseignantOrReadOnly]

    def get_queryset(self):
        profile = getattr(self.request.user, 'profile', None)
        if profile and profile.role in [profile.ROLE_ADMINISTRATION, profile.ROLE_ENSEIGNANT]:
            return Note.objects.all()
        return Note.objects.filter(eleve__user=self.request.user)


class NoteDetailView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Note.objects.all()
    serializer_class = NoteSerializer
    permission_classes = [permissions.IsAuthenticated, IsOwnerOrAdminOrEnseignant]


def moyenne(request, etudiant_id):
    etudiant = get_object_or_404(Etudiant, id=etudiant_id)
    moyenne = etudiant.moyenne()
    response_data = {
        'etudiant': str(etudiant),
        'matricule': etudiant.matricule,
        'filiere': str(etudiant.filiere) if etudiant.filiere else None,
        'moyenne': float(moyenne) if moyenne is not None else None,
        'nombre_notes': etudiant.notes.count(),
    }
    return JsonResponse(response_data)
