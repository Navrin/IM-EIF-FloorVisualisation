import java.nio.file.Paths;

class SensorPair {
  Sensor pointA;
  Sensor pointB;


  SensorPair (Sensor a, Sensor b) {
    this.pointA = a;
    this.pointB = b;
  }
}



class SensorSingular {
  Sensor point;
  // some sensors are singular/unpaired,
  // assume some routes and diffuse from source.
  ArrayList<Vector> routes =  new ArrayList();
  // for stairs, do radial diffuse
  boolean radial = false;

  SensorSingular(Sensor point, boolean radial) {
    this.point = point;
    this.radial = radial;
  }


  SensorSingular addRoute(Vector route) {
    this.routes.add(route);
    return this;
  }
  SensorSingular addRoute(Vector... routes) {
    this.routes.addAll(Arrays.asList(routes));
    return this;
  }
}

class FloorInfo {
  PImage map;
  String name;
  ArrayList<Route> routes = new ArrayList();
  ArrayList<Vector> markPoint = new ArrayList();

  ArrayList<SensorPair> sensorPairs = new ArrayList();
  ArrayList<SensorSingular> sensorSingulars = new ArrayList();

  final static String imageFolder = "images";

  FloorInfo(String floorName) {
    this.name = floorName;
    var path = Paths.get(sketchPath(), FloorInfo.imageFolder, floorName + ".png");
    this.map = loadImage(path.toAbsolutePath().toString());
  }

  Floor getDataEnum() {
    switch (this.name) {
    case "00":
      return Floor.Floor00;
    case "02":
      return Floor.Floor02;
    case "04":
      return Floor.Floor04;
    case "05":
      return Floor.Floor05;
    case "06":
      return Floor.Floor06;
    case "08":
      return Floor.Floor08;
    case "09":
      return Floor.Floor09;
    case "10":
      return Floor.Floor10;
    default:
      throw new UnsupportedOperationException("No data enum member for floor "+this.name);
    }
  }
  FloorInfo addSensor(Sensor a, Sensor b) {
    sensorPairs.add(new SensorPair(a, b));
    return this;
  }
  FloorInfo addSensor(SensorPair pair) {
    sensorPairs.add(pair);
    return this;
  }
  FloorInfo addSensor(SensorSingular sensor) {
    sensorSingulars.add(sensor);
    return this;
  }
  FloorInfo addSensor(Sensor sensor) {
    sensorSingulars.add(new SensorSingular(sensor, true));
    return this;
  }
  FloorInfo addSensor(Sensor sensor, Vector[] routes) {
    sensorSingulars.add(new SensorSingular(sensor, false).addRoute(routes));
    return this;
  }


  // chainable
  FloorInfo addRoute(Route route) {
    routes.add(route);
    return this;
  }

  FloorInfo markPoint(Vector vec) {
    markPoint.add(vec);
    return this;
  }
}
