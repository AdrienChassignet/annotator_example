import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.12

import MaskHelpers 1.0

FocusScope {
    id: root

    clip: true

    property url source
    property url mask

    property string loadingModules: {
        if(!imgContainer.image)
            return "";
        var res = "";
        if(imgContainer.image.status === Image.Loading)
            res += "Image";
        return res;
    }

    function clear()
    {
        source = ''
        metadata = {}
    }

    // slots
    Keys.onPressed: {
        if(event.key == Qt.Key_F) {
            root.fit();
            event.accepted = true;
        }
    }

    // mouse area
    MouseArea {
        anchors.fill: parent
        property double factor: 1.2
        acceptedButtons: Qt.RightButton | Qt.MiddleButton //Qt.LeftButton | 
        onPressed: {
            imgContainer.forceActiveFocus()
            if(mouse.button & Qt.MiddleButton)// || (mouse.button & Qt.LeftButton && mouse.modifiers & Qt.ShiftModifier))
                drag.target = imgContainer // start drag
        }
        onReleased: {
            drag.target = undefined // stop drag
            if(mouse.button & Qt.RightButton) {
                var menu = contextMenu.createObject(root);
                menu.x = mouse.x;
                menu.y = mouse.y;
                menu.open()
            }
        }
        onWheel: {
            var zoomFactor = wheel.angleDelta.y > 0 ? factor : 1/factor
            if(Math.min(imgContainer.width, imgContainer.image.height) * imgContainer.scale * zoomFactor < 10)
                return
            var point = mapToItem(imgContainer, wheel.x, wheel.y)
            imgContainer.x += (1-zoomFactor) * point.x * imgContainer.scale
            imgContainer.y += (1-zoomFactor) * point.y * imgContainer.scale
            imgContainer.scale *= zoomFactor
        }
    }

    // functions
    function fit() {
        if(imgContainer.image.status != Image.Ready)
            return;
        imgContainer.scale = Math.min(imgLayout.width / imgContainer.image.width, root.height / imgContainer.image.height)
        imgContainer.x = Math.max((imgLayout.width - imgContainer.image.width * imgContainer.scale)*0.5, 0)
        imgContainer.y = Math.max((imgLayout.height - imgContainer.image.height * imgContainer.scale)*0.5, 0)
        // console.warn("fit: imgLayout.width: " + imgContainer.scale + ", imgContainer.image.width: " + imgContainer.image.width)
        // console.warn("fit: imgContainer.scale: " + imgContainer.scale + ", x: " + imgContainer.x + ", y: " + imgContainer.y)
    }

    // context menu
    property Component contextMenu: Menu {
        MenuItem {
            text: "Fit"
            onTriggered: fit()
        }
        MenuItem {
            text: "Zoom 100%"
            onTriggered: {
                imgContainer.scale = 1
                imgContainer.x = Math.max((imgLayout.width-imgContainer.width*imgContainer.scale)*0.5, 0)
                imgContainer.y = Math.max((imgLayout.height-imgContainer.height*imgContainer.scale)*0.5, 0)
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent

        // Image
        Item {
            id: imgLayout
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            Item {
                id: imgContainer
                transformOrigin: Item.TopLeft

                // Simple QML Image Viewer (using Qt or qtOIIO to load images)
                Loader {
                    id: qtImageViewerLoader
                    active: true
                    anchors.centerIn: parent
                    sourceComponent: Image {
                        id: qtImageViewer
                        asynchronous: true
                        smooth: false
                        fillMode: Image.PreserveAspectFit
                        autoTransform: true
                        onWidthChanged: if(status==Image.Ready) fit()
                        source: root.source
                        onStatusChanged: {
                            // update cache source when image is loaded
                            if(status === Image.Ready)
                                qtImageViewerCache.source = source
                        }

                        MaskImage {
                            id: mask
                            anchors.fill: parent
                            filepath: root.mask
                            opacity: 0.5
                            smooth: false
                        }

                        MaskEditor {
                            anchors.fill: parent
                            smooth: false
                        }

                        // Image cache of the last loaded image
                        // Only visible when the main one is loading, to maintain a displayed image for smoother transitions
                        Image {
                            id: qtImageViewerCache

                            anchors.fill: parent
                            asynchronous: true
                            smooth: parent.smooth
                            fillMode: parent.fillMode
                            autoTransform: parent.autoTransform

                            visible: qtImageViewer.status === Image.Loading
                        }
                    }
                }

                property var image: qtImageViewerLoader.item // qtImageViewerLoader.active ? qtImageViewerLoader.item : floatImageViewerLoader.item
                width: image ? image.width : 1
                height: image ? image.height : 1
                scale: 1.0
            }
        }
    }

    // Busy indicator
    BusyIndicator {
        anchors.centerIn: parent
        // running property binding seems broken, only dynamic binding assignment works
        Component.onCompleted: {
            running = Qt.binding(function() { return imgContainer.image && imgContainer.image.status === Image.Loading })
        }
        // disable the visibility when unused to avoid stealing the mouseEvent to the image color picker
        visible: running
    }
}
