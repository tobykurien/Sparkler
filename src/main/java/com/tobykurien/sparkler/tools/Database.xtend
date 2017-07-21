package com.tobykurien.sparkler.tools

import com.tobykurien.sparkler.Helper
import com.tobykurien.sparkler.db.DatabaseManager
import java.io.File
import java.io.FileReader
import java.sql.ResultSet
import org.javalite.activejdbc.Base

import static extension com.google.common.io.CharStreams.*

/**
 * Tools for working with Sparkler databases
 */
class Database {
   def init(String[] args) {
      if (args.length > 0 && args.get(0).length > 0) {
         Helper.setEnvironment(args.get(0))
      }
      
      DatabaseManager.init(Database.package.name)
      Base.open(DatabaseManager.newDataSource)
      Base.openTransaction

      try {
         // delete all the existing tables
         var jdbcConnection = DatabaseManager.newDataSource.connection
         var md = jdbcConnection.getMetaData();
         var rs = md.getTables(null, null, "%", #["TABLE"]);
         while (rs.next()) {
            try {
                var table = rs.getString("TABLE_NAME")
                Base.exec("drop table " + table)
            } catch (Exception e) {
                System.err.println("Unable to delete table, continuing. " + e.message)
            }
         }
         
         // load the new schema
         var schema = new File("config/database.schema")
         var sql = new FileReader(schema).readLines.join("\r\n").split(";")
         for (s : sql) Base.exec(s)
         Base.commitTransaction
      } catch (Exception e) {
         Base.rollbackTransaction
         throw e
      } finally {
         Base.close
      }
   }
}