import numpy as np
import mediapipe as mp
import depthai as dai
import cv2

mp_drawing = mp.solutions.drawing_utils
mp_drawing_styles = mp.solutions.drawing_styles
mp_pose = mp.solutions.pose

pipeline = dai.Pipeline()
cam_rgb = pipeline.create(dai.node.ColorCamera)
cam_rgb.setPreviewSize(300,300)
cam_rgb.setInterleaved(False)

xout_rgb = pipeline.create(dai.node.XLinkOut)
xout_rgb.setStreamName("rgb")
cam_rgb.preview.link(xout_rgb.input)

with dai.Device(pipeline) as device:
    q_rgb = device.getOutputQueue("rgb")
    frame = None
    with mp_pose.Pose( min_detection_confidence=0.5, min_tracking_confidence=0.5) as pose:
        while True:
            in_rgb = q_rgb.tryGet()
            if in_rgb is None:
                continue
            frame = in_rgb.getCvFrame()

            if frame is None: 
                continue
            frame.flags.writeable = False
            frame = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
            results = pose.process(frame)

            frame.flags.writeable = True
            frame = cv2.cvtColor(frame, cv2.COLOR_RGB2BGR)
            mp_drawing.draw_landmarks(
                frame,
                results.pose_landmarks,
                mp_pose.POSE_CONNECTIONS,
                landmark_drawing_spec=mp_drawing_styles.get_default_pose_landmarks_style())

            cv2.imshow('MediaPipe Pose', cv2.flip(frame, 1))
            if cv2.waitKey(1) == ord('q'):
                break
