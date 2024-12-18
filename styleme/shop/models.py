from django.db import models
from django.conf import settings

# Create your models here.
class Tshirt(models.Model):
    SIZE_CHOICES = [
        ('S', 'Small'),
        ('M', 'Medium'),
        ('L', 'Large'),
        ('XL', 'Extra Large'),
        ('XXL', '2X Large'),
    ]
    name = models.CharField(max_length=100)
    image = models.ImageField(upload_to='tshirts/')
    brand = models.CharField(max_length=100)
    color = models.CharField(max_length=20)
    size = models.CharField(max_length=3, choices=SIZE_CHOICES)
    price = models.DecimalField(max_digits=10, decimal_places=2)
    
    def __str__(self):
        return f"{self.name} by {self.brand} - {self.price}"


class Cart(models.Model):
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='cart')
    tshirt = models.ForeignKey(Tshirt, on_delete=models.CASCADE, related_name='in_cart')
    quantity = models.PositiveIntegerField(default=1)
    added_on = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.user.username} - {self.tshirt.name} (x{self.quantity})"