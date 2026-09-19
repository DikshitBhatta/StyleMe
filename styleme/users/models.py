from django.db import models
from django.contrib.auth.models import User

DEFAULT_PROFILE_PICTURE = 'profile_pictures/default.png'

class UserProfile(models.Model):
    user = models.OneToOneField(User,on_delete=models.CASCADE)
    profile_picture = models.ImageField(upload_to='profile_pictures/',default=DEFAULT_PROFILE_PICTURE)
    
    def __str__(self):
        return f"{self.user.username}'s profile"