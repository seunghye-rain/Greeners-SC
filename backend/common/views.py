from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework.permissions import AllowAny, IsAuthenticated
from .serializers import FirebaseLoginSerializer
from rest_framework_simplejwt.tokens import RefreshToken

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
