from django.http import JsonResponse
from django.shortcuts import get_object_or_404
from rest_framework.decorators import api_view, permission_classes, authentication_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from common.authentication import FirebaseAuthentication
from .models import UserChallenge, Challenge
from django.views.decorators.http import require_http_methods
from django.db import IntegrityError


@api_view(['GET'])
@authentication_classes([FirebaseAuthentication])
@permission_classes([IsAuthenticated])
def user_challenge_list(request):
    user = request.user
    user_challenges = UserChallenge.objects.select_related('challenge').filter(user=user)

    data = [
        {
            "id": uc.challenge.id,  # ✅ 여기에 추가!
            "name": uc.challenge.name,
            "status": uc.status
        } for uc in user_challenges
    ]

    return Response({
        "message": "유저 챌린지 조회 성공",
        "challenges": data
    })


# 챌린지 상태 조회 및 필터링
@require_http_methods(["GET"])
def challenge_status(request):
    challenges = Challenge.objects.filter(status='PR')

    # 쿼리 파라미터 처리
    filters = {
        'type': request.GET.get('type'),
        'deadline': request.GET.get('deadline'),
        'location': request.GET.get('location'),
        'radius': request.GET.get('radius'),
        'max_participants': request.GET.get('max_participants')
    }


    # 필터링된 챌린지 리스트 반환
    data = [{
        "id": challenge.id,
        "name": challenge.name,
        "location": {
            "latitude": challenge.location.latitude,
            "longitude": challenge.location.longitude,
            "address": challenge.location.address,
        },
        "status": challenge.status,
        "start_time": challenge.start_time.isoformat(),
        "end_time": challenge.end_time.isoformat(),
        "current_participants": challenge.current_participants,
        "max_participants": challenge.max_participants,
    } for challenge in challenges]

    return JsonResponse({
        "message": "진행 중인 챌린지 목록 조회 성공",
        "data": data
    }, status=200)

def challenge_detail(request, id):
    try:
        challenge = Challenge.objects.get(id=id)

        user_joined = False
        if request.user.is_authenticated:
            user_joined = UserChallenge.objects.filter(user=request.user, challenge=challenge).exists()

        return JsonResponse({
            "message": "챌린지 상세 정보 조회 성공",
            "data": {
                "id": challenge.id,
                "name": challenge.name,
                "status": challenge.status,
                "start_time": challenge.start_time.isoformat() if challenge.start_time else None,
                "end_time": challenge.end_time.isoformat() if challenge.end_time else None,
                "current_participants": challenge.current_participants,
                "max_participants": challenge.max_participants,
                "user_joined": user_joined,
                "location": {
                    "latitude": challenge.location.latitude,
                    "longitude": challenge.location.longitude,
                    "address": challenge.location.address,
                }
            }
        }, status=200)
    except Challenge.DoesNotExist:
        return JsonResponse({"message": "해당 챌린지를 찾을 수 없습니다."}, status=404)
    

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def join_challenge(request, challenge_id):
    challenge = get_object_or_404(Challenge, id=challenge_id)
    image = request.FILES.get('image')
    comment = request.data.get('comment')

    if not image or not comment:
        return Response({'message': '이미지와 코멘트를 모두 입력해주세요.'}, status=400)

    try:
        UserChallenge.objects.create(
            user=request.user,
            challenge=challenge,
            image=image,
            comment=comment
        )
    except IntegrityError:
        return Response({'message': '이미 참여한 챌린지입니다.'}, status=400)

    challenge.current_participants += 1
    challenge.save()

    return Response({'message': '챌린지 참여 완료'}, status=201)

