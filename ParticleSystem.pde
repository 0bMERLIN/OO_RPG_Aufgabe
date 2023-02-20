// a functional interface, but this is java 7 so...
interface IParticleBuilder {
  Entity build();
}

class PuffParticleBuilder implements IParticleBuilder {
  private float speed;
  private PVector origin;
  private color col;
  private int fadeOutMs;

  PuffParticleBuilder(float speed, PVector origin, color col, int fadeOutMs) {
    this.speed = speed;
    this.origin = origin;
    this.col = col;
    this.fadeOutMs = fadeOutMs;
  }

  Entity build() {
    return new Entity() {
      PVector pos;
      PVector vel;
      float swirlSeed; // a random seed, so particles don't swirl in sync
      int startMs;
      int initialParticleRadius = 10;

      public void tick() {
        pos.add(vel);
      }

      public void draw() {
        push();
        noStroke();
        fill(col, 255 - 255 * (millis() - startMs) / fadeOutMs);
        
        if (millis() - startMs > fadeOutMs) EntityManager.getInstance().remove(this);
        
        // calculate vector perpendicular to the particles' velocity
        PVector left = new PVector(-vel.y, vel.x);
        
        // offset, that makes particle swirl
        PVector swirl = left.copy().mult(sin(millis() * swirlSeed) * 10f);
        
        circle(pos.x + swirl.x, pos.y + swirl.y, initialParticleRadius - initialParticleRadius * (millis() - startMs) / fadeOutMs);
        pop();
      }

      public void init() {
        vel = PVector.random2D().mult(speed * random(.2, 1));
        pos = origin.copy();
        swirlSeed = random(0, .01);
        startMs = millis();
      }
    };
  }
}

void spawnParticles(IParticleBuilder builder, int amt) {
  EntityManager e = EntityManager.getInstance();
  for (int i = 0; i < amt; i++) {
    e.add(builder.build());
  }
}
