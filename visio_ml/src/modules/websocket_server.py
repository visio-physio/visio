import pickle
import asyncio
import websockets
import np
import cv2
import uuid
import warnings
from .constants import EventType, ConnectionSource

class WebSocketServer:
    CAMERAS = {}
    BACKEND = None

    def __init__(self):
        pass

    async def serve(self, host, port):
        async with websockets.serve(lambda ws: self.handler(ws), host, port, max_size=2**22):
            await asyncio.Future()

    async def send_message(self, websocket, message):
        await websocket.send(pickle.dumps(message))

    async def handler(self, websocket):
        while True:
            data = await websocket.recv()
            event = pickle.loads(data)
            print(f"Received event: {event}")
            match event['type']:
                case EventType.Init:
                    id = str(uuid.uuid4())
                    self.CAMERAS[id] = websocket
                    init_event = {
                        'type': EventType.Init,
                        'source': ConnectionSource.Server,
                        'uuid': id
                    }
                    await self.send_message(websocket, init_event)

                case EventType.Frame:
                    frame = np.frombuffer(event['data'], dtype=np.uint8)
                    print(f"Frame parsed: {frame.shape}")

                    cv2.imshow("frame", frame.reshape((720, 1280, 3)))
                    cv2.waitKey(1)

                case _:
                    warnings.warn(f"Unexpected event type: {event['type']}")
