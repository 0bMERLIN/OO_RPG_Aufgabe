abstract class Widget extends Entity {
  PVector dims;
  PVector pos;
}

interface IWidgetBuilder {
  Widget build(PVector pos, PVector dims);
}

void spawnWidgetList(IWidgetBuilder[] builders, PVector pos, PVector dims, int vSpacing) {
  for (int i = 0; i < builders.length; i++) {
    Widget w = builders[i].build(new PVector(pos.x, pos.y + i * (vSpacing + dims.y)), dims);

    EntityManager.getInstance().add(w);
  }
}
