import cv2

class ResultCompiler:
    def __init__(self):
        self.angles = []
        self.out = cv2.VideoWriter("results.avi", cv2.VideoWriter_fourcc('M','J','P','G'), 10, (1152, 648))
    
    def record_angle(self, angle):
        pass
    
    def record_frame(self, frame):
        pass