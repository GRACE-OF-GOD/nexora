from django.urls import path
from . import views

urlpatterns = [
    path('', views.EtudiantListCreateView.as_view(), name='etudiants_list_create'),
    path('<int:pk>/', views.EtudiantDetailView.as_view(), name='etudiants_detail'),
    path('<int:pk>/bulletin/', views.BulletinView.as_view(), name='etudiants_bulletin'),
]
