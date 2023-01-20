import asyncio
import websockets

class WebSocketClient():
    def __init__(self, host, port):
        self.host = host
        self.port = port

    async def connect(self):
        self.websocket = await websockets.connect(f"ws://{self.host}:{self.port}")

    async def close(self):
        await self.websocket.close()

    async def send_message(self, message):
        await self.websocket.send(message)

