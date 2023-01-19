import cv2
import numpy as np
import pickle
import socket

import requests
import time

url = 'http://192.168.0.10:3001/videoStream/uploadFramePayload'
HOST = '192.168.0.10'
PORT = 8001

# Create a VideoCapture object
cap = cv2.VideoCapture(0)

# Check if camera opened successfully
if (cap.isOpened() == False): 
  print("Unable to read camera feed")

# Default resolutions of the frame are obtained.The default resolutions are system dependent.
# We convert the resolutions from float to integer.
frame_width = int(cap.get(3))
frame_height = int(cap.get(4))
print(frame_width, frame_height)

# Define the codec and create VideoWriter object.The output is stored in 'outpy.avi' file.
with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
  s.connect((HOST, PORT))

  while(True):
    ret, frame = cap.read()
    frame = frame[0:300,0:300]
    
    # params = {'height': frame_height, 'width': frame_width}
    # data = {'params': params, 'arr': frame.tolist()}
    # x = requests.post(url, json=data)
    # x = requests.post(url, data={'key': frame.tobytes()})
    s.sendall(frame.tobytes())
    # print(frame.tostring())

    if ret == True: 
      cv2.imshow('frame',frame)
      if cv2.waitKey(1) & 0xFF == ord('q'):
        break
    else:
      break
    data = s.recv(1024)
    print(f"{data!r}")


  cap.release()
  cv2.destroyAllWindows()
