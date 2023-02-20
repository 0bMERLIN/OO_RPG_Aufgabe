// composition over inheritance!
interface IButtonListener {
  void onPress();
}

class Button extends Widget {
  private String label;
  private IButtonListener listener;

  PFont MONOFONT = createFont("DejaVu Sans Mono", 40);

  Button(String label, PVector pos, PVector dims, IButtonListener listener) {
    this.label = label;
    this.dims = dims;
    this.pos = pos;
    this.listener = listener;
  }

  void tick() {
  }

  private boolean isWithin(int x, int y) {

    return x > pos.x - dims.x/2
      && x < pos.x - dims.x/2 + dims.x
      && y > pos.y - dims.y/2
      && y < pos.y - dims.y/2 + dims.y;
  }

  void draw() {
    // hover?
    if (isWithin(mouseX, mouseY))
      stroke(100, 100, 100);
    else stroke(50, 50, 50);

    noFill();
    rect(pos.x - dims.x/2, pos.y - dims.y/2, dims.x, dims.y);

    push();
    fill(200, 200, 200);
    textFont(MONOFONT);
    textAlign(CENTER);
    
    float fontSize = min(dims.y / 2, dims.x / (label.length() - 1));
    textSize(fontSize);

    text(label, pos.x, pos.y + textAscent() / 2.5);
    pop();
  }

  public void mousePressed(int btn, int mx, int my) {
    if (btn == LEFT && isWithin(mx, my)) {
      listener.onPress();
    }
  }

  void init() {
  }
}

class ButtonWidgetBuilder implements IWidgetBuilder {
  private IButtonListener listener;
  private String label;

  ButtonWidgetBuilder(IButtonListener listener, String label) {
    this.listener = listener;
    this.label = label;
  }

  Button build(PVector pos, PVector dims) {
    return new Button(label, pos, dims, listener);
  }
}
