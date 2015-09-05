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
  property var iconSource
  property var feedTitle

  Rectangle{
    anchors.fill: parent
    color: theme.backgroundColor
  }

  Image{
    id: icon
    source: "http://www.google.com/s2/favicons?domain=" + iconSource
  }

  Label{
    id: newsText
    anchors.fill: parent
    text: parent.currentNews.title
    wrapMode: Text.WordWrap
  }

  Label{
    id: title
    anchors.fill: parent
    text: parent.feedTitle
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
