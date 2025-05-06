from django.urls import path
from .views import user_challenge_list, challenge_status, challenge_detail, join_challenge
from . import views


urlpatterns = [
    path('user/challenges/', user_challenge_list),
    path('challenge/list/', challenge_status),
    path('challenge/detail/<int:id>/', challenge_detail),
    path('challenge/<int:challenge_id>/join/', join_challenge, name='join_challenge'),

]
