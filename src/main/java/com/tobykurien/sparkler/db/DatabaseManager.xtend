package com.tobykurien.sparkler.db

import javax.sql.DataSource
import org.apache.commons.dbcp.DriverManagerConnectionFactory
import org.apache.commons.dbcp.PoolableConnectionFactory
import org.apache.commons.dbcp.PoolingDataSource
import org.apache.commons.pool.impl.GenericObjectPool

class DatabaseManager {

   /**
      * Constructs a new SQL data source with the given parameters. Connections
      * to this data source are pooled.
      *
      * @param uri the URI for database connections
      * @param user the username for the database
      * @param password the password for the database
      * @return a new SQL data source
      */
   def static DataSource newDataSource(String uri, String user, String password) {
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
