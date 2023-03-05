#!/usr/bin/env python

import asyncio
import websockets

async def hello():
    uri = "ws://127.0.0.1:8001"
    async with websockets.connect(uri) as websocket:
        await websocket.send('produce')
        print("sent")
        await asyncio.sleep(2)
        await websocket.send('idle')
        print('hello')
        # await websocket.send('idle')


if __name__ == "__main__":
    asyncio.run(hello())