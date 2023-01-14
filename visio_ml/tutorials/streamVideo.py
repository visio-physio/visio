import numpy as np
import cv2 as cv
import time

cap = cv.VideoCapture('outpy.avi')
while cap.isOpened():
    ret, frame = cap.read()
    # if frame is read correctly ret is True
    if not ret:
        print("Can't receive frame (stream end?). Exiting ...")
        break

    cv.imshow('frame', frame)
    if cv.waitKey(1) == ord('q'):
        break
    time.sleep(0.03)
cap.release()
cv.destroyAllWindows()