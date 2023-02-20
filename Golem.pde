class Golem extends MeleeEntity {

  //Attribute zur Darstellung
  int xSpeed = 3;
  int ySpeed = 3;

  // Konstruktoren
  Golem(PVector pos, String newName) {
    this.pos = pos;
    name = newName;
    ruestung = 10;
    size = .2;
    leben = 30;
    range = 200;
    staerke = .01;
  }

  //Die Bilder werden geladen. Die Größe wird angepasst.
  void init() {
    sprite = loadImage("Figuren/Golem.png");
  }

  //Bewegung des Golems
  void tick() {
    pos.x=pos.x+xSpeed;
    pos.y=pos.y+ySpeed;
    if (pos.x+size>width || pos.x<0) {
      xSpeed=-xSpeed;
    }
    if (pos.y+size>height || pos.y<0) {
      ySpeed=-ySpeed;
    }
    
    if (angreifen(get(Spieler.class))) {
      spawnParticles(new PuffParticleBuilder(5, get(Spieler.class).pos.copy(), color(90, 90, 90), 500), 1);
    }
    
    fill(50, 50, 100, 100);
    circle(pos.x, pos.y, range);
  }

  //Golem stirbt.
  void beforeSterben() {
    EntityManager.getInstance().add(createProp(pos, "Figuren/GolemDead.png", .1));
  }
}
