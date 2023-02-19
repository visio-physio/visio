import cv2
import firebase_admin
from collections import defaultdict

class ResultCompiler:
    PATH_TO_CREDENTIALS = "" # TODO: Add file path to firebase credentials
    PATH_TO_DATABASE = ""    # TODO: Add URL to the realtime database
    PATH_TO_DESTINATION = "" # TODO: Add destination file in firebase storage

    def __init__(self):
        self.results = defaultdict(lambda: defaultdict(list))
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
        cred = firebase_admin.credentials.Certificate(self.PATH_TO_CREDENTIALS)
        firebase_admin.initialize_app(cred, {
            "databaseURL": self.PATH_TO_DATABASE
        })

        ref = firebase_admin.db.reference(self.PATH_TO_DESTINATION)
        ref.set(self.results)