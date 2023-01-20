import asyncio
from modules.websocket_server import WebSocketServer

HOST = "127.0.0.1"
PORT = 8001

async def main():
    print(f"Starting server on {HOST}:{PORT}")
    websocket_server = WebSocketServer(HOST, PORT)
    asyncio.create_task(websocket_server.serve())

    while True:
        print("still alive")
        # insert main loop code here
        await asyncio.sleep(10)

if __name__ == "__main__":
    asyncio.run(main())