import java.time.*;
import java.time.format.*;
class TimeSelectScene {
  Node root;
  SceneManager manager;
  ArrayList<Node> yearNodes = new ArrayList();
  ArrayList<Node> monthNodes = new ArrayList();
  ArrayList<Node> dayNodes = new ArrayList();
  ArrayList<Node> hourNodes = new ArrayList();
  ArrayList<Node> floorNodes = new ArrayList();
  
  SoundFile buttonSound;
  boolean isHoverEventHandled;

  int startYear = 2021;
  int yearLimit = 4;
  int taggedYear = -1;
  int taggedMonth = -1;
  int taggedDay = -1;

  TimeSelectScene(SceneManager manager) {
    var node = new Node();
    this.manager = manager;
    root = node;
    generateYears();
    //taggedYear = 2023;
    //taggedMonth = 6;
    //taggedDay = 10;
    //loadHourSelect();
  }

  int yearBoxWidth = 200;
  int yearBoxHeight = 100;
  int yearBoxDepth = 100;

  int monthBoxWidth = 500;
  int monthBoxHeight = 100;
  int monthBoxDepth = 100;

  int dayBoxWidth = 150;
  int dayBoxHeight = 150;
  int dayBoxDepth = 150;

  int hourBoxWidth = 150;
  int hourBoxHeight = 150;
  int hourBoxDepth = 150;

  int floorBoxWidth = 350;
  int floorBoxHeight = 150;
  int floorBoxDepth = 150;

  float yearRotateMax = 0.35;
  float monthRotateMax = 0.20;
  float dayRotateMax = 0.15;

  float clockLength = 400;
  void rotateToMouse(Node node) {

    var nodep = manager.scene.screenLocation(node.position());


    var rot = new Quaternion( -manager.scene.mouseRADY(0.001), manager.scene.mouseRADX(0.001), 0);

    node.rotate(rot);
  }

  void generateYears() {
    for (var i = 0; i < yearLimit; i++) {
      var node = new Node(root);
      final Integer fx = i;

      node.setShape((pg) -> {
        // use transparent fill for better z-casting
        pg.fill(255, 255, 255, 0);
        pg.stroke(255, 255, 255);
        pg.box(yearBoxWidth, yearBoxHeight, yearBoxDepth);
        pg.fill(255, 255, 255);

        pg.textSize(100);
        pg.text(Integer.toString(startYear+fx), -(yearBoxWidth/2), yearBoxHeight/4, yearBoxDepth/2);
      }
      );


      node.translate(i * 400, 0, 0);

      node.rotate(new Quaternion(
        random(-yearRotateMax, yearRotateMax),
        random(-yearRotateMax, yearRotateMax),
        random(-yearRotateMax, yearRotateMax)
        ));
      manager.scene.addBehavior(node, this::rotateToMouse);
      yearNodes.add(node);
    }
  }


  void clearAllNodes() {
    manager.scene.removeTag("click");

    for (var year : yearNodes) if (year.isAttached()) year.detach();
    for (var month : monthNodes)if (month.isAttached()) month.detach();
    for (var day : dayNodes) if (day.isAttached()) day.detach();
  }


  void loadMonthSelect() {
    clearAllNodes();


    for (var i = 0; i < 12; i++) {
      final Integer fx = i;
      var month = Month
        .of(fx+1);
      var localDate = LocalDate.of(taggedYear, month, 1);
      var now = LocalDate.now();
      if (localDate.getYear() == now.getYear() && month.getValue() > now.getMonth().getValue()) break;
      var node = new Node(root);

      node.setShape((pg) -> {
        //pg.hint(ENABLE_DEPTH_TEST);
        pg.fill(0, 0, 0, 0);
        pg.stroke(255, 255, 255);
        pg.pushMatrix();
        //pg.translate(0,0, -monthBoxDepth);
        pg.box(monthBoxWidth, monthBoxHeight, monthBoxDepth);
        pg.popMatrix();
        pg.textSize(100);
        pg.fill(255, 255, 255);
        pg.text(
          month
          .getDisplayName(TextStyle.FULL_STANDALONE, Locale.getDefault()),
          -(monthBoxWidth/2), monthBoxHeight/4, monthBoxDepth/2);
      }
      );

      node.translate((i % 4) * 600, floor(i / 4) * 400, 0);

      node.rotate(new Quaternion(
        random(-monthRotateMax, monthRotateMax),
        random(-monthRotateMax, monthRotateMax),
        random(-monthRotateMax, monthRotateMax)
        ));

      manager.scene.addBehavior(node, this::rotateToMouse);

      monthNodes.add(node);
    }
  }

  void loadDaySelect() {
    clearAllNodes();
    var localDate = LocalDate.of(taggedYear, taggedMonth, 1);


    for (var i = 0; i < localDate.lengthOfMonth(); i++) {
      final Integer fx = i;
      var node = new Node(root);

      node.setShape((pg) -> {
        //pg.hint(ENABLE_DEPTH_TEST);
        pg.fill(0, 0, 0, 50);
        pg.stroke(255, 255, 255);
        pg.pushMatrix();
        //pg.translate(0,0, -monthBoxDepth);
        pg.box(dayBoxWidth, dayBoxHeight, dayBoxDepth);
        pg.popMatrix();
        pg.textSize(100);
        pg.fill(255, 255, 255);
        pg.text(
          Integer.toString(fx + 1),
          -(dayBoxWidth/2), dayBoxHeight/4, dayBoxDepth/2);
      }
      );

      node.rotate(new Quaternion(
        random(-dayRotateMax, dayRotateMax),
        random(-dayRotateMax, dayRotateMax),
        random(-dayRotateMax, dayRotateMax)
        ));
      manager.scene.addBehavior(node, this::rotateToMouse);



      node.translate((i % 7) * 200, floor(i / 7) * 200, 0);
      dayNodes.add(node);
    }
  }



  void loadHourSelect() {
    clearAllNodes();

    var hourNode = new Node(root);

    for (var i = 0; i < 24; i++) {
      if (i == 23) continue;
      final Integer fx = i;
      var node = new Node(hourNode);

      node.setShape((pg) -> {
        //pg.hint(ENABLE_DEPTH_TEST);
        pg.fill(0, 0, 0, 50);
        pg.stroke(255, 255, 255);
        pg.pushMatrix();
        //pg.translate(0,0, -monthBoxDepth);
        pg.box(hourBoxWidth, hourBoxHeight, hourBoxDepth);
        pg.popMatrix();
        pg.textSize(130);
        pg.fill(255, 255, 255);
        pg.textAlign(CENTER);
        pg.text(
          Integer.toString(fx + 1),
          0, hourBoxHeight/4, hourBoxDepth/2);
      }
      );

      float ratio = (i % 12) / 12.0;
      float xPos = sin(PI + (ratio * -2 * PI)) * clockLength;
      float yPos = cos(PI + (ratio * -2 * PI)) * clockLength;

      node.translate(xPos * (i > 11 ? 1.5 : 1), yPos * (i > 11 ? 1.5 : 1), 0);
      manager.scene.addBehavior(node, this::rotateToMouse);

      hourNodes.add(node);
    }


    hourNode.tagging = false;

    var hourSelectSubnode = new Node(hourNode);
    hourSelectSubnode.tagging = false;
    hourSelectSubnode.setShape((pg) -> {
      pg.pushStyle();
      pg.noFill();
      pg.strokeWeight(5);

      pg.stroke(255, 255, 255);
      pg.circle(0, 0, clockLength * 4);
      pg.textAlign(CENTER);
      pg.textSize(90);
      pg.text("Hour Select\nor\nFloor Select", 0, -100);
      pg.popStyle();
    }
    );

    var floorSelect = new Node(hourNode);

    var floorValues = Arrays.asList(Floor.values());
    for (var i = 0; i < floorValues.size(); i++) {
      var floor = floorValues.get(i);

      final Integer fx = i;
      var node = new Node(floorSelect);

      node.setShape((pg) -> {
        pg.fill(0, 0, 0, 50);
        pg.stroke(255, 255, 255);
        pg.pushMatrix();
        //pg.translate(0,0, -monthBoxDepth);
        pg.box(floorBoxWidth, floorBoxHeight, floorBoxDepth);
        pg.popMatrix();
        pg.textSize(100);
        pg.fill(255, 255, 255);
        pg.text(
          floor.toString(),
          -(floorBoxWidth/2), floorBoxHeight/4, floorBoxDepth/2);
      }
      );
      manager.scene.addBehavior(node, this::rotateToMouse);

      node.translate(1000, 700+ (i * -200), 0);
      floorNodes.add(node);
    }
  }




  void update() {
    if (!root.isAttached()) return;
    boolean isAnyHovered = false;
    if (taggedYear == -1) {
      for (var i = 0; i < yearLimit; i++) {
        var year = yearNodes.get(i);

        if (manager.scene.hasTag("click", year)) {
          taggedYear = startYear + i;
          loadMonthSelect();
          return;
        }
        
        if (year.isTagged(scene)) {
          isAnyHovered = true;
        }
      }
    }

    if (taggedMonth == -1) {
      for (var i =0; i < monthNodes.size(); i++) {
        var month = monthNodes.get(i);

        if (manager.scene.hasTag("click", month)) {

          taggedMonth = i + 1;
          loadDaySelect();
          return;
        }
        
        if (month.isTagged(scene)) {
          isAnyHovered = true;
        }
      }
    }
    if (taggedDay == -1) {
      for (var i =0; i < dayNodes.size(); i++) {
        var day = dayNodes.get(i);

        if (manager.scene.hasTag("click", day)) {

          taggedDay = i + 1;
          loadHourSelect();
          return;
        }
        
        if (day.isTagged(scene)) {
          isAnyHovered = true;
        }
      }
    }

    for (var i = 0; i < hourNodes.size(); i++) {
      var hour = hourNodes.get(i);
      if (manager.scene.hasTag("click", hour)) {
        manager.loadVis(
          LocalDateTime.of(taggedYear, taggedMonth, taggedDay, i, 0)
          );
        return;
      }
      
      if (hour.isTagged(scene)) {
          isAnyHovered = true;
        }
    }
    //var floorValues = Arrays.asList(Floor.values());

    for (var i = 0; i < floorNodes.size(); i++) {
      var floor = floorNodes.get(i);
      if (manager.scene.hasTag("click", floor)) {
        manager.loadVis(
          LocalDate.of(taggedYear, taggedMonth, taggedDay),
          i
          );
        return;
      }
      if (floor.isTagged(scene)) {
          isAnyHovered = true;
        }
    }
    
    if (isAnyHovered && !isHoverEventHandled) {
      isHoverEventHandled = true;
      println("Play!!");
      buttonSound.cue(0);
      buttonSound.play();
    } else if (!isAnyHovered) {
      isHoverEventHandled = false;
    }
  }
  
  public void SetButtonSound (SoundFile buttonSound) {
    this.buttonSound = buttonSound;
  }
}
