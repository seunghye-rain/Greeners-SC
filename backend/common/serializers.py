from rest_framework import serializers
from django.contrib.auth import get_user_model
from rest_framework_simplejwt.tokens import RefreshToken
from firebase_admin import auth as firebase_auth

User = get_user_model()

class FirebaseLoginSerializer(serializers.Serializer):
    token = serializers.CharField()

    def validate(self, data):
        id_token = data.get("token")

        try:
            decoded_token = firebase_auth.verify_id_token(id_token)
            uid = decoded_token["uid"]
            email = decoded_token.get("email")
            name = decoded_token.get("name") or email.split("@")[0]

            user, created = User.objects.get_or_create(
                firebase_uid=uid,
                defaults={
                    "username": email or uid,
                    "email": email or "",
                }
            )

            refresh = RefreshToken.for_user(user)

            return {
                "access_token": str(refresh.access_token),
                "refresh_token": str(refresh),
                "user_id": user.id,
                "username": user.username,
                "is_new": created,
            }

        except Exception as e:
            raise serializers.ValidationError({"error": f"토큰 검증 실패: {str(e)}"})
