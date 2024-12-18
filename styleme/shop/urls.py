from django.urls import path
from .views import TshirtListCreateView, TshirtDetailView, CartListCreateView, CartDetailView

urlpatterns = [
    path('tshirts/', TshirtListCreateView.as_view(), name='tshirt-list-create'),
    path('tshirts/<int:pk>/', TshirtDetailView.as_view(), name='tshirt-detail'),
    path('cart/', CartListCreateView.as_view(), name='cart-list-create'),
    path('cart/<int:pk>/', CartDetailView.as_view(), name='cart-detail'),
]