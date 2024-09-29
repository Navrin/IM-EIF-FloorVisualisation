import nub.primitives.*;
import nub.core.*;
import nub.processing.*;

class Route {
  Vector start, end;
  float weight;

  Route(Vector start, Vector end) {
    this.start = start;
    this.end = end;
    this.weight = 1.0;
  }

  Route(Vector start, Vector end, float weight) {
    this.start = start;
    this.end = end;
    this.weight = weight;
  }

  Route flippedRoute() {
    return new Route(this.end.copy(), this.start.copy(), this.weight);
  }
}


class TimeMapSceneData {
  LocalDateTime startTime;
  int hour = -1;
  SceneType type;
  /**
  * Should be controlled by the scene manager
  */
  SceneDataLoader loader;

  public float timeCompleteRatio = 0;

  TimeMapSceneData(LocalDateTime t, SceneType type, Floor floor, SceneManager manager) {
    startTime = t;
    this.type = type;
    this.loader = new SceneDataLoader(startTime, startTime.plusHours(1), floor, manager.scene);
  }

  TimeMapSceneData(LocalDate t, SceneType type, int hour, Floor floor, SceneManager manager) {
    startTime = t.atTime(hour-1,0);
    this.type = type;
    this.hour= hour;
    this.loader = new SceneDataLoader(t, floor, manager.scene);
  }

  boolean isTimeSeries() {
    return type == SceneType.TIME_SERIES;
  }
}

class TimeMapScene {
  int width, height, depth, depthOffset;
  PImage background;
  float spawnDelay = 1000;
  float maxSpawnBatch = 10;
  int maxSpawnForRoute = 50;

  /**
   * ! Controls how many people should spawn from API values.
   */
  float intensityMultiplier = 1.5;

  /**
   * ! Controls the velocity / distance of singular sensor routes
   */
  float singularRouteDistance = 130;
  
  /**
  * ! Controls the speed/velocity of people in the group
  */

  float lastPersonSpawn;
  ArrayList<Person> group;
  ArrayList<Route> routes = new ArrayList();
  Node node;
  Scene sceneRef;
  boolean isFocus = false;
  FloorInfo floor;
  //boolean isTimeSeries = false;
  //int hour = -1;
  SceneManager sceneManager;
  TimeMapSceneData sceneData;

  int layerPos;

  SceneDataLoader dataSource;

  TimeMapScene(
    SceneManager sceneManager,
    TimeMapSceneData sceneData,
    int w,
    int h,
    int d,
    int dOffset,
    FloorInfo floorInfo,
    int layerPos

    )
  {
    this.sceneManager = sceneManager;
    this.sceneData = sceneData;
    this.sceneRef = this.sceneManager.scene;
    this.floor = floorInfo;
    this.layerPos = layerPos;
    lastPersonSpawn = millis();
    width = w;
    height = h;
    depth = d;
    depthOffset = dOffset;
    background = this.floor.map;
    group = new ArrayList();
    node = new Node();
    node.translate(0, 0, dOffset);
    routes = floorInfo.routes;

    calculateAndSpawnPeople();
    //for (int i = 0; i < (maxSpawnBatch); i++) {
    //  for (var route : routes) {
    //    addPerson(route, random(0.0, 1.0) > 0.5);
    //  }
    //}
  }

  void calculateAndSpawnPeople() {
    //println("running spawn, currently at group n = "+group.size());
    //println(this.floor.sensorPairs);
    for (var paired : this.floor.sensorPairs) {

      spawnPeopleForPairedRoute(paired, false);
      spawnPeopleForPairedRoute(paired, true);

    }

    for (var single : this.floor.sensorSingulars) {
      if (single.radial) {
        spawnRadialPeople(single);
      } else {
        spawnSingular(single); 
      }
    }
  }

  void spawnPeopleForPairedRoute(SensorPair paired, boolean flip) { //<>// //<>//
    // this should always be IN/OUT for paired sensors
    var pointA = flip ? paired.pointB : paired.pointA;
    var pointB = flip ? paired.pointA : paired.pointB;
 //<>// //<>//
    var directions = pointA.getDirectionsForSensor();
        //println("adding new person", directions);

    for (var dir : directions) {

      var data = this.sceneData.loader.estimateValue(
        pointA,
        dir,
        sceneData.startTime.plusMinutes((long)(sceneData.timeCompleteRatio * 60))
      );
      
      var dataOpp =this.sceneData.loader.estimateValue(
        pointB,
        dir.getAntiDirection(),
        sceneData.startTime.plusMinutes((long)(sceneData.timeCompleteRatio * 60))
      );
      


      var intensity = (data + dataOpp) / 2;
      var peopleBatch = round(intensity * this.intensityMultiplier);
      //println("Intensity = ", intensity, "time=", 
      //    sceneData.startTime.plusMinutes((long)(sceneData.timeCompleteRatio * 60)),
      //    "modif =", sceneData.timeCompleteRatio);
          
      for (var i = 0; i < constrain(peopleBatch, 0, maxSpawnForRoute - this.group.size()); i++) {
       
        addPerson(new Route(pointA.toMapPosition(), pointB.toMapPosition()));
      }
    }
  }

  void spawnRadialPeople(SensorSingular sensor) {
    // this should always be UP/DOWN for stair sensors
    var directions = sensor.point.getDirectionsForSensor();

    for (var dir : directions) {
      var data = this.sceneData.loader.estimateValue(
        sensor.point,
        dir,
        sceneData.startTime.plusMinutes((long)(sceneData.timeCompleteRatio * 60))
      );

      var intensity = (data) ;
      var peopleBatch = round(intensity * this.intensityMultiplier);

      for (var i = 0; i <  min(maxSpawnForRoute - this.group.size(), peopleBatch); i++) {
        var ratio = (float)i / (float)peopleBatch;
        var xDir = sin(ratio * 2 * PI) * singularRouteDistance;
        var yDir = cos(ratio * 2 * PI) * singularRouteDistance;

        Vector pointMapPos = sensor.point.toMapPosition();
        var radial = new Vector(pointMapPos.x() + xDir, pointMapPos.y() + yDir);

        var a = dir == Direction.UP ? pointMapPos : radial;
        var b = dir == Direction.UP ? radial : pointMapPos;

        addPerson(new PersonParameterBuilder(new Route(a, b))
          .setEntryFadeDistance(100)
          .setExitFadeDistance(singularRouteDistance * 0.4)
        
        );
      }
    }
  }

  void spawnSingular(SensorSingular sensor) {
    // !!!!! NEED DATA !!!!!!

    // this should always be IN/OUT for singular sensors
    var directions = sensor.point.getDirectionsForSensor();

    for (var dir : directions) {
      var data = this.sceneData.loader.estimateValue(
        sensor.point,
        dir,
        sceneData.startTime.plusMinutes((long)(sceneData.timeCompleteRatio * 60))
      );

      var intensity = data;
      var peopleBatch = round((intensity * this.intensityMultiplier) / 2);
      Vector pointMapPos = sensor.point.toMapPosition();

      for (var vec : sensor.routes) {
        for (var i = 0; i <  min(maxSpawnForRoute - this.group.size(), peopleBatch); i++) {

          var xDir = vec.x() * singularRouteDistance;
          var yDir = vec.y() * singularRouteDistance;

          var endPos = new Vector(pointMapPos.x() + xDir, pointMapPos.y() + yDir);


          addPerson(new Route(pointMapPos, endPos));
        }
      }
    }
  }


  //void setTimeSeries(int hour) {
  //  this.isTimeSeries = true;
  //  this.hour = hour;

  void setFocus(boolean isFocused) {
    this.isFocus = isFocused;
  }

  void addRoute(Route route) {
    routes.add(route);
  }

  void markFailedSensors() {
    for (var sensor : this.sceneData.loader.failedNodes) {
      pushStyle();
      strokeWeight(2);
      stroke(255, 0, 0, getAlpha() / 2);
      var pos = sensor.toMapPosition();
      line(pos.x() - 10, pos.y() + 10, pos.x() + 10, pos.y() + 10);
      line(pos.x() - 10, pos.y() - 10 , pos.x() + 10, pos.y() -10);

      popStyle();

    }
  }
  void markRoutes()
  {
    for (var route : routes) {
      pushStyle();
      strokeWeight(2);
      stroke(255, 0, 0, getAlpha() / 2);
      line(route.start.x(), route.start.y(), route.end.x(), route.end.y());
      popStyle();
    }

    for (var point : floor.markPoint)
    {
      pushStyle();
      strokeWeight(2);
      stroke(255, 0, 0, getAlpha() / 2);
      circle(point.x(), point.y(), 10);
      popStyle();
    }
  }

  void display() {
    //scene.openContext();
    pushMatrix();
    hint(DISABLE_DEPTH_TEST);

    translate(0.0, 0.0, depthOffset);
    drawBounds();

    var peopleCount = group.size();

    for (var i = 0; i < group.size(); i++) {
      var person = group.get(i);
    person.setTint(getAlpha() / (255.0 / 4));
      if (person.hasExited) {
        group.remove(i);
      }
    }
    if (abs(millis() - lastPersonSpawn) > spawnDelay) {
      lastPersonSpawn = millis();

      // !!!!!ADD SPAWN!!!!!
      calculateAndSpawnPeople();
      //for (var i =0; i < min(maxSpawnForRoute - peopleCount, 5); i++) {
      //  for (var route : routes) {
      //    addPerson(route, random(0.0, 1.0) > 0.5);
      //  }
      //  //addPerson(true);
      //}
    }
    markRoutes();
    markFailedSensors();
    popMatrix();
  }

  float calcAlphaScaling() {
    return 1/constrain(abs(scenes.getActiveScene() - layerPos) / 5.0, 0.0, 1.0);
  }

  int getAlpha() {
    if (this.sceneData.isTimeSeries())
      return this.isFocus ? 240 : 30;
    return this.isFocus ? 230 : 50;
  }

  void drawBounds() {
    pushStyle();
    noFill();
    stroke(255, 255, 0, getAlpha());
    //var depth = this.depth + this.depthOffset;

    beginShape();

    if (abs(scenes.getActiveScene() - layerPos) < 5) {


      texture(background);
      tint(255, getAlpha() * (this.sceneData.isTimeSeries() ?calcAlphaScaling() : 1) );

      vertex(0, 0, 0, 0, 0);
      vertex(width, 0, 0, background.width, 0);
      vertex(width, height, 0, background.width, background.height);
      vertex(0, height, 0, 0, background.height);

      endShape();
    }
    // back left line
    line(0, 0, 0, 0, height, 0);
    // front left line
    line(0, 0, depth, 0, height, depth);
    // back top line
    line(0, 0, 0, width, 0, 0);
    //front top line 
    line(0, 0, depth, width, 0, depth);
    // uhh  not sure
    line(width, 0, 0, width, height, 0);
    
    // front right line
    line(width, 0, depth, width, height, depth);
    
    // also unknown
    line(0, height, 0, width, height, 0);
    
    // front bottom line
    line(0, height, depth, width, height, depth);
    
    line(0, 0, 0, 0, 0, depth);
    line(0, height, 0, 0, height, depth);
    line(width, 0, 0, width, 0, depth);
    line(width, height, 0, width, height, depth);

    pushStyle();
    strokeWeight(5);
      stroke(255, 0, 0, getAlpha());
      line(0, 0, depth, width * constrain((this.sceneData.timeCompleteRatio - (0.25 * 0)) * 4, 0.0,  1.0), 0, depth);
      line(width, 0, depth, width, 
        height 
        * constrain((this.sceneData.timeCompleteRatio - (0.25 * 1)) * 4, 0.0,  1.0), 
        depth);
      line(
        width, 
        height, 
        depth, 
        width - (width * constrain((this.sceneData.timeCompleteRatio - (0.25 * 2)) * 4, 0.0,  1.0)), 
        height, 
        depth);
    
    line(
      0, 
      height, 
      depth, 
      0, 
      height - (height * constrain((this.sceneData.timeCompleteRatio - (0.25 * 3)) * 4, 0.0,  1.0)) , 
      depth);


    popStyle();
    textSize(70);
    fill(255, 255, 255, getAlpha());
    text("Floor " + floor.name, 30, 70, depth);

    if (sceneData.hour > -1) {
      var hour = sceneData.hour;
      var hour12 = (hour-1) % 12;
      text((hour12 == 0 ? 12 : hour12) + " " + (hour >= 12 ? "pm":"am"), 30, 110, depth);
    }
    popStyle();
  }

  class PersonParameterBuilder {
    Route route;
    float minSpeed =1;
    float maxSpeed=2;
    float minAccel=-0.03;
    float maxAccel=1.3;
    float exitFadeDistance = 150;
    float entryFadeDistance = 200;
    
    PersonParameterBuilder(Route r) {
      route = r; 
      minSpeed = 1;
      maxSpeed = 2;
      minAccel = -0.03;
      maxAccel = 1.3; 
    }
    
    PersonParameterBuilder setMinSpeed(float newMinSpeed) {
      this.minSpeed = newMinSpeed;
      return this;
    }

    PersonParameterBuilder setMaxSpeed(float newMaxSpeed) {
        this.maxSpeed = newMaxSpeed;
        return this; 
    }
    PersonParameterBuilder setMinAccel(float newMinAccel) {
        this.minAccel = newMinAccel;
        return this;
    }
    PersonParameterBuilder setMaxAccel(float newMaxAccel) {
        this.maxAccel = newMaxAccel;
        return this;
    }
    PersonParameterBuilder setExitFadeDistance(float newExitFadeDistance) {
      this.exitFadeDistance = newExitFadeDistance;
      return this;
    }
    PersonParameterBuilder setEntryFadeDistance(float newEntryFadeDistance) {
      this.entryFadeDistance = newEntryFadeDistance;
      return this;
    }
  }
  
  void addPerson(Route route) {
    addPerson(new PersonParameterBuilder(route));
  }
  
  void addPerson(PersonParameterBuilder params) {
    //println("Addperson called");
    var route = params.route;

    var jitter = random(-25, 25);
    var jitterB = random(-30, 30);
    var speed = random(params.minSpeed, params.maxSpeed);
    var acceleration = random(params.minAccel, params.maxAccel);
    // 100, 350
    // 1150, 300

    var a = new Vector(route.start.x() + jitter, route.start.y() + jitterB);
    var b = route.end;

    var person = new Person(
      this,
      a,
      b,
      speed,
      acceleration,
      params.entryFadeDistance,
      params.exitFadeDistance
      );
    //if (!flip) println(person.towardsAngle);
    person.setTint(getAlpha() / (255.0 / 4));

    group.add(person);

  }
  
  public void clearPeople() {
    for (var person : group) {
      person.hasExited = true;
      person.node.detach();
    }
    group.clear();
  }
  
  public Vector getAveragedPeopleScreenPositions() {
    var x = 0.0;
    var y = 0.0;
    // var z = 0.0;

    for (var person : group) {
      var pos = sceneManager.scene.screenLocation(person.node.worldPosition());
      x += pos.x();
      y += pos.y();
      // z += pos.z();
    }

    if (group.size() > 0) {
      x /= group.size();
      y /= group.size();
      // z /= group.size();

      return new Vector(x, y);
    } else {
      return new Vector(0,0);
    }
  }

    public Vector getAveragedPositions() {
    var x = 0.0;
    var y = 0.0;
    var z = 0.0;

    for (var person : group) {
      var pos = person.node.worldPosition();
      x += pos.x();
      y += pos.y();
      z += pos.z();
    }

    if (group.size() > 0) {
      x /= group.size();
      y /= group.size();
      z /= group.size();

      return new Vector(x, y, z);
    } else {
      return new Vector(0,0,0);
    }
  }

}
