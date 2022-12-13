import QtQuick 2.7
import QtQuick.Controls 2.3
import QtQuick.Window 2.3

import Qt.labs.settings 1.0

ApplicationWindow {
    id: _window

    width: settings_General.windowWidth
    height: settings_General.windowHeight
    minimumWidth: 650
    minimumHeight: 500
    visible: true

    title: "Annotation editor"

    // force Application palette assignation
    // note: should be implicit (PySide bug)
    palette: _PaletteManager.palette

    SystemPalette { id: activePalette }
    SystemPalette { id: disabledPalette; colorGroup: SystemPalette.Disabled }

    Settings {
        id: settings_General
        category: 'General'
        property int windowWidth: 1280
        property int windowHeight: 720
    }

    Viewer2D{
        anchors.fill: parent
        source: "../../data/big.JPG"
        mask: "../../data/big_mask.png"
    }
}
