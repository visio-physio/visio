import pickle
import asyncio
import cv2
import websockets
import base64

async def hello(websocket):
    cap = cv2.VideoCapture(0)
    status = await websocket.recv()
    encode_param = [int(cv2.IMWRITE_JPEG_QUALITY), 90]

    if status == "start":
        i = 0
        while True:
            ret, frame = cap.read()

            if not ret:
                break
            cv2.imshow("frame", frame)
            key = cv2.waitKey(1)
            # result, frame = cv2.imencode('.jpg', frame, encode_param)
            
             # Convert the frame to a byte string
            _, buffer = cv2.imencode('.jpg', frame)
            frame_bytes = buffer.tobytes()
            # Encode the byte string as a base64 string
            frame_base64 = base64.b64encode(frame_bytes).decode('utf-8')
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