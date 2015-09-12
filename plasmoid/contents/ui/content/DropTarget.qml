import QtQuick 2.1
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.2
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.core 2.0 as PlasmaCore

Item{
  id: dropTarget

  Rectangle{
    anchors.fill: parent
    color: theme.backgroundColor
    clip: true

    RowLayout{
      anchors.fill: parent

      PlasmaCore.IconItem {
        Layout.fillHeight: true
        source: "akregator"
      }

      ColumnLayout{
        Layout.fillHeight: true
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignVCenter

        Label{
          Layout.fillWidth: true
          text: "Drop a feed here..."
          wrapMode: Text.WordWrap
          font.bold: true
        }

        Label{
          Layout.fillWidth: true
          text: "...to add one more entry!"
          wrapMode: Text.WordWrap
        }
      }
    }
  }
}
