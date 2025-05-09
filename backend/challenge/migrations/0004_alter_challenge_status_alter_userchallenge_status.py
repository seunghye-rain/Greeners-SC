# Generated by Django 5.2 on 2025-05-05 13:27

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('challenge', '0003_userchallenge_comment_userchallenge_image'),
    ]

    operations = [
        migrations.AlterField(
            model_name='challenge',
            name='status',
            field=models.CharField(choices=[('PR', '진행중'), ('SC', '성공'), ('FL', '실패')], max_length=50),
        ),
        migrations.AlterField(
            model_name='userchallenge',
            name='status',
            field=models.CharField(choices=[('PR', '진행중'), ('SC', '성공'), ('FL', '실패')], default='PR', max_length=10),
        ),
    ]
