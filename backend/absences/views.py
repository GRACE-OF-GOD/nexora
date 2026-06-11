from django.http import HttpResponse
from rest_framework import generics, permissions

from comptes.permissions import IsAdminOrEnseignantOrReadOnly, IsOwnerOrAdminOrEnseignant
from .models import Absence
from .serializers import AbsenceSerializer


def index(request):
    return HttpResponse('API absences : consultation et gestion des absences')


class AbsenceListCreateView(generics.ListCreateAPIView):
    serializer_class = AbsenceSerializer
    permission_classes = [permissions.IsAuthenticated, IsAdminOrEnseignantOrReadOnly]

    def get_queryset(self):
        profile = getattr(self.request.user, 'profile', None)
        if profile and profile.role in [profile.ROLE_ADMINISTRATION, profile.ROLE_ENSEIGNANT]:
            return Absence.objects.all()
        return Absence.objects.filter(eleve__user=self.request.user)


class AbsenceDetailView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Absence.objects.all()
    serializer_class = AbsenceSerializer
    permission_classes = [permissions.IsAuthenticated, IsOwnerOrAdminOrEnseignant]


class AbsenceByEtudiantListView(generics.ListAPIView):
    serializer_class = AbsenceSerializer
    permission_classes = [permissions.IsAuthenticated, IsOwnerOrAdminOrEnseignant]

    def get_queryset(self):
        eleve_id = self.kwargs['eleve_id']
        profile = getattr(self.request.user, 'profile', None)
        if profile and profile.role in [profile.ROLE_ADMINISTRATION, profile.ROLE_ENSEIGNANT]:
            return Absence.objects.filter(eleve_id=eleve_id)
        return Absence.objects.filter(eleve__user=self.request.user, eleve_id=eleve_id)


def marquer(request):
    return HttpResponse('Marquer ou justifier une absence')
