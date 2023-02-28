import cv2
import numpy as np
import mediapipe as mp
import depthai as dai

from .depthai_blazepose import mediapipe_utils as mpu
from .depthai_blazepose.FPS import FPS, now
from depthai_blazepose.BlazeposeRenderer import BlazeposeRenderer

class VisioPose:
    complexity = {'lite': 0, 'full': 1, 'heavy': 2}

    def __init__(self,
                crop = False,
                lm_model="full",
                resolution="full",
                internal_fps=None,
                internal_frame_height=1080,
                force_detection=False):
        
        self.crop = crop
        self.force_detection = force_detection

        if resolution == "full":
            self.resolution = (1920, 1080)
        elif resolution == "ultra":
            self.resolution = (3840, 2160)

        if internal_fps is None:
            if lm_model == "heavy"
                self.internal_fps = 10
            elif lm_model == "full":
                self.internal_fps = 8
            else:
                self.internal_fps = 13
        
        if self.crop:
            self.frame_size, self.scale_nd = mpu.find_isp_scale_params(internal_frame_height)
            self.img_h = self.img_w = self.frame_size
            self.pad_w = self.pad_h = 0
            self.crop_w = (int(round(self.resolution[0] * self.scale_nd[0] / self.scale_nd[1])) - self.img_w) // 2
        else:
            width, self.scale_nd = mpu.find_isp_scale_params(internal_frame_height * 1920 / 1080, is_height=False)
            self.img_h = int(round(self.resolution[1] * self.scale_nd[0] / self.scale_nd[1]))
            self.img_w = int(round(self.resolution[0] * self.scale_nd[0] / self.scale_nd[1]))
            self.pad_h = (self.img_w - self.img_h) // 2
            self.pad_w = 0
            self.frame_size = self.img_w
            self.crop_w = 0
        
        self.device = dai.Device()
        usb_speed = self.device.getUsbSpeed()
        self.device.startPipeline(self.create_pipeline())
        print(f"Pipeline started, USB speed: {str(usb_speed).split('.')[-1]}")
        
        self.q_video = self.device.getOutputQueue(name="cam_out", maxSize=1, blocking=False)
        self.fps = FPS()

        self.pose_model = mp.solutions.pose.Pose(min_detection_confidence=0.5, 
                                                min_tracking_confidence=0.5,
                                                model_complexity=self.complexity[lm_model],
                                                smooth_landmarks=True)

    def create_pipeline(self):
        pipeline = dai.Pipeline()

        cam = pipeline.createColorCamera()
        cam.setResolution(dai.ColorCameraProperties.SensorResolution.THE_1080_P)
        cam.setInterleaved(False)
        cam.setIspScale(self.scale_nd[0], self.scale_nd[1])
        cam.setFps(self.internal_fps)
        cam.setBoardSocket(dai.CameraBoardSocket.RGB)

        if self.crop:
                cam.setVideoSize(self.frame_size, self.frame_size)
                cam.setPreviewSize(self.frame_size, self.frame_size)
        else: 
            cam.setVideoSize(self.img_w, self.img_h)
            cam.setPreviewSize(self.img_w, self.img_h)

        cam_out = pipeline.createXLinkOut()
        cam_out.setStreamName("cam_out")
        cam_out.input.setQueueSize(1)
        cam_out.input.setBlocking(False)
        cam.video.link(cam_out.input)

        return pipeline

    def next_frame(self):
        self.fps.update()
        
        in_video = self.q_video.get()
        video_frame = in_video.getCvFrame()
        if self.pad_h:
            rgb_frame = cv2.copyMakeBorder(video_frame, self.pad_h, self.pad_h, self.pad_w, self.pad_w, cv2.BORDER_CONSTANT)
        else:
            rgb_frame = video_frame

        result = self.pose_model.process(rgb_frame)
        body = mpu.Body()
        body.landmarks = result.pose_landmarks.landmark
        return rgb_frame, body
