import QtQuick 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.draganddrop 2.0 as DragAndDrop
import QtQuick.XmlListModel 2.0
import "./content"

Item{
  id: mainWindow
  width: 300
  height: 200
  clip: true

  property string sourceList: plasmoid.configuration.feedList
  property var individualSources
  property int updateInterval: plasmoid.configuration.updateInterval
  property int switchInterval: plasmoid.configuration.switchInterval
  property bool showLogo: plasmoid.configuration.logo
  property bool showDropTarget: plasmoid.configuration.dropTarget
  property bool animations: plasmoid.configuration.animations

  Component.onCompleted: {
    individualSources = sourceList.split(',');
  }

  Column {
    id: feeds
    anchors.fill: parent

    Image{
      id: logoImage
      source: "img/rssnow.svgz"
      width: sourceSize.width / 1.5
      height: sourceSize.height / 1.5

      states: [
      State {
        name: "show"
        when: showLogo
        PropertyChanges {
          target: logoImage
          visible: true
        }
      },
      State {
        name: "hide"
        when: !showLogo
        PropertyChanges {
          target: logoImage
          visible: false
        }
      }
      ]
    }

    Repeater {
      id: repeater
      model: individualSources

      Feed{
        height: (feeds.height - logoImage.height)/mainWindow.individualSources.length
        animate: mainWindow.animations
        model: XmlListModel {
          source: modelData
          query: "/rss/channel/item"

          XmlRole { name: "title"; query: "title/string()" }
          XmlRole { name: "description"; query: "fn:replace(description/string(), '\&lt;a href=.*\/a\&gt;', '')" }
          XmlRole { name: "link"; query: "link/string()" }
          XmlRole { name: "pubDate"; query: "pubDate/string()" }
        }

        Timer{
          id: switchTimer
          interval: switchInterval * 1000
          running: true
          repeat: true
          onTriggered: moveNext()
        }
      }
    }
  }
}

//TODO:
//add drop target
