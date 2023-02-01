from enum import Enum

# Keep in sync with EventType in visio_pi/src/modules/constants.py
class EventType(Enum):
    Init = 'init'
    Frame = 'frame'

# Keep in sync with ConnectionSource in visio_pi/src/modules/constants.py
class ConnectionSource(Enum):
    Camera = 'camera'
    Client = 'client'
    Server = 'server'