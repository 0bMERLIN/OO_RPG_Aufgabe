class Katapult extends LivingEntity {

  // Gameplay Attribute
  private int reloadTime = 1000;     // in millis
  private int nachladen = 0;            // zur Berechnung der Nachladung
  private boolean istGeladen = true;
  private int timeLoadedMs; // when was the catapult last loaded?
  private int shotTimeout = 1000;

  // Attribute zur Darstellung
  private PImage picGeladen;
  private PImage picAbgefeuert;

  // Konstruktor
  Katapult(PVector pos) {
    this.pos = pos;
    size = .3;
    leben = 60;
  }

  // Hier kann das Katapult ausgeben.
  void vorstellen() {
    println("Ich bin ein Katapult und habe keinen Namen.");
  }

  // Die Bilder werden geladen. Die Größe wird angepasst.
  void init() {
    picGeladen = loadImage("Figuren/Katapult/KatapultGeladen.png");
    picAbgefeuert = loadImage("Figuren/Katapult/KatapultAbgeschossen.png");
    sprite = picGeladen;
  }

  // Katapult wird gezeichnet.
  void tick() {
    laden();
    
    if (millis() > timeLoadedMs + shotTimeout) schuss();
    
    if (istGeladen) {
      sprite = picGeladen;
    } else {
      sprite = picAbgefeuert;
    }
  }

  // Schuss des Katapultes. Der Nachladen Countdown wird gesetzt.
  void schuss() {
    if (istGeladen) {
      nachladen = millis() + reloadTime;
      istGeladen = false;

      EntityManager e = EntityManager.getInstance();
      PVector spawnOffset = new PVector(0, -50f);
      e.add(new GoblinGeschoss(
        GoblinType.FEUER, 
        pos.copy().add(spawnOffset), 
        e.findFirst(Spieler.class).pos.copy()
        ));
    }
  }

  // Katapult geht kaputt.
  void beforeSterben() {
    EntityManager.getInstance().add(createProp(pos, "Figuren/Katapult/KatapultKaputt.png", size));
  }

  // Diese Methode überprüft, ob das Katapult nach einem Schuss wieder geladen ist.
  private void laden() {
    if (!istGeladen) {
      if (nachladen < millis()) {
        istGeladen = true;
        timeLoadedMs = millis();
      }
    }
  }
}


/*
1. Füge das Katapult in dein Programm ein.
 2. Teste die Funktionen des Katapults und verändere die Angriffsrate.
 3. Das Katapult schießt Goblins. Erstelle eine Klasse "GoblinGeschoss".
 Diese braucht neben den Darstellungsattributen ein Attribt String typ, welches "Normal", "Feuer" oder "Eis" sein kann.
 4. Es sollen GoblinGeschosse von den Unterschiedlichen Typen erstellt werden können.
 5. Füge beim Katapult ein Attribut "Geschoss" vom Typ "GoblinGeschoss" ein.
 6. Das "Geschoss" soll beim Abschießen fliegen und beim Aufprallen Schaden machen.
 7. Unterschiedliche Geschosse können unterschiedliche Effekte auf das Ziel haben. Sei kreativ :)
 */
