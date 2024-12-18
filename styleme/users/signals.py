from django.db.models.signals import post_save
from django.dispatch import receiver
from django.contrib.auth.models import User
from .models import UserProfile

@receiver(post_save, sender=User)
def manage_user_profile(sender, instance, created, **kwargs):
    if created:
        # Create a UserProfile instance only if it doesn't already exist
        UserProfile.objects.get_or_create(user=instance)
    else:
        # Save the UserProfile instance if the User is updated
        if hasattr(instance, 'userprofile'):
            instance.userprofile.save()