import QtQuick 2.1
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.2
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.core 2.0 as PlasmaCore

Item{
  id: news
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

    ColumnLayout{
      anchors.fill: parent

      RowLayout{
        Layout.fillHeight: true
        Layout.fillWidth: true

        Image{
          source: "http://www.google.com/s2/favicons?domain=" + news.iconSource
        }

        Label{
          text: "(" + news.numberOfNews + "/" + news.currentNewsNumber + ")"
          wrapMode: Text.WordWrap
          font.bold: true
        }

        Label{
          Layout.fillWidth: true
          text: news.feedTitle
          wrapMode: Text.WordWrap
          font.bold: true
        }
      }

      RowLayout{
        Label{
          Layout.fillHeight: true
          Layout.fillWidth: true
          text: news.currentNews.title
          wrapMode: Text.WordWrap
        }
      }
    }
  }

  Behavior on x {
    NumberAnimation {
      duration: movementDuration
    }
  }
}

//TODO:
//states for animation
//dummy icon when no icon available and while loading
//change feed title to date info on hover
