class Environment extends Entity {
  private ArrayList<PVector> grassPositions;

  private float spacing = 60;
  
  private float genOffset() {
    return random(-spacing/4, spacing/4);
  }
  
  private PImage grassSprite;

  void init() {
    
    grassSprite = loadImage("Umgebung/Gras1.png");
    grassSprite.resize(50, 50);
    
    grassPositions = new ArrayList();
    for (int x = 0; x < width; x += spacing) {
      for (int y = 0; y < height; y += spacing) {
        if (noise(x, y) > 0.5) {
          grassPositions.add(new PVector(x + genOffset(), y + genOffset()));
        }
      }
    }
    
    zIndex = -2; // :)
  }

  void tick() {
    
  }

  void draw() {
    background(#1F4017);
    
    for (PVector p : grassPositions) {
      fill(0, 255, 0);
      image(grassSprite, p.x, p.y);
    }
  }
}
