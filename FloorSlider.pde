class FloorSlider {
  Node rootNode;
  Node slideNode;
  Node railNode;
  boolean isActive = false;
  int x, y, z, len, floor, floorSize, maxFloors;

  Scene scene;

  FloorSlider(Scene scene, int x, int y, int z, int maxFloors, int focusedFloor, int floorSize) {
    this.x = x;
    this.y = y;
    this.z = z;
    this.len = (maxFloors-1) * floorSize;
    this.scene = scene;
    this.floor = focusedFloor;
    this.scene = scene;
    this.maxFloors = maxFloors;
    this.floorSize = floorSize;

    this.rootNode = new Node();

    this.rootNode.setWorldPosition(new Vector(x, y, z));

    this.slideNode = new Node(this.rootNode);
    this.slideNode.setPosition(0, 0, (this.floor-1) * -floorSize);


    this.slideNode.setShape(this::display);
    this.slideNode.setForbidRotationFilter();
    this.railNode = new Node(this.rootNode);

    this.slideNode.setBullsEyeSize(100);
    this.railNode.setShape(this::displayLine);
    this.railNode.setInteraction(this::interact);
    this.slideNode.setInteraction(this::interact);
    this.slideNode.setHighlight(0.35);
    this.railNode.setHighlight(0.0);
    this.railNode.setForbidRotationFilter();

    this.railNode.setPosition(0, 0, -len/2);
    //this.railNode.disablePicking(0);
  }


  void displayLine(PGraphics pg) {
    hint(ENABLE_DEPTH_TEST);
    hint(ENABLE_DEPTH_MASK);

    pg.pushMatrix();
    pg.pushStyle();
    pg.strokeWeight(1);
    pg.noFill();
    pg.stroke(0, 0, 165, 100);

    //translate(0, 0, -len/2);
    pg.box(40, 20, len);
    pg.popStyle();
    pg.popMatrix();


    hint(DISABLE_DEPTH_TEST);
    hint(DISABLE_DEPTH_MASK);
  }

  void display(PGraphics pg) {
    hint(ENABLE_DEPTH_TEST);
    hint(ENABLE_DEPTH_MASK);


    pg.pushStyle();
    pg.pushMatrix();
    //pg.translate(0, 0, -this.floor * this.z);
    pg.fill(255, 255, 255);
    pg.box(80, 40, 30);
    
    pg.popMatrix();
    pg.popStyle();
    hint(DISABLE_DEPTH_TEST);
    hint(DISABLE_DEPTH_MASK);
  }

  void interact(Object[] gs) {
    //println("Interaction registered", gs.length);
    for (var i = 0; i < gs.length; i ++) {
      var gi = gs[i];

      if ((gi instanceof String) && ((String)gi).matches("dragging")) {
        this.isActive = true;
        //println("dragging slider");
        calcNewSliderPos();
      }

      if ((gi instanceof String) && ((String)gi).matches("release")) {
        //this.slideNode.scale(1.0, 0.5);
        this.isActive = false;
      }
    }
  }

  void calcNewSliderPos() {

    var sWpos = this.slideNode.worldPosition();
    
    var toScreen = scene.screenLocation(sWpos);
    var screenDisplace = Vector.subtract(new Vector(mouseX, mouseY), new Vector(toScreen.x(), toScreen.y()));
    if (screenDisplace.magnitude() > 40) {
      this.floor = constrain(this.floor + (screenDisplace.y() < 0 ? 1 : -1), 0, maxFloors-1);
    }

    this.slideNode.setWorldPosition(sWpos.x(), sWpos.y(), (this.floor-1) * -floorSize);
  }
}
