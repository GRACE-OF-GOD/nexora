from django.urls import path
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView
from . import views

urlpatterns = [
    path('', views.IndexView.as_view(), name='comptes_index'),
    path('register/', views.RegisterView.as_view(), name='comptes_register'),
    path('login/', views.LoginView.as_view(), name='comptes_login'),
    path('logout/', views.LogoutView.as_view(), name='comptes_logout'),
    path('profil/', views.ProfileView.as_view(), name='comptes_profile'),
    path('users/<int:pk>/', views.UserDetailView.as_view(), name='comptes_user_detail'),
    path('token/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
]
