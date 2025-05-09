from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework.permissions import AllowAny, IsAuthenticated
from .serializers import FirebaseLoginSerializer
from rest_framework_simplejwt.tokens import RefreshToken
from django.contrib.auth import get_user_model
from challenge.models import UserChallenge
from .authentication import FirebaseAuthentication
from rest_framework.decorators import api_view, authentication_classes, permission_classes




User = get_user_model()

class UserProfileView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        user = request.user

        # 예시: 챌린지 연결 정보 포함
        challenges = getattr(user, 'challenges', [])  # Challenge 모델과 연결된 경우

        return Response({
            'id': user.id,
            'email': user.email,
            'username': user.username,
            'challenges': [
                {
                    'name': c.name,
                    'status': c.status
                } for c in challenges.all()
            ] if hasattr(challenges, 'all') else []
        })

class FirebaseLoginView(APIView):
    permission_classes = [AllowAny]

    def post(self, request):
        serializer = FirebaseLoginSerializer(data=request.data)
        if serializer.is_valid():
            return Response(serializer.validated_data, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class LogoutView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        try:
            refresh_token = request.data.get("refresh")
            if not refresh_token:
                return Response({"error": "refresh 토큰이 필요합니다."}, status=status.HTTP_400_BAD_REQUEST)

            token = RefreshToken(refresh_token)
            token.blacklist()

            return Response({"message": "로그아웃 성공"}, status=status.HTTP_205_RESET_CONTENT)
        except Exception:
            return Response({"error": "유효하지 않은 토큰입니다."}, status=status.HTTP_400_BAD_REQUEST)

@api_view(['GET'])
@authentication_classes([FirebaseAuthentication])
@permission_classes([IsAuthenticated])
def participated_challenge_ids(request):
    user = request.user
    joined_ids = UserChallenge.objects.filter(user=user).values_list('challenge_id', flat=True)
    return Response({"joined_ids": list(joined_ids)})

@api_view(['POST'])
@authentication_classes([FirebaseAuthentication])
@permission_classes([IsAuthenticated])
def register_user(request):
    user = request.user
    if not User.objects.filter(email=user.email).exists():
        # 이미 생성된 유저일 수 있으므로 중복 체크
        User.objects.create_user(email=user.email, username=user.email)
    return Response({'message': '유저 등록 완료'}, status=201)
