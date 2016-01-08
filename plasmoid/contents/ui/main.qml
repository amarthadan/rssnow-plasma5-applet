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

  property var feeds: []
  property string sourceList: plasmoid.configuration.feedList
  property var sources
  property int updateInterval: plasmoid.configuration.updateInterval
  property int switchInterval: plasmoid.configuration.switchInterval
  property bool showLogo: plasmoid.configuration.logo
  property bool showDropTarget: plasmoid.configuration.dropTarget
  property bool animations: plasmoid.configuration.animations
  property bool userConfiguring: plasmoid.userConfiguring
  property bool lightText: plasmoid.configuration.lightText

  onShowLogoChanged: setMinimumHeight()
  onShowDropTargetChanged: setMinimumHeight()

  Component.onCompleted: {
    sources = sourceList.split(',');
    setMinimumHeight();
    createFeeds();
  }

  onUserConfiguringChanged: {
    if(userConfiguring){
      return;
    }
    var newSources = sourceList.split(',');
    if(!identicalSources(sources, newSources)){
      sources = newSources;
      deleteFeeds();
      createFeeds();
    }
    setMinimumHeight();
  }

  ColumnLayout {
    anchors.fill: parent

    ColumnLayout{
      id: feedsLayout
      Layout.fillWidth: true
      Layout.fillHeight: true

      Image{
        id: logoImage
        source: "img/rssnow.svgz"
        width: 192
        height: 100

        states: [
        State {
          name: "showLogo"
          when: showLogo
          PropertyChanges {
            target: logoImage
            visible: true
            height: 100
          }
        },
        State {
          name: "hideLogo"
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

    DropTarget{
      id: dropTarget
      Layout.fillWidth: true
      height: 50

      DragAndDrop.DropArea {
        anchors.fill: parent
        onDrop: {
          addFeed(event.mimeData.url);
        }
      }

      states: [
      State {
        name: "showDropTarget"
        when: showDropTarget
        PropertyChanges {
          target: dropTarget
          visible: true
          height: 50
        }
      },
      State {
        name: "hideDropTarget"
        when: !showDropTarget
        PropertyChanges {
          target: dropTarget
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

  Timer{
    id: updateTimer
    interval: updateInterval * 60000
    running:true
    repeat: true
    onTriggered: reloadFeeds()
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

  function reloadFeeds(){
    for(var i=0; i<feeds.length; i++){
      feeds[i].model.reload();
      feeds[i].titleModel.reload();
    }
  }

  function moveFeed(feedIndex){
    feeds[feedIndex].moveNext(true);
    switchFeed(++feedIndex);
  }

  function setMinimumHeight(){
    if(typeof sources == 'undefined'){
      return;
    }

    Layout.minimumHeight = (50 * sources.length);
    if(showLogo){
      Layout.minimumHeight = Layout.minimumHeight + 100;
    }
    if(showDropTarget){
      Layout.minimumHeight = Layout.minimumHeight + 50;
    }
  }

  function createFeed(source){
    var feedString = 'import QtQuick 2.0;\
    import QtQuick.XmlListModel 2.0;\
    import QtQuick.Layouts 1.2;\
    import "./content";\
    Feed{\
      Layout.fillWidth: true;\
      Layout.fillHeight: true;\
      animate: mainWindow.animations;\
      lightText: mainWindow.lightText;\
      model: XmlListModel {\
        source: "' + source + '";\
        query: "/rss/channel/item";\
        XmlRole { name: "title"; query: "title/string()" }\
        XmlRole { name: "link"; query: "link/string()" }\
        XmlRole { name: "pubDate"; query: "pubDate/string()"; isKey: true }\
      }\
      titleModel: XmlListModel {\
        source: "' + source + '";\
        query: "/rss/channel";\
        XmlRole { name: "feedTitle"; query: "title/string()"; isKey: true }\
      }\
    }';
    return Qt.createQmlObject(feedString, feedsLayout, "feedDynamic");
  }

  function createFeeds(){
    for(var i=0; i<sources.length; i++){
      var feed = createFeed(sources[i]);
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

  function addFeed(url){
    sources.push(url);
    plasmoid.configuration.feedList = sources.toString();
    setMinimumHeight();
    var feed = createFeed(url);
    feeds.push(feed);

    forceLayoutReload();
  }

  //hack to force layout reloading so newly added feed will be displayed immediately
  function forceLayoutReload(){
    var dummyItemString = 'import QtQuick 2.0;\
    import QtQuick.Layouts 1.2;\
    Item{\
      Layout.fillWidth: true;\
      Layout.fillHeight: true;\
    }';
    var dummyItem = Qt.createQmlObject(dummyItemString, feedsLayout, "dummyItemDynamic");
    dummyItem.destroy(5);
  }

  function identicalSources(oldSources, newSources){
    if(oldSources.length != newSources.length){
      return false;
    }

    for(var i=0; i<oldSources.length; i++){
      if(oldSources[i] != newSources[i]){
        return false;
      }
    }

    return true;
  }
}
