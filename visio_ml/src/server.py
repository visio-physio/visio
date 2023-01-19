import socket
import numpy as np
import cv2

HOST = "127.0.0.1"
PORT = 8001

payload_size = 270000

with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
    print("socket created. Listening...")
    s.bind(('', PORT))
    s.listen(5)
    conn, addr = s.accept()
    with conn:
        print(f"Connected by {addr}")
        while True:
            data = b""
            while len(data) < payload_size:
                print(f"Recv: {len(data)}")
                data += conn.recv(8192)
            print(f"Done Recv: {len(data)}")

            if len(data) != payload_size:
                continue

            frame = np.frombuffer(data, dtype=np.uint8)
            print(f"Frame parsed: {frame.shape}")

            cv2.imshow("frame", frame.reshape((300, 300, 3)))
            cv2.waitKey(1)

            conn.sendall(b'ack')