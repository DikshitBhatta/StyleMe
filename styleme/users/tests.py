import uuid
from rest_framework import status
from rest_framework.test import APITestCase
from django.urls import reverse
from django.contrib.auth.models import User
from rest_framework_simplejwt.tokens import RefreshToken
from .models import UserProfile  # Ensure you have the correct import for UserProfile

class UserRegistrationAPITestCase(APITestCase):

    def setUp(self):
        # Create a unique username and email for testing
        self.username = f'user_{uuid.uuid4()}'
        self.email = f'{self.username}@example.com'
        self.password = 'testpassword123'
        
        # Create a user that will be used in tests
        self.user = User.objects.create_user(
            username=self.username,
            email=self.email,
            password=self.password
        )

    def test_user_registration(self):
        url = reverse('user-registration')  # Adjust according to your URL name
        data = {
            'username': f'user_{uuid.uuid4()}',  # Unique username for new user
            'email': f'user_{uuid.uuid4()}@example.com',  # Unique email for new user
            'password': 'testpassword123',
        }
        response = self.client.post(url, data, format='json')
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertTrue(UserProfile.objects.filter(user__username=data['username']).exists())

    def test_duplicate_user_registration(self):
        url = reverse('user-registration')  # Adjust according to your URL name
        data = {
            'username': self.username,  # Use the existing username
            'email': self.email,  # Use the existing email
            'password': self.password,
        }
        response = self.client.post(url, data, format='json')
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)  # Expecting a 400 error due to duplicate user

    def test_user_registration_without_email(self):
        url = reverse('user-registration')  # Adjust according to your URL name
        data = {
            'username': f'user_{uuid.uuid4()}',
            'password': 'testpassword123',
        }
        response = self.client.post(url, data, format='json')
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)  # Expecting a 400 error due to missing email

    def test_user_registration_without_password(self):
        url = reverse('user-registration')  # Adjust according to your URL name
        data = {
            'username': f'user_{uuid.uuid4()}',
            'email': f'user_{uuid.uuid4()}@example.com',
        }
        response = self.client.post(url, data, format='json')
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)  # Expecting a 400 error due to missing password

    def test_user_registration_with_existing_email(self):
        # Register a new user with a unique email
        url = reverse('user-registration')
        unique_username = f'user_{uuid.uuid4()}'
        unique_email = f'{unique_username}@example.com'
        
        # Create the first user
        User.objects.create_user(
            username=unique_username,
            email=unique_email,
            password='password1'
        )

        # Attempt to register a new user with the same email
        data = {
            'username': f'user_{uuid.uuid4()}',
            'email': unique_email,  # Use the existing email
            'password': 'password2',
        }
        response = self.client.post(url, data, format='json')
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)  # Expecting a 400 error due to duplicate email

    def test_user_login_and_token(self):
        url = reverse('token_obtain_pair')  # Adjust according to your URL name for token generation
        data = {
            'username': self.username,
            'password': self.password
        }
        response = self.client.post(url, data, format='json')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIn('access', response.data)
        self.assertIn('refresh', response.data)

    def test_login_with_wrong_credentials(self):
        url = reverse('token_obtain_pair')  # Adjust according to your URL name for token generation
        data = {
            'username': self.username,
            'password': 'wrongpassword'  # Incorrect password
        }
        response = self.client.post(url, data, format='json')
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)  # Expecting a 401 error for wrong credentials

