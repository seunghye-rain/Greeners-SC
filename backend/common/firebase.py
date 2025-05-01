import os
import firebase_admin
from firebase_admin import credentials
from django.conf import settings

FIREBASE_CRED_PATH = os.path.join(settings.BASE_DIR, 'firebase', 'firebase-adminsdk.json')

if not firebase_admin._apps:
    cred = credentials.Certificate(FIREBASE_CRED_PATH)
    firebase_admin.initialize_app(cred)
