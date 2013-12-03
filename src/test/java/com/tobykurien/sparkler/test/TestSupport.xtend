package com.tobykurien.sparkler.test

import com.tobykurien.sparkler.Helper
import com.tobykurien.sparkler.db.DatabaseManager
import com.tobykurien.sparkler.tools.Database
import org.javalite.activejdbc.Base
import org.javalite.test.jspec.JSpecSupport
import org.junit.After
import org.junit.Before

abstract class TestSupport extends JSpecSupport {
   @Before
   def setUpDb() {
      Helper.setEnvironment("test")
      new Database().init(#["test"])
      DatabaseManager.init(getModelPackageName)
      Base.open(DatabaseManager.newDataSource)
   }
   
   abstract def String getModelPackageName()
   
   @After
   def tearDownDb() {
      Base.close
   }   
}