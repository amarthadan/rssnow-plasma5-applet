import QtQuick 2.1
import QtQuick.XmlListModel 2.0
import QtQuick.Layouts 1.2
import org.kde.plasma.components 2.0 as PlasmaComponents

Row {
  id: feedRow
  width: parent.width

  property var model
  property bool animate: true
  property var news
  property int currentIndex: 0
  property bool isAnimating: false
  property int delayedPrev: 0
  property int delayedNext: 0
  property int animationDuration: 500

  Component.onCompleted: {
    createNewsIfModelLoaded();
  }

  Image{
    id: leftArrow
    width: 14
    height: 14
    anchors.right: parent.right
    anchors.top: parent.top
    //opacity: 0
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
    //opacity: 0
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

  function createNewsIfModelLoaded(){
    if(model.status != XmlListModel.Ready){
      modelLoadTimer.running = true;
    }else{
      var newsComponent = Qt.createComponent("News.qml");
      feedRow.news = newsComponent.createObject(feedRow,
        {"currentNews": feedRow.model.get(currentIndex),
        "movementDuration": getDuration(),
        "animate": feedRow.animate,
        "numberOfNews:": feedRow.model.count,
        "currentNewsNumber": feedRow.currentIndex + 1
      });
    }
  }

  function moveNext(){
    if(isAnimating){
      delayedNext++;
    }else{
      isAnimating = true;
      currentIndex++;
      if(currentIndex == model.count){
        currentIndex = 0;
      }

      var duration =  getDuration();
      var newNews = createNewNews(1, duration);

      news.movementDuration = duration;
      news.x = news.x - news.width;
      newNews.x = newNews.x - newNews.width;

      animation.interval = duration;
      animation.running = true;

      news.destroy(duration);
      news = newNews;
    }
  }

  function movePrev(){
    if(isAnimating){
      delayedPrev++;
    }else{
      isAnimating = true;
      currentIndex--;
      if(currentIndex < 0){
        currentIndex = model.count - 1;
      }

      var duration =  getDuration();
      var newNews = createNewNews(-1, duration);

      news.movementDuration = duration;
      news.x = news.x + news.width;
      newNews.x = newNews.x + newNews.width;

      animation.interval = duration;
      animation.running = true;

      news.destroy(duration);
      news = newNews;
    }
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
    var newNews = newsComponent.createObject(feedRow,
      {"currentNews": feedRow.model.get(currentIndex),
      "x": news.x + (direction * news.width),
      "movementDuration": getDuration(),
      "animate": feedRow.animate,
      "numberOfNews:": feedRow.model.count,
      "currentNewsNumber": feedRow.currentIndex + 1
    });

    return newNews;
  }
}

//TODO:
//add timer for scrolling
//unite move methods
//animate arrows opacity
//clicking on feed should open link
