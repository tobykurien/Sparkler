package org.javalite.activejdbc;

import java.util.*;

public enum ListenerRegistry {
  LISTENER_REGISTRY;
  
  private final static HashMap<Class, List<CallbackListener>> listeners = new HashMap<Class, List<CallbackListener>>();


  protected List<CallbackListener> getListeners(Class modelClass) {
    if (listeners.get(modelClass) == null) {
      listeners.put(modelClass, new ArrayList<CallbackListener>());
    }
    return listeners.get(modelClass);
  }

  public void addListener(Class modelClass, CallbackListener listener) {
    getListeners(modelClass).add(listener);
  }

}
