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
    clip: true

    ColumnLayout{
      anchors.fill: parent

      RowLayout{
        Layout.fillHeight: true
        Layout.fillWidth: true

        Image{
          source: news.iconSource
          height: 16
          width: 16
        }

        Label{
          text: "(" + news.currentNewsNumber + "/" + news.numberOfNews + ")"
          wrapMode: Text.WordWrap
          font.bold: true
        }

        Label{
          id: feedTitle
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
      id: moveAnimation
      duration: movementDuration
    }
  }

  states: [
  State {
    name: "animate"
    when: animate
    PropertyChanges {
      target: moveAnimation
      duration: movementDuration
    }
  },
  State {
    name: "dontAnimate"
    when: !animate
    PropertyChanges {
      target: moveAnimation
      duration: 0
    }
  }
  ]

  function feedTitleToFuzzyDate(){
    var dateString = currentNews.pubDate.substring(0, currentNews.pubDate.lastIndexOf(" "));
    feedTitle.text = dateToFuzzyDate(Date.fromLocaleString(Qt.locale("en"), dateString, "ddd, dd MMM yyyy hh:mm:ss"));
  }

  function feedTitleToFeedTitle(){
    feedTitle.text = news.feedTitle;
  }

  function dateToFuzzyDate(date){
    var nowDate = new Date()
    var nowMS = nowDate.getTime();
    var dateMS = date.getTime();

    nowDate.setMilliseconds(0);
    nowDate.setSeconds(0);
    nowDate.setMinutes(0);
    nowDate.setHours(0);
    date.setMilliseconds(0);
    date.setSeconds(0);
    date.setMinutes(0);
    date.setHours(0);

    if (nowMS < (dateMS + 3600000)) {
      return i18np("%1 minute ago", "%1 minutes ago", (Math.floor((nowMS - dateMS)/60000)));
    } else if (+nowDate === +date.setDate(date.getDate() + 1)) {
      return i18n("yesterday");
    } else if (nowDate < date) {
      return i18np("%1 hour ago", "%1 hours ago", (Math.floor((nowMS - dateMS)/3600000)));
    } else if (nowDate < date.setDate(date.getDate() + 6)) {
      return i18np("%1 day ago", "%1 days ago", (Math.floor((nowMS - dateMS)/86400000)));
    } else {
      return i18np("%1 week ago", "%1 weeks ago", (Math.floor((nowMS - dateMS)/604800000)));
    }
  }
}
