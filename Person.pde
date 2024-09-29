class Person {
  // Node
  Node node;
  // fields
  Vector velocity, acceleration, alignment, cohesion, separation; // position, velocity, and acceleration in
  // a vector datatype
  final float neighborhoodRadius = 100; // radius in which it looks for fellow Persons
  final float maxSpeed = 4; // maximum magnitude for the velocity vector
  final float maxSteerForce = 0.1f; // maximum magnitude of the steering vector
  final float sc = 3; // scale factor for the render of the Person

  Vector endPos;
  Vector startPos;
  float towardsAngle;

  float exitFadeAt = 150;
  float entryFadeAt = 200;

  boolean isReverse = false;
  float entryFade = 0;
  float exitFade = 0;
  public boolean hasExited = false;
  ArrayList<Person> group;
  TimeMapScene scene;
  float tint = 255;

  Person(TimeMapScene sceneRef, 
    Vector startPos, 
    Vector endPos, 
    float speed, 
    float accel, 
    // boolean reverse
    float entryFade,
    float exitFade
  ) {

    scene = sceneRef;
    group = scene.group;
    this.entryFadeAt = entryFade;
    this.exitFadeAt = exitFade;
    this.isReverse = false;
    this.startPos = isReverse ? endPos.copy() :  startPos.copy();
    
    //println("Spawning node at ", this.startPos);
    node = new Node(scene.node);
    node.setPosition(this.startPos.copy());

    exitFade = 0;
    hasExited = false;
    node.setShape(this::display);
    startAnimation();

    this.endPos = isReverse ? startPos : endPos;
    //var vec = endPos.copy();
    //vec.subtract(startPos);
    velocity = new Vector(speed, 0);
    //node.rotate(new Vector(1,1,1),towardsAngle);
    acceleration = new Vector(accel, 0);

    rotateTowardsGoal();
  }

  void rotateTowardsGoal() {
    var angle = this.endPos.copy();

    angle.subtract(node.position());
    towardsAngle = angle.heading();
    //println(towardsAngle);
    //println(angle);
    velocity.rotate(towardsAngle);
    acceleration.rotate(towardsAngle);

  }
  void startAnimation() {
    node.setBehavior(scene.sceneRef, this::behavior);
  }

  void stopAnimation() {
    scene.sceneRef.resetBehavior(node);
  }

  void display(PGraphics pg) {
    if (hasExited) {
      return;
    }
    pg.pushStyle();
    // uncomment to draw Person axes
    //Scene.drawAxes(pg, 10);
    pg.strokeWeight(scene.isFocus ? 3 : 0);


    pg.stroke(color(40, 255, 40, (exitFade != 0 ? exitFade : entryFade) * tint));

    pg.fill(color(0, 255, 0, (exitFade != 0 ? exitFade : entryFade) * tint));

    //draw Person
    pg.beginShape(TRIANGLES);
    pg.vertex(3 * sc, 0, 0);
    pg.vertex(-3 * sc, 2 * sc, 0);
    pg.vertex(-3 * sc, -2 * sc, 0);
    pg.vertex(3 * sc, 0, 0);
    pg.vertex(-3 * sc, 2 * sc, 0);
    pg.vertex(-3 * sc, 0, 2 * sc);
    pg.vertex(3 * sc, 0, 0);
    pg.vertex(-3 * sc, 0, 2 * sc);
    pg.vertex(-3 * sc, -2 * sc, 0);
    pg.vertex(-3 * sc, 0, 2 * sc);
    pg.vertex(-3 * sc, 2 * sc, 0);
    pg.vertex(-3 * sc, -2 * sc, 0);
    pg.endShape();
    pg.popStyle();
  }

  //-----------behaviors---------------

  void behavior(Graph graph) {
    for (int i = 0; i < group.size(); i++) {
      Person Person = group.get(i);
    }
    move();
    checkBounds();
  }


  void move() {
    velocity.add(acceleration); // add acceleration to velocity
    velocity.limit(maxSpeed); // make sure the velocity vector magnitude does not
    // exceed maxSpeed
    node.translate(velocity);
    var rot =  new Quaternion(node.position(), endPos);
    //if (this.isReverse) { 
    //  rot = Quaternion.identity;
    //  rot.fromTo(node.position(), endPos);
    //  //rot.invert();
    //}
    //* (this.isReverse ? -1.0 : 1.0)
    node.setOrientation(
      rot
      );
    //node.setOrientation(
    //Quaternion.multiply(Quaternion.from(Vector.plusJ, atan2(-velocity.z(), velocity.x())),
    //Quaternion.from(Vector.plusK, asin(velocity.y() / velocity.magnitude()))));
    acceleration.multiply(0); // reset acceleration
  }

  void checkBounds() {
    var nodePos = node.position();

    float entryDelta = Vector.distance(nodePos, startPos) ;
    //println(nodePos.x(), "-", startPos.x(), "=", entryDelta);
    entryFade = constrain((entryDelta / entryFadeAt) * scene.getAlpha(), 0, scene.getAlpha());

    var xDelta = Vector.distance(endPos, nodePos);
    if (xDelta <= exitFadeAt) {
      //println(xDelta);
      exitFade = constrain((xDelta / exitFadeAt) * scene.getAlpha(), 0, scene.getAlpha());
    }

    //var rtlReachedTarget = (!isReverse && Vector.distance(nodePos,endPos) <= 10);

    //var ltrReachedTarget = (isReverse && );
    //if (isReverse) {
      //println(nodePos.x(), "<", endPos.x());
    //}
    if (Vector.distance(nodePos, endPos) <= 10) {
      //println("killing node");
      //println("rtl="+rtlReachedTarget, ", ltr=", ltrReachedTarget, " killing node");

      stopAnimation();
      hasExited = true;
    }
    if (node.position().x() > groupWidth)
      node.position().setX(0);
    if (node.position().x() < 0)
      node.position().setX(groupWidth);
    if (node.position().y() > groupHeight)
      node.position().setY(0);
    if (node.position().y() < 0)
      node.position().setY(groupHeight);
    if (node.position().z() > groupDepth)
      node.position().setZ(0);
    if (node.position().z() < 0)
      node.position().setZ(groupDepth);
  }

  void setTint(float tint) {

    this.tint = tint;
  }
}
