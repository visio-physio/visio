#!/usr/bin/env python

import pickle
import asyncio
import websockets
import cv2
import base64
import gzip
from concurrent.futures import ProcessPoolExecutor
import os
from depthai_blazepose.BlazeposeRenderer import BlazeposeRenderer
from depthai_blazepose.BlazeposeDepthaiEdge import BlazeposeDepthai

class OakdProducer():
    def __init__(self):
        self.state = 'idle' # 'produce'
        self.excercise = None
        self.name = None
        self.date = None
        self.websocket = None

    async def serve(self, host, port):
        server = await websockets.serve(self.handler, host, port)
        producer_task = asyncio.create_task(self.produce())
        await asyncio.gather(server.serve_forever(), producer_task)
    
    async def handler(self, websocket):
        self.websocket = websocket
        async for message in websocket:
            event = pickle.loads(message)
            self.state = event['state']
            self.excercise = event['exercise']
            self.name = event['name']
            self.date = event['date']
        print(f"State updated to: {self.state}")
    
    async def produce(self):
        tracker = BlazeposeDepthai(
                    xyz=True,
                    crop=True,
                    internal_frame_height=600
                    )
        renderer = BlazeposeRenderer(tracker, show_3d=False)

        while True:
            await asyncio.sleep(0.001)
            if self.state == 'produce':
                frame, body = tracker.next_frame()
                if frame is None:
                    break

                if body is not None:
                    result = body.get_measurement('shoulder','abduction')
                    left_shoulder, right_shoulder = result["left_shoulder"], result["right_shoulder"]
                    print(f"Left: {left_shoulder}, right: {right_shoulder}")

                frame = renderer.draw(frame, body)

                 # Convert the frame to a byte string
                _, buffer = cv2.imencode('.jpg', frame)
                frame_bytes = buffer.tobytes()
                compressed_frame_bytes = gzip.compress(frame_bytes)
                # Encode the byte string as a base64 string
                frame_base64 = base64.b64encode(compressed_frame_bytes).decode('utf-8')
                # Send the base64 string to the client
                await self.websocket.send(frame_base64)

                key = renderer.waitKey(delay=1)
                if key == ord('q') or key == 27:
                    break

                # send to results compiler based on exercise
        renderer.exit()
        tracker.exit()

if __name__ == "__main__":
    server = OakdProducer()
    ip = os.popen('ipconfig getifaddr en0').read()[:-1]
    print("ip:",ip)
    asyncio.run(server.serve(ip, 8080))
