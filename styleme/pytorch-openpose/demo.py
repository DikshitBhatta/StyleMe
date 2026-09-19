import cv2
import matplotlib.pyplot as plt
import copy
import numpy as np
import os
import json

from src import model
from src import util
from src.body import Body
from src.hand import Hand

body_estimation = Body('model/body_pose_model.pth')
#hand_estimation = Hand('model/hand_pose_model.pth')

test_image = '../HR-VITON/test/test/image/00001_00.jpg'
oriImg = cv2.imread(test_image)  # B,G,R order
candidate, subset = body_estimation(oriImg)
canvas = np.zeros_like(oriImg)
#canvas = copy.deepcopy(oriImg)
canvas = util.draw_bodypose(canvas, candidate, subset)
# detect hand
# hands_list = util.handDetect(candidate, subset, oriImg)

# all_hand_peaks = []
# for x, y, w, is_left in hands_list:
#     # cv2.rectangle(canvas, (x, y), (x+w, y+w), (0, 255, 0), 2, lineType=cv2.LINE_AA)
#     # cv2.putText(canvas, 'left' if is_left else 'right', (x, y), cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 0, 255), 2)

#     # if is_left:
#         # plt.imshow(oriImg[y:y+w, x:x+w, :][:, :, [2, 1, 0]])
#         # plt.show()
#     peaks = hand_estimation(oriImg[y:y+w, x:x+w, :])
#     peaks[:, 0] = np.where(peaks[:, 0]==0, peaks[:, 0], peaks[:, 0]+x)
#     peaks[:, 1] = np.where(peaks[:, 1]==0, peaks[:, 1], peaks[:, 1]+y)
#     # else:
#     #     peaks = hand_estimation(cv2.flip(oriImg[y:y+w, x:x+w, :], 1))
#     #     peaks[:, 0] = np.where(peaks[:, 0]==0, peaks[:, 0], w-peaks[:, 0]-1+x)
#     #     peaks[:, 1] = np.where(peaks[:, 1]==0, peaks[:, 1], peaks[:, 1]+y)
#     #     print(peaks)
#     all_hand_peaks.append(peaks)

# canvas = util.draw_handpose(canvas, all_hand_peaks)

# plt.imshow(canvas[:, :, [2, 1, 0]])
# plt.axis('off')
# plt.show()

# Save the output image
input_image_path = "../HR-VITON/test/test/openpose_img/"
output_image_path = os.path.join(os.path.dirname(input_image_path), '00001_00_rendered.png')
cv2.imwrite(output_image_path, canvas)

print(f"Skeleton pose image saved at: {output_image_path}")


# # Prepare COCO-style JSON output
# pose_keypoints_2d = []
# for person in subset:
#     for i in range(18):  # COCO 18 keypoints
#         index = int(person[i])
#         if index == -1:
#             # If no keypoint found, add a placeholder with zero confidence
#             pose_keypoints_2d.extend([0, 0, 0])
#         else:
#             # Add keypoint coordinates and confidence score
#             x, y, confidence = candidate[index][:3]
#             pose_keypoints_2d.extend([float(x), float(y), float(confidence)])

# # Create JSON data
# output_data = {
#     "version": 1.0,
#     "people": [{"pose_keypoints_2d": pose_keypoints_2d}]
# }

# # Save JSON output
# path1 = "../HR-VITON/test/test/openpose_json/"
# json_output_path = os.path.join(os.path.dirname(path1), '00001_00_keypoints.json')
# with open(json_output_path, 'w') as f:
#     json.dump(output_data, f)

# print(f"Pose keypoints saved at: {json_output_path}")
