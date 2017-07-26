package com.tobykurien.sparkler.test

import com.tobykurien.sparkler.Helper
import com.tobykurien.sparkler.db.DatabaseManager
import com.tobykurien.sparkler.tools.Database
import org.javalite.activejdbc.Base
import org.javalite.test.jspec.JSpecSupport

abstract class TestSupport extends JSpecSupport {
   def setUpDb() {
      Helper.setEnvironment("test")
      new Database().init(#["test"])
      DatabaseManager.init(getModelPackageName)
      Base.open(DatabaseManager.newDataSource)
   }
   
   abstract def String getModelPackageName()
   
   def tearDownDb() {
      Base.close
   }   
}