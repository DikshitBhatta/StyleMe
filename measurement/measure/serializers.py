# measure/serializers.py
from rest_framework import serializers

class MeasurementInputSerializer(serializers.Serializer):
    height = serializers.FloatField()
    unit = serializers.ChoiceField(choices=['cm', 'm'])

class MeasurementOutputSerializer(serializers.Serializer):
    shoulder_width = serializers.FloatField()
    hip_width = serializers.FloatField()
    height = serializers.FloatField()
    inseam = serializers.FloatField()