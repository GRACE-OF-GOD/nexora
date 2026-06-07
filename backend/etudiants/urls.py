from django.urls import path
from . import views

urlpatterns = [
    path('', views.EtudiantListCreateView.as_view(), name='etudiants_list_create'),
    path('create-with-user/', views.EtudiantCreateWithUserView.as_view(), name='etudiants_create_with_user'),
    path('<int:pk>/', views.EtudiantDetailView.as_view(), name='etudiants_detail'),
    path('<int:pk>/bulletin/', views.BulletinView.as_view(), name='etudiants_bulletin'),
]
