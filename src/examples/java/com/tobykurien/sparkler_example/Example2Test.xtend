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
      var newBook = book.createIt("title", "Test", "Author", "Toby Kurien")
      a(newBook).shouldNotBeNull      
      a(newBook.id).shouldNotBeNull
      a(newBook.get("title")).shouldBeEqual("Test")
      a(newBook.get("author")).shouldBeEqual("Toby Kurien")
      the(book.findAll.length).shouldBeEqual(1)
   }
   
}