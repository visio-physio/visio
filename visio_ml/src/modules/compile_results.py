# import cv2
import datetime
import time
import firebase_admin
from firebase_admin import firestore
from collections import defaultdict

class ResultCompiler:
    PATH_TO_CREDENTIALS = "./auth.json"

    def __init__(self, user_id, exercise, body_part, frame_rate=15, frame_size=(600, 600), local_file_path="."):
        self.cred = firebase_admin.credentials.Certificate(self.PATH_TO_CREDENTIALS)
        if not firebase_admin._apps:
            firebase_admin.initialize_app(self.cred)
        self.exercise = exercise
        self.body_part = body_part
        self.user_id = user_id
        self.results = defaultdict(lambda: defaultdict(int))
        self.peaks_and_valleys = defaultdict(list)
        self.video_file_name = f"{local_file_path}/{user_id}_{exercise}_{body_part}_{frame_rate}fps_{datetime.datetime.now()}.avi"
        # self.out = cv2.VideoWriter(self.video_file_name, cv2.VideoWriter_fourcc('M','J','P','G'), frame_rate, frame_size)

    def get_body_part(self):
        return self.body_part

    def get_exercise(self):
        return self.exercise

    def record_angle(self, angle) -> None:
        for key, val in angle.items():
            self.results[key][val // 1] += 1

    def record_frame(self, frame) -> None:
        self.out.write(frame)

    # side should be left or right
    def get_average_range(self, side) -> float:
        hist = self.results[side]
        keys = list(hist.keys())
        mid = (max(keys) + min(keys)) / 2
        low = []
        high = []

        for key in keys:
            if key <= mid:
                low.append(key)
            else:
                high.append(key)

        low.sort(key=lambda x: -hist[x])
        high.sort(key=lambda x: -hist[x])

        return max(high[:min(len(high), 5)]) - min(low[:min(len(low), 5)])

    def store_results_in_firebase(self) -> None:
        db = firestore.client()

        res = {}
        for key in self.results:
            res[key] = self.get_average_range(key)

        identifier = f"{self.exercise}-{self.body_part}"
        doc = db.collection(u'results').document(self.user_id)
        doc.set({
            identifier: {
                str(time.time()): res
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
