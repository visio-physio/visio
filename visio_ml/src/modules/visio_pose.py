import cv2
import numpy as np
import mediapipe as mp
import depthai as dai

import depthai_blazepose.mediapipe_utils as mpu
from depthai_blazepose.FPS import FPS, now
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
            if lm_model == "heavy":
                self.internal_fps = 10
            elif lm_model == "full":
                self.internal_fps = 30
            else:
                self.internal_fps = 30
        
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

        self.pose_model = mp.solutions.pose.Pose(min_detection_confidence=0.8, 
                                                min_tracking_confidence=0.6,
                                                model_complexity=self.complexity[lm_model],
                                                smooth_landmarks=True)
        self.presence_threshold = 0.5
        self.xyz = False

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

        rgb_frame = cv2.cvtColor(rgb_frame, cv2.COLOR_BGR2RGB)
        rgb_frame.flags.writeable = False
        result = self.pose_model.process(rgb_frame)
        rgb_frame.flags.writeable = True
        rgb_frame = cv2.cvtColor(rgb_frame, cv2.COLOR_RGB2BGR)

        body = mpu.Body()
        if result.pose_landmarks is not None:
            body.pose_landmarks = result.pose_landmarks
            body.pose_world_landmarks = result.pose_world_landmarks
            landmarks = [np.array([lm.x, lm.y, lm.z]) for lm in result.pose_landmarks.landmark]
            body.landmarks = np.asarray(landmarks)
            body.presence = [lm.visibility for lm in result.pose_landmarks.landmark]

        return rgb_frame, body
    
    def exit(self):
        pass
    
class VisioPoseRenderer():
    def __init__(self, tracker):
        self.tracker = tracker
        self.mp_drawing = mp.solutions.drawing_utils
        self.mp_drawing_styles = mp.solutions.drawing_styles
        self.pose_connection = mp.solutions.pose.POSE_CONNECTIONS

    def draw(self, frame, body):
        self.frame = frame
        if body.pose_landmarks is not None:
            self.mp_drawing.draw_landmarks(
                self.frame,
                body.pose_landmarks,
                self.pose_connection,
                landmark_drawing_spec=self.mp_drawing_styles.get_default_pose_landmarks_style())
        
        self.tracker.fps.draw(self.frame, orig=(50,50), size=1, color=(240,180,100))
        
        return self.frame
    
    def waitKey(self, delay=1):
        cv2.imshow("Blazepose", self.frame)
        key = cv2.waitKey(delay)
        return key
    
    def exit(self):
        pass


if __name__ == "__main__":

    tracker = VisioPose(
                crop=True,
                internal_frame_height=600,
                lm_model='lite'
            )
    # renderer = BlazeposeRenderer(tracker=tracker, show_3d=False)
    renderer = VisioPoseRenderer(tracker)

    while True:
        frame, body = tracker.next_frame()
        frame.flags.writeable = True
        frame = renderer.draw(frame, body)

        if body.landmarks is not None:
            result = body.get_measurement("shoulder", "abduction")
            y_coord = 50
            for body_part, measurement in result.items():
                # Append text to each frame in the top left corner with minimum usage of space on the frame
                cv2.putText(frame, f"{body_part}: {round(measurement, 5)}", (5, y_coord),
                            cv2.FONT_HERSHEY_PLAIN, 1.5,
                            (0, 0, 255), 2)
                print(f"{body_part}: {measurement}\n")
                y_coord += 15
        
        key = renderer.waitKey(delay=1)
        if key == ord('q') or key == 27:
            break
