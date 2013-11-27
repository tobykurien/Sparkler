package com.tobykurien.sparkler_example

import com.tobykurien.sparkler.db.DatabaseManager
import com.tobykurien.sparkler.db.Model
import com.tobykurien.sparkler.transformer.JsonModelTransformer

import static com.tobykurien.sparkler.Sparkler.*

/**
 * A simple RESTful example showing howto create, get, update and delete book resources.
 * The database configuration is stored in /config/database.yml
 * Manage the database by running (from project root): java -jar libs/h2-1.3.174.jar
 * 
 * @see http://code.google.com/p/spark-java/#Examples
 */
class Example2 {
   def static void main(String[] args) {
      DatabaseManager.init(Example2.package.name) // init db with package containing db models
      val book = Model.with(typeof(Book)) // get reference to ModelContext for Book
      
      // Gets all available book resources (id's)
      get(new JsonModelTransformer("/books") [req, res|
         // JsonModelTransform provides db connection, and can take a Model 
         // (or LazyList of Models) and generate JSON
         book.findAll
      ])
       
      // Gets the book resource for the provided id
      get(new JsonModelTransformer("/books/:id") [req, res|
         book.findById(req.params("id"))
      ])
      
      // Creates a new book resource, will return the ID to the created resource
      // author and title are sent as query parameters e.g. /books?author=Foo&title=Bar
      get(new JsonModelTransformer("/books+") [req, res|
         book.createIt(
            "title", req.queryParams("title"),
            "author", req.queryParams("author"))     
      ])
      
      // Updates the book resource for the provided id with new information
      // author and title are sent as query parameters e.g. /books/<id>?author=Foo&title=Bar
      post(new JsonModelTransformer("/books/:id") [req, res|
         // JsonModelTransformer will return other data types as: {'result': '[object.toString]'}
         var b = book.findById(req.params("id"))
         if (b != null) {
           b.set(
             "title", req.queryParams("title"), 
             "author", req.queryParams("author"))
           b.saveIt
         }
         
         b
      ])
      
      // Deletes the book resource for the provided id 
      delete(new JsonModelTransformer("/books/:id") [req, res|
         book.findById(req.params("id"))?.delete
      ])
   }
}

/**
 * Books table in the database
 */
class Book extends Model {
   // data model is inferred from the database 
}