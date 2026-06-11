from django.urls import path
from . import views

urlpatterns = [
    path('', views.index, name='academie_index'),
    path('filieres/', views.FiliereListCreateView.as_view(), name='filieres_list_create'),
    path('filieres/<int:pk>/', views.FiliereDetailView.as_view(), name='filieres_detail'),
    path('matieres/', views.MatiereListCreateView.as_view(), name='matieres_list_create'),
    path('matieres/<int:pk>/', views.MatiereDetailView.as_view(), name='matieres_detail'),
    path('notes/', views.NoteListCreateView.as_view(), name='notes_list_create'),
    path('notes/<int:pk>/', views.NoteDetailView.as_view(), name='notes_detail'),
    path('moyenne/<int:etudiant_id>/', views.moyenne, name='academie_moyenne'),
]
