from django.db import models

class BodyMeasurement(models.Model):
    user = models.ForeignKey('auth.User', on_delete=models.CASCADE)  # Optional, for user-specific data
    shoulder_width_cm = models.FloatField()
    hip_width_cm = models.FloatField()
    height_cm = models.FloatField()
    inseam_cm = models.FloatField()
    chest_width_cm = models.FloatField()
    torso_length_cm = models.FloatField()
    recommended_size = models.CharField(max_length=10)
    created_at = models.DateTimeField(auto_now_add=True)

    def _str_(self):
        return f"Body Measurement for {self.user.username} on {self.created_at}"

# Create your models here.