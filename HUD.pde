void guiDrawMarker(color col, PVector pos) {
  fill(col);
  circle(pos.x, pos.y, sin(millis() / 100f) * 30);
}
