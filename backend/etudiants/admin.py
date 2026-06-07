from django.contrib import admin

from .models import Etudiant


@admin.register(Etudiant)
class EtudiantAdmin(admin.ModelAdmin):
    list_display = ('user', 'matricule', 'filiere', 'groupe')
    list_filter = ('filiere', 'groupe')
    search_fields = ('user__username', 'matricule')
