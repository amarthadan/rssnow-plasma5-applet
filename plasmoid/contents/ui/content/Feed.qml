import QtQuick 2.1
import QtQuick.XmlListModel 2.0
import org.kde.plasma.components 2.0 as PlasmaComponents
import QtQuick.Controls 1.4 as QtControls
import "./HttpHelper.js" as HttpHelper

/*
FIXME
Should not be of type Row because it produces many anchor warnings. But without
the Row type, adding feeds via Drop feed doesn't resize feeds after adding a new
one.
*/
Row {
  id: feed
  width: parent.width

  property var model
  property var titleModel
  property bool animate: true
  property var news
  property int currentIndex: 0
  property bool isAnimating: false
  property int delayedPrev: 0
  property int delayedNext: 0
  property int animationDuration: 500
  property bool lightText: false
  property var hovered: false
  property var iconSource

  onAnimateChanged: {
    news.animate = animate
  }

  Component.onCompleted: {
    loadIcon();
    createNewsIfModelLoaded();
  }

  QtControls.BusyIndicator {
    id: indicator
    anchors.fill: parent
    running: true
  }

  Image{
    id: leftArrow
    width: 14
    height: 14
    anchors.right: parent.right
    anchors.top: parent.top
    opacity: 0
    z: 42
    Behavior on opacity { PropertyAnimation {} }
    source: "../img/arrows.svgz"
    MouseArea {
      anchors.fill: parent
      onClicked: moveNext();
    }
  }

  Image{
    id: rightArrow
    width: 14
    height: 14
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    opacity: 0
    z: 42
    Behavior on opacity { PropertyAnimation {} }
    source: "../img/arrows.svgz"
    transform: Rotation { origin.x: 7; origin.y: 7; axis { x: 0; y: 0; z: 1 } angle: 180 }
    MouseArea {
      anchors.fill: parent
      onClicked: movePrev();
    }
  }

  MouseArea {
    anchors.fill: parent
    hoverEnabled: true
    onWheel: {
      if (wheel.angleDelta.y < 0){
        //down
        moveNext();
      }
      else{
        //up
        movePrev();
      }
    }
    onClicked: {
      Qt.openUrlExternally(parent.model.get(currentIndex).link);
    }
    onEntered: {
      news.feedTitleToFuzzyDate();
      hovered = true;
      rightArrow.opacity = 1;
      leftArrow.opacity = 1;
    }
    onExited: {
      news.feedTitleToFeedTitle();
      hovered = false;
      rightArrow.opacity = 0;
      leftArrow.opacity = 0;
    }
  }

  Timer{
    id: modelLoadTimer
    interval: 1000
    running: false
    repeat: false
    onTriggered: createNewsIfModelLoaded()
  }

  Timer {
    id: nextTimer
    interval: 50
    running: false
    repeat: false
    onTriggered: moveNext()
  }

  Timer {
    id: prevTimer
    interval: 50
    running: false
    repeat: false
    onTriggered: movePrev()
  }

  Timer {
    id: animation
    running: false
    repeat: false
    onTriggered: animationComplete()
  }

  function getDuration(){
    return animationDuration/(Math.max(delayedPrev+1, delayedNext+1));
  }

  function getFontColor(){
    if (lightText){
      dropTarget.dropTitle.color = "lightgray"
      dropTarget.dropText.color = "lightgray"
      return "lightgray"
    } else {
      return "black"
    }
  }

  function createNewsIfModelLoaded(){
    if(!feedReady()){
      modelLoadTimer.running = true;
      return;
    }

    indicator.running = false;

    var newsComponent = Qt.createComponent("News.qml");
    feed.news = newsComponent.createObject(feed,
      {"currentNews": feed.model.get(currentIndex),
      "movementDuration": getDuration(),
      "animate": feed.animate,
      "numberOfNews": feed.model.count,
      "currentNewsNumber": feed.currentIndex + 1,
      "iconSource": feed.iconSource,
      "feedTitle": feed.titleModel.get(0).feedTitle,
      "feedColor": getFontColor()
    });

  }

  function feedReady(){
    return (model.status == XmlListModel.Ready && titleModel.status == XmlListModel.Ready && typeof iconSource !== 'undefined')
  }

  function moveNext(timerSwitch){
    timerSwitch = typeof timerSwitch !== 'undefined' ? timerSwitch : false;

    if(isAnimating){
      if(!timerSwitch){
        delayedNext++;
      }
      return;
    }

    if(hovered && timerSwitch){
      return;
    }

    isAnimating = true;
    currentIndex++;
    if(currentIndex == model.count){
      currentIndex = 0;
    }

    move(1);
  }

  function movePrev(){
    if(isAnimating){
      delayedPrev++;
      return;
    }

    isAnimating = true;
    currentIndex--;
    if(currentIndex < 0){
      currentIndex = model.count - 1;
    }

    move(-1);
  }

  function move(direction){
    var duration =  getDuration();
    var newNews = createNewNews(direction, duration);

    news.movementDuration = duration;
    news.x = news.x - (direction * news.width);
    newNews.x = newNews.x - (direction * newNews.width);

    animation.interval = duration;
    animation.running = true;

    news.destroy(duration);
    news = newNews;
  }

  function animationComplete(){
    isAnimating = false;
    if(delayedNext > 0){
      delayedPrev = 0;
      delayedNext--;
      nextTimer.running = true;
    }else if(delayedPrev > 0){
      delayedPrev--;
      prevTimer.running = true;
    }
  }

  function createNewNews(direction, duration){
    var newsComponent = Qt.createComponent("News.qml");
    var newNews = newsComponent.createObject(feed,
      {"currentNews": feed.model.get(currentIndex),
      "x": news.x + (direction * news.width),
      "movementDuration": getDuration(),
      "animate": feed.animate,
      "numberOfNews": feed.model.count,
      "currentNewsNumber": feed.currentIndex + 1,
      "iconSource": feed.iconSource,
      "feedTitle": feed.titleModel.get(0).feedTitle,
      "feedColor": getFontColor()
    });


    if(hovered){
      newNews.feedTitleToFuzzyDate();
    }

    return newNews;
  }

  function loadIcon(){
    var closure = function(xhr) {
      return function() {
        onLoadIconResponse(xhr);
      }
    };

    var xhr = new XMLHttpRequest();
    xhr.onreadystatechange = closure(xhr);
    xhr.open("GET", HttpHelper.host(feed.model.source + ""), true); //have to convert url to string
    xhr.send();
  }

  function onLoadIconResponse(xhr) {
    if (xhr.readyState === XMLHttpRequest.DONE) {
      iconSource = HttpHelper.favIcon(xhr.responseText);
    }
  }
}
