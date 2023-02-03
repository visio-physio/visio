import asyncio
import pickle
import warnings

import websockets
from .constants import EventType, ConnectionSource

class WebSocketClient():
    def __init__(self):
        self.uuid = ''

    async def connect(self, host, port):
        self.ws_server = await websockets.connect(f"ws://{host}:{port}", max_size=2**22)
        init_event = {
            "type": EventType.Init,
            "source": ConnectionSource.Camera
        }
        await self.send_message(init_event)

    async def close(self):
        await self.ws_server.close()

    async def send_message(self, message):
        if (len(self.uuid) > 0):
            message['uuid'] = self.uuid
        await self.ws_server.send(pickle.dumps(message))

    async def consumer_handler(self):
        async for message in self.ws_server:
            event = pickle.loads(message)
            await self.consumer(event)

    async def consumer(self, event):
        print(f"Received event: {event}")
        match event['type']:
            case EventType.Init:
                self.uuid = event['uuid']

            case _:
                warnings.warn(f"Unexpected event type: {event['type']}")

    async def producer_handler(self, camera):
        while True:
            if (len(self.uuid) == 0):
                await asyncio.sleep(1)
                continue
            frame = await self.producer(camera)
            message = {
                'type': EventType.Frame,
                'source': ConnectionSource.Camera,
                'data': frame
            }
            await self.send_message(message)

    async def producer(self, camera):
        frame = camera.get_frame()
        return frame

