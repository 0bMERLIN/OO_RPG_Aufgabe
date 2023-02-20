class Spieler extends MeleeEntity {
  // Gameplay
  private float speed = 5;
  private PVector target;

  private float dashEndMs;
  private float dashTimeoutMs;
  private float dashVelMultiplier;
  private float dashLengthMs;

  private int lastAttackMs;

  // Anzeige
  private PImage pic;
  private PImage picAttack;

  Spieler(PVector pos) {
    this.pos = pos;
    target = pos;

    name = "Spieler";
    leben = 70;
    staerke = 10;
    ruestung = 5;
    range = 100;

    dashEndMs = millis();
    dashTimeoutMs = 100;
    dashLengthMs = 300;
    dashVelMultiplier = 4;

    size = .3;
  }

  void init() {
    pic = loadImage("Figuren/Dwraf.png");
    picAttack = loadImage("Figuren/DwrafAttack.png");
    sprite = pic;
  }

  PVector toTarget() {
    PVector dir = target.copy().sub(pos);
    return dir;
  }

  void tick() {
    if (pos.dist(target) > 5) {
      PVector dir = toTarget().normalize();

      float speedMultiplier = (millis() < dashEndMs) ? dashVelMultiplier : 1;
      float sp = min(toTarget().mag(), speed * speedMultiplier);
      PVector delta = dir.mult(sp).copy();
      PVector bobbing = new PVector(0, sin(millis() / 50f) * 2);

      pos.add(delta.add(bobbing));

      guiDrawMarker(color(255, 255, 255), target);
    }

    if (millis() - lastAttackMs > 500) sprite = pic;
  }

  private boolean isDashing() {
    return millis() < dashEndMs;
  }

  void retarget(int tx, int ty) {
    target = new PVector(tx, ty);
  }

  void dash() {
    if (millis() > dashEndMs + dashTimeoutMs)
      dashEndMs = millis() + dashLengthMs;
  }

  void beforeAngreifen() {
    sprite = picAttack;
    lastAttackMs = millis();
  }

  void beforeSterben() {
    waveManager.score = 0;
    waveManager.intensity = 1;
    EntityManager.getInstance().findFirst(WaveManagerEntity.class).returnToMenu(true);
  }

  void mousePressed(int btn, int mx, int my) {
    if (btn == RIGHT)
      retarget(mx, my);

    if (btn == LEFT) {
      angreifenAll();
    }
  }
}
