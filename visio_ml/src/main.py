import argparse
import asyncio
from modules.oakd_producer import OakdProducer

HOST = "127.0.0.1"
PORT = 8080

def main(host=HOST, port=PORT):
    print(f"Starting server on {HOST}:{PORT}")
    server = OakdProducer()
    asyncio.run(server.serve(HOST, PORT))

if __name__ == "__main__":
    parser = argparse.ArgumentParser(add_help=False)
    parser.add_argument('-h', '--host', required=False)
    parser.add_argument('-p', '--port', required=False)

    argument = parser.parse_args()
    main(argument.host, argument.port)
