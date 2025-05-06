from celery import shared_task
from django.utils import timezone
from .models import Challenge, UserChallenge

@shared_task
def update_challenge_statuses():
    now = timezone.now()
    challenges = Challenge.objects.filter(status='PR')

    for challenge in challenges:
        if challenge.current_participants >= challenge.max_participants:
            challenge.status = 'SC'
        elif challenge.end_time and challenge.end_time < now:
            challenge.status = 'FL'
        else:
            continue

        challenge.save()

        # ✅ 참여자 상태도 함께 변경
        UserChallenge.objects.filter(challenge=challenge).update(status=challenge.status)
