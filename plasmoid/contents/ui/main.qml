import QtQuick 2.0
import org.kde.draganddrop 2.0 as DragAndDrop
import QtQuick.Layouts 1.2
import "./content"

Item{
  id: mainWindow
  width: 300
  height: 200
  clip: true

  Layout.minimumWidth: 175

  property string sourceList: plasmoid.configuration.feedList
  property var individualSources
  property int updateInterval: plasmoid.configuration.updateInterval
  property int switchInterval: plasmoid.configuration.switchInterval
  property bool showLogo: plasmoid.configuration.logo
  property bool showDropTarget: plasmoid.configuration.dropTarget
  property bool animations: plasmoid.configuration.animations
  property var feeds: []

  Component.onCompleted: {
    splitSourceList();
    setMinimumHeight();
    createFeeds();
  }

  onSourceListChanged: {
    splitSourceList();
    setMinimumHeight();
    deleteFeeds();
    createFeeds();
  }

  onShowLogoChanged: {
    setMinimumHeight();
  }

  ColumnLayout {
    id: feedsLayout
    anchors.fill: parent

    Image{
      id: logoImage
      source: "img/rssnow.svgz"
      width: 192
      height: 100

      states: [
      State {
        name: "show"
        when: showLogo
        PropertyChanges {
          target: logoImage
          visible: true
          height: 100
        }
      },
      State {
        name: "hide"
        when: !showLogo
        PropertyChanges {
          target: logoImage
          visible: false
          height: 0
        }
      }
      ]
    }
  }

  Timer{
    id: switchTimer
    interval: switchInterval * 1000
    running: true
    repeat: true
    onTriggered: switchFeed(0)
  }

  function switchFeed(feedIndex){
    if(feedIndex >= feeds.length){
      return;
    }

    var timerString = 'import QtQuick 2.0;\
    Timer{\
      interval: 200;\
      running: true;\
      repeat: false;\
      onTriggered: moveFeed(' + feedIndex + ');\
    }';
    var timer = Qt.createQmlObject(timerString, mainWindow, "timerDynamic");
    timer.destroy(500);
  }

  function moveFeed(feedIndex){
    feeds[feedIndex].moveNext(true);
    switchFeed(++feedIndex);
  }

  function splitSourceList(){
    individualSources = sourceList.split(',');
  }

  function setMinimumHeight(){
    Layout.minimumHeight = (50 * individualSources.length);
    if(showLogo){
      Layout.minimumHeight = Layout.minimumHeight + 100;
    }
  }

  function createFeeds(){
    for(var i=0; i<individualSources.length; i++){
      var feedString = 'import QtQuick 2.0;\
      import QtQuick.XmlListModel 2.0;\
      import QtQuick.Layouts 1.2;\
      import "./content";\
      Feed{\
        Layout.fillWidth: true;\
        Layout.fillHeight: true;\
        Layout.alignment: Qt.AlignBottom;\
        animate: mainWindow.animations;\
        model: XmlListModel {\
          source: "' + individualSources[i] + '";\
          query: "/rss/channel/item";\
          XmlRole { name: "title"; query: "title/string()" }\
          XmlRole { name: "link"; query: "link/string()" }\
          XmlRole { name: "pubDate"; query: "pubDate/string()"; isKey: true }\
        }\
        titleModel: XmlListModel {\
          source: "' + individualSources[i] + '";\
          query: "/rss/channel";\
          XmlRole { name: "feedTitle"; query: "title/string()" }\
        }\
      }';
      var feed = Qt.createQmlObject(feedString, feedsLayout, "feedDynamic");
      feeds.push(feed);
    }
    switchTimer.running = true;
  }

  function deleteFeeds(){
    switchTimer.running = false;
    for(var i=0; i<feeds.length; i++){
      feeds[i].destroy();
    }
    feeds = [];
  }
}

//TODO:
//add drop target
//update interval for feeds
