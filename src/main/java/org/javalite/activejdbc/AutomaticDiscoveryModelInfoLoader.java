package org.javalite.activejdbc;

import java.io.*;
import java.net.URL;
import java.util.*;

import org.javalite.activejdbc.Configuration.ModelInfoLoader;

public class AutomaticDiscoveryModelInfoLoader implements ModelInfoLoader {
  private final String rootPackage;

  public AutomaticDiscoveryModelInfoLoader(String rootPackage) {
    super();
    this.rootPackage = rootPackage;
  }

  public Map<String, List<String>> load() throws IOException {
    try {
      Map<String, List<String>> res = new HashMap<String, List<String>>();
      for (Class<?> c : new PatternClasspathClassesFinder(Model.class, rootPackage).getClasses()) {
        String modelName = c.getName();
        @SuppressWarnings("unchecked")
        String dbName = MetaModel.getDbName((Class<? extends Model>)c);
        if (res.get(dbName) == null) {
          res.put(dbName, new ArrayList<String>());
        }
        res.get(dbName).add(modelName);

      }
      return res;
    } catch (Exception e) {
      throw new RuntimeException(e);
    }
  }

  public static class PatternClasspathClassesFinder {
    final Class<?> superclass;
    final String packageName;

    public PatternClasspathClassesFinder(Class<?> superclass, String packageName) {
      super();
      this.superclass = superclass;
      this.packageName = packageName;
    }

    public List<Class<?>> getClasses()
        throws ClassNotFoundException, IOException {
      ClassLoader classLoader = Thread.currentThread().getContextClassLoader();
      String path = packageName.replace('.', '/');
      // Get classpath
      Enumeration<URL> resources = classLoader.getResources(path);
      List<File> dirs = new ArrayList<File>();
      while (resources.hasMoreElements()) {
        URL resource = resources.nextElement();
        dirs.add(new File(resource.getFile()));
      }
      // For each classpath, get the classes.
      ArrayList<Class<?>> classes = new ArrayList<Class<?>>();
      for (File directory : dirs) {
        classes.addAll(findClasses(directory, packageName));
      }
      return classes;
    }

    private List<Class<?>> findClasses(File directory, String packageName)
        throws ClassNotFoundException {
      List<Class<?>> classes = new ArrayList<Class<?>>();
      if (!directory.exists()) {
        return classes;
      }
      File[] files = directory.listFiles();
      for (File file : files) {
        if (file.isDirectory()) {
          classes.addAll(findClasses(file, packageName + "." + file.getName()));
        }
        else {
          // We remove the .class at the end of the filename to get the
          // class name...
          try {
             Class<?> clazz = Class.forName(packageName + '.' + file.getName().substring(0, file.getName().length() - 6));
             // Check, if class contains test methods (prevent "No runnable methods" exception):
             if (superclass.isAssignableFrom(clazz)) {
               classes.add(clazz);
             }
          } catch (ClassNotFoundException e) {
             // ignore classes 
          }
        }
      }
      return classes;
    }

    public List<String> getClassNames() throws ClassNotFoundException, IOException {
      ClassLoader classLoader = Thread.currentThread().getContextClassLoader();
      String path = packageName.replace('.', '/');
      // Get classpath
      Enumeration<URL> resources = classLoader.getResources(path);
      List<File> dirs = new ArrayList<File>();
      while (resources.hasMoreElements()) {
        URL resource = resources.nextElement();
        dirs.add(new File(resource.getFile()));
      }
      // For each classpath, get the classes.
      ArrayList<String> classes = new ArrayList<String>();
      for (File directory : dirs) {
        classes.addAll(findClassNames(directory, packageName));
      }
      return classes;
    }

    private List<String> findClassNames(File directory, String packageName) throws ClassNotFoundException {
      List<String> classes = new ArrayList<String>();
      if (!directory.exists()) {
        return classes;
      }
      File[] files = directory.listFiles();
      for (File file : files) {
        if (file.isDirectory()) {
          classes.addAll(findClassNames(file, packageName + "." + file.getName()));
        }
        else {
          // We remove the .class at the end of the filename to get the
          // class name...
          String classname = packageName + '.' + file.getName().substring(0, file.getName().length() - 6);
          // Check, if class contains test methods (prevent "No runnable methods" exception):
          classes.add(classname);
        }
      }
      return classes;
    }
  }
}