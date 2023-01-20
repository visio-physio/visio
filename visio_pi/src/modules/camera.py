from abc import ABC, abstractmethod
from enum import Enum

class CameraType(Enum):
    OAK_D = 1
    WEBCAM = 2


class Camera(ABC):
    def __init__(self, preview_width, preview_height):
        self.preview_width = preview_width
        self.preview_height = preview_height

    @abstractmethod
    def initialize_camera(self):
        pass

    @abstractmethod
    def get_frame(self):
        pass

