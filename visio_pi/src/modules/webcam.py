import cv2
from .camera import Camera

class WebCam(Camera):
    def initialize_camera(self):
        self.cap = cv2.VideoCapture(0)

        # Check if camera opened successfully
        if (self.cap.isOpened() == False):
            print("Unable to read camera feed")

    def get_frame(self):
        ret, frame = self.cap.read()
        if ret:
            return frame