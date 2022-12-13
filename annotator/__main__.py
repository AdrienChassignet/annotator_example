import signal
from app import AnnotatorApp

if __name__ == "__main__":
    # meshroom.setupEnvironment()

    signal.signal(signal.SIGINT, signal.SIG_DFL)

    app = AnnotatorApp()
    app.exec_()
