package com.tobykurien.sparkler.db

import com.tobykurien.sparkler.Helper
import java.io.FileInputStream
import java.util.Map
import javax.sql.DataSource
import org.apache.commons.dbcp.DriverManagerConnectionFactory
import org.apache.commons.dbcp.PoolableConnectionFactory
import org.apache.commons.dbcp.PoolingDataSource
import org.apache.commons.pool.impl.GenericObjectPool
import org.yaml.snakeyaml.Yaml
import org.javalite.activejdbc.Registry
import java.util.Properties
import org.javalite.activejdbc.LogFilter
import org.apache.commons.dbcp.BasicDataSource;

class DatabaseManager {
   var static Map<String,String> dbConfig
   
   /**
    * Initialize the database system
    * 
    * @param modelsPackageName - the root package where your database model classes
    * are stored. Sub-packages will also be searched for database models.
    */
   def static init(String modelsPackageName) {
      // initialize ActiveJDBC with correct parameters
      var p = new Properties
      p.put("model.loader.strategy", "auto")
      p.put("model.loader.package", modelsPackageName)
      //p.put("cache.manager", "") // add OSCache cache manager here
      Registry.instance.configuration.init(p)
      if (!"production".equalsIgnoreCase(Helper.environment)) {
         // log activejdbc queries only
         LogFilter.setLogExpression("Query\\:.*");
      }

      // load the database config
      var yaml = new Yaml()
      var config = yaml.load(new FileInputStream("config/database.yml")) as Map<String,Map<String,String>> 
      dbConfig = config.get(Helper.environment)
      
      Class.forName(dbConfig.get("driver")) // load database driver
   }

   def static DataSource newDataSource() {
      if (dbConfig == null) throw new IllegalStateException("DatabaseManager.init() has not been called")
      newDataSource(dbConfig.get("driver"), dbConfig.get("database"), dbConfig.get("user"), dbConfig.get("password"))
   }

   private def static DataSource newDataSource(String driver, String uri, String user, String password) {
        var bds = new BasicDataSource();
        bds.setDriverClassName(driver);
        bds.setUrl(uri);
        bds.setUsername(user);
        bds.setPassword(password);
        return bds;       
   }

   /**
      * Constructs a new SQL data source with the given parameters. Connections
      * to this data source are pooled.
      *
      * @param uri the URI for database connections
      * @param user the username for the database
      * @param password the password for the database
      * @return a new SQL data source
      */
   private def static DataSource newDataSourceOld(String uri, String user, String password) {
      var connectionPool = new GenericObjectPool(null)
      connectionPool.setMaxActive(maxActive)
      connectionPool.setMaxIdle(maxIdle)
      var connectionFactory = new DriverManagerConnectionFactory(uri, user, password)

      //
      // This constructor modifies the connection pool, setting its connection
      // factory to this. (So despite how it may appear, all of the objects
      // declared in this method are incorporated into the returned result.)
      //
      new PoolableConnectionFactory(connectionFactory, connectionPool, null, null, false, true)
      return new PoolingDataSource(connectionPool)
   }
   
   private def static int getMaxActive() {
      try { 
         var ret = dbConfig.get("max_active")
         Integer.parseInt(ret)
      } catch (Exception e) {
         256
      }
   }

   private def static int getMaxIdle() {
      try { 
         var ret = dbConfig.get("max_idle")
         Integer.parseInt(ret)
      } catch (Exception e) {
         256
      }
   }
}
