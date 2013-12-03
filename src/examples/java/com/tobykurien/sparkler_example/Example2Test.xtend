package com.tobykurien.sparkler_example

import com.tobykurien.sparkler.test.TestSupport
import org.javalite.activejdbc.Model
import org.junit.Test

class Example2Test extends TestSupport {
   
   override getModelPackageName() {
      return Example2.package.name
   }
   
   @Test
   def simpleTest() {
      val book = Model.with(Book)
      
      a(book).shouldNotBeNull      
   }
   
}