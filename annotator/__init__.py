from enum import Enum

class Backend(Enum):
    STANDALONE = 1
    PYSIDE = 2

global backend
backend = Backend.PYSIDE