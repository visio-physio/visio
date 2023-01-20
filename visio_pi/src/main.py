import asyncio
from modules.websocket_client import WebSocketClient
from modules.webcam import WebCam

HOST = "127.0.0.1"
PORT = 8001

async def main():
    print(f"Connecting to server on {HOST}:{PORT}")
    websocket_client = WebSocketClient(HOST, PORT)
    await websocket_client.connect()

    camera = WebCam(1, 1)
    camera.initialize_camera()

    while True:
        frame = camera.get_frame()[0:500,0:500]

        print(f"Sending frame")
        await websocket_client.send_message(frame.tobytes())

    await websocket_client.close()

if __name__ == '__main__':
    asyncio.run(main())
