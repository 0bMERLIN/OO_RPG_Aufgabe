// Note: not a singleton, because it uses methods from processing...
//   Refactor needed when migrating to an explicit `PApplet` class:
//     -> convert to singleton.
// Purpose: Can start a wave of enemies on demand and keeps track of global state
class WaveManager {
  int score;
  int intensity;

  private PVector randomPVectorOnScreen() {
    return new PVector(random(0, width), random(0, height));
  }

  WaveManager() {
    score = 0;
    intensity = 1;
  }

  void startWave() {
    EntityManager entityManager = EntityManager.getInstance();

    // purge the scene
    entityManager.removeAll(Object.class);

    // add enemies + environment
    entityManager.add(new Environment());

    for (int i = 0; i < sqrt(intensity*2); i++) {

      // every 4th intensity step, one more catapult spawns
      if (i % 4 == 0) entityManager.add(new Katapult(randomPVectorOnScreen()));

      entityManager.add(new Drache(randomPVectorOnScreen(), "Kasimir"));
      entityManager.add(new Golem(randomPVectorOnScreen(), "Peter"));
    }

    // add player at center of the screen
    entityManager.add(new Spieler(new PVector(width / 2, height / 2)));

    entityManager.add(new WaveManagerEntity());
  }
}

// Entity that represents the WaveManager in the world during gameplay.
class WaveManagerEntity extends Entity {
  void tick() {

    EntityManager e = EntityManager.getInstance();

    // if only player is alive / has survived the wave
    if (e.findAll(LivingEntity.class).size() == 1) {
      waveManager.intensity++;
      returnToMenu(false);
    }
  }

  void returnToMenu(boolean playerHasDied) {
    EntityManager e = EntityManager.getInstance();

    e.removeAll(Object.class);
    e.add(new Menu(playerHasDied));
  }

  void init() {
  }

  void draw() {
  }

  void keyPressed(char k, int code) {
    EntityManager entityManager = EntityManager.getInstance();

    // Vorstellung der Figuren bei "i".
    if (k == 'i') {
      for (Entity e : entityManager.entities) {
        e.vorstellen();
      }
    }

    // player dash ability (move quicker)
    if (code == SHIFT && exists(Spieler.class)) get(Spieler.class).dash();

    if (k == 'k' && exists(Katapult.class)) {
      get(Katapult.class).schuss();
    }
    if (k =='o' && exists(Katapult.class)) {
      get(Katapult.class).sterben();
    }
  }
}
