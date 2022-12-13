import os

from PySide2.QtCore import Signal, Property, Qt
from PySide2.QtGui import QImage, QColor, QPen, QPixmap
from PySide2.QtQuick import QQuickPaintedItem

class MaskImage(QQuickPaintedItem):
    """
    QML component to display a mask from filepath.
    """
    def __init__(self, parent=None, filepath=None):
        super(MaskImage, self).__init__(parent)
        # self.setRenderTarget(QQuickPaintedItem.FramebufferObject)

        self._mask = QPixmap(self.size().toSize())
        self._filepath = None
        if filepath is not None:
            self._filepath = os.path.abspath(filepath)
            self.filepathChanged.emit()

    def paint(self, painter):
        if self._mask.isNull():
            return
        painter.setPen(QPen(QColor(255, 0, 0), 1, Qt.SolidLine))
        painter.drawPixmap(self._mask.rect(), self._mask, self._mask.rect())

    def set_filepath(self, filepath):
        """ Update the filepath of the mask image. """
        filepath = filepath.split("://")[-1]
        if filepath != self._filepath:
            self._filepath = filepath
            self.filepathChanged.emit()
            pixmap = QPixmap.fromImage(QImage(filepath)) #TODO: Load QImage in separate thread
            self._mask = pixmap.createMaskFromColor(QColor(255, 255, 255).rgb(), Qt.MaskOutColor)
            self.update()

    # ----- QML signals and properties -----
    filepathChanged = Signal()
    filepath = Property(str, lambda self: self._filepath, set_filepath, notify=filepathChanged)
