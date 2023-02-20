interface IAction {
  void run();
}

// singleton, so all functions are contained to one file
// and only one instance can exist
static class EntityManager {
  static EntityManager instance;

  public static EntityManager getInstance() {
    if (instance == null) instance = new EntityManager();
    return instance;
  }

  // aggregates actions to be executed, until the next tick().
  // (to prevent ConcurrentModificationExceptions)
  // (needed because Processing's input system is async...)
  private ConcurrentLinkedQueue<IAction> actionsQueue;

  // action gets exectuted before next tick
  void schedule(IAction action) {
    actionsQueue.offer(action);
  }

  private EntityManager() {
    actionsQueue = new ConcurrentLinkedQueue();
    entities = new ArrayList();
  }

  <T> ArrayList<T> findAll(Class<T> c) {
    ArrayList<T> acc = new ArrayList();
    for (Entity e : entities) {
      if (c.isInstance(e)) {
        acc.add((T)e);
      }
    }
    return acc;
  }

  <T> T findFirst(Class<T> c) {
    return findAll(c).get(0);
  }

  private ArrayList<Entity> entities;

  void add(Entity entity) {
    entities.add(entity);
    entity.init();
  }

  void remove(Entity entity) {
    entities.remove(entity);
  }

  <T> void removeAll(Class<T> c) {

    ArrayList<Entity> acc = new ArrayList();

    for (Entity e : entities) {
      if (!c.isInstance(e)) acc.add(e);
    }

    entities = acc;
  }

  void tick() {
    int i = 0;

    Collections.sort(entities, new Comparator<Entity>() {
      @Override
        public int compare(Entity u1, Entity u2) {
        return u1.zIndex - u2.zIndex;
      }
    }
    );

    while (actionsQueue.peek() != null) {
      actionsQueue.poll().run();
    }

    while (i < entities.size()) {
      Entity e = entities.get(i);
      e.tick();
      e.draw();
      i++;
    }
  }
}

// a shorthand
static <T> T get(Class<T> c) {
  return EntityManager.getInstance().findFirst(c);
}

// Use this before calling `get` blindly, to avoid `get`ting an entity that's not in the scene.
// This is a hack, because java 7 doesn't have convenient anonymous functions.
static <T> int getCount(Class<T> c) {
  return EntityManager.getInstance().findAll(c).size();
}

static <T> boolean exists(Class<T> c) {
  return getCount(c) > 0;
}
