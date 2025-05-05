from django.contrib import admin
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static
# from django_celery_beat.models import PeriodicTask, IntervalSchedule


urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/', include('common.urls')),
    path('api/', include('challenge.urls')), 
]+ static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
 