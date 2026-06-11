from django.contrib import admin

from .models import Absence


@admin.register(Absence)
class AbsenceAdmin(admin.ModelAdmin):
    list_display = ('eleve', 'date', 'statut', 'motif')
    list_filter = ('statut', 'date')
    search_fields = ('eleve__matricule', 'motif')
