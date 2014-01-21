package com.tobykurien.sparkler.utils

import com.tobykurien.sparkler.db.DatabaseManager
import org.javalite.activejdbc.Base

/**
 * Utitily to run a closure with a database connection and
 * close it afterwards. Usage:
 * 
 *    DbConnection.run [
 *       // your code here
 *    ]
 * 
 */
class DbConnection {
   def static run((Void)=>Object func) {
      Base.open(DatabaseManager.newDataSource)
      try {
         func.apply(null)
      } finally {
         Base.close
      }
   }
}