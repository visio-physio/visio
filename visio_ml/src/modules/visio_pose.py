import cv2
import numpy as np
import mediapipe as mp

KEYPOINT_DICT = {
    "nose": 0,
    "left_eye_inner": 1,
    "left_eye": 2,
    "left_eye_outer": 3,
    "right_eye_inner": 4,
    "right_eye": 5,
    "right_eye_outer": 6,
    "left_ear": 7,
    "right_ear": 8,
    "mouth_left": 9,
    "mouth_right": 10,
    "left_shoulder": 11,
    "right_shoulder": 12,
    "left_elbow": 13,
    "right_elbow": 14,
    "left_wrist": 15,
    "right_wrist": 16,
    "left_pinky": 17,
    "right_pinky": 18,
    "left_index": 19,
    "right_index": 20,
    "left_thumb": 21,
    "right_thumb": 22,
    "left_hip": 23,
    "right_hip": 24,
    "left_knee": 25,
    "right_knee": 26,
    "left_ankle": 27,
    "right_ankle": 28,
    "left_heel": 29,
    "right_heel": 30,
    "left_foot_index": 31,
    "right_foot_index": 32
}

class Body():
  def __init__(self, landmarks):
    self.landmarks = [np.array([lm.x, lm.y, lm.z]) for lm in landmarks]
    self.visibility = [lm.visibility for lm in landmarks]

  def get_transverse_plane_n(self):
    return self.get_spine()
  
  def get_sagittal_plane_n(self):
    return self.get_landmark_vector('right_hip', 'left_hip')

  def get_frontal_plane_n(self):
    transverse_plane_n = self.get_transverse_plane_n()
    sagittal_plane_n = self.get_sagittal_plane_n()
    return np.cross(sagittal_plane_n, transverse_plane_n)
  
  def project_on_anatomical_plane(self, v, plane):
    assert plane == 'sagittal' or plane == 'transverse' or plane == 'frontal'

    if plane == 'sagittal':
      sagittal_n = self.get_sagittal_plane_n()
      return v - np.dot(v, sagittal_n) * sagittal_n
    elif plane == 'transverse':
      transverse_n = self.get_transverse_plane_n()
      return v - np.dot(v, transverse_n) * transverse_n
    elif plane == 'frontal':
      frontal_n = self.get_frontal_plane_n()
      return v - np.dot(v, frontal_n) * frontal_n

  def get_spine(self):
    l_shoulder = self.landmarks[KEYPOINT_DICT['left_shoulder']]
    r_shoulder = self.landmarks[KEYPOINT_DICT['right_shoulder']]
    l_hip = self.landmarks[KEYPOINT_DICT['left_hip']]
    r_hip = self.landmarks[KEYPOINT_DICT['right_hip']]

    mid_shoulder = 1/2 * (l_shoulder + r_shoulder)
    mid_hip = 1/2 * (l_hip + r_hip)
    return (mid_hip - mid_shoulder) / np.linalg.norm(mid_hip - mid_shoulder)
  
  def get_landmark_vector(self, tail, head):
    tail_p = self.landmarks[KEYPOINT_DICT[tail]]
    head_p = self.landmarks[KEYPOINT_DICT[head]]
    return (head_p - tail_p) / np.linalg.norm(head_p - tail_p)

class VisioPose:
  def __init__(self):
    self.pose_model = mp.solutions.pose.Pose(min_detection_confidence=0.5, 
                                             min_tracking_confidence=0.5,
                                             model_complexity=1)

  def process_frame(self, rgb_frame):
    result = self.pose_model.process(rgb_frame)
    return result

  def calc_spatial_pose(self, depth_frame):
    pass

if __name__ == "__main__":
  vp = VisioPose()
  
  video_path = "/home/tristanle/visio/visio_ml/camera_outputs/camera_outputs/"
  depth_cap = cv2.VideoCapture(video_path + "%04d.png", cv2.CAP_IMAGES)
  rgb_cap = cv2.VideoCapture(video_path + "RGB_output.avi")

  mp_drawing = mp.solutions.drawing_utils
  mp_drawing_styles = mp.solutions.drawing_styles

  while rgb_cap.isOpened():
    ret, rgb_frame = rgb_cap.read()
    ret, depth_frame = depth_cap.read()
    # print(rgb_frame.shape)
    # print(depth_frame.shape)

    if not ret:
      print("Can't read frame")
      break

    pose = vp.process_frame(rgb_frame)

    body = Body(pose.pose_landmarks.landmark)
    right_arm = body.get_landmark_vector('right_shoulder', 'right_elbow')
    right_arm = body.project_on_anatomical_plane(right_arm, 'frontal')
    left_arm = body.get_landmark_vector('left_shoulder', 'left_elbow')
    left_arm = body.project_on_anatomical_plane(left_arm, 'frontal')
    spine = body.get_spine()
    right_arm_angle = np.arccos(np.clip(np.dot(right_arm, spine), -1.0, 1.0)) * 180 / np.pi
    left_arm_angle = np.arccos(np.clip(np.dot(left_arm, spine), -1.0, 1.0)) * 180 / np.pi
    print(f"Right arm: {right_arm_angle}, \tleft arm: {left_arm_angle}")

    mp_drawing.draw_landmarks(
      rgb_frame,
      pose.pose_landmarks,
      mp.solutions.pose.POSE_CONNECTIONS,
      landmark_drawing_spec = mp_drawing_styles.get_default_pose_landmarks_style())

    cv2.imshow("MP Pose", cv2.flip(rgb_frame, 1))
    if cv2.waitKey(1) == ord('q'):
      break
    