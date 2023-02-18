import cv2
from collections import defaultdict

class ResultCompiler:
    def __init__(self):
        self.results = defaultdict(defaultdict(list))
        self.out = cv2.VideoWriter("results.avi", cv2.VideoWriter_fourcc('M','J','P','G'), 10, (1152, 648))
    
    def record_angle(self, angle) -> None:
        arr = angle.split(":")
        if len(arr) != 3:
            raise Exception("Invalid angle input")

        body_part, name, angle = arr[0], arr[1], float(arr[2])
        self.results[body_part][name].append(angle)

    def record_frame(self, frame) -> None:
        self.out.write(frame)

    def get_average_range(self, body_part, name) -> float:
        total = 0
        for val in self.results[body_part][name]:
            total += val
        
        return total / len(self.results[body_part][name])

    def store_video_in_firebase(self) -> None:
        pass

    def store_results_in_firebase(self) -> None:
        pass