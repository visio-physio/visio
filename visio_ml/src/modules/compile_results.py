# import cv2
import datetime
import time
import firebase_admin
from firebase_admin import firestore
from collections import defaultdict

class ResultCompiler:
    PATH_TO_CREDENTIALS = "./auth.json"

    def __init__(self, user_id, exercise, frame_rate=15, frame_size=(600, 600), local_file_path="."):
        self.cred = firebase_admin.credentials.Certificate(self.PATH_TO_CREDENTIALS)
        self.exercise = exercise
        self.user_id = user_id
        self.results = defaultdict(lambda: [0])
        self.peaks_and_valleys = defaultdict(list)
        self.video_file_name = f"{local_file_path}/{user_id}_{exercise}_{frame_rate}fps_{datetime.datetime.now()}.avi"
        # self.out = cv2.VideoWriter(self.video_file_name, cv2.VideoWriter_fourcc('M','J','P','G'), frame_rate, frame_size)

    def get_exercise(self):
        return self.exercise

    def record_angle(self, angle) -> None:
        for key, val in angle.items():
            if len(self.results[key]) > 1:
                prev_delta = self.results[key][-1] - self.results[key][-2]
                curr_delta = val - self.results[key][-1]
                if prev_delta * curr_delta < 0:
                    self.peaks_and_valleys[key].append(self.results[key][-1])

            self.results[key].append(val)

    def record_frame(self, frame) -> None:
        self.out.write(frame)

    # side should be left or right
    def get_average_range(self, side) -> float:
        total = 0
        arr = self.peaks_and_valleys[side]
        for i in range(1, len(arr)):
            total += abs(arr[i] - arr[i - 1])

        return total / (len(arr) - 1)

    def store_results_in_firebase(self) -> None:
        app = firebase_admin.initialize_app(self.cred)
        db = firestore.client()
        doc = db.collection(u'results').document(self.user_id)
        doc.set({
            self.exercise: {
                str(time.time()): self.peaks_and_valleys
            }
        }, merge=True)

    """
    def store_video_in_firebase(self) -> None:
        self.out.release()
        firebase_admin.initialize_app(self.cred, {
            "storageBucket": self.video_db_name
        })

        bucket = firebase_admin.storage.bucket()
        blob = bucket.blob(f"./{self.video_file_name}")
        blob.upload_from_filename(f"./{self.video_file_name}")
    """
