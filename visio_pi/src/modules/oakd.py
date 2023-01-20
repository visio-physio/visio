import depthai as dai
from .camera import Camera

class OakD(Camera):
    def initialize_camera(self):
        pipeline = dai.Pipeline()
        cam_rgb = pipeline.create(dai.node.ColorCamera)
        cam_rgb.setPreviewSize(self.preview_width, self.preview_height)
        cam_rgb.setInterleaved(False)

        xout_rgb = pipeline.create(dai.node.XLinkOut)
        xout_rgb.setStreamName("rgb")
        cam_rgb.preview.link(xout_rgb.input)

        device = dai.Device(pipeline)
        self.q_rgb = device.getOutputQueue("rgb")

    def get_frame(self):
        in_rgb = self.q_rgb.tryGet()
        if in_rgb:
            return in_rgb.getCvFrame()