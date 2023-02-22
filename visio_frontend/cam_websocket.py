import pickle
import asyncio
import cv2
import websockets
import base64
import gzip

async def hello(websocket):
    cap = cv2.VideoCapture(0)
    status = await websocket.recv()
    if status == "start":
        i = 0
        while True:
            ret, frame = cap.read()

            if not ret:
                break
            cv2.imshow("frame", frame)
            key = cv2.waitKey(1)
            
             # Convert the frame to a byte string
            _, buffer = cv2.imencode('.jpg', frame)
            frame_bytes = buffer.tobytes()

            # Compress the frame_bytes
            compressed_frame_bytes = gzip.compress(frame_bytes)

            # Encode the byte string as a base64 string
            frame_base64 = base64.b64encode(compressed_frame_bytes).decode('utf-8')
            # Send the base64 string to the client
            await websocket.send(frame_base64)

            # await websocket.send(pickle.dumps(frame))
            print(f"Sent frame {i}")
            i += 1
            if key == ord('q'):
                break
        cv2.destroyAllWindows()
        cap.release()

            

async def main():

    async with websockets.serve(hello, "localhost", 8080):

        await asyncio.Future()  # run forever


if __name__ == "__main__":

    asyncio.run(main())