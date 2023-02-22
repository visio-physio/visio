import cv2
import firebase_admin

class ResultCompiler:
    PATH_TO_CREDENTIALS = "" # TODO: Add file path to firebase credentials

    # results_db_path: URL to the realtime database for results
    # results_destination_path: destination file in firebase storage for results
    # video_db_name: name of the realtime database for videos
    def __init__(self, exercise, body_part, results_db_path, results_destination_path, video_db_name):
        self.cred = firebase_admin.credentials.Certificate(self.PATH_TO_CREDENTIALS)
        self.exercise = exercise
        self.body_part = body_part
        self.results_db_path = results_db_path
        self.results_destination_path = results_destination_path
        self.video_db_name = video_db_name
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

        bucket = firebase_admin.storage.bucket()
        blob = bucket.blob("./results.avi")
        blob.upload_from_filename("./results.avi")

    def store_results_in_firebase(self) -> None:
        firebase_admin.initialize_app(self.cred, {
            "databaseURL": self.results_db_path
        })

        ref = firebase_admin.db.reference(self.results_destination_path)
        ref.set(self.results)
