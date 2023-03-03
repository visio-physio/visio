#!/usr/bin/env python

import asyncio
import websockets
import cv2
import base64
import gzip
from concurrent.futures import ProcessPoolExecutor
import os
from depthai_blazepose.BlazeposeRenderer import BlazeposeRenderer
from depthai_blazepose.BlazeposeDepthaiEdge import BlazeposeDepthai
from visio_pose import VisioPose, VisioPoseRenderer

class OakdProducer():
    def __init__(self, cpu=False):
        self.state = 'idle' # 'produce'
        self.excercise = None
        self.name = None
        self.date = None
        self.websocket = None
        self.cpu = cpu
        self.state = ['shoulder', 'hip']

    async def serve(self, host, port):
        server = await websockets.serve(self.handler, host, port)
        producer_task = asyncio.create_task(self.produce())
        await asyncio.gather(server.serve_forever(), producer_task)
    
    async def handler(self, websocket):
        print("New connection")
        self.websocket = websocket
        async for message in websocket:
            # event = pickle.loads(message)
            # self.state = event['state']
            # self.excercise = event['exercise']
            # self.name = event['name']
            # self.date = event['date']
            self.state = message
        print(f"State updated to: {self.state}")

    async def send_frame(self, frame):
        # Convert the frame to a byte string
        _, buffer = cv2.imencode('.jpg', frame)
        frame_bytes = buffer.tobytes()
        compressed_frame_bytes = gzip.compress(frame_bytes)
        # Encode the byte string as a base64 string
        frame_base64 = base64.b64encode(compressed_frame_bytes).decode('utf-8')
        # Send the base64 string to the client
        await self.websocket.send(frame_base64)

    
    async def produce(self):
        if self.cpu:
            tracker = VisioPose(
                crop=True,
                internal_frame_height=600,
                lm_model='lite'
            )
            renderer = VisioPoseRenderer(tracker)
        else:
            tracker = BlazeposeDepthai(
                xyz=True,
                crop=True,
                internal_frame_height=600
            )
            renderer = BlazeposeRenderer(tracker=tracker, show_3d=False)
        

        while True:
            await asyncio.sleep(0.001)

            frame, body = tracker.next_frame()
            if frame is None:
                break

            
            if self.state in self.states:
                # frame, body = tracker.next_frame()
                # if frame is None:
                #     break

                if body.landmarks is not None:
                    # To_do task: reformat the get_measurement para, passed in self.state only
                    '''
                    example: if you want hip abduction use: state = "hip_abduction"
                    '''
                    result = body.get_measurement(self.state, "abduction")
                    y_coord = 50
                    for body_part, measurement in result.items():
                        # Append text to each frame in the top left corner with minimum usage of space on the frame
                        cv2.putText(frame, f"{body_part}: {round(measurement, 5)}", (5, y_coord),
                                    cv2.FONT_HERSHEY_PLAIN, 1.5,
                                    (0, 0, 255), 2)
                        print(f"{body_part}: {measurement}\n")
                        y_coord += 15
                frame = renderer.draw(frame, body)

                await self.send_frame(frame)

                # key = renderer.waitKey(delay=1)
                # if key == ord('q') or key == 27:
                #     break

                # send to results compiler based on exercise
            elif self.state == 'end':
                # TODO: Result compiler code
                
                self.state = 'idle'
            
            key = renderer.waitKey(delay=1)
            if key == ord('q') or key == 27:
                break

        renderer.exit()
        tracker.exit()

if __name__ == "__main__":
    server = OakdProducer(cpu=True)
    ip = "127.0.0.1"
    print(f"Starting server at {ip}:8080")
    asyncio.run(server.serve(ip, 8080))
