import cv2
import firebase_admin

class ResultCompiler:
    PATH_TO_CREDENTIALS = "" # TODO: Add file path to firebase credentials

    # db_path: URL to the realtime database for results
    # video_db_name: name of the realtime database for videos
    # destination_path: destination file in firebase storage
    def __init__(self, exercise, body_part, db_path, video_db_name, destination_path):
        self.cred = firebase_admin.credentials.Certificate(self.PATH_TO_CREDENTIALS)
        self.exercise = exercise
        self.body_part = body_part
        self.results_db_path = db_path
        self.video_db_name = video_db_name
        self.destination_path = destination_path
        self.results = []
        self.total = 0
        self.out = cv2.VideoWriter("results.avi", cv2.VideoWriter_fourcc('M','J','P','G'), 10, (1152, 648))
    
    def record_angle(self, angle) -> None:
        self.results.append(angle)
        self.total += angle

    def record_frame(self, frame) -> None:
        self.out.write(frame)

    def get_average_range(self) -> float:
        return self.total / len(self.results)

    def store_video_in_firebase(self) -> None:
        self.out.release()
        firebase_admin.initialize_app(self.cred, {
            "databaseURL": self.results_db_path
        })

    def store_results_in_firebase(self) -> None:
        firebase_admin.initialize_app(self.cred, {
            "storageBucket": self.video_db_name
        })

        bucket = firebase_admin.storage.bucket()
        blob = bucket.blob("./results.avi")
        blob.upload_from_filename("./results.avi")
