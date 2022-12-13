import os

from PySide2.QtCore import Qt
from PySide2.QtWidgets import QApplication
from PySide2.QtQml import qmlRegisterType, QQmlApplicationEngine

from palette import PaletteManager
from mask_image import MaskImage

class AnnotatorApp(QApplication):
    """ Label Editor UI Application. """
    def __init__(self):
        QApplication.setAttribute(Qt.AA_EnableHighDpiScaling)

        super(AnnotatorApp, self).__init__()

        self.setOrganizationName('SwissInspect')
        self.setApplicationName('Label Editor')

        font = self.font()
        font.setPointSize(9)
        self.setFont(font)

        # QML engine setup
        pwd = os.path.dirname(__file__)
        qmlDir = os.path.join(pwd, "qml")
        url = os.path.join(qmlDir, "main.qml")

        self.engine = QQmlApplicationEngine()
        self.engine.addImportPath(qmlDir)

        # additional context properties
        self.engine.rootContext().setContextProperty("_PaletteManager", PaletteManager(self.engine, parent=self))
        self.engine.rootContext().setContextProperty("LabelEditorApp", self)

        qmlRegisterType(MaskImage, "MaskHelpers", 1, 0, "MaskImage")

        self.engine.load(os.path.normpath(url))