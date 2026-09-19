from rest_framework import serializers
from .models import UserProfile
from django.contrib.auth.models import User
from rest_framework_simplejwt.tokens import RefreshToken
from django.contrib.auth import authenticate

class UserProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserProfile
        fields = ['profile_picture']

class UserSerializer(serializers.ModelSerializer):
    profile = UserProfileSerializer(required=False)  # Mark as not required if not needed

    class Meta:
        model = User
        fields = ['id', 'username', 'email', 'password', 'profile']
        extra_kwargs = {
            'password': {'write_only': True},  # Ensure password is write-only
            'email': {'required': True},
        }

    def create(self, validated_data):
        # Pop profile data if it exists
        profile_data = validated_data.pop('profile', None)
        
        # Create the user
        user = User(**validated_data)
        user.set_password(validated_data['password'])  # Use set_password to hash the password
        user.save()
        
        return user
    
    def validate_email(self, value):
       
        if User.objects.filter(email=value).exists():
            raise serializers.ValidationError(('A user with this email already exists.'))
        return value
    
class LoginSerializer(serializers.Serializer):
    username = serializers.CharField(required=True)
    password = serializers.CharField(write_only=True)

    def validate(self, data):
        username = data.get('username')
        password = data.get('password')
        
        # Authenticate the user
        user = authenticate(username=username, password=password)
        if not user:
            raise serializers.ValidationError('Invalid username or password.')
        
        # Ensure user is active
        if not user.is_active:
            raise serializers.ValidationError('This user account is inactive.')

        # Generate tokens for the user
        refresh = RefreshToken.for_user(user)
        data = {
            'refresh': str(refresh),
            'access': str(refresh.access_token),
        }

        return data
