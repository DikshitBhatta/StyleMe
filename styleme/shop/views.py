from django.shortcuts import render
from rest_framework import generics
from .models import Tshirt,Cart
from .serializers import TshirtSerializer,CartSerializer
from rest_framework.permissions import AllowAny, IsAuthenticatedOrReadOnly, IsAuthenticated, IsAdminUser

# Create your views here.
class TshirtListCreateView(generics.ListCreateAPIView):
    queryset = Tshirt.objects.all()
    serializer_class = TshirtSerializer
    
    def get_permissions(self):
        if self.request.method == 'POST':
            return [IsAdminUser()]  # Only admin can create
        return [AllowAny()]  # Everyone can view
    
class TshirtDetailView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Tshirt.objects.all()
    serializer_class = TshirtSerializer

    def get_permissions(self):
        if self.request.method in ['DELETE']:
            return [IsAdminUser()]  # Only admin can delete
        return [AllowAny()]  # Everyone can view
    

class CartListCreateView(generics.ListCreateAPIView):
    serializer_class = CartSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        # Only return cart items for the authenticated user
        return Cart.objects.filter(user=self.request.user)

    def perform_create(self, serializer):
        # Automatically set the user as the authenticated user
        serializer.save(user=self.request.user)

class CartDetailView(generics.RetrieveUpdateDestroyAPIView):
    serializer_class = CartSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        # Only allow authenticated users to access their own cart items
        return Cart.objects.filter(user=self.request.user)
