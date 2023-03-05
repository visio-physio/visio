# import cv2
import datetime
import firebase_admin
from firebase_admin import firestore
from collections import defaultdict
from time import time, sleep

class ResultCompiler:
    PATH_TO_CREDENTIALS = "src/modules/auth.json"

    def __init__(self, user_id, exercise, body_part, frame_rate=15, frame_size=(600, 600), local_file_path=".", delta=0.5):
        self.cred = firebase_admin.credentials.Certificate(self.PATH_TO_CREDENTIALS)
        if not firebase_admin._apps:
            firebase_admin.initialize_app(self.cred)

        self.delta = delta
        self.exercise = exercise
        self.body_part = body_part
        self.user_id = user_id
        self.results = defaultdict(lambda: defaultdict(int))
        self.timestamped_angles = defaultdict(list)
        self.peaks_and_valleys = defaultdict(list)
        self.video_file_name = f"{local_file_path}/{user_id}_{exercise}_{body_part}_{frame_rate}fps_{datetime.datetime.now()}.avi"
        # self.out = cv2.VideoWriter(self.video_file_name, cv2.VideoWriter_fourcc('M','J','P','G'), frame_rate, frame_size)

    def get_body_part(self):
        return self.body_part

    def get_exercise(self):
        return self.exercise

    def record_angle(self, angle) -> None:
        t = time()
        for key, val in angle.items():
            self.results[key][val // 1] += 1
            self.timestamped_angles[key].append((t, val // 1))

    """
    def record_frame(self, frame) -> None:
        self.out.write(frame)
    """
        
    def get_max_range(self, side) -> float:
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
    
    def get_timestamped_results(self):
        res = {}
        for key, arr in self.timestamped_angles.items():
            prev = arr[0][0]
            res[key] = [arr[0][1]]
            for t, angle in arr[1:]:
                if t - prev >= self.delta:
                    prev = t
                    res[key].append(angle)
        
        return res

    def store_results_in_firebase(self) -> None:
        db = firestore.client()

        res = {}
        for key in self.results:
            res[f"max {key}"] = self.get_max_range(key)

        timestamped_results = self.get_timestamped_results()
        res["timestamped_data"] = timestamped_results
        res["delta (s)"] = self.delta

        identifier = f"{self.exercise}-{self.body_part}"
        doc = db.collection(u'results').document(self.user_id)
        doc.set({
            identifier: {
                str(time()): res
            },
        }, merge=True)
