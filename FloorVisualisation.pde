import nub.primitives.*;
import nub.core.*;
import nub.processing.*;

import processing.sound.*;

SoundFile buttonSound;

Scene scene;
//group bounding box
int groupWidth = 1280;
int groupHeight = 720;
int groupDepth = 100;

float fov;
// amount of Persons to start the program with
Node avatar;

class SceneManager {
  ArrayList<TimeMapScene> scenes = new ArrayList();
  Scene scene;
  float timeForHourCycleMillis = 1000 * 30/*secs*/;
  TimeSelectScene timeSelect;
  float started = millis();

  SceneManager(Scene scene) {
    this.scene = scene;
  }

  void generateFloorSeries(LocalDateTime time) {

    int i = 0;
    for (i = 0; i < floorInfos.size(); i++) {
      var floorInfo = floorInfos.get(i);
      var data = new TimeMapSceneData(time, SceneType.FLOOR_SERIES, this);

      var floorScene = new TimeMapScene(
        this,
        data,
        groupWidth,
        groupHeight,
        groupDepth,
        groupDepth * -i,
        floorInfo,
        i);
      floorScene.setFocus(i == focusedFloor);
      scenes.add(floorScene);
    }
    generateSlider(1);
  }
  void generateTimeSeries(LocalDate date, int i) {
    var floorInfo = floorInfos.get(i);

    for (var h =0; h < 24; h++) {
      // TODO: MAKE t VARIABLE;

      var data = new TimeMapSceneData(date, SceneType.TIME_SERIES, h+1, floorInfo.getDataEnum(), this);

      var floorScene = new TimeMapScene(
        this,
        data,
        groupWidth,
        groupHeight,
        groupDepth/2,
        (groupDepth/2) * -h,
        floorInfo,
        h
        );

      floorScene.setFocus(false);

      scenes.add(floorScene);
    }
    generateSlider(0.5);
  }
  void showTimeSelect() {
    timeSelect = new TimeSelectScene(this);
    timeSelect.SetButtonSound(buttonSound);
  }


  void clear() {
    for (var scene : scenes) {
      scene.clearPeople();
    }
    scenes.clear();
  }
  int sceneCount() {
    return scenes.size();
  }

  TimeMapScene get(int i) {
    return scenes.get(i);
  }
  int getActiveScene() {
    return slider.floor;
  }

  void update() {
    for (var scene : scenes) {
      scene.sceneData.timeCompleteRatio = ((millis() - started) % timeForHourCycleMillis) / timeForHourCycleMillis;
    }

    if (timeSelect != null) {
      timeSelect.update();
    }
  }

  public void loadVis(LocalDateTime time) {
    started = millis();
    timeSelect.root.detach();
    timeSelect = null;
    textSize(70);
    text("Loading data ... this may take some time!", 0, 300);
    generateFloorSeries(time);
  }

  public void loadVis(LocalDate date, int floorIdx) {
    started = millis();
    timeSelect.root.detach();
    timeSelect = null;
    textSize(70);
    text("Loading data ... this may take some time!", 0, 300);

    generateTimeSeries(date, floorIdx);
  }
}
SceneManager scenes;
//ArrayList<TimeMapScene> timeScenes = new ArrayList();
ArrayList<FloorInfo> floorInfos = new ArrayList();
int focusedFloor = 1;
FloorSlider slider;

void setup() {
  var floorZero = new FloorInfo("00")
    .addSensor(Sensor.PC00_WATTLE, Sensor.PC00_CR04_EAST)
    .addSensor(Sensor.PC00_CR04_EAST, Sensor.PC00_CR04_WEST)
    .addSensor(Sensor.PC00_ST01);

  // floor one has no sensor data
  //var floorOne = new FloorInfo("01")
  //.markPoint(new Vector(300,300));
  //.addRoute(new Route(new Vector(100, 300), new Vector(500, 400)));

  var floorTwo = new FloorInfo("02")
    .addSensor(Sensor.PC02_BROADWAY, Sensor.PC02_JONES);

  //var floorThree = new FloorInfo("03")

  var floorFour = new FloorInfo("04")
    .addSensor(Sensor.PC04_ST18);

  var floorFive = new FloorInfo("05")
    .addSensor(Sensor.PC05_CR07, Sensor.PC05_CR09);
  var floorSix = new FloorInfo("06")
    .addSensor(Sensor.PC06_ST19);

  //var floorSeven = new FloorInfo("07")
  var floorEight = new FloorInfo("08")
    .addSensor(Sensor.PC08_CR10, new Vector[]{ new Vector(-1, 0), new Vector(1, 0) } );

  //.addRoute(new Route(new Vector(220, 250), new Vector(1150, 300), 1.0));
  var floorNine = new FloorInfo("09")
    .addSensor(Sensor.PC09_CR12, Sensor.PC09_CR11)
    .addSensor(Sensor.PC09_CR11, Sensor.PC09_CR14)
    .addSensor(Sensor.PC09_ST21)
    .addSensor(Sensor.PC09_ST22);


  //.addRoute(new Route(new Vector(220, 250), new Vector(1150, 300), 1.0));
  var floorTen = new FloorInfo("10")
    .addSensor(Sensor.PC10_CR09, new Vector[]{ new Vector(-1, 0), new Vector(1, 0)});

  //var floorEleven = new FloorInfo("11")
  //var floorTwelve  = new FloorInfo("12")


  floorInfos.add(floorZero);
  //floorInfos.add(floorOne);
  floorInfos.add(floorTwo);
  //floorInfos.add(floorThree);
  floorInfos.add(floorFour);
  floorInfos.add(floorFive);
  floorInfos.add(floorSix);
  floorInfos.add(floorEight);
  floorInfos.add(floorNine);
  floorInfos.add(floorTen);
  size(1000, 700, P3D);

  scene = new Scene(this, new Vector(groupWidth / 2, groupHeight / 2, groupDepth / 2), 800);
  scenes = new SceneManager(scene);
  fov = scene.fov();
  // HACK: needed for transparency to work.
  scene.disableDepthTest();

  buttonSound = new SoundFile(this, "buttonSound.mp3");
  scenes.showTimeSelect();
  //scenes.generateFloorSeries();
  //generateSlider(1);
  //println(groupDepth * i);
}

void generateSlider(float resize) {
  if (slider != null) {
    slider.rootNode.detach();
  }
  slider = new FloorSlider(scene, -50, 0, (int)(groupDepth * resize), scenes.sceneCount(), focusedFloor, (int)(groupDepth * resize));
}




void draw() {
  background(10, 50, 25);
  ambientLight(128, 128, 128);
  directionalLight(150, 150, 150, 0, 1, -100);
  scenes.update();
  if (slider != null) {
    this.focusedFloor = slider.floor;

    for (var i = 0; i < scenes.sceneCount(); i++) {
      var timeScene = scenes.get(i);
      timeScene.setFocus(i == slider.floor);

      timeScene.display();
    }
  }
  //slider.display();
  scene.render();
  if (slider != null && slider.isActive) slider.calcNewSliderPos();
  //scene.drawAxes();
}



void updateAvatar(Node node) {
  //if (node != avatar) {
  //  avatar = node;
  //  if (avatar != null)
  //    thirdPerson();
  //  else if (scene.eye().reference() != null)
  //    resetEye();
  //}
}


// Resets the eye
void resetEye() {
  scene.eye().resetReference();
  scene.lookAt(scene.center());
  if (avatar != null)
    avatar.setMagnitude(1);
  scene.fit(1000);
}

void mouseClicked() {
  //scene.tag();
  var node = scene.updateTag("click");
  //onNodeClicked(node);
}

void onNodeClicked(Node node) {
  if (node == null) return;

  //scene.interact("click", "clicked");
}

boolean preventInteractions = false;

void mouseReleased() {
  //var node = scene.updateTag("drag");

  //checkSceneInteract(node);
  if (slider != null) slider.isActive = false;

  scene.removeTag("drag");
  preventInteractions = false;
}

void checkSceneInteract(Node node) {
  if (slider != null && node != null && (node.colorID() == slider.railNode.colorID() || node.colorID() == slider.slideNode.colorID())) {
    scene.interact("drag", "dragging");

    preventInteractions = true;
    return;
  }
}

// 'first-person' interaction
void mouseDragged() {
  var node = scene.updateTag("drag");
  //println("node is ", node);
  checkSceneInteract(node);



  if (scene.eye().reference() == null && !preventInteractions) {
    if (mouseButton == LEFT)
      // same as: scene.spin(scene.eye());
      scene.spin();
    else if (mouseButton == RIGHT)
      // same as: scene.translate(scene.eye());
      scene.shift();
    else
      scene.moveForward(mouseX - pmouseX);
  }
}


// highlighting and 'third-person' interaction
void mouseMoved(MouseEvent event) {
  // 1. highlighting
  scene.tag("mouseMoved");
  // 2. third-person interaction
  if (scene.eye().reference() != null)
    // press shift to move the mouse without looking around
    if (!event.isShiftDown())
      scene.lookAround();
}

void mouseWheel(MouseEvent event) {
  // same as: scene.zoom(event.getCount() * 20, scene.eye());
  scene.zoom(event.getCount() * 20);
}

void changeFloor(int amount) {
  if (slider == null) return;
  slider.floor = constrain(slider.floor + amount, 0, scenes.sceneCount() - 1);
}

void keyPressed() {
  switch (keyCode) {
  case UP:
    {
      changeFloor(-1);
      break;
    }
  case DOWN:
    {
      changeFloor(+1);
      break;
    }
  }
  switch (key) {
  case 'p':
    scene.togglePerspective();
    break;
    //case 't':
    //  scenes.clear();
    //  focusedFloor = 1;
    //  scenes.generateTimeSeries(1);
    //  break;
    //case 'f':
    //  scenes.clear();
    //  focusedFloor = 1;
    //  scenes.generateFloorSeries();
    //  break;

  case '[':
  case ']':
    {
      fov += (key == '[' ? -0.1 : 0.1);
      scene.setFOV(fov);
      println("New FOV: ", fov);
      break;
    }
  }
}
