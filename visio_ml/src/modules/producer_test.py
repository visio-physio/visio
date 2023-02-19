#!/usr/bin/env python

import pickle
import asyncio
import cv2
import websockets


async def hello(websocket):
    cap = cv2.VideoCapture(0)
    status = await websocket.recv()
    if status == "hello there!":
        i = 0
        while True:
            ret, frame = cap.read()
            if not ret:
                break
            cv2.imshow("frame", frame)
            key = cv2.waitKey(1)
            await websocket.send(pickle.dumps(frame))
            print(f"Sent frame {i}")
            i += 1
            if key == ord('q'):
                break
        cv2.destroyAllWindows()
        cap.release()

            

async def main():

    async with websockets.serve(hello, "192.168.0.117", 8765):

        await asyncio.Future()  # run forever


if __name__ == "__main__":

    asyncio.run(main())