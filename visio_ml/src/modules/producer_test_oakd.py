#!/usr/bin/env python

import pickle
import asyncio
import websockets
from concurrent.futures import ProcessPoolExecutor

from depthai_blazepose.BlazeposeRenderer import BlazeposeRenderer
from depthai_blazepose.BlazeposeDepthaiEdge import BlazeposeDepthai

class OakdProducer():
    def __init__(self):
        self.state = 'idle' # 'produce'
        self.websocket = None

    async def serve(self, host, port):
        server = await websockets.serve(self.handler, host, port)
        producer_task = asyncio.create_task(self.produce())
        await asyncio.gather(server.serve_forever(), producer_task)
    
    async def handler(self, websocket):
        self.websocket = websocket
        async for message in websocket:
            self.state = message
        print(f"State updated to: {self.state}")
    
    async def produce(self):
        tracker = BlazeposeDepthai(xyz=True)
        renderer = BlazeposeRenderer(self.tracker, show_3d=False)

        while True:
            if self.state == 'produce':
                frame, body = tracker.next_frame()
                if frame is None:
                    break

                if body is not None:
                    right_shoulder, left_shoulder = body.get_shoulder_angles()
                    print(f"Left: {left_shoulder}, right: {right_shoulder}")

                frame = renderer.draw(frame, body)
                await self.websocket.send(pickle.dumps(frame))

                key = renderer.waitKey(delay=1)
                if key == ord('q') or key == 27:
                    break
        renderer.exit()
        tracker.exit()

if __name__ == "__main__":
    server = OakdProducer()
    asyncio.run(server.serve('127.0.0.1', 8001))
