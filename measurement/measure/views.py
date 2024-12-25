from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.parsers import JSONParser
import cv2
import mediapipe as mp
import numpy as np
import base64
from PIL import Image
from io import BytesIO
import logging
from django.http import JsonResponse
import base64

# Initialize MediaPipe Pose
mp_pose = mp.solutions.pose

# Configure logging
logger = logging.getLogger(__name__)

class LiveMeasurementView(APIView):
    parser_classes = [JSONParser]  # Allow receiving JSON data

    def post(self, request, *args, **kwargs):
        logger.info("Received request with data: %s", request.data)
        image_data = request.data.get('image', None)
        user_height_cm = float(request.data.get('user_height', 0))

        if not image_data or not user_height_cm:
            logger.error("Invalid data provided: image_data=%s, user_height_cm=%s", image_data, user_height_cm)
            return Response({"error": "Invalid data provided."}, status=400)

        # Decode the image from base64
        try:
            image_bytes = base64.b64decode(image_data)
            image = Image.open(BytesIO(image_bytes))
            frame = cv2.cvtColor(np.array(image), cv2.COLOR_RGB2BGR)
        except Exception as e:
            logger.error("Failed to decode image: %s", str(e))
            return Response({"error": "Invalid image data."}, status=400)

        # Process the frame using MediaPipe Pose
        with mp_pose.Pose(static_image_mode=False, model_complexity=1) as pose:
            frame_rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
            results = pose.process(frame_rgb)

            if results.pose_landmarks:
                landmarks = results.pose_landmarks.landmark
                frame_height = frame.shape[0]

                # Ensure both ankles are detected before proceeding
                if (
                    landmarks[mp_pose.PoseLandmark.LEFT_ANKLE].visibility < 0.5 or
                    landmarks[mp_pose.PoseLandmark.RIGHT_ANKLE].visibility < 0.5
                ):
                    logger.error("Both ankles must be detected for accurate calculation.")
                    return Response({"error": "Both ankles must be detected for calculation."}, status=400)

                # Apply offset for head estimation and vertical torso adjustment
                # landmarks = self.apply_offsets_for_head_and_torso(landmarks)

                # Calculate scaling factor and measurements
                scaling_factor = self.calculate_scaling_factor(landmarks, frame_height, user_height_cm)
                shoulder_width, hip_width = self.calculate_measurements(landmarks, frame_height, scaling_factor)
                inseam = self.calculate_inseam(landmarks, frame_height, scaling_factor)
                chest_width = self.calculate_chest_width(landmarks, frame_height, scaling_factor)
                torso_length = self.calculate_torso_length(landmarks, frame_height, scaling_factor)
                shoulder_width = round(shoulder_width)
                hip_width = round(hip_width)
                user_height_cm = round(user_height_cm)
                inseam = round(inseam)
                chest_width = round(chest_width)
                torso_length = round(torso_length)
                recommended_size = self.recommend_size(chest_width, torso_length)

                # Additional measurements
                logger.info("Measurements calculated: shoulder_width=%s, hip_width=%s, inseam=%s, scaling_factor=%s, torso_length=%s, chest_width=%s",
                            shoulder_width, hip_width, inseam, scaling_factor, torso_length, chest_width)

                return Response({
                    "shoulder_width_cm": shoulder_width,
                    "hip_width_cm": hip_width,
                    "height_cm": user_height_cm,
                    "inseam_cm": inseam,
                    "scaling_factor": round(scaling_factor, 2),
                    "torso_length_cm": torso_length,
                    "chest_width_cm": chest_width,
                    "recommended_size": recommended_size,  # Ensure this key is included
                })

            logger.error("Pose landmarks not detected.")
            return Response({"error": "Pose landmarks not detected."}, status=400)

    def calculate_scaling_factor(self, landmarks, frame_height, real_height_cm):
        left_eye = landmarks[mp_pose.PoseLandmark.LEFT_EYE]
        right_eye = landmarks[mp_pose.PoseLandmark.RIGHT_EYE]
        top_of_head_y = (left_eye.y + right_eye.y) / 2 * frame_height

        left_ankle = landmarks[mp_pose.PoseLandmark.LEFT_ANKLE]
        right_ankle = landmarks[mp_pose.PoseLandmark.RIGHT_ANKLE]
        mid_ankle_y = ((left_ankle.y + right_ankle.y) / 2) * frame_height

        pixel_height = abs(mid_ankle_y - top_of_head_y)
        return real_height_cm / pixel_height

    def calculate_measurements(self, landmarks, frame_height, scaling_factor):
        left_shoulder = landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER]
        right_shoulder = landmarks[mp_pose.PoseLandmark.RIGHT_SHOULDER]
        shoulder_width_px = np.linalg.norm(
            np.array([left_shoulder.x, left_shoulder.y]) - np.array([right_shoulder.x, right_shoulder.y])
        ) * frame_height

        left_hip = landmarks[mp_pose.PoseLandmark.LEFT_HIP]
        right_hip = landmarks[mp_pose.PoseLandmark.RIGHT_HIP]
        hip_width_px = np.linalg.norm(
            np.array([left_hip.x, left_hip.y]) - np.array([right_hip.x, right_hip.y])
        ) * frame_height

        return shoulder_width_px * scaling_factor, hip_width_px * scaling_factor

    def calculate_inseam(self, landmarks, frame_height, scaling_factor):
        left_hip = landmarks[mp_pose.PoseLandmark.LEFT_HIP]
        right_hip = landmarks[mp_pose.PoseLandmark.RIGHT_HIP]
        mid_hip_y = (left_hip.y + right_hip.y) / 2 * frame_height

        left_ankle = landmarks[mp_pose.PoseLandmark.LEFT_ANKLE]
        right_ankle = landmarks[mp_pose.PoseLandmark.RIGHT_ANKLE]
        mid_ankle_y = (left_ankle.y + right_ankle.y) / 2 * frame_height

        inseam_px = abs(mid_ankle_y - mid_hip_y)
        return inseam_px * scaling_factor

    def calculate_torso_length(self, landmarks, frame_height, scaling_factor):
        # Using the midpoint between shoulders and hips to estimate torso length
        left_shoulder = landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER]
        left_hip = landmarks[mp_pose.PoseLandmark.LEFT_HIP]

        torso_length_px = abs(left_shoulder.y - left_hip.y) * frame_height
        return (torso_length_px * scaling_factor)+18

    def calculate_chest_width(self, landmarks, frame_height, scaling_factor):
        # Calculate shoulder-to-shoulder width in pixels
        right_shoulder = landmarks[mp_pose.PoseLandmark.RIGHT_SHOULDER]
        left_shoulder = landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER]
        left_hip = landmarks[mp_pose.PoseLandmark.LEFT_HIP]

        # Calculate shoulder width in pixels
        shoulder_width_px = abs(left_shoulder.x - right_shoulder.x) * frame_height
        shoulder_width = shoulder_width_px * scaling_factor

        # Calculate torso length (distance from shoulder to hip) in pixels
        torso_length_px = abs(left_shoulder.y - left_hip.y) * frame_height
        torso_length = torso_length_px * scaling_factor

        # Refine chest width based on torso length (using weighted average)
        chest_width = shoulder_width * 0.75 + torso_length * 0.25  # Weighted average of shoulder width and torso length

        return chest_width

    def recommend_size(self, chest_width, torso_length):
        # Define size charts for T-shirt, pants, etc.
        size_chart_tshirt = {
        "S": {"chest_width": (46, 48), "torso_length": (71, 73)},
        "M": {"chest_width": (49, 51), "torso_length": (74, 76)},
        "L": {"chest_width": (52, 54), "torso_length": (77, 79)},
        "XL": {"chest_width": (55, 57), "torso_length": (80, 82)},
        "2XL": {"chest_width": (58, 60), "torso_length": (83, 85)},
        "3XL": {"chest_width": (61, 63), "torso_length": (86, 88)},
        "4XL": {"chest_width": (64, 66), "torso_length": (89, 91)},
        "5XL": {"chest_width": (67, 69), "torso_length": (92, 94)}
    }

        # Check if both chest width and torso length fall within the same size range
        for size, values in size_chart_tshirt.items():
            if (values["chest_width"][0] <= chest_width <= values["chest_width"][1] and
                    values["torso_length"][0] <= torso_length <= values["torso_length"][1]):
                return size

        # If they fall into different ranges, recommend based on chest width
        for size, values in size_chart_tshirt.items():
            if values["chest_width"][0] <= chest_width <= values["chest_width"][1]:
                return size

        return "Size not found"

def test_view(request):
    return JsonResponse({"message": "Measure app is working!"})