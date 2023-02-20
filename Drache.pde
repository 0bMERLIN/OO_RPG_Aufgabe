class Drache extends MeleeEntity {
  // Attribute zur Darstellung
  private int xSpeed=5;
  private int ySpeed=1;

  // Animation Constants
  private PImage picNormal;
  private PImage picAttack;

  // attack timeout
  private int lastAttackStart;
  private final int attackTimeout = 2000;
  private final int attackDuration = 500;

  // Konstruktoren
  Drache(PVector pos, String newName) {
    this.pos = pos;
    name = newName;
    size = 0.2;
    zIndex = 10;

    leben = 40;
    staerke = .5;
    range = 200;

    lastAttackStart = millis();
  }

  //Die Bilder werden geladen. Die Größe wird angepasst.
  void init() {
    picNormal = loadImage("Figuren/Dragon.png");
    picAttack = loadImage("Figuren/DragonAttack.png");
  }

  //Bewegung des Drachens
  void tick() {
    pos.x=pos.x+xSpeed;

    float flyAnimOffset = sin(millis() / 100f)*10f;
    pos.y=pos.y+ySpeed+flyAnimOffset;

    if (pos.x+size>width || pos.x<0) {
      xSpeed=-xSpeed;
    }
    if (random(100)<90 ||pos.y+size>height || pos.y<0 ) {
      ySpeed=-ySpeed;
    }
    
    // attacking
    sprite = picNormal;
    
    if (millis() < lastAttackStart + attackDuration) {
      if (angreifen(get(Spieler.class))) {
        spawnParticles(new PuffParticleBuilder(8, get(Spieler.class).pos.copy(), color(255, 20, 10), 500), 1);
      }
      sprite = picAttack;
      
      fill(255, 100, 50, 100);
      circle(pos.x, pos.y, range);
    }
    
    if (millis() > lastAttackStart + attackDuration + attackTimeout) {
      lastAttackStart = millis();
    }
  }

  //Drache stirbt.
  void beforeSterben() {
    spawnParticles(new PuffParticleBuilder(10, pos, color(20, 100, 255), 500), 10);
  }
}
