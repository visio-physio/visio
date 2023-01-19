import cv2
import depthai as dai
import numpy as np
import mediapipe as mp
from time import monotonic

mp_drawing = mp.solutions.drawing_utils
mp_drawing_styles = mp.solutions.drawing_styles
mp_pose = mp.solutions.pose


pipeline = dai.Pipeline()

spatial_location_calculator = pipeline.createSpatialLocationCalculator()
spatial_location_calculator.setWaitForConfigInput(True)
spatial_location_calculator.inputDepth.setBlocking(False)
spatial_location_calculator.inputDepth.setQueueSize(1)

spatial_data_out = pipeline.createXLinkOut()
spatial_data_out.setStreamName("spatial_data_out")
spatial_data_out.input.setQueueSize(1)
spatial_data_out.input.setBlocking(False)

spatial_calc_config_in = pipeline.createXLinkIn()
spatial_calc_config_in.setStreamName("spatial_calc_config_in")

spatial_location_calculator.out.link(spatial_data_out.input)
spatial_calc_config_in.out.link(spatial_location_calculator.inputConfig)

depth_in_frame = pipeline.create(dai.node.XLinkIn)
depth_in_frame.setStreamName("depth_in_frame")
depth_in_frame.out.link(spatial_location_calculator.inputDepth)

with dai.Device(pipeline) as device:
    qIn = device.getInputQueue(name="depth_in_frame")
    depth_frame = None

    with mp_pose.Pose( min_detection_confidence=0.5, min_tracking_confidence=0.5) as pose:
      while True:
         # Receive RGB frame and run BlazePose
         pass
      
      
