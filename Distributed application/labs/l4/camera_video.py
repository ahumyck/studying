import os
import cv2
from base_camera import BaseCamera


class Camera(BaseCamera):
    
    
    video_source = "video.mp4"

    @staticmethod
    def frames():
        camera = cv2.VideoCapture(Camera.video_source)

        while True:
            success, image = camera.read()

            if not success:
                camera.release()
                camera = cv2.VideoCapture(Camera.video_source)
                continue

            yield cv2.imencode('.jpg', image)[1].tobytes()
