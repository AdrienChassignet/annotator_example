import QtQuick 2.11

/**
 * MaskEditor to scribble a mask.
 *
 * Feature added by Adrien Chassignet (11/08/2022)
 */
Item {
    id: root

    property int brushWidth: 20
    property var brushColor: Qt.rgba(0, 0, 1, 1)

    Canvas {
        id: drawArea
        anchors.fill: parent
        smooth: false
        // renderTarget: Canvas.FrameBufferObject
        // renderStrategy: Canvas.Threaded

        onPaint: {
            // console.warn(canvasSize, drawArea.width, drawArea.height)
            var context = getContext("2d")
            context.imageSmoothingEnabled = false
            context.lineWidth = brushWidth
            context.strokeStyle = brushColor
            context.moveTo(mouseArea.last_x, mouseArea.last_y)
            context.lineTo(mouseArea.mouseX, mouseArea.mouseY)
            context.stroke()
            mouseArea.last_x = mouseArea.mouseX
            mouseArea.last_y = mouseArea.mouseY
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton

            property var last_x
            property var last_y

            onPressed: {
                last_x = mouse.x
                last_y = mouse.y
            }
            onPositionChanged: {
                if (mouse.x < last_x) {
                    var region_x = mouse.x - brushWidth
                    var width = last_x - mouse.x + 2 * brushWidth
                } else {
                    var region_x = last_x - brushWidth
                    var width = mouse.x - last_x + 2 * brushWidth
                }
                if (mouse.y < last_y) {
                    var region_y = mouse.y - brushWidth
                    var height = last_y - mouse.y + 2 * brushWidth
                } else {
                    var region_y = last_y - brushWidth
                    var height = mouse.y - last_y + 2 * brushWidth
                }
                drawArea.markDirty(Qt.rect(region_x, region_y, width, height))
            }
        }
    }
}
