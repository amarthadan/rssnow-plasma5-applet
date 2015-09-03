import QtQuick 2.1
import QtQuick.Controls 1.4
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.core 2.0 as PlasmaCore

Item{
  width: parent.width
  height: parent.height

  property bool animate: true
  property int numberOfNews
  property int currentNewsNumber
  property var currentNews
  property int movementDuration

  Rectangle{
    anchors.fill: parent
    color: theme.backgroundColor
  }

  Label{
    id: newsText
    anchors.fill: parent
    text: parent.currentNews.title
    wrapMode: Text.WordWrap
  }

  Behavior on x {
    NumberAnimation {
      duration: movementDuration
    }
  }
}

//TODO:
//change design to match old RSSNOW
//states for animation
