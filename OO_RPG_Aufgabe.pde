import java.util.*;
import java.util.concurrent.*;

static int width = 1200;
static int height = 800;

EntityManager entityManager = EntityManager.getInstance();
WaveManager waveManager = new WaveManager(); // <- actual gameplay logic

void setup() {
  size(1200, 800);
  
  entityManager.add(new Menu());
}

void draw() {
  background(0);

  entityManager.tick();

  fill(255, 255, 255);
}

void keyPressed() {

  entityManager.schedule(new IAction() {
    public void run() {
      for (Entity e : EntityManager.getInstance().findAll(Entity.class)) {
        e.keyPressed(key, keyCode);
      }
    }
  }
  );
}

void mousePressed() {
  entityManager.schedule(new IAction() {
    public void run() {
      for (Entity e : EntityManager.getInstance().findAll(Entity.class)) {
        e.mousePressed(mouseButton, mouseX, mouseY);
      }
    }
  }
  );
}
