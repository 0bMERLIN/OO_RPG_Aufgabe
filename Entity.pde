abstract class Entity {
  abstract void init();
  abstract void tick();
  abstract void draw();

  void keyPressed(char k, int code) {
  }
  void mousePressed(int btn, int mx, int my) {
  }

  int zIndex = 0;
  String name = "[no name]"; // :(

  void vorstellen() {
    println("Hallo, mein name ist " + name + ".");
  }
}


abstract class SpriteEntity extends Entity {
  PImage sprite;
  float size;
  PVector pos;
  int originalW;
  int originalH;
  private boolean initted = false;

  // should've used components to make extending the draw method possible
  // without adding more methods, but thats overkill for now
  void drawHud() {
  }

  void draw() {
    if (!initted) {
      initted = true;
      originalW = sprite.width;
      originalH = sprite.height;
    }

    sprite.resize(int(size * originalW), int(size * originalH));
    image(sprite, pos.x-sprite.width/2, pos.y-sprite.height/2);
    fill(255, 0, 0);

    drawHud();
  }
}

SpriteEntity createProp(final PVector p, final String spritePath, final float scale) {
  return new SpriteEntity() {
    public void init() {
      size = scale;
      sprite = loadImage(spritePath);
      pos = p;
      zIndex = -1;
    }

    public void tick() {
    }
  };
}

abstract class LivingEntity extends SpriteEntity {

  float leben;
  int ruestung;
  int score = 10;

  abstract void beforeSterben();

  void drawHud() {
    fill(255, 0, 0, 100);
    rect(pos.x, pos.y - sprite.height / 2, leben, 10); // TODO
  }

  void sterben() {
    beforeSterben();
    waveManager.score += score;
    EntityManager.getInstance().remove(this);
  }

  void schadenErhalten(float amt) {
    leben -= max(0, amt - ruestung);
    if (leben <= 0) sterben();
  }
}

abstract class MeleeEntity extends LivingEntity {

  float staerke;
  int ruestung;
  float range;

  // again, components would help...
  void beforeAngreifen() {
  }

  // returns t.rue if attack succeeds
  boolean angreifen(LivingEntity other) {
    beforeAngreifen();
    if (other.pos.dist(pos) - other.sprite.width * other.size > range) return false;
    other.schadenErhalten(staerke);
    return true;
  }
  
  // attack all entities within range
  void angreifenAll() {
    for (LivingEntity e : EntityManager.getInstance().findAll(LivingEntity.class)) {
      if (e != this) angreifen(e);
    }
  }

  void vorstellen() {
    println("Hallo, mein name ist " + name + " ich habe stärke " + staerke + " und " + leben + "leben");
  }
}
