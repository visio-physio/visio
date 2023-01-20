import np
import cv2
import asyncio
import websockets

class WebSocketServer:
    CONNECTIONS = set()

    def __init__(self, host, port):
        self.host = host
        self.port = port

    async def serve(self):
        async with websockets.serve(lambda ws: self.handler(ws), self.host, self.port):
            await asyncio.Future()

    async def handler(self, websocket):
        self.CONNECTIONS.add(websocket)
        while True:
            data = await websocket.recv()
            frame = np.frombuffer(data, dtype=np.uint8)
            print(f"Frame parsed: {frame.shape}")

            cv2.imshow("frame", frame.reshape((500, 500, 3)))
            cv2.waitKey(1)

        # put data somewhere for ml to use