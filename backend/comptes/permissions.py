from rest_framework import permissions

from .models import Profile


class IsAdminOrEnseignant(permissions.BasePermission):
    """Autorise l'écriture uniquement aux admins ou enseignants."""

    def has_permission(self, request, view):
        if not request.user or not request.user.is_authenticated:
            return False
        if request.method in permissions.SAFE_METHODS:
            return True
        profile = getattr(request.user, 'profile', None)
        return profile and profile.role in [Profile.ROLE_ADMINISTRATION, Profile.ROLE_ENSEIGNANT]


class IsOwnerOrAdminOrEnseignant(permissions.BasePermission):
    """Permet à l'utilisateur lui-même de voir son propre objet ou aux admins/enseignants d'agir."""

    def has_permission(self, request, view):
        return bool(request.user and request.user.is_authenticated)

    def has_object_permission(self, request, view, obj):
        profile = getattr(request.user, 'profile', None)
        if request.method in permissions.SAFE_METHODS:
            if profile and profile.role in [Profile.ROLE_ADMINISTRATION, Profile.ROLE_ENSEIGNANT]:
                return True
            if hasattr(obj, 'user'):
                return obj.user == request.user
            if hasattr(obj, 'eleve') and hasattr(obj.eleve, 'user'):
                return obj.eleve.user == request.user
            return False
        return profile and profile.role in [Profile.ROLE_ADMINISTRATION, Profile.ROLE_ENSEIGNANT]


class IsAdminOrEnseignantOrReadOnly(permissions.BasePermission):
    """Autorise lecture à tous les utilisateurs authentifiés et écriture aux admins/enseignants."""

    def has_permission(self, request, view):
        if not request.user or not request.user.is_authenticated:
            return request.method in permissions.SAFE_METHODS
        if request.method in permissions.SAFE_METHODS:
            return True
        profile = getattr(request.user, 'profile', None)
        return profile and profile.role in [Profile.ROLE_ADMINISTRATION, Profile.ROLE_ENSEIGNANT]
