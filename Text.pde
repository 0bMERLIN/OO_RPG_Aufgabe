class Text extends Widget {

  private ILabelUpdater updater;

  PFont MONOFONT = createFont("DejaVu Sans Mono", 40);

  Text(ILabelUpdater updater, PVector pos, PVector dims) {
    this.updater = updater;
    this.pos = pos;
    this.dims = dims;
  }

  void tick() {
  }
  void init() {
  }
  void draw() {
    String text = updater.mkLabel();
    textFont(MONOFONT);

    push();
    fill(200, 200, 200);
    textFont(MONOFONT);
    textAlign(CENTER);

    float fontSize = dims.x / (text.length() - 1);
    textSize(fontSize);

    text(text, pos.x, pos.y + textAscent() / 2.5);
    pop();
  }
}

interface ILabelUpdater {
  String mkLabel();
}

class TextWidgetBuilder implements IWidgetBuilder {
  private ILabelUpdater updater;

  TextWidgetBuilder(ILabelUpdater updater) {
    this.updater = updater;
  }

  TextWidgetBuilder(final String label) {
    this.updater = new ILabelUpdater() { 
      String mkLabel() { 
        return label;
      }
    };
  }

  Text build(PVector pos, PVector dims) {
    return new Text(updater, pos, dims);
  }
}
