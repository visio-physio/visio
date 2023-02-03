import asyncio
import argparse
from modules.websocket_client import WebSocketClient
from modules.webcam import WebCam

HOST = "127.0.0.1"
PORT = 8001

async def main(host=HOST, port=PORT):
    print(f"Connecting to server on {HOST}:{PORT}")
    websocket_client = WebSocketClient()
    await websocket_client.connect(HOST, PORT)

    camera = WebCam(1, 1)
    camera.initialize_camera()

    await asyncio.gather(
        websocket_client.consumer_handler(),
        websocket_client.producer_handler(camera)
    )

if __name__ == '__main__':
    parser = argparse.ArgumentParser(add_help=False)
    parser.add_argument('-h', '--host', required=False)
    parser.add_argument('-p', '--port', required=False)

    argument = parser.parse_args()

    asyncio.run(main(argument.host, argument.port))
