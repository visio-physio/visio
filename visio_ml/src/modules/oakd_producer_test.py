#!/usr/bin/env python

import asyncio
import websockets
import cv2
import base64
import gzip
import json
from concurrent.futures import ProcessPoolExecutor
import os
import argparse
import time

from depthai_blazepose.BlazeposeRenderer import BlazeposeRenderer
from depthai_blazepose.BlazeposeDepthaiEdge import BlazeposeDepthai
from visio_pose import VisioPose, VisioPoseRenderer
from compile_results import ResultCompiler

class OakdProducer():
    def __init__(self, oakd=False):
        self.state = 'idle' # 'produce'
        self.exercise = None
        self.body_part = None
        self.user_id = None
        self.websocket = None
        self.oakd = oakd
        self.result_compilers = {}

        print(f"Running Blazepose model in {'Oak-D' if self.oakd else 'CPU'}")

    async def serve(self, host, port):
        server = await websockets.serve(self.handler, host, port)
        producer_task = asyncio.create_task(self.produce())
        await asyncio.gather(server.serve_forever(), producer_task)
    
    async def handler(self, websocket):
        print("New connection")
        self.websocket = websocket
        async for message in websocket:
            event = json.loads(message)
            self.state = event['state']
            self.exercise = event['exercise']
            self.body_part = event['body_part']
            self.user_id = event['user_id']

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
        if not self.oakd:
            tracker = VisioPose(
                crop=True,
                internal_frame_height=600,
                lm_model='full'
            )
            renderer = VisioPoseRenderer(tracker)
        else:
            tracker = BlazeposeDepthai(
                xyz=True,
                crop=True,
                internal_frame_height=600
            )
            renderer = BlazeposeRenderer(tracker=tracker, show_3d=True)
        

        while True:
            await asyncio.sleep(0.001)

            frame, body = tracker.next_frame()
            if frame is None:
                break
            frame = renderer.draw(frame, body)

            if self.state == 'start':
                if not body.is_body_part_present(self.body_part):
                    cv2.putText(frame, f"{self.body_part} not present", (50, 300),
                                    cv2.FONT_HERSHEY_PLAIN, 2.5,
                                    (0, 0, 255), 2)
                
                if self.user_id not in self.result_compilers or (self.result_compilers[self.user_id].get_exercise(), self.result_compilers[self.user_id].get_body_part()) != (self.exercise, self.body_part):
                    self.result_compilers[self.user_id] = ResultCompiler(self.user_id, self.exercise, self.body_part)

                if body.landmarks is not None:
                    result = body.get_measurement(self.body_part, self.exercise)
                    y_coord = 50
                    for body_part, measurement in result.items():
                        # Append text to each frame in the top left corner with minimum usage of space on the frame
                        cv2.putText(frame, f"{body_part}: {round(measurement, 5)}", (390, y_coord),
                                    cv2.FONT_HERSHEY_PLAIN, 1.5,
                                    (0, 0, 255), 2)
                        # print(f"{body_part}: {measurement}\n")
                        y_coord += 20

                    self.result_compilers[self.user_id].record_angle(result)

                st = time.time()
                await self.send_frame(frame)
                print(f"time: {time.time() - st:.5f}")

            elif self.state == 'end':
                if self.user_id in self.result_compilers:
                    self.result_compilers[self.user_id].store_results_in_firebase()

                self.state = 'idle'
            
            key = renderer.waitKey(delay=1)
            if key == ord('q') or key == 27:
                break
            elif key == ord('s'):
                self.state = 'start'
                self.user_id = time.time()
            elif key == ord('e'):
                self.state = 'end'
            elif key == ord('i'):
                self.state = 'idle'

        renderer.exit()
        tracker.exit()

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('--oakd', action="store_true",
                        help="Set flag to run pose detection in Oak-D")
    
    args = parser.parse_args()
    print(args.oakd)

    server = OakdProducer(oakd=args.oakd)
    ip = "10.33.128.185"
    print(f"Starting server at http://{ip}:8080")
    asyncio.run(server.serve(ip, 8080))
