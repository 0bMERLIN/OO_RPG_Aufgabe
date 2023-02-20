enum GoblinType {
  NORMAL("Normal"), FEUER("Feuer"), EIS("Eis");

  private final String str;

  private GoblinType(String str) { 
    this.str = str;
  };

  String toString() { 
    return str;
  };
}

class GoblinGeschoss extends SpriteEntity {
  private GoblinType type;

  private PImage[] sprites = new PImage[3];

  private PVector start;
  private PVector worldPos; // actual position in the game world (pos: position on screen)
  private PVector target;

  // constants
  private float vel = 4;
  private float hitRadius = 100f;
  private int hitDmg = 10;

  private PVector toTarget() {
    PVector dir = target.copy().sub(worldPos);
    return dir;
  }

  GoblinGeschoss(GoblinType type, PVector pos, PVector target) {
    this.type = type;
    this.pos = pos.copy();
    this.worldPos = pos.copy();
    this.start = pos;
    this.target = target;

    size = .3;
  }

  void tick() {
    worldPos.add(toTarget().normalize().mult(vel));

    float d = 1 - worldPos.dist(target) / start.dist(target);

    int n = 0;
    // animation
    if (d < 1f/7f) n = 0; 
    else if (d < 2f/3f) n = 1; 
    else if (d <= 1f) n = 2;

    // target reached!
    if (d > 0.9) {
      hit();
      EntityManager.getInstance().remove(this);
    }

    pos = worldPos.copy().add(new PVector(0, -sin(d*PI)*200f));

    sprite = sprites[n];

    // gui
    guiDrawMarker(color(255, 0, 0), target);

    // draw hit radius
    noStroke();
    fill(255, 0, 0, 50);
    circle(target.x, target.y, hitRadius);
    
    // draw shadow
    fill(0, 0, 0, 80);
    float shadowRadius = 80;
    circle(worldPos.x, worldPos.y, 1.3 * shadowRadius - sin(d*PI) * shadowRadius);
  }

  private void hit() {
    ArrayList<LivingEntity> es = EntityManager.getInstance().findAll(LivingEntity.class);
    for (LivingEntity e : es) {
      if (e.pos.dist(worldPos) < hitRadius) {

        e.schadenErhalten(hitDmg);
      }
    }

    spawnParticles(new PuffParticleBuilder(10, pos, explosionColor(), 1000), 20);
  }

  private color explosionColor() {
    switch (type) {
    case NORMAL:
      return color(0, 255, 0);
    case EIS:
      return color(100, 100, 255);
    case FEUER:
      return color(255, 70, 20);
    default:
      return color(255, 255, 255);
    }
  }

  void init() {
    for (int i = 0; i <= 2; i++) {
      String fileName = "Figuren/Katapult/Goblin" + type.toString() + (i+1) + ".png";
      sprites[i] = loadImage(fileName);
    }
  }

  void beforeSterben() {
  }
}
