from django.contrib import admin
from .models import Challenge, UserChallenge, Location

 
admin.site.register(Challenge),
admin.site.register(UserChallenge),
admin.site.register(Location),