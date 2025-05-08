from django.urls import path
from .views import FirebaseLoginView, LogoutView, UserProfileView, participated_challenge_ids, register_user


urlpatterns = [
    path("auth/firebase-login/", FirebaseLoginView.as_view(), name="firebase_login"),
    path("auth/logout/", LogoutView.as_view(), name="logout"),
    path('user/profile/', UserProfileView.as_view()), 
    path('user/joined-challenges/', participated_challenge_ids),
    path('user/register/', register_user)
]
