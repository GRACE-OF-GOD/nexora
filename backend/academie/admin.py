from django.contrib import admin

from .models import Filiere, Matiere, Note


@admin.register(Filiere)
class FiliereAdmin(admin.ModelAdmin):
    list_display = ('nom',)
    search_fields = ('nom',)


@admin.register(Matiere)
class MatiereAdmin(admin.ModelAdmin):
    list_display = ('nom', 'filiere')
    list_filter = ('filiere',)
    search_fields = ('nom',)


@admin.register(Note)
class NoteAdmin(admin.ModelAdmin):
    list_display = ('eleve', 'matiere', 'valeur', 'coefficient', 'semestre', 'date')
    list_filter = ('semestre', 'matiere')
    search_fields = ('eleve__matricule', 'matiere__nom')
