class Menu extends Entity {
  boolean playerHasDied;

  Menu() {
    playerHasDied = false;
  }
  
  Menu(boolean playerHasDied) {
    this.playerHasDied = playerHasDied;
  }
  
  void init() {
    zIndex = -1;

    spawnWidgetList( new IWidgetBuilder[]{
      new TextWidgetBuilder(playerHasDied ? "You Died" : "~ Menu ~"),
      
      new ButtonWidgetBuilder(new IButtonListener() { 
        public void onPress() { 
          waveManager.startWave();
        }
      }, "New Round"),
      
      new ButtonWidgetBuilder(new IButtonListener() { 
        public void onPress() { 
          exit();
        }
      }, "Quit"),
      
      new TextWidgetBuilder(new ILabelUpdater() {
        public String mkLabel() {
          return "Current Score: " + waveManager.score;
        }
      })
    }
    , new PVector(width/2, height/4), new PVector(300, 100), 20);
  }

  void tick() {
  }

  void draw() {
    background(0);
  }
}
