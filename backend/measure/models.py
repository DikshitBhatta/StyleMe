from django.db import models

class BodyMeasurement(models.Model):
    user = models.ForeignKey('auth.User', on_delete=models.CASCADE)  # Optional, for user-specific data
    shoulder_width = models.FloatField()
    hip_width = models.FloatField()
    height = models.FloatField()
    inseam = models.FloatField()
    created_at = models.DateTimeField(auto_now_add=True)
# Create your models here.
