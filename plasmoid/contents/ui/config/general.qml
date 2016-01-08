import QtQuick 2.0
import QtQuick.Controls 1.4 as QtControls
import QtQuick.Layouts 1.2 as QtLayouts

Item {
  id: generalPage
  width: childrenRect.width
  height: childrenRect.height

  property alias cfg_dropTarget: dropTargetCheckBox.checked
  property alias cfg_logo: logoCheckBox.checked
  property alias cfg_animations: animationsCheckBox.checked
  property alias cfg_lightText: lightTextCheckBox.checked

  property alias cfg_updateInterval: updateInterval.value
  property alias cfg_switchInterval: switchInterval.value

  QtLayouts.ColumnLayout {
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top

    QtControls.GroupBox {
      QtLayouts.Layout.fillWidth: true
      title: i18n("Appearance")
      flat: true

      QtLayouts.ColumnLayout {
        anchors.fill: parent
        QtControls.CheckBox {
          id: dropTargetCheckBox
          text: i18n("Show drop target")
        }

        QtControls.CheckBox {
          id: logoCheckBox
          text: i18n("Show logo")
        }

        QtControls.CheckBox {
          id: animationsCheckBox
          text: i18n("Animations")
        }

        QtControls.CheckBox {
          id: lightTextCheckBox
          text: i18n("Show light text")
        }

      }
    }

    QtControls.GroupBox {
      QtLayouts.Layout.fillWidth: true
      title: i18n("News")
      flat: true

      QtLayouts.ColumnLayout {
        anchors.fill: parent
        QtLayouts.RowLayout {
          QtControls.Label {
            id: intervalLabel
            text: i18n("Update interval:")
          }
          QtControls.SpinBox {
            id: updateInterval
            QtLayouts.Layout.minimumWidth: units.gridUnit * 8
            suffix: " "+i18n("minutes")
            stepSize: 1
          }
        }
        QtLayouts.RowLayout {
          QtControls.Label {
            QtLayouts.Layout.minimumWidth: intervalLabel.width
            text: i18n("Switch interval:")
          }
          QtControls.SpinBox {
            id: switchInterval
            QtLayouts.Layout.minimumWidth: units.gridUnit * 8
            suffix: " "+i18n("seconds")
            stepSize: 1
          }
        }
      }
    }
  }
}
