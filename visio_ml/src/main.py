import argparse
import asyncio
from modules.websocket_server import WebSocketServer

HOST = "127.0.0.1"
PORT = 8001

async def main(host=HOST, port=PORT):
    print(f"Starting server on {HOST}:{PORT}")
    websocket_server = WebSocketServer()
    asyncio.create_task(websocket_server.serve(HOST, PORT))

    while True:
        print("still alive")
        # insert main loop code here
        await asyncio.sleep(10)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(add_help=False)
    parser.add_argument('-h', '--host', required=False)
    parser.add_argument('-p', '--port', required=False)

    argument = parser.parse_args()

    asyncio.run(main(argument.host, argument.port))
