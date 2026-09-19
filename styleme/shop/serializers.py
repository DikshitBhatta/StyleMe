from rest_framework import serializers
from .models import Tshirt, Cart

class TshirtSerializer(serializers.ModelSerializer):
    class Meta:
        model = Tshirt
        fields = ['id', 'name', 'brand', 'color', 'size', 'price', 'image']
        
        
class CartSerializer(serializers.ModelSerializer):
    class Meta:
        model = Cart
        fields = ['id', 'user', 'tshirt', 'quantity', 'added_on']
        read_only_fields = ['user']  # User is set automatically in the view