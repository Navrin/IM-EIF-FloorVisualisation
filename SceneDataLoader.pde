import java.time.*;
import java.util.*;
import nub.primitives.*;
import nub.primitives.Vector;
import java.text.*;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.Paths;
import java.nio.file.Files;

public enum Direction {
  IN,
    OUT,
    UP,
    DOWN;


  String toAPIFormat() {
    switch (this) {
    case IN:
      return "In";
    case OUT:
      return "Out";
    case UP:
      return "Up";
    case DOWN:
      return "Down";
    default:
      throw new UnsupportedOperationException("API format not given for enum member "+this);
    }
  }

  public Direction getAntiDirection() {
    switch (this) {
    case IN:
      return OUT;
    case OUT:
      return IN;
    case UP:
      return DOWN;
    case DOWN:
      return UP;
    default:
      throw new UnsupportedOperationException("Unreachable!");
    }
  }
}

public enum Sensor {
  PC00_WATTLE,
    PC00_CR04_EAST,
    PC00_CR04_WEST,
    PC00_ST01,
    PC02_BROADWAY,
    PC02_JONES,
    PC04_ST18,
    PC06_ST19,
    PC05_CR07,
    PC05_CR09,
    PC08_CR10,
    PC09_CR12,
    PC09_CR14,
    PC09_CR21,
    PC09_ST21,
    PC09_CR11,
    PC10_CR09,
    PC09_ST22
    ;


  public List<Direction> getDirectionsForSensor() {
    switch (this) {
    case PC00_WATTLE:
    case PC00_CR04_EAST:
    case PC00_CR04_WEST:
    case PC02_BROADWAY:
    case PC02_JONES:
    case PC05_CR07:
    case PC05_CR09:
    case PC08_CR10:
    case PC09_CR12:
    case PC09_CR14:
    case PC09_CR21:
    case PC09_CR11:
    case PC10_CR09:
      return Arrays.asList(Direction.IN, Direction.OUT);
    case PC00_ST01:
    case PC04_ST18:
    case PC06_ST19:
    case PC09_ST21:
    case PC09_ST22:
      return Arrays.asList(Direction.UP, Direction.DOWN);


    default:
      throw new UnsupportedOperationException("API format not given for enum member "+this);
    }
  }

  public String toAPIFormat(Direction dir) {
    var valids = this.getDirectionsForSensor();
    if (!valids.contains(dir)) {
      throw new UnsupportedOperationException("Direction " + dir + " is not valid for this sensor ("+this+")!");
    }
    switch (this) {
    case PC00_WATTLE:
      return "CB11.00.Wattle " + dir.toAPIFormat();
    case PC00_CR04_EAST:
      return "CB11.00.CR04.East " + dir.toAPIFormat();
    case PC00_CR04_WEST:
      return "CB11.00.CR04.West " + dir.toAPIFormat();
    case PC00_ST01:
      return "CB11.00.ST01" + dir.toAPIFormat();
    case PC02_BROADWAY:
      return "CB11.02.Broadway.East " + dir.toAPIFormat();
    case PC02_JONES:
      return "CB11.02.JonesSt " + dir.toAPIFormat();
    case PC04_ST18:
      return "CB11.04.ST18 " + dir.toAPIFormat();
    case PC05_CR07:
      return "CB11.05.CR07 " + dir.toAPIFormat();
    case PC05_CR09:
      return "CB11.05.CR09 " + dir.toAPIFormat();
    case PC06_ST19:
      return "CB11.06.ST19 " + dir.toAPIFormat();
    case PC08_CR10:
      return "CB11.08.CR10 " + dir.toAPIFormat();
    case PC09_CR12:
      return "CB11.09.CR12 " + dir.toAPIFormat();
    case PC09_CR14:
      return "CB11.09.CR14 " + dir.toAPIFormat();
    case PC09_ST21:
      return "CB11.09.ST21 " + dir.toAPIFormat();
    case PC09_CR11:
      return "CB11.09.CR11 " + dir.toAPIFormat();
    case PC09_CR21:
      return "CB11.09.CR21 " + dir.toAPIFormat();

    case PC09_ST22 :
      return "CB11.09.ST22 " + dir.toAPIFormat();
    case PC10_CR09:
      return "CB11.10.CR09 " + dir.toAPIFormat();
    default:
      throw new UnsupportedOperationException("API format not given for enum member "+this);
      //return "No API Format Defined for " + this;
    }
  }

  public String toAPISensorFamily() {
    switch (this) {
    case PC00_WATTLE:
      return "CB11.PC00.06.West";
    case PC00_CR04_EAST:
    case PC00_ST01:
      return "CB11.PC00.08.ST12";
    case PC00_CR04_WEST:
      return "CB11.PC00.09.CR01";
    case PC02_BROADWAY:
      return "CB11.PC02.14.Broadway";
    case PC02_JONES:
      return "CB11.PC02.16.JonesStEast";
    case PC04_ST18:
    case PC06_ST19:
      return "CB11.PC05.22";
    case PC05_CR07:
    case PC05_CR09:
      return "CB11.PC05.23";
    case PC08_CR10:
    case PC09_CR12:
    case PC09_CR21:
    case PC09_CR14:
    case PC09_ST21:
      return "CB11.PC09.28";
    case PC09_CR11:
    case PC10_CR09:
      return "CB11.PC10.30";
    case PC09_ST22 :
      return "CB11.PC09.27";
    default:
      throw new UnsupportedOperationException("API format not given for enum member "+this);
    }
  }

  /**
   * !!TODO!!
   * This function should return the coordinate for the given sensor for the scene.
   * The coordinate should be correct for the scene within the 3D view.
   */
  public Vector toMapPosition() {
    switch (this) {
    case PC00_WATTLE:
      return new Vector(90, 275);
    case PC00_CR04_EAST:
      return new Vector(195, 490);
    case PC00_CR04_WEST:
      return new Vector(695, 450);
    case PC00_ST01:
      return new Vector(850, 400);
    case PC02_BROADWAY:
      return new Vector(1150, 510);
    case PC02_JONES:
      return new Vector(1150, 300);
    case PC04_ST18:
      return new Vector(600, 430);
    case PC05_CR07:
      return new Vector(250, 420);
    case PC05_CR09:
      return new Vector(980, 320);
    case PC06_ST19:
      return new Vector(750, 400);
    case PC08_CR10:
      return new Vector(650, 390);
    case PC09_CR12:
      return new Vector(350, 400);
    case PC09_CR14:
      return new Vector(950, 330);
    case PC09_ST21:
      return new Vector(760, 450);
    case PC09_CR11:
      return new Vector(640, 390);
    case PC09_ST22:
      return new Vector(250, 320);
    case PC10_CR09:
      return new Vector(600, 390);
    default:
      throw new UnsupportedOperationException("No map position defined for "+this);
    }
  }
}

enum SceneType {
  /**
   * Represents only (1) floor with each layer (z-level) being a different >HOUR< of the day.
   */
  TIME_SERIES,
  /**
   * Represents ALL (supported) floors with each layer (z-level) being a different floor.
   * Only represents (1) hour of data.
   */
    FLOOR_SERIES;
}

enum Floor {
  Floor00,
    Floor02,
    Floor04,
    Floor05,
    Floor06,
    Floor08,
    Floor09,
    Floor10;


  List<Sensor> getSensors() {
    switch (this) {
    case Floor00:
      return Arrays.asList(Sensor.PC00_WATTLE,
        Sensor.PC00_CR04_EAST,
        Sensor.PC00_CR04_WEST,
        Sensor.PC00_ST01);
    case Floor02:
      return Arrays.asList(Sensor.PC02_BROADWAY,
        Sensor.PC02_JONES);
    case Floor04:
      return Arrays.asList(Sensor.PC04_ST18);
    case Floor05:
      return Arrays.asList(Sensor.PC05_CR07,
        Sensor.PC05_CR09);
    case Floor06:
      return Arrays.asList(Sensor.PC06_ST19);
    case Floor08:
      return Arrays.asList(Sensor.PC08_CR10);
    case Floor09:
      return Arrays.asList(Sensor.PC09_CR12,
        Sensor.PC09_CR14,
        Sensor.PC09_CR21,
        Sensor.PC09_ST21,
        Sensor.PC09_CR11,
        Sensor.PC09_ST22);
    case Floor10:
      return Arrays.asList(Sensor.PC10_CR09);

    default:
      throw new UnsupportedOperationException("Floor missing sensor array"+this);
    }
  }
}

class DataPacket {
  Floor floor;
  Sensor sensor;
  LocalDateTime timestamp;
  Direction direction;
  float value;

  DataPacket(Floor floor, Sensor sensor, LocalDateTime timestamp, Direction direction, float value) {
    this.floor = floor;
    this.sensor = sensor;
    this.timestamp = timestamp;
    this.direction = direction;
    this.value = value;
  }
}

class SceneDataLoader {
  ArrayList<DataPacket> sceneData = new ArrayList();
  Scene scene;
  ArrayList<String> hudMessageQueue = new ArrayList();
  final static String cacheDir = ".cache";
  ArrayList<Sensor> failedNodes = new ArrayList();
  /**
   * Both constructors should call the API request and populate the sceneData field.
   */

  /**
   * Constructor for TIME SERIES data only.
   * Should accept a floor, and a day.
   * API request should be all sensor data for that floor from 12AM til 11pm for the day.
   * Params:
   * - LocalDate date : Represents a specific day with NO TIME associated with it.
   * - Floor floor : Represents the chosen floor.
   */
  SceneDataLoader(LocalDate date, Floor floor, Scene scene) {
    this.scene = scene;
    var sensors = floor.getSensors();

    // for (var i = 0; i < 22; i++) {
      for (var sensor : sensors) {
        for (var dir : sensor.getDirectionsForSensor()) {
          var fromDate = date.atTime(0, 0);
          var toDate = date.atTime(23, 59);
          try {
            var jsonData = loadJSONAndCache(fromDate, toDate, sensor, dir);
            processData(jsonData, floor, sensor, dir);
          }
          catch (java.lang.RuntimeException e) {
            failedNodes.add(sensor);
            // eif api is silly and poorly made and doesn't return error codes :/
            addToHud(String.format("[WARN] eif silently errored for %s [%s]", sensor, sensor.toAPIFormat(dir)));
          }
        }
      }
    // }
  }


  /**
   * Constructor for FLOOR SERIES data.
   * Should accept the start and end time.
   */
  SceneDataLoader(LocalDateTime start, LocalDateTime end, Scene scene) {
    this.scene = scene;

    for (var floor : Floor.values()) {
      for (var sensor : floor.getSensors()) {
        for (var dir : sensor.getDirectionsForSensor()) {
          try {
            var jsonData = loadJSONAndCache(start, end, sensor, dir);
            processData(jsonData, floor, sensor, dir);
          }
          catch (java.lang.RuntimeException e) {
            failedNodes.add(sensor);
            // eif api is silly and poorly made and doesn't return error codes :/
            addToHud(String.format("[WARN] eif silently errored for %s [%s]", sensor, sensor.toAPIFormat(dir)));
          }
        }
      }
    }
  }

  JSONArray loadJSONAndCache(LocalDateTime fromTime, LocalDateTime toTime, Sensor sensor, Direction dir) {
    // check cache first
    
    var cacheRoute = Paths.get(
      sketchPath(), 
      SceneDataLoader.cacheDir, 
      formatter.format(fromTime) + "-" + formatter.format(toTime) + "-" + sensor.toAPIFormat(dir) + ".json");

    var cacheFile = cacheRoute.toFile();
    if (cacheFile.exists()) {
      return loadJSONArray(cacheFile.getAbsolutePath());
    }

    var route = generateRoute(fromTime, toTime, sensor, dir);

    var obj = loadJSONArray(route);
    // cache it
    saveJSONArray(obj, cacheFile.getAbsolutePath());  

    return obj;
  }
  
  void addToHud(String msg) {
    println(msg);
    if (hudMessageQueue.size() > 8) 
      hudMessageQueue.remove(0);
    hudMessageQueue.add(msg);
    scene.beginHUD();
    textSize(40);
    textAlign(RIGHT);
    for (var i = 0; i < hudMessageQueue.size(); i++) {
      var queueMsg = hudMessageQueue.get(i);

      text(queueMsg, i * 30, 600);
    }
    scene.endHUD();
  }

  void processData(JSONArray data, Floor floor, Sensor sensor, Direction dir) {
    for (var i = 0; i < data.size(); i++) {
      JSONArray row = data.getJSONArray(i);

      String dateString = row.getString(0);
      float value = row.getFloat(1);

      sceneData.add(new DataPacket(
        floor,
        sensor,
        LocalDateTime.parse(dateString, apiFormat),
        dir,
        value
        ));
    }

    sceneData.sort((a, b) -> a.timestamp.compareTo(b.timestamp));
  }

  DateTimeFormatter formatter = DateTimeFormatter.ISO_LOCAL_DATE_TIME;
  DateTimeFormatter apiFormat = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

  String generateRoute(LocalDateTime fromTime, LocalDateTime toTime, Sensor sensor, Direction dir) {
    var fmt = new MessageFormat(

      "rFromDate={0}"
      + "&rToDate={1}"
      + "&rFamily=people_sh"
      + "&rSensor={2}"
      + "&rSubSensor={3}"
      );

    var formatted = fmt.format(new Object[]{
      URLEncoder.encode(formatter.format(fromTime), StandardCharsets.UTF_8),
      URLEncoder.encode(formatter.format(toTime), StandardCharsets.UTF_8),
      URLEncoder.encode(sensor.toAPISensorFamily(), StandardCharsets.UTF_8),
      URLEncoder.encode(sensor.toAPIFormat(dir), StandardCharsets.UTF_8)
      });

    return "https://eif-research.feit.uts.edu.au/api/json/?" + formatted;
  }



  /**
   * HARD TASK:
   * This function should accept a sensor and for ANY ARBITARY TIME (within the acceptable time range)
   * should return a DataPacket. This will require some data processing to do curve fitting!
   *
   * One possible approach is for a given time (t),
   * find the nearest two existing data points,
   * (t-1), (t), (t+1)
   * then calculate the derivitive of the known points (basic rise over run)
   * m = [ (t+1).value - (t-1).value ] / [ (t+1).time - (t-1).time ]
   * then we can estimate the value of (t) via [ m * (t).time ] = (t).value
   *
   * Note this only works for linear-ish data. If the [t-1, t+1] is too far apart,
   * then the estimation will be inaccurate, however it should still be a smooth transition.
   */

  float estimateValue(Sensor sensor, Direction direction, LocalDateTime time) {
    var values = sceneData.stream()
      .filter(packet -> packet.sensor == sensor && packet.direction == direction)
      .sorted((a, b) -> a.timestamp.compareTo(b.timestamp))
      .toList();

    ArrayList<DataPacket> finalVals = new ArrayList();

    for (var i = 0; i < values.size(); i++) {
      var val = values.get(i);
      if (val.timestamp.compareTo(time) < 0) continue;

      if (val.timestamp.isEqual(time)) {
        finalVals.add(val);
        break;
      }

      if (i - 1 > 0) {
        finalVals.add(values.get(i - 1));
        finalVals.add(val);
        break;
      }
      if (i - 1 < 0) {
        finalVals.add(val);
      }
    }

    if (finalVals.size() == 1) return (float)finalVals.get(0).value;
    if (finalVals.size() == 2) {
      var zoneId = ZoneId.systemDefault();
      float m = (finalVals.get(1).value - finalVals.get(0).value)
        / (finalVals.get(1).timestamp.atZone(zoneId).toEpochSecond()
        - finalVals.get(0).timestamp.atZone(zoneId).toEpochSecond());

      return (m * time.atZone(zoneId).toEpochSecond());
    }

    return 0;
  }
}
