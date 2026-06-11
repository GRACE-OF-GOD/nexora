from django.urls import path
from . import views

urlpatterns = [
    path('', views.AbsenceListCreateView.as_view(), name='absences_list_create'),
    path('<int:pk>/', views.AbsenceDetailView.as_view(), name='absences_detail'),
    path('etudiant/<int:eleve_id>/', views.AbsenceByEtudiantListView.as_view(), name='absences_by_etudiant'),
    path('marquer/', views.marquer, name='absences_marquer'),
]
