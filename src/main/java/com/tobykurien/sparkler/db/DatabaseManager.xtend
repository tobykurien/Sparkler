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

class DatabaseManager {
   var static String rootPackage
   var static Map<String,String> dbConfig
   
   /**
    * Initialize the database system
    */
   def static init(String rootPackageName) {
      rootPackage = rootPackageName

      // load the database config
      var yaml = new Yaml()
      var config = yaml.load(new FileInputStream("config/database.yml")) as Map<String,Map<String,String>> 
      dbConfig = config.get(Helper.environment)
      
      Class.forName(dbConfig.get("driver")) // load database driver
   }

   def static DataSource newDataSource() {
      if (dbConfig == null) throw new IllegalStateException("DatabaseManager.init() has not been called")
      newDataSource(dbConfig.get("database"), dbConfig.get("user"), dbConfig.get("password"))
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
   private def static DataSource newDataSource(String uri, String user, String password) {
      var connectionPool = new GenericObjectPool(null);
      connectionPool.setMaxActive(256);
      connectionPool.setMaxIdle(256);
      var connectionFactory = new DriverManagerConnectionFactory(uri, user, password);

      //
      // This constructor modifies the connection pool, setting its connection
      // factory to this. (So despite how it may appear, all of the objects
      // declared in this method are incorporated into the returned result.)
      //
      new PoolableConnectionFactory(connectionFactory, connectionPool, null, null, false, true);
      return new PoolingDataSource(connectionPool);
   }
}
