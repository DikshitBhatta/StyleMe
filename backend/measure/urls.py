from django.urls import path
from .views import LiveMeasurementView

urlpatterns = [
    path('live/', LiveMeasurementView.as_view(), name='live-measurements'),
]
